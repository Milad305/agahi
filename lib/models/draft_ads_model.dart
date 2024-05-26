import 'dart:convert';

class Ad {
  List<dynamic> imagesArr;
  String title;
  String description;
  dynamic contact;
  dynamic categoryId;
  String price;
  List<dynamic> fields;
  double? lang;
  double? lat;

  Ad({
    required this.imagesArr,
    required this.title,
    required this.description,
    required this.contact,
    required this.categoryId,
    required this.price,
    required this.fields,
    this.lang,
    this.lat
  });

  Map<String, dynamic> toMap() {
    return {
      'imagesArr': imagesArr,
      'title': title,
      'description': description,
      'contact': contact,
      'categoryId': categoryId,
      'price': price,
      'fields': fields,
      'lang': lang,
      'lat': lat
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      imagesArr: map['imagesArr'],
      title: map['title'],
      description: map['description'],
      contact: map['contact'],
      categoryId: map['categoryId'],
      price: map['price'],
      fields: map['fields'],
      lang: map['lang'],
      lat: map['lat']
    );
  }

  String toJson() => json.encode(toMap());

  factory Ad.fromJson(String source) => Ad.fromMap(json.decode(source));
}


// Call saveData() to save your data