

import 'package:location/location.dart';

var location = Location();


Future<void> serviceEn() async{
  var serviceEnabled = await location.serviceEnabled();
  if(!serviceEnabled){
    serviceEnabled = await location.requestService();
    if(!serviceEnabled){
      return null;
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