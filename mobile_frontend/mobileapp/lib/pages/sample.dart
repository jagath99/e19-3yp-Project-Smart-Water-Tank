
import 'package:flutter/material.dart';
import 'package:mobileapp/handle/userPro.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _load createState() => _load();
}

const spinkit = SpinKitRotatingCircle(
  color: Color.fromARGB(255, 98, 100, 172),
  size: 50.0,
);


Future<void> getWaterLevel(BuildContext context,String user) async {
  try {
    final response = await http.post(
      Uri.parse('http://54.160.171.100/api/user/hardware/receive-water-level'), // Replace with your actual API endpoint
      body: jsonEncode({
        'userId': user, // Replace with the actual user ID or use another way to get it
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String waterLevel = responseData['data']['waterLevel'] ?? '0.0';
      
      print("Water level: $waterLevel");
    
      
      // Use setWaterLevel function according to your implementation.
      Provider.of<userpro>(context,listen:false).setwaterlevel(waterLevel);
      print("Registration successful: ${responseData['success']}");
    } else {
      print("Registration failed with status code: ${response.statusCode}");
      throw Exception("Failed to fetch water level");
    }
  } catch (error) {
    print("Error during HTTP request: $error");
    //throw error;
  }
}


class _load extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Define screenSize variable
    String uid = Provider.of<userpro>(context).id;
    //receiveWaterLevel(uid, context);
    print("get water level1");
    getWaterLevel(context,uid);
    print("get water level");
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: screenSize.height * 0.08, // Set maximum height for the image
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        //centerTitle: true,
        actions: [
          // ignore: prefer_const_constructors
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
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
