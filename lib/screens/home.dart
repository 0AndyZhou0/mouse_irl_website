import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
            height: 200,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Container(
            height: 200,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}