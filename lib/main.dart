
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MapTest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController _googleMapController;
  LocationData? currentLocation;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  String path = 'images/icon.png';
  int width = 20;
  int heght = 20;
  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
    print("location >>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    setState(() {});
    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      print("Location :${currentLocation} >>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      setState(() {});
    });
  }

  void setIcons() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'images/icon.png',
    ).then((icon) {
      userIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: currentLocation == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            icon: userIcon,
            position: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
          ),
        },
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 16),
        onMapCreated: (controller) => _googleMapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();

          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 16),
          ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.location_pin),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
