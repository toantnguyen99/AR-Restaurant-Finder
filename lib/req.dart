import "package:http/http.dart" as http;
import "dart:convert";
class Store{
  final double lat;
  final double lon;
  final String name;
  final double priceLevel;
  final double rating;
  final String vicinity;
  double alteredLat;
  double alteredLong;
  double distance;
  double coordX;
  double coordZ;
  Store({this.lat, this.lon, this.name, this.priceLevel, this.rating, this.vicinity});

  factory Store.fromJson(Map<String, dynamic> json){
    print("Store JSON: $json");
    return Store(
      lat: json['location']['lat'],
      lon: json['location']['lng'],
      name: json['name'],
      priceLevel: json['priceLevel'],
      rating: json['rating'],
      vicinity: json['vicinity']
    );
  }
}
class StoresList{
  List<Store> stores;
  StoresList({this.stores});
  factory StoresList.fromJson(List<dynamic> json){
   List<Store> stores = new List<Store>();
   stores = json.map((i)=>Store.fromJson(i)).toList();
   return new StoresList(
     stores: stores
   );
  }
}
Future<StoresList> fetchStore(double lon, double lat) async{
  final response = await http.get("https://shielded-thicket-68030.herokuapp.com/$lat/$lon");
  if (response.statusCode == 200){
    var body = response.body;
    print('JSON: $body');
    return StoresList.fromJson(jsonDecode(response.body));
  }else {
    // If that call was not successful, throw an error.
    throw Exception('Cannot load stores');
  }
}