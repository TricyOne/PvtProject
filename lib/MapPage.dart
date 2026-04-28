import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class TextGeoPoint extends GeoPoint {
  TextGeoPoint({required double latitude, required double longitude})
      : super(latitude: latitude, longitude: longitude);

  TextGeoPoint.fromGeoPoint(GeoPoint p)
      : super(latitude: p.latitude, longitude: p.longitude);

  @override
  String toString() {
    return latitude.toStringAsFixed(3) + ', ' + longitude.toStringAsFixed(3);
  }
}

class _MapPageState extends State<MapPage> {
  TextGeoPoint _homeLocation = TextGeoPoint(latitude: 48.8, longitude: 9.9);
  TextGeoPoint _workLocation = TextGeoPoint(latitude: 48.8, longitude: 9.9);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle updateStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.green, textStyle: const TextStyle(fontSize: 20));
    final ButtonStyle deleteStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent, textStyle: const TextStyle(fontSize: 20));

    final textHeadStyle =
        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold);

    final textGPSStyle = TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Map'),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          //mainAxisAlignment: .center,
          /*children: [
            ElevatedButton(
                style: updateStyle,
                onPressed: () async {*/
                child: OSMFlutter(
                    controller: MapController(
                      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
                      areaLimit: const BoundingBox(
                        east: 10.4922941,
                        north: 47.8084648,
                        south: 45.817995,
                        west: 5.9559113,
                      ),
                    ),
                    osmOption: OSMOption(
                      userTrackingOption: const UserTrackingOption(
                        enableTracking: true,
                        unFollowUser: false,
                      ),
                      zoomOption: const ZoomOption(
                        initZoom: 8,
                        minZoomLevel: 3,
                        maxZoomLevel: 19,
                        stepZoom: 1.0,
                      ),
                      userLocationMarker: UserLocationMaker(
                        personMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                        directionArrowMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.double_arrow,
                            size: 48,
                          ),
                        ),
                      ),
                      roadConfiguration: const RoadOption(
                        roadColor: Colors.yellowAccent,
                      ),
                    ),
                  )
                  /*MapController(
                    /*context: context,
                    isDismissible: true,
                    title: "Home Location Picker",
                    textConfirmPicker: "pick",*/
                    //initCurrentUserPosition: false,
                    //zoomOption: const ZoomOption(initZoom: 8),
                    initPosition: _homeLocation,
                    //radius: 8.0,
                    //markerHome: MarkerIcon(icon: Icon(Icons.home)),
                  );*/
                  /*if (p != null) {
                    setState(() {
                      _homeLocation = TextGeoPoint.fromGeoPoint(p);
                    });
                  }'*/
                //},
                //child: const Text('Update'),
              //),
            /*
            Text('Home', style: textHeadStyle),
            Text('$_homeLocation', style: textGPSStyle),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: updateStyle,
                onPressed: () async {
                  var p = await showSimplePickerLocation(
                    context: context,
                    isDismissible: true,
                    title: "Home Location Picker",
                    textConfirmPicker: "pick",
                    //initCurrentUserPosition: false,
                    zoomOption: const ZoomOption(initZoom: 8),
                    initPosition: _homeLocation,
                    radius: 8.0,
                  );
                  if (p != null) {
                    setState(() {
                      _homeLocation = TextGeoPoint.fromGeoPoint(p);
                    });
                  }
                },
                child: const Text('Update'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: deleteStyle,
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ),
            Text('Work', style: textHeadStyle),
            Text('$_workLocation', style: textGPSStyle),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: updateStyle,
                onPressed: () async {
                  var p = await showSimplePickerLocation(
                    context: context,
                    isDismissible: true,
                    title: "Work Location Picker",
                    textConfirmPicker: "pick",
                    //initCurrentUserPosition: false,
                    zoomOption: const ZoomOption(initZoom: 8),
                    initPosition: _workLocation,
                    radius: 8.0,
                  );
                  if (p != null) {
                    setState(() {
                      _workLocation = TextGeoPoint.fromGeoPoint(p);
                    });
                  }
                },
                child: const Text('Update'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: deleteStyle,
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ),
            Text('Display Name', style: textHeadStyle),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Donny',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: updateStyle,
                onPressed: () {},
                child: const Text('Update'),
              ),
            ),*/
          //],
        ));
  }
}
