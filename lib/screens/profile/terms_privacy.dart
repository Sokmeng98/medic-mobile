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

class MyTermsPrivacy extends StatelessWidget {
  const MyTermsPrivacy({super.key});

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
        home: MyTermsPrivacyScreen(title: AppLocalizations.of(context)!.termsPrivacy),
      );
    });
  }
}

class MyTermsPrivacyScreen extends StatefulWidget {
  const MyTermsPrivacyScreen({super.key, required this.title});

  final String title;

  @override
  State<MyTermsPrivacyScreen> createState() => _MyTermsPrivacyScreenState();
}

class _MyTermsPrivacyScreenState extends State<MyTermsPrivacyScreen> {
  void _onBack() {
    Navigator.pushNamed(context, profileRoute);
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationBar = Provider.of<NavigationBarProvider>(context).showNavigationBar;
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

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
          style: isDarkMode ? titleFontSizeDarkTextStyle(22.0) : titleFontSizeLightTextStyle(22.0),
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Updated",
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "November 7, 2023",
                          style: subtitleColorTextStyle(AppTheme.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 40.0),
              Text(
                "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects you.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Text(
                "We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Text(
                "Interpretation and Definitions",
                style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Text(
                "Interpretation",
                style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Text(
                "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Text(
                "Definitions",
                style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Text(
                "For the purposes of this Privacy Policy:",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Account means a unique account created for You to access our Service or parts of our Service.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Affiliate means an entity that controls, is controlled by or is under common control with a party, where 'control' means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Application refers to RHAC, the software program provided by the Company.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Company (referred to as either 'the Company', 'We', 'Us' or 'Our' in this Agreement) refers to RHAC, Phnom Penh, Cambodia.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Country refers to: Cambodia",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Personal Data is any information that relates to an identified or identifiable individual.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Service refers to the Application.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                "* You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.",
                style: subtitleColorTextStyle(isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 3),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}
