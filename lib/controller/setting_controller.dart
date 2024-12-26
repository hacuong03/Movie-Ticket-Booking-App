import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // Language settings
  var selectedLanguage = 'Vietnamese'.obs;
  final List<String> languages = ['English', 'Vietnamese'];

  // Theme settings
  var isDarkTheme = false.obs;

  // Notification settings
  var notificationsEnabled = false.obs;
  var doNotDisturb = false.obs;
  var pushNotifications = false.obs;

  // Playback settings
  var autoPlayTrailers = false.obs;

  // Support information
  final String supportEmail = 'support@example.com';
  final String facebookPage = 'https://facebook.com/example';
  
  @override
  void onInit() {
    super.onInit();
    // Có thể thêm code để load các settings đã lưu từ local storage
    loadSavedSettings();
  }

  void loadSavedSettings() {
    // TODO: Implement loading saved settings from local storage
  }

  // Language methods
  void updateLanguage(String language) {
    selectedLanguage.value = language;
    if (language == 'English') {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (language == 'Vietnamese') {
      Get.updateLocale(const Locale('vi', 'VN'));
    }
    saveSettings();
  }

  // Theme methods
  void toggleTheme(bool isDark) {
    isDarkTheme.value = isDark;
    Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
    saveSettings();
  }

  // Notification methods
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    saveSettings();
  }

  void toggleDoNotDisturb(bool value) {
    doNotDisturb.value = value;
    saveSettings();
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    saveSettings();
  }

  // Playback methods
  void toggleAutoPlayTrailers(bool value) {
    autoPlayTrailers.value = value;
    saveSettings();
  }

  // Support methods
  Future<bool> sendSupportEmail() async {
    // TODO: Implement email sending logic
    return true;
  }

  Future<bool> openFacebookSupport() async {
    // TODO: Implement Facebook messenger opening logic
    return true;
  }

  Future<void> startLiveChat() async {
    // TODO: Implement live chat logic
  }

  // Save settings
  void saveSettings() {
    // TODO: Implement saving settings to local storage
    // Có thể sử dụng shared_preferences để lưu các cài đặt
  }

  // Reset settings to default
  void resetToDefault() {
    selectedLanguage.value = 'Vietnamese';
    isDarkTheme.value = false;
    notificationsEnabled.value = false;
    doNotDisturb.value = false;
    pushNotifications.value = false;
    autoPlayTrailers.value = false;
    Get.changeTheme(ThemeData.light());
    Get.updateLocale(const Locale('vi', 'VN'));
    saveSettings();
  }
}