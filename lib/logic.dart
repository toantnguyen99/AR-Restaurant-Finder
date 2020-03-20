import 'dart:math';
import 'req.dart';
class Rotation {
 List<double> rotate(double latitude, double longitude, double angle){
   double lat = latitude;
   double lon = longitude;
   lat = cos(angle) * longitude - sin(angle) * latitude;
   lon = sin(angle) * longitude + cos(angle) * latitude;
   return [lon, lat];
 }
 List<List<double>> multipleRotate(List<List<double>> inputVectors){
   List<List<double>> output_list = new List();
   for (var i = 0; i < inputVectors.length; i++){
     List l = rotate(inputVectors[i][0],inputVectors[i][1], inputVectors[i][2]);
     output_list.add(l);
   }
   return output_list;
 }
}
class Simulation {
 double xangle;
 double distance = 1000;
 List camerav;
 var bounds;
 var storevector = new List(2);
 double storeangle;
 String closeststore;
 double cameraangle;
 var rng = new Random();
 Simulation() {
   this.xangle = xangle;
   this.camerav = new List(2);
   this.bounds = new List(2);
   this.closeststore = closeststore;
   this.storeangle = storeangle;
   this.cameraangle = cameraangle;
 }

 void generateVector(List x) {
   x[0] = rng.nextInt(20) - 10;
   x[1] = rng.nextInt(20) - 10;
 }
 double getAngle(List x) {
   double xangle = atan((x[1] / x[0]) * 180 / pi);
   return xangle;
 }
 String closeDistance(List storevector, String storestring, double distance,
     String closeststore) {
   if (sqrt(
           pow(storevector[0],2) + pow(storevector[1],2)) < distance) {
     distance = sqrt(pow(storevector[1],2) + pow(storevector[1],2));
     closeststore = "";
     closeststore += storestring;
     return closeststore;
   } else
     return closeststore;
 }
}
void main() {
 var sim = new Simulation();
 List camerav = new List(2);
 sim.generateVector(camerav);
 double cameraangle = sim.getAngle(camerav);
 var bounds = new List(2);
 bounds[0] = cameraangle - 30;
 bounds[1] = cameraangle + 30;
 var x = new List(10);
 for (int i = 0; i < 10; i++) {
   x[i] = new List(3);
   sim.generateVector(x[i]);
   (x[i])[2] = i;
   String closeststore;
   if (sim.getAngle(x[i]) > bounds[0] && sim.getAngle(x[i]) < bounds[1]) {
     closeststore =
         sim.closeDistance(x[i], (x[i][2]).toString(), sim.distance, sim.closeststore);
   }
   sim.closeststore = closeststore;
 }
 print(sim.closeststore);
}


void mapToOrigin(StoresList storesList, double longitude, double latitude){
  for (var i = 0; i < storesList.stores.length; i++) 
  {
    print('Latitude: $latitude');
    print('Lat: $storesList.stores[i].lat');
    storesList.stores[i].alteredLat = storesList.stores[i].lat.toDouble() - latitude;
    storesList.stores[i].alteredLong = storesList.stores[i].lon - longitude;
    storesList.stores[i].distance = sqrt(pow(storesList.stores[i].alteredLat*111320, 2) + pow(storesList.stores[i].alteredLong*111320, 2));
  }
}

 List<double> rotate(double latitude, double longitude, double angle){
   double x = 0.0;
   double z = 0.0;
   x = cos(angle) * longitude - sin(angle) * latitude;
   z = sin(angle) * longitude + cos(angle) * latitude;
   return [x, z];
 }
 void  multipleRotate(StoresList storesList, double angle){
   for (var i = 0; i < storesList.stores.length; i++){
     
     List l = rotate(storesList.stores[i].alteredLat, storesList.stores[i].alteredLong, angle);
     storesList.stores[i].alteredLat = l[1];
     storesList.stores[i].alteredLong = l[0];
   }
 }
 void calculateCoord(StoresList storesList) {
   for (var i = 0; i < storesList.stores.length; i++) {
     String name = storesList.stores[i].name;
     double coordX = storesList.stores[i].alteredLong*111320.0 / 161 * -1;
     double coordZ = storesList.stores[i].alteredLat*111320.0 / 161;
     double distance = storesList.stores[i].distance;
     double alteredLat = storesList.stores[i].alteredLat;
     double altreadLng = storesList.stores[i].alteredLong;
     print('Name: $name; CoordX: $coordX; CoordZ: $coordZ; Distance $distance; AlteredLat: $alteredLat; AlteredLng: $altreadLng');
     storesList.stores[i].coordX = storesList.stores[i].alteredLong*111320.0 / 20 * storesList.stores[i].distance / 40;
     storesList.stores[i].coordZ = storesList.stores[i].alteredLat*111320.0 / 20 * (-1) * storesList.stores[i].distance / 40;
    //  storesList.stores[i].coordX = storesList.stores[i].alteredLong*111320.0  * -1;
    //  storesList.stores[i].coordZ = storesList.stores[i].alteredLat*111320.0;
   }
 }
 