import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/screens/authentication/create_account.dart';
import 'package:paramedix/screens/authentication/signup.dart';
import 'package:paramedix/screens/home.dart';
import 'package:paramedix/screens/map.dart';
import 'package:paramedix/screens/notification.dart';
import 'package:paramedix/screens/profile.dart';
import 'package:provider/provider.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _page = 1;
  bool showNavigationBar = true;
  List<Widget> _screen = [
    MyHome(),
    MyMap(),
    MyNotification(),
    MyProfile(),
  ];
  late PageController _pageController;

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    genderController = TextEditingController();
    fullNameController = TextEditingController();
    dateController = TextEditingController();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _screen,
        ),
        bottomNavigationBar: showNavigationBar
            ? Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
                height: rlgScreen(context)
                    ? MediaQuery.of(context).size.height * 0.11
                    : rxlScreen(context)
                        ? MediaQuery.of(context).size.height * 0.10
                        : MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _homeNavigationBar(),
                    _mapNavigationBar(),
                    _emergencyNavigationBar(isDarkMode),
                    _notificationNavigationBar(),
                    _profileNavigationBar(),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
                height: rlgScreen(context)
                    ? MediaQuery.of(context).size.height * 0.11
                    : rxlScreen(context)
                        ? MediaQuery.of(context).size.height * 0.10
                        : MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 5.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: isDarkMode ? AppTheme.primary.withOpacity(0.4) : AppTheme.primary.withOpacity(0.2),
                      size: 30.0,
                    ),
                    Icon(
                      Icons.place_outlined,
                      color: isDarkMode ? AppTheme.primary.withOpacity(0.4) : AppTheme.primary.withOpacity(0.2),
                      size: 30.0,
                    ),
                    IconButton(
                      padding: EdgeInsets.only(bottom: 10.0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      enableFeedback: true,
                      icon: Icon(Icons.disabled_by_default, color: Colors.red, size: 50.0),
                      onPressed: () {
                        setState(() {
                          showNavigationBar = !showNavigationBar;
                        });
                      },
                    ),
                    Icon(
                      Icons.notifications_outlined,
                      color: isDarkMode ? AppTheme.primary.withOpacity(0.4) : AppTheme.primary.withOpacity(0.2),
                      size: 30.0,
                    ),
                    Icon(
                      Icons.person_outline,
                      color: isDarkMode ? AppTheme.primary.withOpacity(0.4) : AppTheme.primary.withOpacity(0.2),
                      size: 30.0,
                    ),
                  ],
                ),
              ),
        bottomSheet: showNavigationBar ? null : _emergencyScreen(isDarkMode),
      );
    });
  }

  Widget _homeNavigationBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, homeRoute);
              });
            },
            icon: Icon(
              Icons.home_outlined,
              color: AppTheme.primary,
              size: 30.0,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 4.0,
            width: _page == 0 ? 10.0 : 0.0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapNavigationBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                if (_page == 1) {
                  Navigator.pushNamed(context, bottomNavigationRoute);
                } else {
                  navigationTapped(1);
                }
              });
            },
            icon: Icon(
              Icons.place_outlined,
              color: AppTheme.primary,
              size: 30.0,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 4.0,
            width: _page == 1 ? 10.0 : 0.0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyNavigationBar(isDarkMode) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: isDarkMode ? Colors.black : Colors.white,
      onPressed: () {
        setState(() {
          showNavigationBar = !showNavigationBar;
        });
      },
      padding: EdgeInsets.zero,
      icon: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
          Icon(Icons.local_hospital, color: Colors.red, size: 50.0),
          Text(
            AppLocalizations.of(context)!.emergency,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _notificationNavigationBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, notificationRoute);
              });
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTheme.primary,
              size: 30.0,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 4.0,
            width: _page == 2 ? 10.0 : 0.0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileNavigationBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, profileRoute);
              });
            },
            icon: Icon(
              Icons.person_outline,
              color: AppTheme.primary,
              size: 30.0,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 4.0,
            width: _page == 3 ? 10.0 : 0.0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyScreen(isDarkMode) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 170.0,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: outlineButton(
                            AppLocalizations.of(context)!.emergency1,
                            context,
                            bottomNavigationRoute,
                            AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (rmdScreen(context)) SizedBox(height: 10.0),
                  if (mdScreen(context)) SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: fillButton(
                            AppLocalizations.of(context)!.emergency2,
                            context,
                            bottomNavigationRoute,
                            AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
