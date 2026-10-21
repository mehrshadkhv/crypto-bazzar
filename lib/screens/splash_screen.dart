import 'package:crypto_bazzar/data/model/crypto.dart';
import 'package:crypto_bazzar/screens/coin_list_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/logo.png')),
            SizedBox(height: 50.0),
            SpinKitWave(color: Colors.white, size: 30.0),
          ],
        ),
      ),
    );
  }

  void getData() async {
    var response = await Dio().get(
      'API key',//Put your CoinCap API here
    );
    List<dynamic> jsonList = response.data['data'];
    List<Crypto> cryptoList = jsonList
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(cryptoList: cryptoList),
      ),
    );
  }
}
