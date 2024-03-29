import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoc;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:miniprojectsem5/HomeScreenRecognize.dart';
void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GeolocationApp());
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  var time;

  double startLatitude = 19.0450936;//for xie
  double startLongitude = 72.8419759;//for xie
  double? distanceInMeter = 0.0;
  Future<Position> _getCurrentLocation() async{
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if(!servicePermission) {
      print("Service Disabled");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Location'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Location Coordinates",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
              SizedBox(
                height: 6,
              ),
              Text("Latitude= ${_currentLocation?.latitude} , Longitude= ${_currentLocation?.longitude}"),
              Text("as of ${time}", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(onPressed: ()async{
                _currentLocation = await _getCurrentLocation();
                distanceInMeter = await Geolocator.distanceBetween(startLatitude, startLongitude,  _currentLocation!.latitude, _currentLocation!.longitude);
                print(distanceInMeter);
                if(distanceInMeter!<=100){
                  print("You are inside the radius");
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreenRecognize()),
                  );
                }
                else{
                  print("You are outside the prescribed radius");
                }
                setState((){
                  time = DateTime.now();
                });
                print("${_currentLocation}");
              }, child: Text("Get Current Location"),),
            ],
          ),
        ),
      ),
    );
  }
}
