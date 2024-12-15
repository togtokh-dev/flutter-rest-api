class UserProfile {
  final String? avatar;
  final String? nickname;
  final String? email;
  final String? phoneNumber;

  UserProfile({
    this.avatar,
    this.nickname,
    this.email,
    this.phoneNumber,
  });

  // Factory constructor to parse JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      avatar: json['user_avatar'],
      nickname: json['user_nickname'],
      email: json['user_email'],
      phoneNumber: json['phone_number']?.toString(),
    );
  }

  // Method to convert UserProfile instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_avatar': avatar,
      'user_nickname': nickname,
      'user_email': email,
      'phone_number': phoneNumber,
    };
  }
}
