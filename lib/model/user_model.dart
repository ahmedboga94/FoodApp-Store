class UserModel {
  String userName;
  String userEmail;
  String userUID;
  String userPhotoURL;
  String status;
  List userCart;

  UserModel(
      {required this.status,
      required this.userName,
      required this.userEmail,
      required this.userUID,
      required this.userPhotoURL,
      required this.userCart});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["userName"],
      userEmail: json["userEmail"],
      userUID: json["userUID"],
      userPhotoURL: json["userPhotoURL"],
      status: json["status"],
      userCart: json["userCart"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["userName"] = userName;
    data["userEmail"] = userEmail;
    data["userUID"] = userUID;
    data["userPhotoURL"] = userPhotoURL;
    data["status"] = status;
    data["userCart"] = userCart;

    return data;
  }
}
