import 'dart:async';
import 'package:Shrine/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' ;
import 'package:rounded_modal/rounded_modal.dart';
//import 'package:search_map_place/search_map_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart'  ;
import 'geofenceList.dart';
import 'globals.dart' as globals;
import 'globals.dart';

String apiKEY = "AIzaSyDYh77SKpI6kAD1jiILwbiISZEwEOyJLtM";

class Map1 extends StatefulWidget {
  @override
  _MapState createState() => _MapState();

}

class _MapState extends State<Map1> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  Completer<GoogleMapController> controller1 = Completer();
  //Completer<GoogleMapController> _mapController = Completer();
  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;
  String currentloc='';
  LatLng latlang;
  LatLng _currentPosition;
  var addresses;
  String searchlocation ='';
  var lat;
  var long;
  var currlat;
  var currlong;
  String streamlocationaddr1 ="";
  String clat='';
  String clong='';
  String userlat='';
  String userlong='';
  Map<int, dynamic>res;

  //LocationData _currentLocation;
//  double lat = 0.0;
//  double long = 0.0;
//  static location.LocationData _currentLocationlater = globals.list[globals.list.length - 1];
//  double lat = _currentLocationlater.latitude.toDouble();
//  double long =_currentLocationlater.longitude.toDouble();
//  var currentLocation = LocationData;

//  static location.LocationData _currentLocationlater = globals.list[globals.list.length - 1];
//  double lat = _currentLocationlater.latitude.toDouble();
//  double long =_currentLocationlater.longitude.toDouble();
  static Position position;
  TextEditingController _name;
  TextEditingController _radius;

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager= true;


  @override
  void initState() {
    _name = new TextEditingController();
    _radius = new TextEditingController();
    setState(() {

      streamlocationaddr1 = globals.globalstreamlocationaddr;

    });
    _getLocation();
    // _getUserLocation();
    super.initState();
  }

  void _getLocation() async {
    var location = new Location();
    try {
      await location.getLocation().then((onValue) {
        setState(() {
          currlat = onValue.latitude.toDouble();
          currlong =  onValue.longitude.toDouble();
          clat = currlat.toString();
          clong = currlong.toString();
          print("clat"+ clat);
        });
      });
    } catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
      }
    }
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed1() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onMapTypeButtonPressed2() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.normal
          : MapType.terrain;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    print(position.target);
    print("position.target");
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(_currentPosition.toString()),
              position: _currentPosition,
              // flat: true,
              draggable: true,
