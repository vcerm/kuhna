class User {
  final int id;
  final String name;
  final String email;
  final String? avatarPath;
  final String avatarPlaceholderPath = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

  get finalAvatarPath { return avatarPath ?? avatarPlaceholderPath; }

  User({ 
    required this.id, 
    required this.name, 
    required this.email, 
    required this.avatarPath 
  });
}