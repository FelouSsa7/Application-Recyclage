import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationWithMarker extends StatefulWidget {
  LatLng fournisseurLocation;
  LatLng achteurLocation;

  LocationWithMarker({
    Key? key,
    required this.fournisseurLocation,
    required this.achteurLocation,
  }) : super(key: key);

  @override
  LocationWithMarkerState createState() => LocationWithMarkerState();
}

class LocationWithMarkerState extends State<LocationWithMarker> {
  @override
  void initState() {
    super.initState();
  }

  void _showMarkerMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marker Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locations with Markers"),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: widget.fournisseurLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.fournisseurLocation,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showMarkerMessage("Localisation de l'achteur");
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 50.0,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.achteurLocation,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showMarkerMessage("Localisation du fournisseur");
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.transparent,
                    size: 50.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
