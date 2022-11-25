import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class MapServices {
  // final String key = 'API_KEY';
  // final String types = 'geocode';
  final String foursquareApiUrl = "https://api.foursquare.com";
  final String foursquareApiKey =
      "fsq3/G1x0EqMynsoNCFMPARrF7nBw+5Yn2uJyuStttyEP1E=";
  Future<List> getNearbyPlaces(LocationData l) async {
    var value = await http.get(
        Uri.parse(
            "$foursquareApiUrl/v3/places/search?ll=${l.latitude}%2C${l.longitude}&radius=1000"),
        headers: {
          "Accept": "application/json",
          "Authorization": foursquareApiKey,
          "Host": "api.foursquare.com"
        });

    var data = jsonDecode(value.body);

    print(data["results"]);
    // for (int i = 0; i < data["results"].length; i++) {
    //   //send data to firebase
    // }

    return data["results"];
  }

  // Future<Map<String, dynamic>> getPlace(String? input) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';

  //   var response = await http.get(Uri.parse(url));

  //   var json = jsonDecode(response.body);

  //   var results = json['result'] as Map<String, dynamic>;

  //   return results;
  // }

  // Future<Map<String, dynamic>> getDirections(
  //     String origin, String destination) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

  //   var response = await http.get(Uri.parse(url));

  //   var json = convert.jsonDecode(response.body);

  //   var results = {
  //     'bounds_ne': json['routes'][0]['bounds']['northeast'],
  //     'bounds_sw': json['routes'][0]['bounds']['southwest'],
  //     'start_location': json['routes'][0]['legs'][0]['start_location'],
  //     'end_location': json['routes'][0]['legs'][0]['end_location'],
  //     'polyline': json['routes'][0]['overview_polyline']['points'],
  //     'polyline_decoded': PolylinePoints()
  //         .decodePolyline(json['routes'][0]['overview_polyline']['points'])
  //   };

  //   return results;
  // }

  // Future<dynamic> getPlaceDetails(LatLng coords, int radius) async {
  //   var lat = coords.latitude;
  //   var lng = coords.longitude;

  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=$lat,$lng&radius=$radius&key=$key';

  //   var response = await http.get(Uri.parse(url));

  //   var json = jsonDecode(response.body);

  //   return json;
  // }

//   Future<dynamic> getMorePlaceDetails(String token) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$key';

//     var response = await http.get(Uri.parse(url));

//     var json = jsonDecode(response.body);

//     return json;
  // }
}
