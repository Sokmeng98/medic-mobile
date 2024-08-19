import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:provider/provider.dart';

class MySetting extends StatelessWidget {
  const MySetting({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      final languageProvider = Provider.of<LanguageProvider>(context);

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouterNavigator.generateRoute,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: languageProvider.getCurrentLocale(),
        title: "PARAMEDIX",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background, brightness: isDarkMode ? Brightness.dark : Brightness.light),
          useMaterial3: true,
        ),
        home: MySettingScreen(title: AppLocalizations.of(context)!.setting),
      );
    });
  }
}

class MySettingScreen extends StatefulWidget {
  const MySettingScreen({super.key, required this.title});

  final String title;

  @override
  State<MySettingScreen> createState() => _MySettingScreenState();
}

class _MySettingScreenState extends State<MySettingScreen> {
  bool switchActive = false;

  void _onBack() {
    Navigator.pushNamed(context, profileRoute);
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationBar = Provider.of<NavigationBarProvider>(context).showNavigationBar;
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;
    bool isLanguageEnglish = Provider.of<LanguageProvider>(context, listen: false).isLanguageEnglish;
    List titleAccountSetting = [
      AppLocalizations.of(context)!.changePassword,
      AppLocalizations.of(context)!.securitySetting,
      AppLocalizations.of(context)!.privacySetting,
    ];
    List titlePreference = [
      AppLocalizations.of(context)!.notificationSetting,
      AppLocalizations.of(context)!.appPermissions,
    ];
    List titleHelp = [
      AppLocalizations.of(context)!.contactUs,
      AppLocalizations.of(context)!.helpUs,
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: rlgScreen(context) ? 90.0 : 100.0,
        scrolledUnderElevation: 0.0,
        leading: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 13.0),
                decoration: BoxDecoration(
                  boxShadow: isDarkMode
                      ? [
                          BoxShadow(
                            color: AppTheme.shadow.withOpacity(0.3),
                            blurRadius: 20.0,
                            spreadRadius: -5.0,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppTheme.shadow.withOpacity(0.3),
                            blurRadius: 20.0,
                          ),
                        ],
                ),
                child: IconButton(
                  padding: EdgeInsets.all(10.0),
                  color: AppTheme.primary,
                  icon: Icon(Icons.arrow_back),
                  onPressed: _onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          widget.title,
          style: isDarkMode
              ? titleFontSizeDarkTextStyle(22.0)
              : isDarkMode
                  ? titleFontSizeDarkTextStyle(22.0)
                  : titleFontSizeLightTextStyle(22.0),
        ),
        titleSpacing: 8.0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              //Account Setting
              Container(
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.accountSetting,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                child: Column(
                  children: [
                    for (int i = 0; i < 3; i++) _settingCard(titleAccountSetting[i], AppLocalizations.of(context)!.privacySetting, isDarkMode),
                  ],
                ),
              ),
              //Preference
              Container(
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.preference,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                child: Column(
                  children: [
                    //Language
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLanguageEnglish = !isLanguageEnglish;
                        });
                        Provider.of<LanguageProvider>(context, listen: false).toggleLanguage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: isLanguageEnglish ? 1.0 : 1.5, color: AppTheme.shadow.withOpacity(0.5)),
                          ),
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.language,
                              style: rxlScreen(context)
                                  ? isDarkMode
                                      ? titleDarkTextStyle(18.0, FontWeight.normal)
                                      : titleLightTextStyle(18.0, FontWeight.normal)
                                  : isDarkMode
                                      ? titleDarkTextStyle(20.0, FontWeight.normal)
                                      : titleLightTextStyle(20.0, FontWeight.normal),
                            ),
                            if (isLanguageEnglish == true)
                              Image.asset(
                                "assets/images/khmer.png",
                                width: 30.0,
                                height: 25.0,
                                fit: BoxFit.contain,
                              ),
                            if (isLanguageEnglish == false)
                              Image.asset(
                                "assets/images/english.png",
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.contain,
                              ),
                          ],
                        ),
                      ),
                    ),
                    //Dark Mode
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: AppTheme.shadow.withOpacity(0.5)),
                          ),
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.darkMode,
                              style: rxlScreen(context)
                                  ? isDarkMode
                                      ? titleDarkTextStyle(18.0, FontWeight.normal)
                                      : titleLightTextStyle(18.0, FontWeight.normal)
                                  : isDarkMode
                                      ? titleDarkTextStyle(20.0, FontWeight.normal)
                                      : titleLightTextStyle(20.0, FontWeight.normal),
                            ),
                            Switch(
                              value: isDarkMode,
                              activeColor: AppTheme.primary,
                              onChanged: (bool value) {
                                setState(() {
                                  Provider.of<DarkModeProvider>(context, listen: false).toggleDarkMode();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < 2; i++) _settingCard(titlePreference[i], AppLocalizations.of(context)!.appPermissions, isDarkMode),
                      ],
                    ),
                  ],
                ),
              ),
              //Help
              Container(
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.help,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                child: Column(
                  children: [
                    for (int i = 0; i < 2; i++) _settingCard(titleHelp[i], AppLocalizations.of(context)!.helpUs, isDarkMode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 3),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }

  Widget _settingCard(settingList, bottomBorder, isDarkMode) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, settingRoute);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1.0,
                color: settingList == bottomBorder
                    ? isDarkMode
                        ? Colors.black
                        : Colors.white
                    : AppTheme.shadow.withOpacity(0.5)),
          ),
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settingList,
              style: rxlScreen(context)
                  ? isDarkMode
                      ? titleDarkTextStyle(18.0, FontWeight.normal)
                      : titleLightTextStyle(18.0, FontWeight.normal)
                  : isDarkMode
                      ? titleDarkTextStyle(20.0, FontWeight.normal)
                      : titleLightTextStyle(20.0, FontWeight.normal),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}
