class Product {
  String title;
  String url;
  dynamic price;
  String img;
  String website;
  List images;
  double rating;
  int reviews;

  List<Product> removeDuplicates({List<Product> data}) {
    int z;
    int y = 0;
    while (y < data.length) {
      z = y + 1;
      while (z < data.length) {
        if (data[y].price != data[z].price) {
          break;
        } else {
          if (data[y].title == data[z].title) {
            print(data[y]);
            print(data[z]);
            data.removeAt(z);
          } else {
            z++;
          }
        }
      }
      y++;
    }
    return data;
  }
}
