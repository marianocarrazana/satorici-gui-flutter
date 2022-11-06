import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  List<dynamic> _monitors = [];
  String api_host = 'https://nuvyp2kffa.execute-api.us-east-2.amazonaws.com';
  Future<void> _change_text(val) async {
    final SharedPreferences prefs = await _prefs;
    _token = prefs.setString('token', val).then((bool success) {
      print('Saved: $val');
      return val;
    });
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'token $val'
    };
    http
        .get(Uri.parse('$api_host/monitor'), headers: requestHeaders)
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _monitors = jsonDecode(response.body);
        });
        // for (var mon in monitors) {
        //   print(mon['ID']);
        // }
      } else {
        print("error");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      var token = prefs.getString('token') ?? 'Paste your token here';
      print(prefs.getString('token'));
      _change_text(token);
      return token;
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
            margin: const EdgeInsets.all(25.0),
            height: 500,
            child: MonitorList(
              monitors: _monitors,
            ))
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
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(95, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 134, 183, 255),
              Colors.blueAccent
            ]),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(108, 11, 23, 33),
                  offset: new Offset(4, 4),
                  blurRadius: 6),
            ],
          ),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
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
    return ListView(padding: const EdgeInsets.all(2), children: _getListings());
  }
}