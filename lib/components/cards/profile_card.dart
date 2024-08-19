import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      bool isLanguageEnglish = Provider.of<LanguageProvider>(context, listen: false).isLanguageEnglish;
      List title = [
        AppLocalizations.of(context)!.favorite,
        AppLocalizations.of(context)!.setting,
        AppLocalizations.of(context)!.termsPrivacy,
        AppLocalizations.of(context)!.refer,
      ];
      List icon = [
        Icon(Icons.favorite_outline, color: AppTheme.primary),
        Icon(Icons.settings_outlined, color: AppTheme.primary),
        Icon(Icons.description_outlined, color: AppTheme.primary),
        Icon(Icons.person_add_alt_outlined, color: AppTheme.primary),
      ];
      List route = [
        favoriteRoute,
        settingRoute,
        termsPrivacyRoute,
        profileRoute,
      ];

      return GestureDetector(
        onTap: () {
          if (route[index] == profileRoute) {
            showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => _referDialog(context, isDarkMode, isLanguageEnglish),
            );
          } else {
            Navigator.pushNamed(context, route[index]);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadow.withOpacity(0.3),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title[index],
                      style: rxlScreen(context)
                          ? isDarkMode
                              ? titleDarkTextStyle(18.0, FontWeight.normal)
                              : titleLightTextStyle(18.0, FontWeight.normal)
                          : isDarkMode
                              ? titleDarkTextStyle(20.0, FontWeight.normal)
                              : titleLightTextStyle(20.0, FontWeight.normal),
                    ),
                    icon[index],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _referDialog(BuildContext context, isDarkMode, isLanguageEnglish) {
    return AlertDialog(
      surfaceTintColor: Colors.grey,
      insetPadding: EdgeInsets.all(10),
      title: Text(
        isLanguageEnglish ? "Share to" : "ចែករំលែកទៅ",
        style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/profile/facebook.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                Text(
                  'Facebook',
                  style: TextStyle(
                    color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/profile/messager.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                Text(
                  'Messager',
                  style: TextStyle(
                    color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/profile/telegram.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                Text(
                  'Telegram',
                  style: TextStyle(
                    color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/profile/copy_link.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                Text(
                  'Copy Link',
                  style: TextStyle(
                    color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.red, width: 2.0),
                ),
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text(
                  isLanguageEnglish ? "Cancel" : "ចាកចេញ",
                  style: subtitleColorTextStyle(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
