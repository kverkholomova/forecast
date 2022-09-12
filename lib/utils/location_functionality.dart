

import 'package:location/location.dart';

var location = new Location();
// var currentLocation;
// Future<void> getCurrentLocation() async{
//   currentLocation = await location.getLocation();
//   print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
//   print(currentLocation.longitude);
// }

Future<void> serviceEn() async{
  var serviceEnabled = await location.serviceEnabled();
  if(!serviceEnabled){
    serviceEnabled = await location.requestService();
    if(!serviceEnabled){
      return;
    }
  }
}

Future<void> permissGranted() async{
  var permissionGranted = await location.hasPermission();
  if(permissionGranted == PermissionStatus.denied){
    permissionGranted = await location.requestPermission();
  }
  if(permissionGranted != PermissionStatus.granted){
    return;
  }
}