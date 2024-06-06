// lib/model/hotel.dart
class Hotel {
  final String id;
  final String name;
  final String iataCode;
  final String subType;
  final String hotelId;
  final String cityName;
  final String countryCode;

  Hotel({
    required this.id,
    required this.name,
    required this.iataCode,
    required this.subType,
    required this.hotelId,
    required this.cityName,
    required this.countryCode,
  });

  // Método factory para criar uma instância de Hotel a partir de um JSON
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      iataCode: json['iataCode'],
      subType: json['subType'],
      hotelId: json['hotelIds'][0],
      cityName: json['address']['cityName'],
      countryCode: json['address']['countryCode'],
    );
  }
}
