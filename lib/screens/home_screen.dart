import 'package:crypto_bazzar/data/model/crypto.dart';
import 'package:crypto_bazzar/screens/coin_list_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      'https://rest.coincap.io/v3/assets?apiKey=b3300f24b85279a26c13a5b47947b08ea7723666754a0c72535f61086b6ae7c9',
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
