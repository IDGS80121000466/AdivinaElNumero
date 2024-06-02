import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Adivina el Número - Emmanuel Escobedo - IDGS901'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controlador = TextEditingController();
  late int numeroAAdivinar;
  late int numeroBajo;
  late int numeroAlto;
  int intentosRestantes = 10;

  @override
  void initState() {
    super.initState();
    numeroAAdivinar = Random().nextInt(101);
    numeroBajo = 1;
    numeroAlto = 100;
    intentosRestantes = 10;
  }

  void verificarNumero(BuildContext context) {
    if (intentosRestantes > 0) {
      final numeroIngresado = int.tryParse(controlador.text);
      if (numeroIngresado != null) {
        setState(() {
          if (numeroIngresado == numeroAAdivinar) {
            mostrarAlerta(context, '¡Felicidades! Has adivinado el número $numeroAAdivinar');
          } else if (numeroIngresado < numeroAAdivinar) {
            numeroBajo = numeroIngresado;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El número es bajo'), backgroundColor: Colors.red),
            );
          } else {
            numeroAlto = numeroIngresado;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El número es alto'), backgroundColor: Colors.green),
            );
          }
          intentosRestantes--;
          controlador.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Ingresa un número válido'), backgroundColor: Colors.red),
        );
      }
    } else {
      mostrarAlerta(context, 'Ya no tienes intentos Perdedor. El número era $numeroAAdivinar');
    }
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarJuego();
              },
              child: Text('Reiniciar Juego'),
            ),
          ],
        );
      },
    );
  }

  void reiniciarJuego() {
    setState(() {
      numeroAAdivinar = Random().nextInt(100) + 1;
      numeroBajo = 1;
      numeroAlto = 100;
      intentosRestantes = 10;
      controlador.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.3, 1],
            colors: [Color.fromARGB(255, 252, 253, 252), Color.fromARGB(255, 177, 221, 225)],
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Intentos restantes: $intentosRestantes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controlador,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 3,
                obscureText: false,
                autofocus: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.numbers),
                  helperText: 'Numero Bajo: $numeroBajo',
                  border: OutlineInputBorder(),
                  counterText: 'Numero Alto: $numeroAlto',
                  hintText: 'Escribe un número de $numeroBajo a $numeroAlto',
                  fillColor: Colors.blue, filled: true,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () => verificarNumero(context),
                child: Text('Comprobar'),
              ),              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reiniciarJuego,
        tooltip: 'Reiniciar',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
