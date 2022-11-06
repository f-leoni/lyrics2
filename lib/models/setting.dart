class Setting {
  String setting;
  String value;
  static String _onboardingSettingName = "onboarding_complete";
  static String get onboardingComplete => _onboardingSettingName;
  static String _loginSettingName = "logged_id";
  static String get loggedIn => _loginSettingName;

// Constructor
  Setting({
    required this.setting,
    required this.value,
  });

  // Create from json object
  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
        setting: json['setting'] as String, value: json['value'] as String);
  }

// Convert our Recipe to JSON to make it easier when you store
// it in the database
  Map<String, dynamic> toJson() => {
        'setting': setting,
        'value': value,
      };
}
