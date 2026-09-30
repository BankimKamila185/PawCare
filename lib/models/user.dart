class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? location;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.location = 'Austin, TX',
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      location: json['location'] as String? ?? 'Austin, TX',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? location,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
