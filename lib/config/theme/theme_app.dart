import 'package:flutter/material.dart';
import 'package:movie_ticket/config/color/color.dart';

class ThemesApp {
  // Chế độ sáng (Light Theme)
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.primary, // Tông màu chính của app
      iconTheme: IconThemeData(color: Colors.white), // Màu icon trên AppBar
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: AppColor.primary, // Màu chữ chính
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColor.secondary, // Màu chữ cho tiêu đề
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87, // Chữ body thông thường
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54, // Chữ body phụ
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.secondary, // Màu nút chính
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    // Màu nút nổi bật (floating action button)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
    ),
  );

  // Chế độ tối (Dark Theme)
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.primary,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: AppColor.backgroundDark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    // Màu nút nổi bật (floating action button)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
    ),
  );
}
