class User {
  final String userName;
  final String firstName;
  final String lastName;
  final String lang;
  final int userId;
  final String userPictureUrl;

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.lang,
    required this.userId,
    required this.userPictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['username'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      lang: json['lang'],
      userId: json['userid'],
      userPictureUrl: json['userpictureurl'],
    );
  }
}