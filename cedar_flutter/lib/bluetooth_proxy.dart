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

    // Set up the BT→TCP forwarder once. It writes to whatever _clientSocket is
    // currently connected; drops data if no client is connected. This avoids
    // the "stream already listened to" crash that occurs when re-subscribing to
    // a single-subscription stream on reconnect.
    _bluetoothSubscription = _connection.input?.listen(
      (Uint8List data) {
        final socket = _clientSocket;
        if (socket == null) return;
        try {
          socket.add(data);
        } catch (e) {
          debugPrint('Error writing to Socket: $e');
          _disconnectClient();
        }
      },
      onError: (e) {
        debugPrint('Bluetooth input error: $e');
        stop();
      },
      onDone: () {
        // BT connection closed — full teardown.
        stop();
      },
    );

    _server!.listen((Socket socket) {
      if (_clientSocket != null) {
        // Only one gRPC client at a time.
        socket.destroy();
        return;
      }
      _clientSocket = socket;

      // Forward TCP (gRPC) data to Bluetooth output.
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
          _disconnectClient();
        },
        onDone: () {
          // gRPC client closed this connection (e.g. stream cancel). Drop the
          // client socket so the next getClient() can reconnect; keep the proxy
          // and BT connection alive.
          _disconnectClient();
        },
      );
    });

    return _server!.port;
  }

  void _disconnectClient() {
    _clientSocket?.destroy();
    _clientSocket = null;
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
