// Copyright (c) 2025 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/cedar.pb.dart' as cedar_pb;
import 'package:cedar_flutter/platform.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class BluetoothScreen extends StatefulWidget {
  final bool _isDIY;

  const BluetoothScreen(this._isDIY, {super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

enum PairingStep { idle, confirmStart, pairing, result }

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<cedar_pb.BondedDevice> _bondedDevices = [];
  bool _isLoadingList = true;

  // User-friendly device name
  String _deviceName = 'Hopper';
  
  // Track which specific device is currently being removed to show the spinner on the correct row
  String? _removingDeviceAddress;
  String _bluetoothName = 'cedar';
  bool _isLoadingName = true;

  // Pairing State
  PairingStep _pairingStep = PairingStep.idle;
  Timer? _countdownTimer;
  int _countdownValue = 55;
  ResponseFuture<cedar_pb.StartBondingResponse>? _bondingFuture;
  cedar_pb.StartBondingResponse? _pairingResponse;
  String? _pairingErrorMessage;

  @override
  void initState() {
    super.initState();
    if (widget._isDIY) {
      _deviceName = 'Cedar e-finder';
    }
    _getBluetoothName();
    _refreshBondedDevices();
  }

  @override
  void dispose() {
    _stopTimer();
    _bondingFuture?.cancel();
    super.dispose();
  }

  Future<void> _getBluetoothName() async {
    try {
      final client = getClient();
      final response = await client.getBluetoothName(cedar_pb.EmptyMessage(),
          options: CallOptions(timeout: const Duration(seconds: 5)));

      if (mounted) {
        setState(() {
          _bluetoothName = response.name;
          _isLoadingName = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching bluetooth name: $e');
      if (mounted) {
        setState(() {
          _isLoadingName = false;
        });
      }
    }
  }

  Future<void> _refreshBondedDevices() async {
    setState(() {
      _isLoadingList = true;
    });

    try {
      final client = getClient();
      final response = await client.getBondedDevices(cedar_pb.EmptyMessage(),
          options: CallOptions(timeout: const Duration(seconds: 10)));

      if (mounted) {
        setState(() {
          _bondedDevices = response.devices;
          _isLoadingList = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching bonded devices: $e');
      if (mounted) {
        setState(() {
          _isLoadingList = false;
        });
      }
    }
  }

  Future<void> _removeBond(String address) async {
    setState(() {
      _removingDeviceAddress = address;
    });

    try {
      final client = getClient();
      await client.removeBond(cedar_pb.RemoveBondRequest(address: address),
          options: CallOptions(timeout: const Duration(seconds: 5)));

      // Refresh the list after successful removal.
      await _refreshBondedDevices();
    } catch (e) {
      debugPrint('Error removing bond: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove device: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _removingDeviceAddress = null;
        });
      }
    }
  }

  // --- Pairing Logic ---

  void _onPairNewDevicePressed() {
    setState(() {
      _pairingStep = PairingStep.confirmStart;
      _pairingErrorMessage = null;
      _pairingResponse = null;
    });
  }

  void _resetPairingState() {
    _stopTimer();
    _bondingFuture?.cancel();
    setState(() {
      _pairingStep = PairingStep.idle;
      _countdownValue = 55;
      _pairingErrorMessage = null;
      _pairingResponse = null;
    });
    // Refresh the list when returning to idle, just in case a pairing succeeded
    _refreshBondedDevices();
  }

  void _startTimer() {
    _countdownValue = 55;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdownValue > 0) {
            _countdownValue--;
          } else {
            _stopTimer();
          }
        });
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  Future<void> _startBonding() async {
    setState(() {
      _pairingStep = PairingStep.pairing;
      _pairingErrorMessage = null;
    });
    _startTimer();

    try {
      final client = getClient();
      // Use a longer timeout for pairing as it involves user action on the other device
      _bondingFuture = client.startBonding(cedar_pb.EmptyMessage(),
          options: CallOptions(timeout: const Duration(seconds: 60)));
      final response = await _bondingFuture!;

      if (mounted) {
        setState(() {
          _pairingResponse = response;
          _pairingStep = PairingStep.result;
        });
      }
    } catch (e) {
      if (e is GrpcError && e.code == StatusCode.cancelled) {
        return;
      }
      debugPrint('Error starting bonding: $e');
      if (mounted) {
        setState(() {
          _pairingErrorMessage = e.toString();
          _pairingStep = PairingStep.result;
        });
      }
    } finally {
      _bondingFuture = null;
      _stopTimer();
    }
  }

  // --- UI Construction ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bluetooth Devices')),
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontFamilyFallback: ['Roboto']),
        child: _pairingStep == PairingStep.idle
            ? _buildDeviceListLayout()
            : _buildPairingFlowLayout(),
      ),
    );
  }

  Widget _buildDeviceListLayout() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Pair New Device Button
        Center(
          child: _isLoadingName
              ? const CircularProgressIndicator()
              : OutlinedButton(
                  onPressed: _onPairNewDevicePressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  child: const Text('Pair New Device'),
                ),
        ),
        const SizedBox(height: 30),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Paired Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Device List
        Expanded(
          child: _isLoadingList
              ? const Center(child: CircularProgressIndicator())
              : _bondedDevices.isEmpty
                  ? const Center(child: Text('No Paired Devices'))
                  : ListView.separated(
                      itemCount: _bondedDevices.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final device = _bondedDevices[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      device.name.isEmpty
                                          ? 'Unknown Device'
                                          : device.name,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      device.address,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (_removingDeviceAddress == device.address)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              else
                                OutlinedButton(
                                  onPressed: () => _removeBond(device.address),
                                  child: const Text('Remove'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildPairingFlowLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_pairingStep == PairingStep.confirmStart) ...[
                Text(
                  'Pair $_deviceName with a mobile device.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: _startBonding,
                      child: const Text('Start'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: _resetPairingState,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ] else if (_pairingStep == PairingStep.pairing) ...[
                Text(
                  '$_deviceName is now available for pairing.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Open Bluetooth settings on your mobile device to continue pairing.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Select '),
                      TextSpan(
                        text: _bluetoothName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' from the list of available devices'),
                    ],
                  ),
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  '$_countdownValue',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: _resetPairingState,
                  child: const Text('Cancel'),
                ),
              ] else if (_pairingStep == PairingStep.result) ...[
                if (_pairingErrorMessage != null) ...[
                  const Text(
                    'Pairing failed.',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _pairingErrorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ] else if (_pairingResponse != null) ...[
                  if (!_pairingResponse!.hasName() ||
                      !_pairingResponse!.hasPasskey())
                    const Text('No mobile device found.')
                  else ...[
                    const Text('Please verify this passkey on your mobile device:'),
                    const SizedBox(height: 20),
                    Text(
                      '${_pairingResponse!.passkey}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _pairingResponse!.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Complete the pairing process in Bluetooth settings on your mobile device.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: _resetPairingState,
                  child: const Text('Dismiss'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}