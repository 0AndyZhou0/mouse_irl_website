import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';
import 'reset_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text(
      'mouse_irl login',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      obscureText: title == 'Password' ? true : false,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : errorMessage!);
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        isLogin
            ? signInWithEmailAndPassword()
            : createUserWithEmailAndPassword();
      },
      child: isLogin ? const Text('Login') : const Text('Create Account'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: isLogin ? const Text('Create Account') : const Text('Login'),
    );
  }

  Widget _resetPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          ),
        );
      },
      child: const Text('Forgot Password'),
    );
  }

  Widget _signInWithGoogle() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Image.asset(
        'assets/images/google_logo.png',
        width: 20,
      ),
      label: const Text('Sign in with Google'),
      onPressed: () {
        Auth().signInWithGoogle();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(40.0),
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/catbot.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            _entryField('Email', _emailController),
            const SizedBox(
              height: 10,
            ),
            _entryField('Password', _passwordController),
            _errorMessage(),
            const SizedBox(
              height: 30,
            ),
            _submitButton(),
            _loginOrRegisterButton(),
            _resetPasswordButton(),
            const SizedBox(
              height: 30,
            ),
            _signInWithGoogle(),
          ],
        ));
  }
}
