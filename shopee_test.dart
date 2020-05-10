import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'if-none-match-': '*',
  };

  var params = {
    'by': 'relevancy',
    'keyword': 'iphone',
    'limit': '50',
    'newest': '0',
    'order': 'desc',
    'page_type': 'search',
    'version': '2',
  };
  var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

  var res = await http.get('https://shopee.co.id/api/v2/search_items/?$query',
      headers: headers);
  if (res.statusCode == 200) {
    String data = res.body;

    dynamic json = jsonDecode(data);
    int searchLength = json['items'].length;
    print(searchLength);

    for (int x = 0; x < searchLength; x++) {
      String tempPrice =
          (json['items'][x]['price'] / 100000).toStringAsFixed(0);
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      var title = json['items'][x]['name'];
      print(title);
      print(tempPrice);
      String shopId = json['items'][x]['shopid'].toString();
      String itemId = json['items'][x]['itemid'].toString();
      String url = 'https://shopee.co.id/' +
          json['items'][x]['name'].replaceAll(' ', '-') +
          '-i.' +
          shopId +
          '.' +
          itemId;
      print(url);
      var img = 'https://cf.shopee.co.id/file/' + json['items'][x]['image'];
      print(img);
      var rating = json['items'][x]['item_rating']['rating_star'];
      print(rating);
      var reviewCount = 0;
      if (rating != 0) {
        reviewCount = json['items'][x]['item_rating']['rating_count'][0];
      }

      print(reviewCount);
    }
  } else {
    throw Exception('Blibli error: statusCode= ${res.statusCode}');
  }
}
