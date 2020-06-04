import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var exchangeRates;
  var displayedCards;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownMenuItemList = [
      for (String currency in currenciesList)
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        )
    ];
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownMenuItemList,
        onChanged: (value) async {
          setState(() {
            selectedCurrency = value;
            getData();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerList = [
      for (String currency in currenciesList) Text(currency)
    ];
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (selected) async {
        setState(() {
          selectedCurrency = currenciesList[selected];
          getData();
        });
      },
      children: pickerList,
    );
  }

  void getData() async {
    isWaiting = true;
    setState(() {});
    try {
      var data = await CoinData().getRates(selectedCurrency);
      isWaiting = false;
      setState(() {
        exchangeRates = data;
      });
    } catch (e) {
      print(e);
    }
  }

  List<StatelessWidget> getDisplayedCards() {
    List<StatelessWidget> cardsList = [];
    for (var crypto in cryptoList) {
      cardsList.add(ConversionCards(
        exchangeRate: isWaiting ? '?' : exchangeRates[crypto],
        selectedCurrency: selectedCurrency,
        crypto: crypto,
      ));
    }
    return cardsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: ModalProgressHUD(
        color: Colors.black87,
        inAsyncCall: isWaiting,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: getDisplayedCards(),
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversionCards extends StatelessWidget {
  const ConversionCards(
      {this.exchangeRate, this.selectedCurrency, this.crypto});

  final String exchangeRate;
  final String selectedCurrency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $exchangeRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
