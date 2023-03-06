import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store_app/Firebase/locations.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/Firebase/locations.dart' as locations;


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Map<String, Marker> _markers = {};
  late Position currentPosition;
  Completer<GoogleMapController> mGGController = Completer();

  var geoLocator = Geolocator();
  late List<Office> myStores;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void locatePosition(GoogleMapController mapController) async {
    LatLng currentPos =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    CameraPosition camPos = new CameraPosition(target: currentPos, zoom: 14);

    mapController.animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    locatePosition(controller);

    mGGController.complete(controller);

    myStores = await locations.getStores();

    setState(() {
      _markers.clear();
      for (final office in myStores) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.id] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder<Position>(
      future: determinePosition(),
      builder: (context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return googleMap(screenSize, snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget listStore() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Location').where("active", isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const Center(
                    child: Text(
                      "Danh sách cửa hàng",
                      style: TextStyle(
                          fontSize: mFontSize, fontWeight: FontWeight.w600),
                    )),//Danh sách cửa hàng
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        double distance = (Geolocator.distanceBetween(
                            document['latitude'],
                            document['longitude'],
                            currentPosition.latitude, currentPosition.longitude) /
                            1000);
                        return GestureDetector(
                          onTap: () {
                            moveCamera(document.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    '${document['name']}',
                                    style: const TextStyle(
                                        color: mPrimaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    '${document['address']}',
                                    style: const TextStyle(fontSize: mFontListTile),
                                  ),
                                ),
                              ),
                              Text(
                                '${double.parse(distance.toStringAsFixed(2))} km',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget googleMap(Size screenSize, Position? currentPos) {
    locations.setCurrentPosition(currentPos!);
    currentPosition = currentPos;
    return Stack(children: [
      GoogleMap(
        padding: EdgeInsets.only(bottom: screenSize.height - 420),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            const CameraPosition(target: LatLng(10.762622, 106.660172), zoom: 14),
        markers: _markers.values.toSet(),
      ),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
              height: 220.0,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 18.0),
                child: listStore(),
              ))),
    ]);
  }

  Future<void> moveCamera(String id) async {
    Marker? selectedMarker = _markers[id];
    final GoogleMapController controller = await mGGController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
          selectedMarker!.position.latitude, selectedMarker.position.longitude),
      zoom: 16,
    )));
  }
}
