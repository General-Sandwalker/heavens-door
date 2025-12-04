import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../models/property.dart';

class PropertyMapViewScreen extends StatefulWidget {
  final Property property;

  const PropertyMapViewScreen({super.key, required this.property});

  @override
  State<PropertyMapViewScreen> createState() => _PropertyMapViewScreenState();
}

class _PropertyMapViewScreenState extends State<PropertyMapViewScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> _marker;

  @override
  void initState() {
    super.initState();
    final markerColor = _getMarkerColor(widget.property.propertyType);

    _marker = {
      Marker(
        markerId: MarkerId(widget.property.id.toString()),
        position: LatLng(widget.property.latitude, widget.property.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
        infoWindow: InfoWindow(
          title: widget.property.title,
          snippet:
              '[${widget.property.propertyTypeDisplay.toUpperCase()}] ${widget.property.address}',
        ),
      ),
    };
  }

  double _getMarkerColor(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return BitmapDescriptor.hueBlue;
      case 'house':
        return BitmapDescriptor.hueGreen;
      case 'villa':
        return BitmapDescriptor.hueViolet;
      case 'studio':
        return BitmapDescriptor.hueOrange;
      case 'shop':
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      widget.property.latitude,
                      widget.property.longitude,
                    ),
                    zoom: 17,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.property.address,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.property.latitude,
                  widget.property.longitude,
                ),
                zoom: 15,
              ),
              markers: _marker,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
