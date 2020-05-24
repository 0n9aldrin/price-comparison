import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pricecomparison/main.dart';
import '../Item.dart';
import '../product.dart';
import 'dart:developer';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io';

class Tokopedia {
  String search;
  int searchLength;
  int topAdsLength;

  Future<dynamic> getTotal({String searches}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      var json = await getJson(pages: 0);
      var total = json[0]['data']['searchProduct']['totalData'];
      total = '$total'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return total;
    } on NoSuchMethodError {}
  }

  Future<List<Product>> getTokopedia({String searches, int page}) async {
    try {
      search = searches;
      search = search.replaceAll(' ', '%20');

      var json = await getJson(pages: page);
      List<Product> items = getData(json: json);

      return items;
    } on NoSuchMethodError {}
  }

  Future<List<Product>> getAds({String searches}) async {
    search = searches;
    String searchSpecial = search;
    search = search.replaceAll(' ', '%20');

    var json = await getAdsJson(searchSpecial: searchSpecial);
    List<Product> items = getAdData(json: json);

    return items;
  }

  List<Product> getAdData({var json}) {
    List<Product> items = [];

    if (topAdsLength != 0) {
      for (int x = 0; x < topAdsLength; x++) {
        Product imageModel = Product();
        String tempPrice =
            json[1]['data']['displayAdsV3']['data'][x]['product']['price'];
        tempPrice = tempPrice.replaceAll('.', '');
        tempPrice = tempPrice.replaceAll('Rp ', '');
        tempPrice = '$tempPrice'.replaceAllMapped(
            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},');
        imageModel.price = tempPrice;
        imageModel.title =
            json[1]['data']['displayAdsV3']['data'][x]['product']['name'];
        imageModel.url =
            json[1]['data']['displayAdsV3']['data'][x]['product']['url'];
        imageModel.img = json[1]['data']['displayAdsV3']['data'][x]['product']
            ['image']['imageUrl'];
        imageModel.img = imageModel.img.replaceAll('200-square', '700');
        imageModel.website = 'Tokopedia';
        imageModel.rating = (json[1]['data']['displayAdsV3']['data'][x]
                    ['product']['rating'] ~/
                20)
            .toDouble();
        String tempReview = json[1]['data']['displayAdsV3']['data'][x]
            ['product']['countReviewFormat'];
        tempReview = tempReview.replaceAll('.', '');
        imageModel.reviews = int.parse(tempReview);
        items.add(imageModel);
      }
      return items;
    }

    return items;
  }

  List<Product> getData({var json}) {
    List<Product> items = [];

    searchLength = json[0]['data']['searchProduct']['products'].length;
    for (int x = 0; x < searchLength; x++) {
      Product imageModel = Product();
      String tempPrice =
          json[0]['data']['searchProduct']['products'][x]['price'];
      tempPrice = tempPrice.replaceAll('.', '');
      tempPrice = tempPrice.replaceAll('Rp ', '');
      tempPrice = '$tempPrice'.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      imageModel.title =
          json[0]['data']['searchProduct']['products'][x]['name'];
      imageModel.price = tempPrice;
      imageModel.url = json[0]['data']['searchProduct']['products'][x]['url'];
      imageModel.img =
          json[0]['data']['searchProduct']['products'][x]['imageURL'];
      imageModel.img = imageModel.img.replaceAll('200-square', '700');
      imageModel.website = 'Tokopedia';
      imageModel.rating =
          json[0]['data']['searchProduct']['products'][x]['rating'].toDouble();
      imageModel.reviews =
          json[0]['data']['searchProduct']['products'][x]['countReview'];
      items.add(imageModel);
    }
    return items;
  }

  Future<dynamic> getAdsJson({String searchSpecial}) async {
    var headers = {
      'authority': 'gql.tokopedia.com',
      'origin': 'https://www.tokopedia.com',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36 OPR/67.0.3575.115',
      'content-type': 'application/json',
      'accept': '*/*',
      'sec-fetch-dest': 'empty',
      'x-source': 'tokopedia-lite',
      'x-device': 'desktop-0.0',
      'x-tkpd-lite-service': 'zeus',
      'sec-fetch-site': 'same-site',
      'sec-fetch-mode': 'cors',
      'referer': 'https://www.tokopedia.com/search?st=product&q=$search',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
      'cookie':
          '_SID_Tokopedia_=4SFKRT3OuFk2z8oUVpfemU3uhnZkOpxo0vySJX9NCcmtSXXphXBMsNOGTs7CitGxPDU8-e0wU8loP0UGGDrewscypji3Kg1PxQ77fxi0RYWGvX-IemlPI7vULhPH6Qx3; DID=e973dbdcfbd528bbfa8ef3ce0719a5666c62293222e777c7f35e02fd0492ab656cb5b41d3f4dfe7a25f6ed24e264beee; DID_JS=ZTk3M2RiZGNmYmQ1MjhiYmZhOGVmM2NlMDcxOWE1NjY2YzYyMjkzMjIyZTc3N2M3ZjM1ZTAyZmQwNDkyYWI2NTZjYjViNDFkM2Y0ZGZlN2EyNWY2ZWQyNGUyNjRiZWVl47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=; __auc=ca1feb51170f5b73e8818b9b54f; _gcl_au=1.1.2146018598.1584670392; _ga=GA1.2.1230456053.1584670393; _UUID_NONLOGIN_=fcfdf780964ff1e39455cf668f085a6f; _fbp=fb.1.1584670392911.1146567030; _jx=5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; _jxs=1584670394-5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; l=1; _hjid=8a00daa3-1ea3-4ac2-87b4-7fc4954abb32; CSHLD_SID=d145929d6ae06a3b78b007d28c95f03e7b086be1d34af67c6e85263816defb49; lang=id; S_L_b9a31656f38e2621d53480ddb37511c2=7ffe6883fe6380f7524842f3fc9683e5~20200618091413; aus=1; lasty=7; tuid=97678791; TOPATK=8yee8HKuSsevuFHE_MD_oA; TOPRTK=FQE8C_ieTl6FM0J6WNoqVQ; isWebpSupport=true; zarget_visitor_info=%7B%7D; _abck=82F5554FC158C7ECD01679C16EEE4623~0~YAAQpNt5LcFnKb9wAQAAeEBeCgPtDuGClLP+qEhzo4mdOA1rH1+UsGS3B1mGjCnwmFSMZbeqjz+pMwqkzHxEmdwkk68VjlYzZuDwXCXVnds7bcNCuEjF+WbFBNGNAG+/QlyOhd6OF4nEwjA2aF8oKLsWO8hBpEMsXC/mtpYj3DeszWk7v1GeqxK6xmiCZ4VrTOGqT3cmfEibCfs+WUhTuf5sqbCDnOXf9aNxyCgEzB3r8pLCXk6Cdz26ESQJkCAOz7jhZ8el0pzzjOPNn4v1HKEDA7usf5VculwjUwtcNFz8ITJ3bZxAwm7FwCFZi5P30hlZDocmhdj66Q==~-1~-1~-1; _BID_TOKOPEDIA_=4bcc15988d4f3e7b52b0b6d679fcb6c3; bm_sz=70ADAFD7DE6C118494A25D598996214B~YAAQttt5LdrcrmBxAQAA73fNYgdZFS1D4aQ7Wk1KFeHRPkN+0k5JdVGnXmnby8BJQyq6N51dPqxxWZQ8PQXSxXGR4qi1e9dlRM8O4drJXwQ5BFoCsi2dnCZvAQdmRxl3ASruY+eR3n7PjexSHRHCHWGbBox55rhPl4LJ90FIW0hZ89Bv+9pyDyaKd+veEDS8rMSV; ak_bmsc=F6D9476C39679C0E1246F1549AEB33182D79DBB6BB030000D413905E63E72E2F~plphF+GbOYGchLno2NLufYBO+66RNOQ9ZCN2hlftQDA9G6zIuQBGfLCqGsr0U4NU4cFRBFdqcdo2vSu8DLR7hYvIKcjTQIeGgiQIvoJYDQkXd2G2GEsXzzq9gwWaKDo6yZ/OcCJYxIYHWSz9uKp8fyLJaKqZO88eFDsjc1eYSjuyWwFXGdMvq8IXKPLByiV/WtG5iDatpLdqyXVYdkOlS1Z4k4QYl/qNzcTDyTXzxR8MOYfbyqsOCBmhQxD2KbfLU6; bm_sv=08F487CAD1C3D08D0FDA6C2367F74773~lKqzIXmOVQP3FdT4eI/vjvomZvl+qxl5cdqgqHuzp3LkWW1dA00IU1FZga7WX9dKzyqoeHkGEfrnE4YY1sMOkLOS9Y6dNa5ungGBP/ninpZfIeoB/EuR7uu/XoMLgLLZk/qZuYmgkQkklVlogzWaVBaZ2wD5QU/HOHmHwyBa0iQ=',
      'Accept-Encoding': 'gzip',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = utf8.encode(
        r'[{"operationName":"GlobalNavigation","variables":{"keyword":"' +
            searchSpecial +
            r'","device":"desktop","size":4},"query":"query GlobalNavigation($keyword: String, $device: String, $size: Int) {\n  global_search_navigation(keyword: $keyword, device: $device, size: $size) {\n    data {\n      title\n      keyword\n      nav_template\n      see_all_applink\n      see_all_url\n      list {\n        name\n        info\n        imageURL: image_url\n        url\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"},{"operationName":"TopadsProductQuery","variables":{"adParams":"st=product&q=' +
            search +
            r'&ob=23&page=1&dep_id=&ep=product&src=search&device=desktop&item=20&minimum_item=10&user_id=97678791"},"query":"query TopadsProductQuery($adParams: String) {\n  displayAdsV3(displayParams: $adParams) {\n    data {\n      clickTrackUrl: product_click_url\n      product {\n        id\n        name\n        wishlist\n        image {\n          imageUrl: s_ecs\n          trackerImageUrl: s_url\n          __typename\n        }\n        url: uri\n        relative_uri\n        price: price_format\n        wholeSalePrice: wholesale_price {\n          quantityMin: quantity_min_format\n          quantityMax: quantity_max_format\n          price: price_format\n          __typename\n        }\n        count_talk_format\n        countReviewFormat: count_review_format\n        category {\n          id\n          __typename\n        }\n        preorder: product_preorder\n        product_wholesale\n        free_return\n        isNewProduct: product_new_label\n        cashback: product_cashback_rate\n        rating: product_rating\n        top_label\n        bottomLabel: bottom_label\n        labelGroups: label_group {\n          position\n          type\n          title\n          __typename\n        }\n        campaign {\n          discountPercentage: discount_percentage\n          originalPrice: original_price\n          __typename\n        }\n        __typename\n      }\n      shop {\n        id\n        name\n        domain\n        location\n        city\n        tagline\n        goldmerchant: gold_shop\n        gold_shop_badge\n        official: shop_is_official\n        lucky_shop\n        uri\n        owner_id\n        is_owner\n        badges {\n          title\n          imageURL: image_url\n          show\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"}]');

    var res = await http.post('https://gql.tokopedia.com/',
        headers: headers, body: data);
    log('TokAds http called');
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    dynamic json = jsonDecode(res.body);
    topAdsLength = json[1]['data']['displayAdsV3']['data'].length;
    return json;
  }

  Future<dynamic> getJson({int pages}) async {
    int start = pages * 60;
    String pageText;
    if (pages != 1) {
      pageText = '&page=' + pages.toString();
    } else {
      pageText = '';
    }

    var headers = {
      'authority': 'gql.tokopedia.com',
      'tkpd-userid': '97678791',
      'origin': 'https://www.tokopedia.com',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36 OPR/67.0.3575.115',
      'content-type': 'application/json',
      'accept': '*/*',
      'sec-fetch-dest': 'empty',
      'x-source': 'tokopedia-lite',
      'x-device': 'desktop-0.0',
      'x-tkpd-lite-service': 'zeus',
      'sec-fetch-site': 'same-site',
      'sec-fetch-mode': 'cors',
      'referer':
          'https://www.tokopedia.com/search?st=product&q=$search$pageText',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
      'cookie': '_SID_Tokopedia_=4SFKRT3OuFk2z8oUVpfemU3uhnZkOpxo0vySJX9NCcmtSXXphXBMsNOGT'
          's7CitGxPDU8-e0wU8loP0UGGDrewscypji3Kg1PxQ77fxi0RYWGvX-IemlPI7vULhPH6Qx3; DID='
          'e973dbdcfbd528bbfa8ef3ce0719a5666c62293222e777c7f35e02fd0492ab656cb5b41d3f4dfe7a25'
          'f6ed24e264beee; DID_JS=ZTk3M2RiZGNmYmQ1MjhiYmZhOGVmM2NlMDcxOWE1NjY2YzYyMjkzMjIyZTc3N'
          '2M3ZjM1ZTAyZmQwNDkyYWI2NTZjYjViNDFkM2Y0ZGZlN2EyNWY2ZWQyNGUyNjRiZWVl47DEQpj8HBSa+/TImW+'
          '5JCeuQeRkm5NMpJWZG3hSuFU=; __auc=ca1feb51170f5b73e8818b9b54f; _gcl_au=1.1.2146018598.15'
          '84670392; _ga=GA1.2.1230456053.1584670393; _UUID_NONLOGIN_=fcfdf780964ff1e39455cf668f085'
          'a6f; _fbp=fb.1.1584670392911.1146567030; _jx=5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; _jxs=15'
          '84670394-5adf4110-6a50-11ea-9f24-5dc4fe97dfe7; l=1; _hjid=8a00daa3-1ea3-4ac2-87b4-7fc4954a'
          'bb32; CSHLD_SID=d145929d6ae06a3b78b007d28c95f03e7b086be1d34af67c6e85263816defb49; lang=id; S'
          '_L_b9a31656f38e2621d53480ddb37511c2=7ffe6883fe6380f7524842f3fc9683e5~20200618091413; aus='
          '1; lasty=7; tuid=97678791; TOPATK=8yee8HKuSsevuFHE_MD_oA; TOPRTK=FQE8C_ieTl6FM0J6WNoqVQ; isW'
          'ebpSupport=true; zarget_visitor_info=%7B%7D; _abck=82F5554FC158C7ECD01679C16EEE4623~0~YAAQpNt5'
          'LcFnKb9wAQAAeEBeCgPtDuGClLP+qEhzo4mdOA1rH1+UsGS3B1mGjCnwmFSMZbeqjz+pMwqkzHxEmdwkk68VjlYzZuDwXCX'
          'Vnds7bcNCuEjF+WbFBNGNAG+/QlyOhd6OF4nEwjA2aF8oKLsWO8hBpEMsXC/mtpYj3DeszWk7v1GeqxK6xmiCZ4VrTOGqT'
          '3cmfEibCfs+WUhTuf5sqbCDnOXf9aNxyCgEzB3r8pLCXk6Cdz26ESQJkCAOz7jhZ8el0pzzjOPNn4v1HKEDA7usf5Vculwj'
          'UwtcNFz8ITJ3bZxAwm7FwCFZi5P30hlZDocmhdj66Q==~-1~-1~-1; _BID_TOKOPEDIA_=4bcc15988d4f3e7b52b0b6d67'
          '9fcb6c3; bm_sz=62F037397E176477409E3383FEDD53C7~YAAQhvpWuN0rexNxAQAAm1+yXwedUx3WHW45XqlMyDXgNlpmi'
          'brcziptERHhdniUXJGUqypkUIj96ztnGsbNJGzTf2CvgV8nWhf3dqw0vyM5rAcF2RJsq1NtoQh8UrM54GoEXu/udPrvXppczq'
          'xVKjICnUMSncLDWGzKPPD11eN1qeIO+y92OlL6syJXnIA9vDe4; ak_bmsc=81BD77B5A63EBC75557092E696542694B856'
          'FA86205C000049488F5EE8331C68~plRY78T3FZqEfiwK0or9oNDS8ZO5DbkJV29gWxHujsSYq1NAA6+WnIbTKCta0xi/VCUC'
          'Wj8mddej01FiUsjh9bf9WaxBbSik7gVoRUo4HHgq1lFiMdQcSiNhQFTkcgn0n98oUG19CFBdsKqvHd05iGae3NWmES1XNhfl'
          'sR2NNfxgM3UNZPgDoJSoALYopvPGExolg6eZqY1+cptsDVrdCmtabY6VuXsuS/uWIiOWeUCp4yiN+5+RH/IsgvcjM1LrDL; b'
          'm_sv=4CF377FAB488C6F63C8680C880C0FE38~8QXPRLGJNr2GwwmKMSFj3Vi+yDISF0vnGKempEhz5j6igGtktGgbHNZp4TTQ'
          'pTK2yVGJbFGGQ5+kMtQXkPWFUnSOdsCTxqb12+DjTfNDkD5kUerqGNjkOcR+jb1Mid7e0zEjldlBeO+lpuGyWwWpAyu948SDcSl'
          'GrSd+OmLrEhs=',
      'Accept-Encoding': 'gzip',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var dataTemp = r'[{"operationName":"SearchProductQuery","variables":{"params":"scheme=https&device=d'
            'esktop&related=true&st=product&q=' +
        search +
        r'&ob=23&page=' +
        pages.toString() +
        '&variants=&shippi'
            r'ng=&start=' +
        start.toString() +
        '&rows=60&user_id=97678791&unique_id=53057abe15ffed716e7d0264cddffbfa&s'
            r'afe_search=false&source=search&nuq="},"query":"query SearchProductQuery($params: String) {\'
            r'n  searchProduct(params: $params) {\n    source\n    totalData: count\n    totalDataText: cou'
            r'nt_text\n    additionalParams: additional_params\n    redirection {\n      redirectionURL: red'
            r'irect_url\n      departmentID: department_id\n      __typename\n    }\n    responseCode: respon'
            r'se_code\n    keywordProcess: keyword_process\n    suggestion {\n      suggestion\n      suggestio'
            r'nCount\n      currentKeyword\n      instead\n      insteadCount\n      suggestionText: text\'
            r'n      suggestionTextQuery: query\n      __typename\n    }\n    related {\n      relatedKeyw'
            r'ord: related_keyword\n      otherRelated: other_related {\n        keyword\n        url\'
            r'n        __typename\n      }\n      __typename\n    }\n    isQuerySafe\n    ticker {\n      te'
            r'xt\n      query\n      __typename\n    }\n    catalogs {\n      id\n      name\n      pri'
            r'ce\n      priceMin: price_min\n      priceMax: price_max\n      countProduct: count_produ'
            r'ct\n      description\n      imageURL: image_url\n      url\n      category: department_i'
            r'd\n      __typename\n    }\n    products {\n      id\n      name\n      childs\n      url\n      im'
            r'ageURL: image_url\n      imageURL300: image_url_300\n      imageURL500: image_url_500\n      ima'
            r'geURL700: image_url_700\n      price\n      priceRange: price_range\n      category: departm'
            r'ent_id\n      categoryID: category_id\n      categoryName: category_name\n      categoryBread'
            r'crumb: category_breadcrumb\n      discountPercentage: discount_percentage\n      originalPric'
            r'e: original_price\n      shop {\n        id\n        name\n        url\n        isPowerBadg'
            r'e: is_power_badge\n        isOfficial: is_official\n        location\n        city\n        re'
            r'putation\n        clover\n        __typename\n      }\n      wholesalePrice: whole_sale_pr'
            r'ice {\n        quantityMin: quantity_min\n        quantityMax: quantity_max\n        pric'
            r'e\n        __typename\n      }\n      courierCount: courier_count\n      condition\n      lab'
            r'els {\n        title\n        color\n        __typename\n      }\n      labelGroups: label_gr'
            r'oups {\n        position\n        type\n        title\n        __typename\n      }\n      bad'
            r'ges {\n        title\n        imageURL: image_url\n        show\n        __typename\n      }\'
            r'n      isFeatured: is_featured\n      rating\n      countReview: count_review\n      stock\'
            r'n      GAKey: ga_key\n      preorder: is_preorder\n      wishlist\n      shop {\n        i'
            r'd\n        name\n        url\n        goldmerchant: is_power_badge\n        location\n        ci'
            r'ty\n        reputation\n        clover\n        official: is_official\n        __typenam'
            r'e\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"}]';

    var data = utf8.encode(dataTemp);

    var res = await http.post('https://gql.tokopedia.com/',
        headers: headers, body: data);
    log('Tok http called');
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');

    dynamic json = jsonDecode(res.body);

    return json;
  }
}

class TokopediaGridView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TokopediaGridViewState();
  }
}

