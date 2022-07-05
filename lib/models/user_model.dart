class UserModel{
  String? userUID;
  String? userEmail;
  String? userName;
  String? userPhotoUrl;

  UserModel({this.userUID, this.userEmail, this.userName, this.userPhotoUrl,});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "userUID": userUID,
      "userEmail": userEmail,
      "userName": userName,
      "userPhotoUrl": userPhotoUrl,
    };
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    userUID: map['userUID'],
    userEmail: map['userEmail'],
    userName: map['userName'],
    userPhotoUrl: map['userPhotoUrl'],
  );
}