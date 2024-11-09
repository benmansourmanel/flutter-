import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { restaurantOwner, simpleUser }

class User {
  int? id;
  String name;
  String login;
  String password;
  UserRole role;

  User({
    this.id,
    required this.name,
    required this.login,
    required this.password,
    required this.role,
  });

  // Method to convert a User object to a map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'password': password,
      'role': role.toString().split('.').last, // Convert enum to string
    };
  }

  // Factory constructor to create a User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      login: map['login'],
      password: map['password'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${map['role']}'),
    );
  }

  // Method to create a user with auto-incremented ID (needs Firestore setup)
  static Future<int> getNextId() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.length + 1; // Assumes each doc represents one user
  }
}
