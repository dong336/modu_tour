class TourData {
  String? title;
  String? tel;
  String? zipcode;
  String? address;
  var id;
  var mapx;
  var mapy;
  String? imagePath;

  TourData({
    required this.id,
    required this.mapx,
    required this.mapy,
    this.imagePath,
    this.title,
    this.tel,
    this.zipcode,
    this.address,
  });

  factory TourData.fromJson(Map data) {
    return TourData(
      id: data['contentid'],
      title: data['title'],
      tel: data['tel'],
      zipcode: data['zipcode'],
      address: data['address'],
      mapx: data['mapx'],
      mapy: data['mapy'],
      imagePath: data['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tel': tel,
      'zipcode': zipcode,
      'address': address,
      'mapx': mapx,
      'mapy': mapy,
      'imagePath': imagePath,
    };
  }
}