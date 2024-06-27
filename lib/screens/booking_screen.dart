import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_booking_app/model/hotel.dart';
import 'package:hotel_booking_app/amadeus.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;

  const BookingScreen({required this.hotel});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _agentEmailController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 1));
  Amadeus amadeus = Amadeus();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (_formKey.currentState!.validate()) {
      String? token = await amadeus.generateAccessToken();
      if (token != null) {
        var bookingDetails = {
          'data': {
            'type': 'hotel-order',
            'guests': [
              {
                'tid': 1,
                'title': _titleController.text,
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'phone': _phoneController.text,
                'email': _emailController.text,
              }
            ],
            'travelAgent': {
              'contact': {
                'email': _agentEmailController.text,
              }
            },
            'roomAssociations': [
              {
                'guestReferences': [
                  {
                    'guestReference': '1'
                  }
                ],
                'hotelOfferId': widget.hotel.hotelId,
              }
            ],
            'payment': {
              'method': 'CREDIT_CARD',
              'paymentCard': {
                'paymentCardInfo': {
                  'vendorCode': 'VI',
                  'cardNumber': _cardNumberController.text,
                  'expiryDate': _expiryDateController.text,
                  'holderName': _cardHolderNameController.text,
                }
              }
            }
          }
        };

        final response = await http.post(
          Uri.parse('https://test.api.amadeus.com/v1/booking/hotel-bookings'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(bookingDetails),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reserva realizada com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao realizar a reserva.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao obter token de acesso.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reservar ${widget.hotel.name}', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.hotel.imageUrl != null && widget.hotel.imageUrl!.isNotEmpty
                      ? Image.network(widget.hotel.imageUrl!, height: 200, fit: BoxFit.cover)
                      : Container(
                          height: 200,
                          color: Colors.grey,
                          child: Icon(Icons.image, size: 100, color: Colors.white),
                        ),
                  SizedBox(height: 20),
                  Text(
                    'CHECK-IN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_checkInDate.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'CHECKOUT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_checkOutDate.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Título (ex: MR, MRS)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu título';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'Primeiro Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu primeiro nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Sobrenome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu sobrenome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu telefone';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _agentEmailController,
                    decoration: InputDecoration(labelText: 'Email do Agente de Viagem'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email do agente de viagem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(labelText: 'Número do Cartão'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número do cartão';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(labelText: 'Data de Expiração (YYYY-MM)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data de expiração do cartão';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _cardHolderNameController,
                    decoration: InputDecoration(labelText: 'Nome do Titular do Cartão'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do titular do cartão';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor : Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Confirmar Reserva',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
