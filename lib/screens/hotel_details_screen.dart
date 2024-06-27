import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/model/hotel.dart';
import 'package:hotel_booking_app/screens/booking_screen.dart';

class HotelDetailsScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailsScreen({required this.hotel});

  @override
  Widget build(BuildContext context) {
    int desconto = _gerarDescontoAleatorio(); // Gerando o desconto aleatório

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  hotel.imageUrl ?? 'lib/assets/fallback_image.jpg',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(Icons.favorite_border, color: Colors.white, size: 30),
                ),
                Positioned(
                  top: 200,
                  left: 20,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      '${desconto}% OFF', // Usando o desconto gerado
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  right: 20,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '4.5',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text('${hotel.cityName}, ${hotel.countryCode}'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconText(icon: Icons.bed, text: '2 Camas'),
                      IconText(icon: Icons.wifi, text: 'Wifi'),
                      IconText(icon: Icons.free_breakfast, text: 'Café da manhã'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconText(icon: Icons.ac_unit, text: 'Ar cond.'),
                      IconText(icon: Icons.fitness_center, text: 'Academia'),
                      IconText(icon: Icons.square_foot, text: '40m²'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    hotel.description ?? 'Este hotel oferece tudo e mais um pouco.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Preço total',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'R\$${_gerarPrecoAleatorio().toStringAsFixed(2)}/dia',
                          style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(hotel: hotel),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Reserve Agora'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _gerarDescontoAleatorio() {
    Random random = Random();
    return 5 + random.nextInt(31); // Gera um valor entre 5 e 35 (inclusive)
  }

  double _gerarPrecoAleatorio() {
    Random random = Random();
    return 50 + random.nextInt(50) + random.nextDouble();
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 5),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
