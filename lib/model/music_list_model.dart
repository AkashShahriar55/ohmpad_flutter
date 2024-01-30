class MusicListModel{

  String? name;
  String? downloadURL;
  String? thumb;

  MusicListModel({this.name, this.downloadURL,this.thumb});

  Map<String, dynamic> toJson() => {
    'name': name,
    'downloadURL': downloadURL,
    'thumb': thumb,
  };

  factory MusicListModel.fromJson(Map<String, dynamic> json){
    return MusicListModel(
      name : json['name'],
      downloadURL : json['downloadURL'],
      thumb : json['thumb'],
    );
  }
}