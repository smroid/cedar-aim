// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/client_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final MyHomePageState _homePageState;
  const MapScreen(this._homePageState, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    LatLng? selectedPosition = widget._homePageState.mapPosition;
    LatLng initialCenter;
    double initialZoom;
    if (selectedPosition != null) {
      initialCenter = selectedPosition;
      initialZoom = 5.0;
    } else {
      double longitudeFromTz =
          15.0 * widget._homePageState.tzOffset.inMinutes / 60.0;
      initialCenter = LatLng(0, longitudeFromTz);
      initialZoom = 3.0;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: DefaultTextStyle.merge(
          style: const TextStyle(fontFamilyFallback: ['Roboto']),
          child: Stack(children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
                minZoom: 1.0,
                maxZoom: 6.0,
                interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all &
                        ~InteractiveFlag.doubleTapZoom &
                        ~InteractiveFlag.rotate),
                onTap: (tapPosition, point) {
                  setState(() {
                    widget._homePageState.mapPosition = point;
                  });
                },
              ),
              children: [
                TileLayer(
                    urlTemplate: 'assets/tiles/{z}/{x}/{y}{r}.webp',
                    tileProvider: AssetTileProvider(),
                    maxNativeZoom: 5,
                    retinaMode: true),
                if (selectedPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedPosition,
                        child:
                            const Icon(Icons.location_pin, color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: () {
                      final pos =
                          selectedPosition ?? _mapController.camera.center;
                      _mapController.move(pos, _mapController.camera.zoom + 1);
                    },
                    elevation: 0,
                    hoverElevation: 0,
                    backgroundColor: const Color(0xc0ffffff),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10.0),
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: () {
                      final pos =
                          selectedPosition ?? _mapController.camera.center;
                      _mapController.move(pos, _mapController.camera.zoom - 1);
                    },
                    elevation: 0,
                    hoverElevation: 0,
                    backgroundColor: const Color(0xc0ffffff),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 20.0,
              left: 20.0,
              child: Text(
                "© MapTiler © OpenStreetMap contributors",
                textScaler: TextScaler.linear(0.5),
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ])),
    );
  }
}
