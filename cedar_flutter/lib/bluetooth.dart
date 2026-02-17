// Copyright (c) 2025 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pb.dart' as cedar_pb;
import 'package:cedar_flutter/client_main.dart';
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
  String _productName = 'Cedar Box';

  // Track which specific device is currently being removed to show the spinner
  // on the correct row.
  String? _removingDeviceAddress;

  @override
  void initState() {
    super.initState();
    _getProductName();
    _refreshBondedDevices();
  }

  Future<void> _getProductName() async {
    try {
      final name = await getProductName();
      if (mounted) {
        setState(() {
          _productName = name;
        });
      }
    } catch (e) {
      debugPrint('Error fetching product name: $e');
      // Keep default 'Cedar Box'
    }
  }

  Future<void> _refreshBondedDevices() async {
    setState(() {
      _isLoadingList = true;
    });

    try {
      final client = await getClient();
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
      final client = await getClient();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paired Mobile Devices')),
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontFamilyFallback: ['Roboto']),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Devices paired with $_productName',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Device List
            Expanded(
              child: _isLoadingList
                  ? const Center(child: CircularProgressIndicator())
                  : _bondedDevices.isEmpty
                      ? Center(
                          child: Text('No devices paired with $_productName yet'),
                        )
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