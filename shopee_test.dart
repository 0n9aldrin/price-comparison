import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print(await getTokDetails());
  print(await getBlibliDetails());
}

Future<String> getTokDetails() async {
  var headers = {
    'authority': 'gql.tokopedia.com',
    'accept': '*/*',
    'x-tkpd-akamai': 'product_info',
    'x-source': 'tokopedia-lite',
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.104',
    'x-tkpd-lite-service': 'zeus',
    'content-type': 'application/json',
    'origin': 'https://www.tokopedia.com',
    'sec-fetch-site': 'same-site',
    'sec-fetch-mode': 'cors',
    'sec-fetch-dest': 'empty',
    'referer':
        'https://www.tokopedia.com/joyko/calculator-kalkulator-joyko-cc-38-12-digits-check-correct',
    'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
    'cookie':
        'DID=e973dbdcfbd528bbfa8ef3ce0719a5666c62293222e777c7f35e02fd0492ab656cb5b41d3f4dfe7a25f6ed24e264beee; DID_JS=ZTk3M2RiZGNmYmQ1MjhiYmZhOGVmM2NlMDcxOWE1NjY2YzYyMjkzMjIyZTc3N2M3ZjM1ZTAyZmQwNDkyYWI2NTZjYjViNDFkM2Y0ZGZlN2EyNWY2ZWQyNGUyNjRiZWVl47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=; __auc=ca1feb51170f5b73e8818b9b54f; _gcl_au=1.1.2146018598.1584670392; _ga=GA1.2.1230456053.1584670393; _UUID_NONLOGIN_=fcfdf780964ff1e39455cf668f085a6f; _fbp=fb.1.1584670392911.1146567030; _jx=5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; _jxs=1584670394-5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; _hjid=8a00daa3-1ea3-4ac2-87b4-7fc4954abb32; lang=id; isWebpSupport=true; zarget_visitor_info=%7B%7D; g_yolo_production=1; _BID_TOKOPEDIA_=594a4a6675cda9a725ac6376b2c861f1; S_L_a64d7848c372527987982852ed015270=c7263fd82b9ae96660e369858692e05a~20200801141032; _SID_Tokopedia_=hvZp6M2cNt0wqr7Icwd1ETU_OKyI3zTK6tooSecWdiDmatmN0i6EdsxFxQUHTIeJozcsP-JXP5jhIj8StngGk-cKaoGdsvU3-h4Q3GJ0o3HYJ630aZ_B3hvpy5FLghFH; CSHLD_SID=b9079dda914af696586c9d3da22f100b55f99e5ba3abe50aa14acaefb12ea9ae; S_L_b9a31656f38e2621d53480ddb37511c2=ab00f56283f5eac8b5ffaed9cf667ae1~20200811214558; l=1; aus=1; lasty=8; tuid=97678791; TOPATK=H9e-0N0tR0m1HaApRtjmzw; TOPRTK=FQE8C_ieTl6FM0J6WNoqVQ; _ID_autocomplete_=bf22b28001264f2f80008acf16ceebe3; _abck=82F5554FC158C7ECD01679C16EEE4623~0~YAAQLuUcuLu3/8hxAQAAe5ZAFgOeO2w7gBs1dlF0NMP6M+HL3Zf1L4B1uCQ+9OT3kdMKN9rQodsuua2zGCBaBNEud/NVzEJXopfxWBAjr6RMy1INlxUWkt8eihtCYR/sNEqWvhIxpcX+ABrku6CfIzwb32HNA4YC93RlWSmhG/3QqOZvu0mLZd2aCPAcrMEmHc2G5a2814AEF0YDfOWFuq4woQxrFFK69LGVwM8O65WtGEwWmnEXMBE+3aj7vQ2njqxd2OmX4ka3YJh0wqkB+F8uR2X6dLvf1AAO21hoWqFPDlfGi6A+Io1VqEVk6+9B1nLfZZsnof6nmg==~-1~-1~-1; bm_sz=D36C5628D8EFEEBEE83EAAA76E7B5836~YAAQ3CE1F6HqcSlyAQAAM2FlOwfTsbiu/pZv8o4r+U6jTeURS0viE4nKlJCVJ0xzftqU8ClyWqMdfYQCAhvLVhB5WLwaUn4uY3F2S+HqFpnt00QJoKuIASliPN0Fibuh2nSIPcWsMAWqDjnFjyljH6j6ksaVJX+bOfhUrdXFnAAEyiCi/XtjlYcXIWPpT0g7YqbK; ak_bmsc=70D342FAF317950DE86E007E7DA8F264173521DC753200007F86C75E37E03850~plTjbcPgo/04GD4rAOBAiNfLZtBBMhAq5vtjDfhW8I5Tmoay7DeNyO2/oVJjEfrVmZLlLe52turONGbH7H/XcB2KlNMSMZUdItq0LLzsAP/tvMLxa24mvlJEIxOvz4IUGenZ6u9raljwRVrBL3DUicUq67ClGpC6/rB0pgp3nvOKLrF2pxg5sCzkAgB8jgX7VPaQHundk6+v20VVUH/54NChMoW0Koi92WdLzTjI6kZZnWDtUf3JHzN6OLP2Pt8fF/; bm_sv=5F6FC08082A385A26DC2287D9F92FF69~kIlmRE7WoYVo/JhltwIlbCDU73mwzN5JhU9Z8vZ89V6+GUX1jPqqLKmRkC6ez84AQSKxMridMhpapdu99OlH7uBTPLi2r1kbapwHO7eyS/QZJYq+fSw8J3JVRu7jVgGoYc5RttbBtzIRZ1qFWcRWR5R6uCsFkDOVb1C9YH0vPCo=',
    'Accept-Encoding': 'gzip',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var data = utf8.encode(
      r'[{"operationName":"PDPInfoQuery","variables":{"shopDomain":"datasempoa","productKey":"texas-instruments-ti-nspire-cx-ii-graphing-calculator-gdc"},"query":"query PDPInfoQuery($shopDomain: String, $productKey: String) {\n  getPDPInfo(productID: 0, shopDomain: $shopDomain, productKey: $productKey) {\n    basic {\n      id\n      shopID\n      name\n      alias\n      price\n      priceCurrency\n      lastUpdatePrice\n      description\n      minOrder\n      maxOrder\n      status\n      weight\n      weightUnit\n      condition\n      url\n      sku\n      gtin\n      isKreasiLokal\n      isMustInsurance\n      isEligibleCOD\n      isLeasing\n      catalogID\n      needPrescription\n      __typename\n    }\n    category {\n      id\n      name\n      title\n      breadcrumbURL\n      isAdult\n      detail {\n        id\n        name\n        breadcrumbURL\n        __typename\n      }\n      __typename\n    }\n    pictures {\n      picID\n      fileName\n      filePath\n      description\n      isFromIG\n      width\n      height\n      urlOriginal\n      urlThumbnail\n      url300\n      status\n      __typename\n    }\n    preorder {\n      isActive\n      duration\n      timeUnit\n      __typename\n    }\n    wholesale {\n      minQty\n      price\n      __typename\n    }\n    videos {\n      source\n      url\n      __typename\n    }\n    campaign {\n      campaignID\n      campaignType\n      campaignTypeName\n      originalPrice\n      discountedPrice\n      isAppsOnly\n      isActive\n      percentageAmount\n      stock\n      originalStock\n      startDate\n      endDate\n      endDateUnix\n      appLinks\n      hideGimmick\n      __typename\n    }\n    stats {\n      countView\n      countReview\n      countTalk\n      rating\n      __typename\n    }\n    txStats {\n      txSuccess\n      txReject\n      itemSold\n      __typename\n    }\n    cashback {\n      percentage\n      __typename\n    }\n    variant {\n      parentID\n      isVariant\n      __typename\n    }\n    stock {\n      useStock\n      value\n      stockWording\n      __typename\n    }\n    menu {\n      name\n      __typename\n    }\n    __typename\n  }\n}\n"}]');

  var res = await http.post('https://gql.tokopedia.com/',
      headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  return res.body;
}

Future<String> getBlibliDetails() async {
  var res = await http.get(
      'https://www.blibli.com/backend/product/products/pc--MTA-3414952/_summary?selectedItemSku=TOD-60083-00010-00001');
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  return res.body;
}
