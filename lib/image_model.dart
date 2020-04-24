class ImageModel {
  String title;
  String url;
  dynamic price;
  String img;
  String website;
  List images;
  int rating;
  int reviews;

  List<ImageModel> removeDuplicates({List<ImageModel> data}) {
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
