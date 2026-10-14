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
        child: Center(
          child: SpinKitSpinningLines(color: Colors.white, size: 80.0),
        ),
      ),
    );
  }

  void getData() async {
    var response = await Dio().get(
      'https://rest.coincap.io/v3/assets?apiKey=0884ceb7c980a3462b5979657feb49716d15bcc499a7df38491ad7fdeacf0b55',
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
