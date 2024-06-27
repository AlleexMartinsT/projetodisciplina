import 'package:flutter/material.dart';
import 'package:hotel_booking_app/amadeus.dart';
import 'package:hotel_booking_app/model/hotel.dart';
import 'package:hotel_booking_app/screens/hotel_details_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Hotel> _hotels = [];
  final Amadeus _amadeus = Amadeus();

  @override
  void initState() {
    super.initState();
    _fetchHotelOffers();
  }

  Future<void> _fetchHotelOffers() async {
    print("Fetching hotel offers...");
    List<Hotel> hotels = await _amadeus.fetchHotelOffers('LON'); // City code
    setState(() {
      _hotels = hotels;
    });
    print("Fetched ${hotels.length} hotels.");
  }

  Future<void> _searchHotelById() async {
    if (_searchController.text.isNotEmpty) {
      Hotel? hotel = await _amadeus.fetchHotelById(_searchController.text);
      setState(() {
        if (hotel != null) {
          _hotels = [hotel];
        } else {
          _hotels = [];
        }
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca Hotel por ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar por ID do hotel',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchHotelById,
                ),
              ),
              onSubmitted: (_) => _searchHotelById(),
            ),
            const SizedBox(height: 20),
            _hotels.isEmpty
                ? Center(child: Text('Nenhum hotel encontrado'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(hotel: _hotels[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsScreen(hotel: hotel),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'lib/assets/fallback_image.jpg', // Placeholder image
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset('lib/assets/fallback_image.jpg', // Fallback local image
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '10% OFF',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      hotel.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '${hotel.cityName}, ${hotel.countryCode}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      'R\$50/dia',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

