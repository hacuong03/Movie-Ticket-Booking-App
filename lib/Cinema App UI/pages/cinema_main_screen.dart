import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/consts.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/pages/profile_page.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/pages/ticket_page.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/pages/location_page.dart';

import 'home_page_cinema.dart';

class CinemaMainScreen extends StatefulWidget {
  const CinemaMainScreen({super.key});

  @override
  State<CinemaMainScreen> createState() => _CinemaMainScreenState();
}

class _CinemaMainScreenState extends State<CinemaMainScreen> {
  List<IconData> bottomIcons = [
    Icons.home_filled,
    CupertinoIcons.compass_fill, // For Location Page
    CupertinoIcons.ticket_fill,  // For Ticket Page
    Icons.person_rounded, // Icon for Profile
  ];

  int currentIndex = 0;
  late final List<Widget> page;

  @override
  void initState() {
    page = [
      const HomePageCinema(),
      const LocationPage(),  // Thêm LocationPage vào danh sách page
      const TicketPage(),    // Thêm TicketPage vào danh sách page
      const ProfilePage(),   // Thêm ProfilePage vào danh sách page
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text('Main Screen'),
        backgroundColor: appBackgroundColor,
        elevation: 0,
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            bottomIcons.length,
                (index) => GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index; // Chuyển đến các trang khác
                });
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: currentIndex == index ? 25 : 0,
                    width: currentIndex == index ? 25 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          spreadRadius: currentIndex == index ? 10 : 0,
                          blurRadius: currentIndex == index ? 15 : 0,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    bottomIcons[index],
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: page[currentIndex], // Hiển thị trang hiện tại
    );
  }
}
