import 'package:flutter/material.dart';
import 'package:mobileapp/handle/userPro.dart';
import 'package:mobileapp/pages/sample.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _load createState() => _load();
}

class _load extends State<Loading> {
  @override
  void initState() {
    super.initState();
    // Call getWaterLevel only once when the widget is created
    getWaterLevel(context, Provider.of<userpro>(context, listen: false).id);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: screenSize.height * 0.08,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/tank');
            },
            icon: Icon(Icons.arrow_drop_down_sharp),
            color: Colors.black,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: spinkit,
      ),
    );
  }
}

Future<void> getWaterLevel(BuildContext context, String user) async {
  try {
    final response = await http.post(
      Uri.parse('http://54.160.171.100/api/user/hardware/receive-water-level'),
      body: jsonEncode({
        'userId': user,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String waterLevel = responseData['data']['waterLevel'] ?? '0.0';

      print("Water level: $waterLevel");

      Provider.of<userpro>(context, listen: false).setwaterlevel(waterLevel);
      print("Registration successful: ${responseData['success']}");
    } else {
      print("Registration failed with status code: ${response.statusCode}");
      throw Exception("Failed to fetch water level");
    }
  } catch (error) {
    print("Error during HTTP request: $error");
    // handle error accordingly
  }
}
