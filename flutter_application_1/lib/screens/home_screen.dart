import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Text(
          "Bienvenido a la pantalla de inicio",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
