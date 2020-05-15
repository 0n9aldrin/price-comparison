import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../product.dart';

class Lazada {
  String search;
  int searchLength;

  Future<dynamic> getTotal({String searches}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    dynamic total = 'not found';
    return total;
  }

  Future<List<Product>> getLazada({String searches, int page}) async {
    search = searches;
    search = search.replaceAll(' ', '%20');

    var html = await getHtml(page: page);
    html = parse(html);
    List<Product> items = getData(html: html);
//    for (int x = 0; x < items.length; x++) {
//      print(items[x].img);
//    }
    return items;
  }

  List<Product> getData({var html}) {
    List<Product> items = [];
    List element = html.querySelectorAll('#root > div');

    return (items);
  }

  Future<dynamic> getHtml({int page}) async {
    var headers = {
      'authority': 'www.lazada.co.id',
      'x-umidtoken':
          'T5F49945755E1E406BEF13C50DBD08DFB0375377D1EC5F513EBA09E3231',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36 OPR/67.0.3575.137',
      'accept': 'application/json, text/plain, */*',
      'sec-fetch-dest': 'empty',
      'x-csrf-token': 'ee5de5e6beb98',
      'x-requested-with': 'XMLHttpRequest',
      'x-ua':
          '123#lMHDblHtPNJuXQbxlDKt8ldEz6XHO1iDg85/aEPS8m/HzaHKDkybFtCmsAZjcdNtkIsTYPdSFHY3ly9pUvpBmFgzjM/1RmsR9hIDHrBVLwBCzAtXI+B3vyJiNHgaNsbt5EmLBxKlX/8iOFJwPN+ll3rgU272WAMXJHyaa+OSVHDJ+5QNOyqQQJ0cpUrA9c50CZKlLLMXFHLovBpbE3uqTnr3FP8ZicVhb0r+s+KVl1Bd2M4CA29MCWsga+HxzdqphfNe5dqgOU9I2YUoCfeNNgNeJmTMQTxxoRCTbRXl5Twb+EpWJ0hc5LliE79UjjgKq28uuf2+aMWj8pCzQE1m/zgvJoMQfLgePYntawdwYZF23BEHSQKf2CN1jcbCVkxi+gXMxwCW/7hqSc5yS25+Gd0SMhQqqPVKOfq0cZoFjOCT+twO/zdBTglrMEH47D+ahnmd8H1W8IfkgUKWV6dJbHXcwdVg25UCZZ8jcCLlZkpd+sZWeeT0CIM49TZ9pnonJnuanBA2Nv8BG29Z0EX/1QWerAVN03LwfEswig0+vuF8I/X6Tnwnunib9V+IS1RX9E+iD1EdDFM1aCZK7X59H+H0sdDzRWaB8yFHjZVZNiEVxslx1EZXopobgWgAy6q6FUZvx4YBKpx7EZPf29l5zue0+pnv7DvMQS5cAfub0MLKl7iKZPxayy6q5s/cSx3LOmqnogMbVU9/',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'referer':
          'https://www.lazada.co.id/catalog/?_keyori=ss&from=input&page=$page&q=$search&spm=a2o4j.home.search.go.57991559Jez22i&style=wf',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
      'cookie':
          'lzd_cid=41c99659-78e5-4856-c6dc-ae268d456578; t_uid=41c99659-78e5-4856-c6dc-ae268d456578; lzd_sid=161a5313ac0c0f4c8b7f948d0c1c411d; _tb_token_=ee5de5e6beb98; t_fv=1584632399900; cna=UID6FhSQRx0CAbb9+jfBI3Pi; _bl_uid=etkhv8j2skUoXh0Cb4Oe257dIgv8; XSRF-TOKEN=1bcec5aa-c49a-4af3-a5d8-75d708d51717; hng=ID|id|IDR|360; userLanguageML=id; _m_h5_tk=e01cda29c550d5311ddc12aae9763afe_1587771205247; _m_h5_tk_enc=8e1dc1b1eb20dac5273d1caa4b95c013; t_sid=CAEbKAVJkuNI0CIpjCKJ9qDhSraSkcZf; utm_channel=NA; JSESSIONID=C489FBF41692E96F74294C2062D74262',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      '_keyori': 'ss',
      'ajax': 'true',
      'from': 'input',
      'page': '$page',
      'q': '$search',
      'spm': 'a2o4j.home.search.go.57991559Jez22i',
      'style': 'wf',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var res = await http.get('https://www.lazada.co.id/catalog/?$query',
        headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    print(res.body);
  }
}
