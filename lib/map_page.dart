import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'studio_provider.dart'; // Import the StudioProvider
import 'studio_info_page.dart'; // Import the StudioInfoPage


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final studioProvider = Provider.of<StudioProvider>(context, listen: false);
    for (final studio in studioProvider.studios) {
      try {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(studio.name),
              position: LatLng(studio.latitude, studio.longitude),
              infoWindow: InfoWindow(
                title: studio.name,
                snippet: studio.address,
              ),
              icon: BitmapDescriptor.defaultMarker, // Use default icon for testing
              onTap: () {
                // Navigate to StudioInfoPage when the marker is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudioInfoPage(
                      name: studio.name,
                      address: studio.address,
                      description: studio.description,
                      style: studio.style,
                    ),
                  ),
                );
              },
            ),
          );
        });
      } catch (e) {
        print('Failed to geocode address: ${studio.address}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studio Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(60.222004,24.857657), // Default to Helsinki
          zoom: 10,
        ),
        markers: _markers,
      ),
    );
  }
}