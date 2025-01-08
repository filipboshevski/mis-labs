import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/exam.dart';

class MapScreen extends StatefulWidget {
  final Exam exam;

  const MapScreen({super.key, required this.exam});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? currentPosition;
  List<LatLng> routePoints = [];
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    getCurrentLocation();
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services in your settings.'),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location services in your settings.'),
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services in your settings.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      if (currentPosition != null) {
        await getRoute();

        fitBounds();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get current location: $e'),
        ),
      );
    }
  }

  void fitBounds() {
    if (currentPosition != null) {
      final bounds = LatLngBounds(
        LatLng(
          min(currentPosition!.latitude, widget.exam.coordinates.latitude),
          min(currentPosition!.longitude, widget.exam.coordinates.longitude),
        ),
        LatLng(
          max(currentPosition!.latitude, widget.exam.coordinates.latitude),
          max(currentPosition!.longitude, widget.exam.coordinates.longitude),
        ),
      );

      mapController.fitBounds(
        bounds,
      );
    }
  }

  Future<void> getRoute() async {
    if (currentPosition == null) {
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/'
              '${currentPosition!.longitude},${currentPosition!.latitude};'
              '${widget.exam.coordinates.longitude},${widget.exam.coordinates.latitude}'
              '?overview=full&geometries=geojson'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates = data['routes'][0]['geometry']['coordinates'] as List;

          setState(() {
            routePoints = coordinates
                .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      setState(() {
        routePoints = [
          currentPosition!,
          widget.exam.coordinates,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: widget.exam.coordinates,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  // Exam location marker
                  Marker(
                    point: widget.exam.coordinates,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                  if (currentPosition != null)
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: currentPosition!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                ],
              ),
              if (routePoints.length == 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 3.0,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}