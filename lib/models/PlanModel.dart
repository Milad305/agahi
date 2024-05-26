class PlanModel {
  int? id;
  String? name;
  int? price;
  String? description;
  bool? isSelected;

  PlanModel(
      {this.isSelected = false,
      this.id,
      this.name,
      this.price,
      this.description});

  PlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];

    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}
