import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelOverviewScreen extends StatelessWidget {
  Future<Map<String, String?>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName'),
      'lastName': prefs.getString('lastName'),
      'age': prefs.getString('age'),
      'cpf': prefs.getString('cpf'),
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visão Geral do Hotel'),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados do usuário'));
          } else {
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${userData['firstName']} ${userData['lastName']}'),
                  Text('Idade: ${userData['age']}'),
                  Text('CPF: ${userData['cpf']}'),
                  Text('Email: ${userData['email']}'),
                  // Não exiba a senha na interface do usuário
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
