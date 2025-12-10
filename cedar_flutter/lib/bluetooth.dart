// Copyright (c) 2025 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pb.dart' as cedar_pb;
import 'package:cedar_flutter/cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/platform.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<cedar_pb.BondedDevice> _bondedDevices = [];
  bool _isLoadingList = true;
  bool _isPairing = false;
  // Track which specific device is currently being removed to show the spinner on the correct row
  String? _removingDeviceAddress;
  String _bluetoothName = 'cedar';
  bool _isLoadingName = true;
  ResponseFuture<cedar_pb.StartBondingResponse>? _bondingFuture;

  @override
  void initState() {
    super.initState();
    _getBluetoothName();
    _refreshBondedDevices();
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

  Future<void> _startBonding() async {
    setState(() {
      _isPairing = true;
    });

    try {
      final client = getClient();
      // Use a longer timeout for pairing as it involves user action on the other device
      _bondingFuture = client.startBonding(cedar_pb.EmptyMessage(),
          options: CallOptions(timeout: const Duration(seconds: 60)));
      final response = await _bondingFuture!;

      if (mounted) {
        _showPairingResult(response);
      }
    } catch (e) {
      if (e is GrpcError && e.code == StatusCode.cancelled) {
        return;
      }
      debugPrint('Error starting bonding: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pairing failed: $e')),
        );
      }
    } finally {
      _bondingFuture = null;
      if (mounted) {
        setState(() {
          _isPairing = false;
        });
      }
    }
  }

  void _cancelBonding() {
    _bondingFuture?.cancel();
  }

  Future<void> _removeBond(String address) async {
    setState(() {
      _removingDeviceAddress = address;
    });

    try {
      final client = getClient();
      await client.removeBond(cedar_pb.RemoveBondRequest(address: address),
          options: CallOptions(timeout: const Duration(seconds: 5)));
      
      // Refresh the list after successful removal
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

  void _showPairingResult(cedar_pb.StartBondingResponse response) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Data is only present if we have a pairing
        bool hasData = response.hasName() && response.hasPasskey();

        return AlertDialog(
          title: const Text('Pairing Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasData)
                const Text('No device found.')
              else ...[
                const Text('Please verify this passkey on your device:'),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '${response.passkey}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('${response.name}'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Follow the instructions on the other device to complete the pairing process.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
                // Refresh list in case pairing succeeded immediately
                _refreshBondedDevices(); 
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bluetooth Devices')),
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontFamilyFallback: ['Roboto']),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Pair New Device Button
            Center(
              child: _isLoadingName
                  ? const CircularProgressIndicator()
                  : _isPairing
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pair with "$_bluetoothName" using your other device.',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              onPressed: _cancelBonding,
                              child: const Text('Cancel'),
                            ),
                          ],
                        )
                      : OutlinedButton(
                          onPressed: _startBonding,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_removingDeviceAddress == device.address)
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  else
                                    OutlinedButton(
                                      onPressed: () =>
                                          _removeBond(device.address),
                                      child: const Text('Remove'),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
