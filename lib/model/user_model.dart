class AppUser {
  final String uid;
  final String email;
  final String name;
  final String gender;
  final String phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.gender,
    required this.phone,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      gender: data['gender'],
      phone: data['phone'],
    );
    // jjjj
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'gender': gender,
      'phone': phone,
    };
  }
}
