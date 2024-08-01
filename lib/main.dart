import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Flutter

  Map data = await getData();

  runApp(MaterialApp(
    home: const Home(),
    debugShowCheckedModeBanner: false, // tirar a faixa debug
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
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

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dollar;
  late double euro;

  // Adicionado: Método para limpar todos os campos de texto
  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  // Adicionado: Método para lidar com mudanças no campo de Reais
  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  // Adicionado: Método para lidar com mudanças no campo de Dólares
  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * dollar).toStringAsFixed(2);
    euroController.text = (dolar * dollar / euro).toStringAsFixed(2);
  }

  // Adicionado: Método para lidar com mudanças no campo de Euros
  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euroValue = double.parse(text);
    realController.text = (euroValue * euro).toStringAsFixed(2);
    dolarController.text = (euroValue * euro / dollar).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  dollar = double.parse(snapshot.data!["USDBRL"]["low"]);
                  euro = double.parse(snapshot.data!["EURBRL"]["low"]);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,),
                      const SizedBox(height: 20.0,),
                      buildTextField("Reais","R\$", realController, _realChanged),
                      const SizedBox(height: 20.0,),
                      buildTextField("Dólares","\$", dolarController, _dolarChanged),
                      const SizedBox(height: 20.0,),
                      buildTextField("Euros","€", euroController, _euroChanged),
                    ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Sem dados disponíveis.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController c, Function(String) f){
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        border: const OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: const TextStyle(
        color: Colors.amber, fontSize: 25.0,
      ),
      onChanged: f,
      keyboardType: const TextInputType.numberWithOptions(decimal: true), // Adicionado: Tipo de teclado numérico
    );
  }
}

