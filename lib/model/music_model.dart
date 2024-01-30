import 'dart:typed_data';

class MusicModel{

  String? name;
  String? url;
  String? thumbUrl;

  MusicModel({this.name, this.url,this.thumbUrl});

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'thumbUrl': thumbUrl,
  };

  factory MusicModel.fromJson(Map<String, dynamic> json){
    return MusicModel(
      name : json['name'],
      url : json['url'],
      thumbUrl : json['thumbUrl'],
    );
  }
}