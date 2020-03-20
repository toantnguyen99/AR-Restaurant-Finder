import 'dart:math' as math;
import 'package:ar_demo/req.dart';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import "dart:async";
import 'package:flutter_compass/flutter_compass.dart';
import 'logic.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ARKitController arkitController;
  ARKitSceneView arKitSceneView;
  List<ARKitNode> nodes = [];
  double num = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  double _angle = 0;
  StoresList _storesList = new StoresList();
  bool loaded = false;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }




@override
initState(){
  super.initState();
  Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position){
    var handleFlutterCompass;
    StreamSubscription s = FlutterCompass.events.listen((double direction) {
      print("hello");
      handleFlutterCompass(direction);
      
      
    });
    handleFlutterCompass = (double direction) { //direction is angle 3
      
      if (direction!= 0.0){
        s.cancel();
        fetchStore(position.longitude, position.latitude).then((StoresList sList){ //list of stores 1
          print("fetched\n");
          print(sList.stores.length);
          print('sList: $sList');
          print('sList Store: $sList.stores');
          print('sList Lat: $sList.stores[0].lat');
          mapToOrigin(sList, position.longitude, position.latitude);
          multipleRotate(sList, direction);
          calculateCoord(sList); 
          sList.stores = sList.stores.where((i) => i.distance < 100).toList();

          setState(() {
            _angle = direction;
            latitude = position.latitude; //long and lat 2
            longitude = position.longitude;
            _storesList=sList;
            loaded = true;
          });
        });
        
      }
    };
  });
  
  
  //location
  // var geolocator = Geolocator();
  // var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
  
// StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
//     (Position position) {
//         print("\nlocation\n");
//         print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
//         if(position != null){
//           setState(() {
//             this.longitude = position.longitude;
//             this.latitude = position.latitude;
//           });
//         }
//     });



  
  Timer.periodic(Duration(seconds: 5), (timer){
    // setState(() {
      
    // })
    
  });
  
}
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('ARKit in Flutter')),
      body: Stack(
        children: <Widget>[
          loaded ? ARKitSceneView(onARKitViewCreated: onARKitViewCreated): Container()
        ],
      )
    );
      
      
      
  

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    for (var i = 0; i < _storesList.stores.length; i++){
      print('CoordX: $_storesList.stores[i].coordX');
      print('CoordZ: $_storesList.stores[i].coordZ');
      this.arkitController.add(_createPlane(_storesList.stores[i].coordX, _storesList.stores[i].coordZ, _storesList.stores[i].name));
      this.arkitController.add(_createText(_storesList.stores[i].coordX, _storesList.stores[i].coordZ, _storesList.stores[i].name));
      this.arkitController.add(_createText2(_storesList.stores[i].coordX, _storesList.stores[i].coordZ,  _storesList.stores[i].rating));
    }
    

  }
  ARKitNode _createPlane(double coordX, double coordZ, String name2) {
    final plane = ARKitPlane(
      width: 1,
      height: 1,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    final node = ARKitNode(
      geometry: plane,
      name: name2,
      position: vector.Vector3(coordX, 0, coordZ-1),
    );
    
    this.nodes.add(node);
    return node;
  }

  ARKitNode _createText(double coordX, double coordZ, String name) {
    final text = ARKitText(
      text: name,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.lightGreen),
        )
      ],
    );
    final node =  ARKitNode(
      geometry: text,
      position: vector.Vector3(coordX, 0, coordZ -1),
      scale: vector.Vector3(0.01, 0.01, 0.01),
    );
     this.nodes.add(node);
    return node;
  }

    ARKitNode _createText2(double coordX, double coordZ, double rating) {
    final text = ARKitText(
      text: 'Rating: $rating',
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.lightGreen),
        )
      ],
    );
    final node = ARKitNode(
      geometry: text,
      position: vector.Vector3(coordX - 0.4, -0.1, coordZ -1),
      scale: vector.Vector3(0.01, 0.01, 0.01),
    );
     this.nodes.add(node);
    return node;
  }
}