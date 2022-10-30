import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SAPP',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('SAPP Testing'),
            ),
            body: Home()));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _token = '';
  List<dynamic> _monitors = [
    {'ID': 'test'}
  ];
  String api_host = 'https://nuvyp2kffa.execute-api.us-east-2.amazonaws.com';
  void _change_text(val) {
    setState(() {
      _token = val;
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'Authorization': 'token $_token'
      };
      http
          .get(Uri.parse('$api_host/monitor'), headers: requestHeaders)
          .then((response) {
        if (response.statusCode == 200) {
          _monitors = jsonDecode(response.body);
          // for (var mon in monitors) {
          //   print(mon['ID']);
          // }
        } else {
          print("error");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(25.0),
            child: TextFormField(
              onFieldSubmitted: _change_text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your user token here',
              ),
            )),
        Container(
            margin: EdgeInsets.all(25.0),
            child: Row(children: <Widget>[
              Expanded(
                  child: MonitorList(
                monitors: _monitors,
              )),
              Text('Reports List'),
            ]))
      ],
    );
  }
}

class MonitorList extends StatefulWidget {
  final List<dynamic> monitors;
  const MonitorList({super.key, required this.monitors});

  @override
  State<MonitorList> createState() => _MonitorListState();
}

class _MonitorListState extends State<MonitorList> {
  List<Widget> _getListings() {
    var listings = <Widget>[];
    for (var mon in widget.monitors) {
      listings.add(Container(
          margin: EdgeInsets.all(5.0),
          color: Colors.blue[600],
          child: Column(children: [
            for (var key in mon.keys)
              Row(
                children: [Text('$key: '), Text(mon[key])],
              )
          ])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _getListings());
  }
}
