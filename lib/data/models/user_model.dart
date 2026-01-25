class UserModel {
  final String name;
  final String email;
  final bool isGuest;

  UserModel({required this.name, required this.email, this.isGuest = false});

  factory UserModel.guest() {
    return UserModel(name: "Misafir", email: "", isGuest: true);
  }
}
