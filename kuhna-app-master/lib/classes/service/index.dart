import 'package:maks/classes/user/index.dart';

class Service {
  final int id;
  final User owner;
  final String number;
  final String desc;
  
  final String? avatarPath;
  final String avatarPlaceholderPath = 'https://sun1-84.userapi.com/s/v1/if1/EmuDVvf30OQYUjjY0hprCP5PatcJIXDSM3B0B-MF2Zcp7uaGPiCcGVod0itJHs3Qvqcg3mCm.jpg?size=200x200&quality=96&crop=128%2C128%2C766%2C766&ava=1';

  get finalAvatarPath { return avatarPath ?? avatarPlaceholderPath; }

  Service({
    required this.id,
    required this.owner,
    required this.number,
    required this.desc,
    required this.avatarPath
  });
}