//              visible: true,
              infoWindow: InfoWindow(
                  title: searchlocation == ''? streamlocationaddr1 : searchlocation,
                  // snippet: ,
                  onTap: () {
                  }
              ),
              onTap: () {},
              icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      currlat == null && currlong == null ? Container(child: Center(child: Text(
        'loading map..', style: TextStyle(
          fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),)

          : SafeArea(
        child: ListView(
          //physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new  Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .70,
//            width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        markers: _markers,
                        mapType: _currentMapType,
                        initialCameraPosition: CameraPosition(
                          target:  LatLng(currlat,currlong),
                          zoom: 14.4746,
                        ),
                        onMapCreated: _onMapCreated,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        onCameraMove: _onCameraMove,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: false,
//                        gestureRecognizers: Set()
//                          ..add(
//                              Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
//                          ..add(
//                            Factory<VerticalDragGestureRecognizer>(
//                                    () => VerticalDragGestureRecognizer()),
//                          )..add(
//                            Factory<HorizontalDragGestureRecognizer>(
//                                    () => HorizontalDragGestureRecognizer()),
//                          )..add(
//                            Factory<ScaleGestureRecognizer>(
//                                    () => ScaleGestureRecognizer()),
//                          ),
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                        ].toSet(),

                        onTap: (latlang) {
                          _getAddressFromLatLng(latlang);
                        },

                      ),

                      //onTap: touch(),

                    ),
                    Positioned(
                      top: 10,
                      left: MediaQuery.of(context).size.width * 0.05,
                      // height: MediaQuery.of(context).size.width * 0.25,
                  /*    child: SearchMapPlaceWidget(
                        //icon: MediaQuery.of(context).size.width * 0.9,
                        apiKey: apiKEY,
                        location: LatLng(currlat , currlong),
                        radius: 30000,
                        onSelected: (place) async {
                          final geolocation = await place.geolocation;
                          //  print(geolocation.fullJSON["adress_components"][0]["short_name"]);
                          print(geolocation.fullJSON);
                          print("placessss");
                          //print(geolocation.fullJSON["adress_components"][0]["short_name"]);
                          print("locaaaa");
                          final GoogleMapController controller = await controller1.future;
                          controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                          controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                        },
                      ),*/

                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.50,
                          margin: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
                          child: Column(
                            children: <Widget>[
                              mapButton(_onMapTypeButtonPressed1,
                                  Icon(
                                    IconData(0xf473,
                                        fontFamily: CupertinoIcons.iconFont,
                                        fontPackage: CupertinoIcons.iconFontPackage),
                                  ),
                                  Colors.white),
                              /* mapButton(_onMapTypeButtonPressed2,
                                  Icon(
                                      Icons.ac_unit
                                  ), Colors.white),*/
//                              mapButton(
//                                  _onMapTypeButtonPressed1,
//                                  Icon(
//                                    IconData(0xf473,
//                                        fontFamily: CupertinoIcons.iconFont,
//                                        fontPackage: CupertinoIcons.iconFontPackage),
//                                  ),
//                                  Colors.red),
                            ],
                          )),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.01),
                //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                // SizedBox(height: 5.0),
                Container( // Detailed box of employee
                  padding: new EdgeInsets.only(left: 10.0, right: 10.0),
//                  decoration: new ShapeDecoration(
//                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
//                      color: Colors.white.withOpacity(0.1)
//                  ) ,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Divider(
                        color: Colors.black,
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            'Selected Geofence',
                            style: TextStyle(fontSize: 24.0, color:  Colors.orangeAccent,fontWeight:FontWeight.bold ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),

                      Center(
                        child: Container(
                          height:MediaQuery.of(context).size.height * 0.09,
                          //padding:EdgeInsets.only(top:15.0,bottom: 0.0),Fence radius
                          child: new Text(
                            searchlocation==''?streamlocationaddr1:searchlocation,
                            style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight:FontWeight.bold),
                          ),

                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width*0.8,
                        height: 45.0,
                        child:RaisedButton(
                          child: Text('Confirm location & Proceed',style: new TextStyle(color: Colors.white,fontSize: 15.0)),
                          color: Colors.orangeAccent,
                          onPressed: () {
                            if(searchlocation!='' || streamlocationaddr1 !='')
                              _showModalSheet();
                            else{
                              showDialog(context: context, child:
                              new AlertDialog(
                                title: new Text("Alert"),
                                content: new Text("Please select the geo center address first"),
                              ));
                              return null;


                            }
                          },

                        ),
                      ),
                    ],
                  ),

                ),

              ],
            ),
          ],
        ),

      ),
    );
  }

