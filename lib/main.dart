import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL";

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Flutter

    Map data = await getData();

  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false, // tirar a faixa debug
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Falha ao carregar os dados");
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),

    );
  }
}


