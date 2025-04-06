class Usermodel {
  String email;
  String username;
  String major;
  String profile;
  List following;
  List followers;
  Usermodel(this.major, this.email, this.followers, this.following, this.profile,
      this.username);
}