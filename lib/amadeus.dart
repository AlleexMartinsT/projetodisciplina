// amadeus.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/hotel.dart';

class Amadeus {
  String? token;
  late String clientId;
  late String clientSecret;

  void setEnvironment(Map<String, String> env) {
    clientId = env['client_id']!;
    clientSecret = env['client_secret']!;
  }

  Future<String?> generateAccessToken() async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception("Client ID or Client Secret is not set");
    }

    Uri authorizationUri = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");

    try {
      http.Response response = await http.post(
        authorizationUri,
        headers: {"Content-type": "application/x-www-form-urlencoded"},
        body: "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret",
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        token = data['access_token'];
        return token;
      } else {
        print("Error generating token --> ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error generating token --> $e");
      return null;
    }
  }

  Future<void> getHotelOffers(String cityCode, DateTime checkInDate, DateTime checkOutDate, int adults) async {
    try {
      String? accessToken = await generateAccessToken();

      if (accessToken == null) {
        print("Failed to obtain access token");
        return;
      }

      Uri uri = Uri.parse("https://test.api.amadeus.com/v3/shopping/hotel-offers?cityCode=$cityCode&checkInDate=${checkInDate.toIso8601String().split('T')[0]}&checkOutDate=${checkOutDate.toIso8601String().split('T')[0]}&adults=$adults");
      http.Response response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
      } else {
        print("Error getting hotel offers --> ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<List<Hotel>> fetchHotels(String name) async {
    try {
      String? accessToken = await generateAccessToken();

      if (accessToken == null) {
        print("Failed to obtain access token");
        return [];
      }

      Uri uri = Uri.parse("https://test.api.amadeus.com/v1/reference-data/locations/hotels?keyword=$name&subType=HOTEL_GDS&lang=EN&max=20");
      http.Response response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<Hotel> fetchedHotels = [];

        for (int i = 0; i < data.length; i++) {
          Hotel hotel = Hotel(
            id: data[i]['id'],
            name: data[i]['name'],
            iataCode: data[i]['iataCode'],
            subType: data[i]['subType'],
            hotelId: data[i]['hotelId'],
            cityName: data[i]['address']['cityName'],
            countryCode: data[i]['address']['countryCode'],
          );
          fetchedHotels.add(hotel);
        }
        return fetchedHotels;
      } else {
        print("Error fetching hotels --> ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }
}