class _TokopediaGridViewState extends State<TokopediaGridView>
    with AutomaticKeepAliveClientMixin<TokopediaGridView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Tokopedia tokopedia = Tokopedia();

  Widget buildCtn() {
    if (globalSearch == null) {
      return Center(
        child: Text('Please search item'),
      );
    }
    if (tokopediaItems == null) {
      tokopedia.getAds(searches: globalSearch).then((result) {
        setState(() {
          if (result.length == 0) {
            tokopedia
                .getTokopedia(searches: globalSearch, page: tokopediaCounter)
                .then((result1) {
              setState(() {
                tokopediaItems = result1;
              });
            });
          } else {
            tokopediaItems = result;
          }
        });
      });
      return Center(
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(
                  radius: 20,
                )
              : RefreshProgressIndicator(
                  backgroundColor: Colors.grey,
                  strokeWidth: 5.0,
                ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(15.0),
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.555,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (c, i) => Item(
        title: tokopediaItems[i].title,
        url: tokopediaItems[i].url,
        image: tokopediaItems[i].img,
        price: tokopediaItems[i].price,
        reviews: tokopediaItems[i].reviews,
        rating: tokopediaItems[i].rating,
        website: tokopediaItems[i].website,
        combined: false,
      ),
      itemCount: tokopediaItems.length,
    );
  }

//  @override
//  void initState() {
//    super.initState();
//    blibli.getBlibli(page: counter, searches: globalSearch).then((result) {
//      setState(() {
//        data = result;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropHeader(),
      onRefresh: () async {
        //monitor fetch data from network
        if (tokopediaItems != null) {
          if (tokopediaSorted == false) {
            tokopediaItems.clear();
            await Future.delayed(Duration(milliseconds: 1000));
            tokopediaCounter = 0;
            tokopediaItems = await tokopedia.getAds(searches: globalSearch);
          } else {
            setState(() {});
          }
        }

        if (mounted) setState(() {});
        _refreshController.refreshCompleted();

        /*
        if(failed){
         _refreshController.refreshFailed();
        }
      */
      },
      onLoading: () async {
        //monitor fetch data from network
        if (tokopediaItems != null) {
          await Future.delayed(Duration(milliseconds: 1000));
          tokopediaCounter++;
          List<Product> tempList = await tokopedia.getTokopedia(
              searches: globalSearch, page: (tokopediaCounter - 1));
          for (int x = 0; x < tempList.length; x++) {
            tokopediaItems.add(tempList[x]);
          }
          if (tokopediaSorted == true) {
            sortDataByPrice(list: tokopediaItems);
          }
        }

//    pageIndex++;
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
