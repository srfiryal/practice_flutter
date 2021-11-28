import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String baseUrl = 'https://krista-staging.trackingworks.io';
  String name = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Wrap(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(label: Text('Email')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              label: Text('Password')),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => login(_emailController.text, _passwordController.text),
                          child: const Text('Login')),
                      const SizedBox(height: 30.0,),
                      Text(name),
                    ],
                  ),
                ]
            )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void login(String email, String password) async {
    print('login function called');
    Map<String, String> headers = {
      'user-device': '97a95688f6ad1ab4',
    };

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/employee/authentication/login'),
        headers: headers,
        body: body,
      );

      print(res.statusCode);
      print(res.body.toString());
      var response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
      } else {
        setState(() {
          name = response['meta']['error'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
