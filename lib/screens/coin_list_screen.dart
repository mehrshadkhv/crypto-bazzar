import 'package:crypto_bazzar/data/model/crypto.dart';
import 'package:flutter/material.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptoList});
  List<Crypto>? cryptoList;
  @override
  State<CoinListScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.red,
              height: 150,
              child: Center(
                child: Text(
                  cryptoList![index].name,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          itemCount: cryptoList!.length,
        ),
      ),
    );
  }
}