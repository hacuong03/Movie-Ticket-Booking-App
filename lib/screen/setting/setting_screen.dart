import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/config/color/color.dart';
import '../../controller/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  final SettingController _controller = Get.put(SettingController());

  SettingScreen({super.key});

  Future<void> _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text('setting'.tr, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Section
              Text(
                'selectLanguage'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:newMethod.isDarkTheme.value
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _controller.selectedLanguage.value,
                    onChanged: (String? newValue) {
                      _controller.updateLanguage(newValue ?? "");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language changed to $newValue'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _controller.languages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                );
              }),

              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              // Support Section
              Text(
                'Support'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // Gmail Support
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: Text('Contact via Email'.tr),
                subtitle: const Text('support@example.com'),
                onTap: () => _launchURL('mailto:support@example.com'),
              ),

              // Facebook Support
              ListTile(
                leading: const Icon(Icons.facebook, color: Colors.blue),
                title: Text('Facebook Support'.tr),
                subtitle: const Text('Message us on Facebook'),
                onTap: () => _launchURL('https://facebook.com/example'),
              ),

              // Live Chat Support
              ListTile(
                leading: const Icon(Icons.chat_bubble, color: Colors.green),
                title: Text('Live Chat'.tr),
                subtitle: Text('Available 24/7'.tr),
                onTap: () {
                  Get.snackbar(
                    'Live Chat',
                    'Connecting to support agent...',
                    duration: const Duration(seconds: 2),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              // Theme Section
              Text(
                'Theme'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(() {
                return SwitchListTile(
                  title: Text('darkTheme'.tr),
                  value: _controller.isDarkTheme.value,
                  onChanged: (bool value) {
                    _controller.toggleTheme(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'Dark theme activated' : 'Light theme activated'
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }),

              // Additional Settings
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              Text(
                'Additional Settings'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Notifications
              Obx(() => SwitchListTile(
                title: Text('Push Notifications'.tr),
                value: _controller.pushNotifications.value,
                onChanged: (bool value) {
                  _controller.togglePushNotifications(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Notifications enabled' : 'Notifications disabled'
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )),

              // Auto-play
              Obx(() => SwitchListTile(
                title: Text('Auto-play Trailers'.tr),
                value: _controller.autoPlayTrailers.value,
                onChanged: (bool value) {
                  _controller.toggleAutoPlayTrailers(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Auto-play enabled' : 'Auto-play disabled'
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )),

              // Save Button
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings saved successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'save'.tr,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              // App Version
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              // Decorative Footer
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Thank you for using our app!',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SettingController get newMethod => _controller;
}