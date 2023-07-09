import 'package:flutter/material.dart';
import 'package:mouse_irl_website/screens/home.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(40.0),
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/images/catbot.png'),
          ),
          const SizedBox(height: 30,),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'suck a dick',
            ),
          ),
          const SizedBox(height: 10,),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: const Text('Login'),
          ),
        ],
      )
    );
  }
}