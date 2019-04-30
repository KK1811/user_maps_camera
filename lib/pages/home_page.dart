import 'package:flutter/material.dart';
import 'package:flutter_base/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_base/models/todo.dart';
// import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:convert';
// import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';

// import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /*final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;*/

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();

    getLocation().then((result) {
          setState(() {
              _kGooglePlex = result;
          });
      });
    testuser();
    /*_todoList = new List();
    _todoQuery = _database
        .reference()
        .child("Location")
        .orderByChild("userId")
        .equalTo(widget.userId);*/
   /* _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);*/
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  /*void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }*/

 /* _onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });*

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] = Todo.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }*/

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

 /* _addNewTodo(String todoItem) {
    if (todoItem.length > 0) {

      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  _updateTodo(Todo todo){
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  _deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }*/

  /*_showDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add new todo',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    _addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
      }
    );
  }
*/
  Widget _showLocation() {
    /*if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String subject = _todoList[index].subject;
            bool completed = _todoList[index].completed;
            String userId = _todoList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteTodo(todoId, index);
              },
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 20.0,
                    )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      _updateTodo(_todoList[index]);
                    }),
              ),
            );
          });
    } else {*/
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));

  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //       appBar: new AppBar(
  //         title: new Text('TRACKED YOU!'),
  //         actions: <Widget>[
  //           new FlatButton(
  //               child: new Text('Logout',
  //                   style: new TextStyle(fontSize: 17.0, color: Colors.white)),
  //               onPressed: _signOut)
  //         ],
  //       ),
  //       body: _showLocation(),
  //       /*floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           _showDialog(context);
  //         },
  //         tooltip: 'Increment',
  //         child: Icon(Icons.add),
  //       )*/
  //   );
  // }

  void testuser(){
    print("99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"+widget.userId);
  }

  GoogleMapController mapController;
  Location location = new Location();

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  int a;

  // Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
  Stream<dynamic> query;

  // Subscription
  StreamSubscription subscription;
  static CameraPosition _kGooglePlex;

  Future<CameraPosition> getLocation() async {
    var pos = await location.getLocation();

    if (location != null){
    _kGooglePlex = CameraPosition (
      target: LatLng(pos['latitude'], pos['longitude']),
      zoom: 18.0,
    );
    }else{
    _kGooglePlex = CameraPosition(
            target: LatLng(24.142, -110.321),
            zoom: 15
          );
    }
  print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  print(_kGooglePlex);
    return _kGooglePlex;
  }

  // @override
  //   void initState() {
  //     getLocation().then((result) {
  //         setState(() {
  //             _kGooglePlex = result;
  //         });
  //     });
  //   }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('TRACKED YOU!'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
          // initialCameraPosition: CameraPosition(
          //   target: LatLng(13.5340, 80.0020),
          //   zoom: 16
          // ),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid, 
          compassEnabled: true,
          trackCameraPosition: true,
      ),
    //  Positioned(
    //       bottom: 50,
    //       right: 10,
    //       child: 
    //       FlatButton(
    //         child: Icon(Icons.play_arrow, color: Colors.white),
    //         color: Colors.blue,
    //         //onPressed: _addGeoPoint
    //         onPressed: repeat
    //       )
    //   ),
    //      Positioned(
    //       bottom: 10,
    //       right: 10,
    //       child: 
    //       FlatButton(
    //         child: Icon(Icons.stop, color: Colors.white),
    //         color: Colors.blue,
    //         onPressed: stop
    //         //onPressed: _addMarker
    //       )
    //   ),
        ],),
        bottomNavigationBar: BottomAppBar(
          child: Container(height: 100.0, child: Stack(children: <Widget>[
            // Positioned(bottom: 50, left: 20, child: Text("Start", style: TextStyle(color: Colors.black),),),
            // Positioned(bottom: 50, right: 20, child: Text("Stop"),),
            Positioned(
          bottom: 30,
          left: 20,
          child: 
          FlatButton(
            child: Icon(Icons.play_arrow, color: Colors.white),
            color: Colors.blue,
            //onPressed: _addGeoPoint
            onPressed: repeat
          )
      ),
         Positioned(
           bottom: 30,
           right: 20,
          child: 
          FlatButton(
            child: Icon(Icons.stop, color: Colors.white),
            color: Colors.blue,
            onPressed: stop
            //onPressed: _addMarker
          )
      ),
          ],),)
      // child: Stack(children: <Widget>[
      //     Positioned(
      //     bottom: 50,
      //     right: 10,
      //     child: 
      //     FlatButton(
      //       child: Icon(Icons.play_arrow, color: Colors.white),
      //       color: Colors.blue,
      //       //onPressed: _addGeoPoint
      //       onPressed: repeat
      //     )
      // ),
      //    Positioned(
      //      bottom: 5,
      //      right: 5,
      //     child: 
      //     FlatButton(
      //       child: Icon(Icons.stop, color: Colors.white),
      //       color: Colors.blue,
      //       onPressed: stop
      //       //onPressed: _addMarker
      //     )
      // ),
      // ],),
    ),
    );

    // GoogleMap(
    //       // initialCameraPosition: CameraPosition(
    //       //   target: LatLng(13.5340, 80.0020),
    //       //   zoom: 16
    //       // ),
    //       initialCameraPosition: _kGooglePlex,
    //       onMapCreated: _onMapCreated,
    //       myLocationEnabled: true,
    //       mapType: MapType.hybrid, 
    //       compassEnabled: true,
    //       trackCameraPosition: true,
    //   ),
    //  Positioned(
    //       bottom: 50,
    //       right: 10,
    //       child: 
    //       FlatButton(
    //         child: Icon(Icons.play_arrow, color: Colors.white),
    //         color: Colors.blue,
    //         //onPressed: _addGeoPoint
    //         onPressed: repeat
    //       )
    //   ),
    //      Positioned(
    //       bottom: 10,
    //       right: 10,
    //       child: 
    //       FlatButton(
    //         child: Icon(Icons.stop, color: Colors.white),
    //         color: Colors.blue,
    //         onPressed: stop
    //         //onPressed: _addMarker
    //       )
    //   ),
      // Positioned(
      //   bottom: 50,
      //   left: 10,
      //   child: Slider(
      //     min: 100.0,
      //     max: 500.0, 
      //     divisions: 4,
      //     value: radius.value,
      //     label: 'Radius ${radius.value}km',
      //     activeColor: Colors.green,
      //     inactiveColor: Colors.green.withOpacity(0.2),
      //     onChanged: _updateQuery,
      //   )
      // )
    // ]);
  }

  // Map Created Lifecycle Hook
  _onMapCreated(GoogleMapController controller) {
    _startQuery();
    setState(() {
      mapController = controller;
    });
  }

  _addMarker() async {
    var pos = await location.getLocation();
    var marker = MarkerOptions(
      //position: mapController.cameraPosition.target,
      position: LatLng(pos['latitude'], pos['longitude']),
      icon: BitmapDescriptor.defaultMarker,
      infoWindowText: InfoWindowText("Current Location", '')
    );

    mapController.addMarker(marker);
  }
  
  _addMarker1() async {
    var pos = await location.getLocation();
    var marker = MarkerOptions(
      //position: mapController.cameraPosition.target,
      position: LatLng(pos['latitude'], pos['longitude']),
      icon: BitmapDescriptor.defaultMarker,
      infoWindowText: InfoWindowText("Current Location", '')
    );

    mapController.addMarker(marker);
  }


  void repeat() {
    a = 1;
    Timer.periodic(new Duration(seconds: 10), (timer){
      _addMarker1();
      _addGeoPoint();
      _test();
      testuser();
      //a++;
      print("jhvjhmvjhvjhvjhvhm+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      if(a == 7){timer.cancel();}}
    );
  }

  void stop(){
    a = 7;
  }

  void _test(){
    print("testing");
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(pos['latitude'], pos['longitude']),
          zoom: 17.0,
        )
      )
    );
  }

  // Set GeoLocation Data
  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    double lat = pos['latitude'];
    double lon = pos['longitude'];
    _saveData(new location1(lat, lon));
    GeoFirePoint point = geo.point(latitude: pos['latitude'], longitude: pos['longitude']);
    return firestore.collection('locations').add({ 
      'position': point.data,
      // 'name': 'Yay I can be q/ueried!' 
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    mapController.clearMarkers();
    documentList.forEach((DocumentSnapshot document) {
        GeoPoint pos = document.data['position']['geopoint'];
        double distance = document.data['distance'];
        var marker = MarkerOptions(
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
        );

        mapController.addMarker(marker);
    });
  }

  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos['latitude'];
    double lng = pos['longitude'];


    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center, 
        radius: rad, 
        field: 'position', 
        strictMode: true
      );
    }).listen(_updateMarkers);
  }

  _updateQuery(value) {
      final zoomMap = {
          100.0: 12.0,
          200.0: 10.0,
          300.0: 7.0,
          400.0: 6.0,
          500.0: 5.0 
      };
      final zoom = zoomMap[value];
      mapController.moveCamera(CameraUpdate.zoomTo(zoom));

      setState(() {
        radius.add(value);
      });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  var jsonCodec = const JsonCodec(); 

  _saveData(location1 _location1) async {
    var json = jsonCodec.encode(_location1);
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++json = $json");

    // var url = "https://flutter-maps-1553606423657.firebaseio.com/location.json";
    var url = "https://flutter-maps-1553606423657.firebaseio.com/"+widget.userId+".json";
    //var httpClient = createHttpClient();
    // http.post(url, body: json).then((response){
    //   print("status: ${response.statusCode}");
    //   print("body: ${response.body}");
    // });
    var response = await http.post(url, body: json);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}




// class FireMap extends StatefulWidget {
//   State createState() => FireMapState();
// }

// class FireMapState extends State<FireMap> {
//   GoogleMapController mapController;
//   Location location = new Location();

//   Firestore firestore = Firestore.instance;
//   Geoflutterfire geo = Geoflutterfire();
//   int a;

//   // Stateful Data
//   BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
//   Stream<dynamic> query;

//   // Subscription
//   StreamSubscription subscription;
//   static CameraPosition _kGooglePlex;

//   Future<CameraPosition> getLocation() async {
//     var pos = await location.getLocation();

//     if (location != null){
//     _kGooglePlex = CameraPosition (
//       target: LatLng(pos['latitude'], pos['longitude']),
//       zoom: 18.0,
//     );
//     }else{
//     _kGooglePlex = CameraPosition(
//             target: LatLng(24.142, -110.321),
//             zoom: 15
//           );
//     }
//   print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
//   print(_kGooglePlex);
//     return _kGooglePlex;
//   }

//   @override
//     void initState() {
//       getLocation().then((result) {
//           setState(() {
//               _kGooglePlex = result;
//           });
//       });
//     }


//   @override
//   Widget build(context) {
//     return Stack(children: [

//     GoogleMap(
//           // initialCameraPosition: CameraPosition(
//           //   target: LatLng(13.5340, 80.0020),
//           //   zoom: 16
//           // ),
//           initialCameraPosition: _kGooglePlex,
//           onMapCreated: _onMapCreated,
//           myLocationEnabled: true,
//           mapType: MapType.hybrid, 
//           compassEnabled: true,
//           trackCameraPosition: true,
//       ),
//      Positioned(
//           bottom: 50,
//           right: 10,
//           child: 
//           FlatButton(
//             child: Icon(Icons.play_arrow, color: Colors.white),
//             color: Colors.blue,
//             //onPressed: _addGeoPoint
//             onPressed: repeat
//           )
//       ),
//          Positioned(
//           bottom: 10,
//           right: 10,
//           child: 
//           FlatButton(
//             child: Icon(Icons.stop, color: Colors.white),
//             color: Colors.blue,
//             onPressed: stop
//             //onPressed: _addMarker
//           )
//       ),
//       // Positioned(
//       //   bottom: 50,
//       //   left: 10,
//       //   child: Slider(
//       //     min: 100.0,
//       //     max: 500.0, 
//       //     divisions: 4,
//       //     value: radius.value,
//       //     label: 'Radius ${radius.value}km',
//       //     activeColor: Colors.green,
//       //     inactiveColor: Colors.green.withOpacity(0.2),
//       //     onChanged: _updateQuery,
//       //   )
//       // )
//     ]);
//   }

//   // Map Created Lifecycle Hook
//   _onMapCreated(GoogleMapController controller) {
//     _startQuery();
//     setState(() {
//       mapController = controller;
//     });
//   }

//   _addMarker() async {
//     var pos = await location.getLocation();
//     var marker = MarkerOptions(
//       //position: mapController.cameraPosition.target,
//       position: LatLng(pos['latitude'], pos['longitude']),
//       icon: BitmapDescriptor.defaultMarker,
//       infoWindowText: InfoWindowText("Current Location", '')
//     );

//     mapController.addMarker(marker);
//   }
  
//   _addMarker1() async {
//     var pos = await location.getLocation();
//     var marker = MarkerOptions(
//       //position: mapController.cameraPosition.target,
//       position: LatLng(pos['latitude'], pos['longitude']),
//       icon: BitmapDescriptor.defaultMarker,
//       infoWindowText: InfoWindowText("Current Location", '')
//     );

//     mapController.addMarker(marker);
//   }


//   void repeat() {
//     a = 1;
//     Timer.periodic(new Duration(seconds: 10), (timer){
//       _addMarker1();
//       _test();
//       //a++;
//       print("jhvjhmvjhvjhvjhvhm+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
//       if(a == 7){ timer.cancel();}}
//     );
//   }

//   void stop(){
//     a = 7;
//   }

//   void _test(){
//     print("testing");
//   }

//   _animateToUser() async {
//     var pos = await location.getLocation();
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//           target: LatLng(pos['latitude'], pos['longitude']),
//           zoom: 17.0,
//         )
//       )
//     );
//   }

//   // Set GeoLocation Data
//   Future<DocumentReference> _addGeoPoint() async {
//     var pos = await location.getLocation();
//     double lat = pos['latitude'];
//     double lon = pos['longitude'];
//     _saveData(new location1(lat, lon));
//     GeoFirePoint point = geo.point(latitude: pos['latitude'], longitude: pos['longitude']);
//     return firestore.collection('locations').add({ 
//       'position': point.data,
//       'name': 'Yay I can be queried!' 
//     });
//   }

//   void _updateMarkers(List<DocumentSnapshot> documentList) {
//     print(documentList);
//     mapController.clearMarkers();
//     documentList.forEach((DocumentSnapshot document) {
//         GeoPoint pos = document.data['position']['geopoint'];
//         double distance = document.data['distance'];
//         var marker = MarkerOptions(
//           position: LatLng(pos.latitude, pos.longitude),
//           icon: BitmapDescriptor.defaultMarker,
//           infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
//         );

//         mapController.addMarker(marker);
//     });
//   }

//   _startQuery() async {
//     // Get users location
//     var pos = await location.getLocation();
//     double lat = pos['latitude'];
//     double lng = pos['longitude'];


//     // Make a referece to firestore
//     var ref = firestore.collection('locations');
//     GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

//     // subscribe to query
//     subscription = radius.switchMap((rad) {
//       return geo.collection(collectionRef: ref).within(
//         center: center, 
//         radius: rad, 
//         field: 'position', 
//         strictMode: true
//       );
//     }).listen(_updateMarkers);
//   }

//   _updateQuery(value) {
//       final zoomMap = {
//           100.0: 12.0,
//           200.0: 10.0,
//           300.0: 7.0,
//           400.0: 6.0,
//           500.0: 5.0 
//       };
//       final zoom = zoomMap[value];
//       mapController.moveCamera(CameraUpdate.zoomTo(zoom));

//       setState(() {
//         radius.add(value);
//       });
//   }

//   @override
//   dispose() {
//     subscription.cancel();
//     super.dispose();
//   }

//   var jsonCodec = const JsonCodec(); 

//   _saveData(location1 _location1) async {
//     var json = jsonCodec.encode(_location1);
//     print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++json = $json");

//     var url = "https://flutter-maps-1553606423657.firebaseio.com/location.json";
//     //var httpClient = createHttpClient();
//     // http.post(url, body: json).then((response){
//     //   print("status: ${response.statusCode}");
//     //   print("body: ${response.body}");
//     // });
//     var response = await http.post(url, body: json);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }



class location1{
  double lat,lon;
  
  location1(this.lat, this.lon);

  Map toJson(){
    return {"latitute": lat, "longitude": lon};
  }
}