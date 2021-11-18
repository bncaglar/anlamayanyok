import 'file:///C:/Users/hvplt/AndroidStudioProjects/anlamayanyok/lib/AnaSayfa/Anaekran.dart';
import 'package:anlamayanyok/utilities/App_color.dart';

import '../Conversations/SearchPage.dart';
import 'package:anlamayanyok/Conversations/recent_conversations_page.dart';
import 'package:flutter/material.dart';
import '../Profile/ProfileView.dart';

class FirstNavigation extends StatefulWidget {
  @override
  _FirstNavigationState createState() => _FirstNavigationState();
}

class _FirstNavigationState extends State<FirstNavigation> {
  int secilisayfa = 0;
  double _height;
  double _width;
  PageController _pagecontroller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double textSize = MediaQuery.of(context).textScaleFactor;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pagecontroller,
        onPageChanged: (index) {
          setState(() {
            secilisayfa = index;
          });
        },
        children: [
          AnaEkran(),
          SearchPage(),
          RecentConversationsPage(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secilisayfa == 0
            ? Colors.white
            : AppColors.modalBottomSheetColor,
        currentIndex: secilisayfa,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xFF323030),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school_outlined,
              color: secilisayfa == 0
                  ? AppColors.backgroundPrimaryColor
                  : AppColors.primaryWightColor,
            ),
            title: Text(
              'Dersler',
              style: TextStyle(
                  color: secilisayfa == 0
                      ? AppColors.backgroundPrimaryColor
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize * 13),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_outline,
              color: secilisayfa == 0
                  ? AppColors.backgroundPrimaryColor
                  : Colors.white,
            ),
            title: Text(
              'Arama',
              style: TextStyle(
                  color: secilisayfa == 0
                      ? AppColors.backgroundPrimaryColor
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize * 13),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: secilisayfa == 0
                  ? AppColors.backgroundPrimaryColor
                  : Colors.white,
            ),
            title: Text(
              'Mesajlar',
              style: TextStyle(
                  color: secilisayfa == 0
                      ? AppColors.backgroundPrimaryColor
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize * 13),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: secilisayfa == 0
                  ? AppColors.backgroundPrimaryColor
                  : Colors.white,
            ),
            title: Text(
              'Hesabım',
              style: TextStyle(
                  color: secilisayfa == 0
                      ? AppColors.backgroundPrimaryColor
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize * 13),
            ),
          ),
        ],
        onTap: (index) {
          _pagecontroller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }
}
