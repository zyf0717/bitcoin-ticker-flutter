import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'Select currency',
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '86BC0EBB-A500-4440-AAEE-B5F3E686EC77';
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getRates(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (var crypto in cryptoList) {
      String url =
          '$coinAPIURL/$crypto/$currency?apikey=63CF6F4D-3B7E-4FC7-BD07-13160B622FAD';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        print('Checking $crypto to $currency rates...');
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
