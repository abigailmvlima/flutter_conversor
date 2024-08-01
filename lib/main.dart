import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL";

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Flutter

    Map data = await getData();
    print(data);


  runApp(MaterialApp(
    home: Container(),
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

