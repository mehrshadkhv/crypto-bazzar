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
  bool isSearchLoadingVisible = false;
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (Value) {
                    _filterList(Value);
                  },
                  decoration: InputDecoration(
                    hintText: 'اسم رمزارز معتبر را سرچ کنید',
                    hintStyle: TextStyle(fontFamily: 'mr', color: Colors.white),
                    hintTextDirection: TextDirection.rtl,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    filled: true,
                    fillColor: greenColor,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSearchLoadingVisible,
              child: Text(
                '...در حال آپدیت اطلاعات رمزارز ها',
                style: TextStyle(
                  color: greenColor,
                  fontFamily: 'mr',
                  fontSize: 18.0,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: greyColor,
                backgroundColor: greenColor,
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
          ],
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
      'API Key', //Put your CoinCap API here
    );
    List<dynamic> jsonList = response.data['data'];
    List<Crypto> cryptoList = jsonList
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _filterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }

    cryptoResultList = cryptoList!
        .where(
          (element) =>
              element.name.toLowerCase().contains(enteredKeyword.toLowerCase()),
        )
        .toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
