class MoodModel{

  String? name;
  String? imageUrl;
  bool? isPNG;
  List<String>? subItems;

  MoodModel({this.name, this.imageUrl, this.subItems, this.isPNG = false});

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'subItems': subItems,
  };

  factory MoodModel.fromJson(Map<String, dynamic> json){
    return MoodModel(
      name : json['name'],
      imageUrl : json['imageUrl'],
        subItems : json['subItems'],
    );
  }
}