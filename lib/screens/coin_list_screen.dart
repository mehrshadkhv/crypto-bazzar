import 'package:crypto_bazzar/data/constant/constants.dart';
import 'package:crypto_bazzar/data/model/crypto.dart';
import 'package:dio/dio.dart';
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
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text(
          'کریپتو بازار',
          style: TextStyle(color: Colors.white, fontFamily: 'mr'),
        ),
        centerTitle: true,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: greenColor,
          backgroundColor: greyColor,
          onRefresh: () async {
           List<Crypto> freshData = await _getData();
           setState(() {
             cryptoList = freshData;
           });
          },
          child: ListView.builder(
            itemBuilder: (context, index) =>
                _getListTileItem(cryptoList![index]),
            itemCount: cryptoList!.length,
          ),
        ),
      ),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(crypto.name, style: TextStyle(color: greenColor)),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 18),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorChangeText(crypto.changePercent24hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30.0,
              child: Center(
                child: _getIconChangePercent(crypto.changePercent24hr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(Icons.trending_down, size: 24, color: redColor)
        : Icon(Icons.trending_up, size: 24, color: greenColor);
  }

  Color _getColorChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get(
      'https://rest.coincap.io/v3/assets?apiKey=b3300f24b85279a26c13a5b47947b08ea7723666754a0c72535f61086b6ae7c9',
    );
    List<dynamic> jsonList = response.data['data'];
    List<Crypto> cryptoList = jsonList
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }
}
