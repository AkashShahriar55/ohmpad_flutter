class LoginData{
  String? email;
  String? first_name;
  String? last_name;
  String? mobile_no;

  LoginData({this.email, this.first_name, this.last_name, this.mobile_no});

  Map<String, dynamic> toJson() => {
    'email': email,
    'first_name': first_name,
    'last_name': last_name,
    'mobile_no': mobile_no,
  };

  factory LoginData.fromJson(Map<String, dynamic> json){
    return LoginData(
      email : json['email'],
      first_name : json['first_name'],
      last_name : json['last_name'],
      mobile_no : json['mobile_no'],
    );
  }

}