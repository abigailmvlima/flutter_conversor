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
  late double dollar;
  late double euro;

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
                  return const SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),
                      SizedBox(height: 20.0,),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Real",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dolár",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Euro",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),
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
}
