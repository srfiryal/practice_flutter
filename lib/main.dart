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
  final String _baseUrl = 'https://krista-staging.trackingworks.io';
  String _name = '';
  String _schedule = '';
  late String _token;
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
                          onPressed: () => _login(_emailController.text, _passwordController.text),
                          child: const Text('Login')),
                      const SizedBox(height: 5.0,),
                      ElevatedButton(
                          onPressed: () => _getSchedule(_token, '', 1, 15, ''),
                          child: const Text('Get Schedule')),
                      const SizedBox(height: 30.0,),
                      Text(_name),
                      const SizedBox(height: 30.0,),
                      Text(_schedule),
                    ],
                  ),
                ]
            )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _getSchedule(String token, String date, int page, int perPage, String endDate) async {
    print('get schedule function called');
    Map<String, String> headers = {
      'user-device': '3a9d2744b16c3a37',
      'Authorization': 'Bearer $token',
    };

    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/api/v1/employee/schedule?date=$date&page=$page&per_page=$perPage&endDate=$endDate'),
        headers: headers,
      );

      print(res.statusCode);
      print(res.body.toString());
      var response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          _schedule = res.body.toString();
        });
      } else {
        setState(() {
          _name = response['meta']['error'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _login(String email, String password) async {
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
        Uri.parse('$_baseUrl/api/v1/employee/authentication/login'),
        headers: headers,
        body: body,
      );

      print(res.statusCode);
      print(res.body.toString());
      var response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          _token = response['token'];
          _name = response['data']['name'];
        });
      } else {
        setState(() {
          _name = response['meta']['error'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
