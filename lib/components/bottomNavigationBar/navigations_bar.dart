import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:provider/provider.dart';

class NavigationsBar extends StatefulWidget {
  const NavigationsBar({super.key, required this.screen});

  final int screen;

  @override
  _NavigationsBarState createState() => _NavigationsBarState();
}

class _NavigationsBarState extends State<NavigationsBar> {
  bool showNavigationBar = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return showNavigationBar
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
                        Provider.of<NavigationBarProvider>(context, listen: false).toggleNavigationBar();
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
              Navigator.pushNamed(context, homeRoute);
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
            width: widget.screen == 0 ? 10.0 : 0.0,
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
              // Navigator.pushNamed(context, mapRoute);
              Navigator.pushNamed(context, bottomNavigationRoute);
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
            width: widget.screen == 1 ? 10.0 : 0.0,
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
          Provider.of<NavigationBarProvider>(context, listen: false).toggleNavigationBar();
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
              Navigator.pushNamed(context, notificationRoute);
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
            width: widget.screen == 2 ? 10.0 : 0.0,
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
              Navigator.pushNamed(context, profileRoute);
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
            width: widget.screen == 3 ? 10.0 : 0.0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }
}
