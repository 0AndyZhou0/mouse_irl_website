import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        foregroundColor: Colors.white,
      ),
      // body: ListView(
      //   children: [
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.primary,
      //     ),
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.secondary,
      //     ),
      //     Container(
      //       height: 200,
      //       color: Theme.of(context).colorScheme.tertiary,
      //     ),
      //   ],
      // ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            color: Colors.purple[(((index%16)-7).abs()+1)*100]
          );
        },
      )
    );
  }
}