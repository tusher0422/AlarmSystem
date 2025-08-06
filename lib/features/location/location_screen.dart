import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../alarm/alarm_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _locationText;

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return setState(() {
        _locationText = 'Location services are disabled.';
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return setState(() {
          _locationText = 'Location permissions are denied.';
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return setState(() {
        _locationText =
        'Location permissions are permanently denied, cannot request.';
      });
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _locationText = 'Lat: ${position.latitude}, Lon: ${position.longitude}';
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AlarmScreen(location: _locationText!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set a fixed width for buttons for consistency
    const buttonWidth = 250.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome! Your Personalized Alarm",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "A lovely cute tone is your smart alarm based on your location.",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ClipOval(
                child: Image.asset(
                  "assets/location_illustration.jpg",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  label: const Text("Use Current Location"),
                  icon: const Icon(Icons.location_on_outlined),
                  onPressed: _getLocation,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AlarmScreen(location: _locationText ?? 'Unknown location'),
                      ),
                    );
                  },
                  child: const Text("Home"),
                ),
              ),
              const SizedBox(height: 20),
              if (_locationText != null)
                Text(
                  _locationText!,
                  style: const TextStyle(color: Colors.white70),
                )
            ],
          ),
        ),
      ),
    );
  }
}
