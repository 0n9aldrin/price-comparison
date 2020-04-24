import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

void main() async {
  var headers = {
    'authority': 'shopee.co.id',
    'cache-control': 'max-age=0',
    'upgrade-insecure-requests': '1',
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36 OPR/67.0.3575.137',
    'sec-fetch-dest': 'document',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'sec-fetch-site': 'none',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-user': '?1',
    'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
    'cookie':
        '_gcl_au=1.1.1537991119.1584632413; _fbp=fb.2.1584632413191.822978092; SPC_IA=-1; SPC_EC=-; SPC_F=EdLhfKN1aS8M5d4BoOmcDe4CvGKHT34B; REC_T_ID=f1e47d4a-69f7-11ea-a658-ccbbfe5d5ce8; SPC_U=-; _ga=GA1.3.1206425812.1584632423; _med=affiliates; csrftoken=Fe3DVpnzt50xL90PhzIpux0ck0rKnFDF; welcomePkgShown=true; SPC_SI=g2y5axtf9p4uctlnzn6is8i03uza5ez6; REC_MD_20=1587704714; SPC_CT_ac24c020="1587704663.1APRCwoYb/cYayDoNpBES4NcFKQTlPzJ65T1rBqdo0Zcm1+c0Rajo5Gjux9dNaUU"; SPC_R_T_ID="kLAAfJIgnyN3Q+IJEBnKPffWXuHd4xtQNm/5X8y8eHtoSxybblrB0J03K3PNUSi0FOvto0JaXQ/gdht29X+PtIroTMWNAIbxGqndxUu7LTY="; SPC_T_IV="/sx9BDdxp4wBktQv/ZSSBg=="; SPC_R_T_IV="/sx9BDdxp4wBktQv/ZSSBg=="; SPC_T_ID="kLAAfJIgnyN3Q+IJEBnKPffWXuHd4xtQNm/5X8y8eHtoSxybblrB0J03K3PNUSi0FOvto0JaXQ/gdht29X+PtIroTMWNAIbxGqndxUu7LTY="',
    'Accept-Encoding': 'gzip',
  };

  var params = {
    'keyword': 'calculator',
    'page': '1',
  };
  var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

  var res =
      await http.get('https://shopee.co.id/search?$query', headers: headers);
  if (res.statusCode != 200)
    throw Exception('http.get error: statusCode= ${res.statusCode}');
  var data = res.body;
  print(data);
  var html = parse(data);
  List element = html.querySelectorAll('#main > div');
  print(element);
}
