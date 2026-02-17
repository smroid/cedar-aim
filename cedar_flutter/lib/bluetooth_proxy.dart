// Copyright (c) 2026 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothGrpcProxy {
  final BluetoothConnection _connection;
  ServerSocket? _server;
  StreamSubscription? _bluetoothSubscription;
  Socket? _clientSocket;

  BluetoothGrpcProxy(this._connection);

  // Starts the proxy server and returns the port to connect to.
  // 0 (default) lets OS assign an available port.
  Future<int> start({int port = 0}) async {
    _server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    _server!.listen((Socket socket) {
      if (_clientSocket != null) {
        // We only support one client (the local gRPC client)
        socket.destroy();
        return;
      }
      _clientSocket = socket;

      // Forward TCP (gRPC) data to Bluetooth output
      socket.listen(
        (Uint8List data) {
          try {
            _connection.output.add(data);
          } catch (e) {
            debugPrint('Error writing to Bluetooth: $e');
            stop();
          }
        },
        onError: (e) {
          debugPrint('Socket error: $e');
          stop();
        },
        onDone: () {
          stop();
        },
      );

      // Forward Bluetooth input to TCP (gRPC)
      _bluetoothSubscription = _connection.input?.listen(
        (Uint8List data) {
          try {
            socket.add(data);
          } catch (e) {
            debugPrint('Error writing to Socket: $e');
            stop();
          }
        },
        onError: (e) {
          debugPrint('Bluetooth input error: $e');
          stop();
        },
        onDone: () {
          stop();
        },
      );
    });

    return _server!.port;
  }

  Future<void> stop() async {
    await _bluetoothSubscription?.cancel();
    _bluetoothSubscription = null;
    _clientSocket?.destroy();
    _clientSocket = null;
    await _server?.close();
    _server = null;
  }
}
