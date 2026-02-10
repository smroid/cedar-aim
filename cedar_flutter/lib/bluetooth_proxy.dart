// Copyright (c) 2026 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class BluetoothGrpcProxy {
  final BluetoothConnection _connection;
  ServerSocket? _server;
  StreamSubscription? _bluetoothSubscription;
  Socket? _clientSocket;

  BluetoothGrpcProxy(this._connection);

  // Starts the proxy server and returns the port to connect to.
  // 0 (default) indicates a random port.
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
            print('Error writing to Bluetooth: $e');
            stop();
          }
        },
        onError: (e) {
          print('Socket error: $e');
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
            print('Error writing to Socket: $e');
            stop();
          }
        },
        onError: (e) {
          print('Bluetooth input error: $e');
          stop();
        },
        onDone: () {
          stop();
        },
      );
    });

    return _server!.port;
  }

  void stop() {
    _bluetoothSubscription?.cancel();
    _clientSocket?.destroy();
    _clientSocket = null;
    _server?.close();
    _server = null;
  }
}
