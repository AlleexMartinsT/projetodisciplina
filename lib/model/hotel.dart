class Hotel {
  final String id;
  final String name;
  final String iataCode;
  final String subType;
  final String hotelId;
  final String cityName;
  final String countryCode;
  final String? imageUrl;
  final String? description;

  Hotel({
    required this.id,
    required this.name,
    required this.iataCode,
    required this.subType,
    required this.hotelId,
    required this.cityName,
    required this.countryCode,
    this.imageUrl,
    this.description,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['hotelId'] ?? '',
      name: json['name'] ?? '',
      iataCode: json['iataCode'] ?? '',
      subType: json['type'] ?? '',
      hotelId: json['hotelId'] ?? '',
      cityName: json['address']['cityName'] ?? '',
      countryCode: json['address']['countryCode'] ?? '',
      imageUrl: json['media'] != null && json['media'].isNotEmpty
          ? json['media'][0]['uri']
          : null,
      description: json['description'] ?? '',
    );
  }
}
