import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const request = "https://economia.awesomeapi.com.br/json/last/:moedas";

void main() {
  runApp(MaterialApp(
    home: Container(),
    debugShowCheckedModeBanner: false, // tirar a faixa debug
  ));
}