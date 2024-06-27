import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/hotel.dart';

class Amadeus {
  String? token;
  final String clientId = 'J3fDHUv36Fzv4XcnSCROOJYvLLnmoVj5';
  final String clientSecret = 'Gs7O9Wai4gfujGd8';

  Future<String?> generateAccessToken() async {
    Uri authorizationUri = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");

    try {
      final response = await http.post(
        authorizationUri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['access_token'];
        return token;
      } else {
        print("Failed to generate access token: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error generating token: $e");
      return null;
    }
  }

  Future<List<Hotel>> fetchHotelOffers(String cityCode) async {
    final accessToken = await generateAccessToken();
    if (accessToken == null) return [];

    Uri uri = Uri.parse("https://test.api.amadeus.com/v2/shopping/hotel-offers?cityCode=$cityCode&page%5Blimit%5D=10");

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<Hotel> hotels = [];

        for (var hotelInfo in responseData['data']) {
          final hotel = Hotel.fromJson(hotelInfo['hotel']);
          hotels.add(hotel);
        }
        return hotels;
      } else {
        print("Error fetching hotel offers: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  Future<Hotel?> fetchHotelById(String hotelId) async {
    final accessToken = await generateAccessToken();
    if (accessToken == null) return null;

    Uri uri = Uri.parse("https://test.api.amadeus.com/v1/reference-data/locations/hotels/by-hotels?hotelIds=$hotelId");

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          return Hotel.fromJson(responseData['data'][0]);
        } else {
          print("No data found for the given hotel ID");
          return null;
        }
      } else {
        print("Error fetching hotel: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  Future<bool> bookHotel({
    required String hotelId,
    required String name,
    required String email,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    final accessToken = await generateAccessToken();
    if (accessToken == null) return false;

    final bookingDetails = {
      'data': {
        'hotelId': hotelId,
        'guests': [
          {
            'name': name,
            'email': email,
          }
        ],
        'checkInDate': checkInDate.toIso8601String(),
        'checkOutDate': checkOutDate.toIso8601String(),
      }
    };

    try {
      final response = await http.post(
        Uri.parse('https://test.api.amadeus.com/v1/booking/hotel-bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(bookingDetails),
      );

      if (response.statusCode == 200) {
        print("Booking successful: ${response.body}");
        return true;
      } else {
        print("Booking failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }
}
