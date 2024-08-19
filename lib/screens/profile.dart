import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/cards/profile_card.dart';
import 'package:paramedix/components/current_location.dart';
import 'package:paramedix/components/button/language_button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:paramedix/providers/userProfile_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;
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
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? userProfile;
  ProfileModel? user;

  @override
  void initState() {
    super.initState();
    final _getUserProfileProviderData = Provider.of<UserProfileProvider>(context, listen: false).profileProviderData;
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      user = _getUserProfileProviderData;
    });
    userProfile = user?.profile;
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationBar = Provider.of<NavigationBarProvider>(context).showNavigationBar;
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: rlgScreen(context) ? 90.0 : 100.0,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5.0)),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop_outlined,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.currentLocation,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(15.0) : titleFontSizeLightTextStyle(15.0),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(3.0)),
              CurrentLocation(fullLocation: false),
            ],
          ),
        ),
        actions: <Widget>[
          LanguageButton(),
          Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
        ],
        titleSpacing: 5.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            //Profile Info
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadow.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Skeletonizer(
                enabled: _isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: userProfile != null
                              ? Image.network(
                                  userProfile!,
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                )
                              : Image.asset(
                                  "assets/images/profile/profile.png",
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
                        Expanded(
                          child: Text(
                            user?.fullName ?? 'N/A',
                            style: rxlScreen(context)
                                ? isDarkMode
                                    ? titleFontSizeDarkTextStyle(18.0)
                                    : titleFontSizeLightTextStyle(18.0)
                                : isDarkMode
                                    ? titleFontSizeDarkTextStyle(20.0)
                                    : titleFontSizeLightTextStyle(20.0),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Container(
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                          Expanded(child: CurrentLocation(fullLocation: true)),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    Wrap(
                      spacing: 10.0,
                      children: <Widget>[
                        Chip(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                          backgroundColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                          side: BorderSide.none,
                          avatar: Icon(
                            Icons.phone_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          label: Text(
                            user?.phoneNumber ?? 'N/A',
                            style: TextStyle(fontSize: 12.0, color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title),
                          ),
                        ),
                        Chip(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                          backgroundColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                          side: BorderSide.none,
                          avatar: Icon(
                            Icons.calendar_month_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          label: Text(
                            user?.dateOfBirth ?? 'N/A',
                            style: TextStyle(fontSize: 12.0, color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title),
                          ),
                        ),
                        Chip(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                          backgroundColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                          side: BorderSide.none,
                          avatar: Icon(
                            user?.gender == 'Male'
                                ? Icons.male
                                : user?.gender == 'Female'
                                    ? Icons.female
                                    : Icons.transgender,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          label: Text(
                            user?.gender ?? 'N/A',
                            style: TextStyle(fontSize: 12.0, color: isDarkMode ? ThemeDarkMode.title : ThemeLightMode.title),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    Row(
                      children: [
                        Expanded(
                          child: outlineButton(
                            AppLocalizations.of(context)!.editInfo,
                            context,
                            editInfoRoute,
                            AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Profile Cards
            Column(
              children: [
                for (int i = 0; i < 4; i++) ProfileCard(index: i),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 3),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}