//  _getCurrentLocation(latlang) {
////    geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best)
////        .then((Position position) {
////      setState(() {
////        _currentPosition = latlang;
////       // _onAddMarkerButtonPressed();
////        print(_currentPosition);
////        //print("jojo khush hua!!");
////      });
//
//
//     // _getAddressFromLatLng();
////    }).catchError((e) {
////      print(e);
////    });
//
//  }

  _getAddressFromLatLng(LatLng latlang) async {
    print(latlang.latitude);
    //print("latiioioioi");
    // print(latlang.latitude.toDouble());
    // print("latlang.latitude");
    try {
//      List<Placemark> p = await geolocator.placemarkFromCoordinates(
//          _currentPosition.latitude, _currentPosition.longitude);
      try {
        print("try");
        addresses = await Geocoder.google(apiKEY).findAddressesFromCoordinates(
            Coordinates(latlang.latitude.toDouble(), latlang.longitude.toDouble()));
      }
      catch(e){
        print(e);
        print("error is");
      }
      setState(() {
        _currentPosition = latlang;
        var first = addresses.first;
        streamlocationaddr1 = "${first.addressLine}";
        lat = latlang.latitude.toString();
        long =latlang.longitude.toString();
        userlat = lat;
        userlong = long;
        _onAddMarkerButtonPressed();

      });
    } catch (e) {
      // print("omom");
      print(e);
    }
    print(streamlocationaddr1);
    print('locaaa');
    print(lat);
  }

  _showModalSheet() async{
    showRoundedModalBottomSheet(context: context, builder: (builder) {

      return Container(
        height: MediaQuery.of(context).size.height*30,
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
//
                Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height*0.02),
                      Center(child:
                      Text("Add Geo Center",style: new TextStyle(fontSize: 22.0,color: Colors.orange,fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.01),
                      Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 1.0,
                              ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.text,


                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                //prefixIcon:  Icon(Icons.business, color: Colors.black38,),
                                prefixIcon:  Icon(
                                  Icons.account_balance,
                                  color: Colors.black38,
                                ),
                                //hintText: AppTranslations.of(context).text("key_company_name"),
                                hintText: 'Eg. Connaught Place',
                                labelText: 'Geo Center Name *',
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                )
                            ),
                            controller: _name,
                            //focusNode: __name,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),

                      Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [new BoxShadow(
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new TextFormField(
                            //enabled: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter contact person name';
                              }
                            },

                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                prefixIcon:  Icon(Icons.call_split, color: Colors.black38,),
                                //hintText: AppTranslations.of(context).text("key_contact_person_name"),
                                labelText: 'Latitude, Longitude *',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                )
                            ),
                            readOnly: true,
                            initialValue:  userlat == ''? clat+" , "+clong: userlat+" , "+userlong,
//                            focusNode: __cname,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),

                      Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [new BoxShadow(
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new TextFormField(
                            //enabled: false,
//                              validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Please enter contact person name';
//                          }
//                        },
                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                prefixIcon:  Icon(Icons.business, color: Colors.black38,),
                                labelText: 'Geo Center Address *',

                                //hintText: AppTranslations.of(context).text("key_contact_person_name"),
                                //hintText: 'Company Name',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                )
                            ),
                            readOnly: true,
                            initialValue: searchlocation ==''? streamlocationaddr1 : searchlocation,
//                            focusNode: __cname,
                          ),
                        ),
                      ),

                      SizedBox(height: 15.0),

                      Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [new BoxShadow(
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new TextFormField(
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'Please enter fence radius';
//                              }
//                            },
                            // readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.blur_circular,
                                  color: Colors.black38,
                                ),
                                labelText: "Fence Radius (Km) *",
                                hintText: '0.250',
                                //errorText: _validate? "jbjbj": null,
                                //fillColor: Colors.green,

                                // labelStyle: Colors.red,
                                //hintText: 'Fence Radius (Km)',

                                //hintText: AppTranslations.of(context).text("key_city"),
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                )
                            ),
                            //initialValue:"0.250",
                            controller: _radius,

                            //controller: locController1,
                          ),
                        ),
                      ),

                      ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            FlatButton(
                              shape: Border.all(color: Colors.grey),
                              child: Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text(' ADD ' ,style: TextStyle(color: Colors.white),),
                              color: Colors.orangeAccent,
                              onPressed: () async {

                                if(_name.text.trim()==''){
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("Alert"),
                                    content: new Text("Please enter the Geo Center Name"),
                                    //content: new Text(AppTranslations.of(context).text("key_enter_company_name")),
                                  ));
                                  return null;
                                }
                                else if(_radius.text.trim()==''){

                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("Alert"),
                                    content: new Text("Please enter fence radius"),
                                    //content: new Text(AppTranslations.of(context).text("key_enter_company_name")),
                                  ));
                                  return null;

                                }
                                else {
                                  addgeofence(_name.text, searchlocation, streamlocationaddr1, clat,
                                      clong, userlat, userlong, _radius.text).then((response){
                                    print(response.toString());

                                    if(response == 1){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 2),() {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: Text('Geofence added successfully'),
                                            );
                                          });
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 2),() {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: Text('Unable to call the service.'),
                                            );
                                          });
                                    }
                                    // res = json.decode(response.body);
                                    //print("lpllplppl");


                                  });


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => geofencelist()),
                                  );
                                }
                              },
                            )
                          ]),
                      //err==true?Text('Invalid Email.',style: TextStyle(color: Colors.red,fontSize: 16.0),):Center(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }


}

