import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';
import 'package:paramedix/api/services/notification_service.dart';
import 'package:paramedix/api/services/profile_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/button/language_button.dart';
import 'package:paramedix/components/cards/grid_card.dart';
import 'package:paramedix/components/current_location.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/notification.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:paramedix/providers/userProfile_provider.dart';
import 'package:provider/provider.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

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
        home: const MyHomeScreen(),
      );
    });
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int activePage = 1;
  List<String> images = [
    "assets/images/home/slideshow1.png",
    "assets/images/home/slideshow2.png",
    "assets/images/home/slideshow3.png",
  ];
  ProfileModel? user;
  NotificationService notificationService = NotificationService();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    String devicePlatform;
    String? subscriptionID;
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    final _getUserProfileProviderData = Provider.of<UserProfileProvider>(context, listen: false).profileProviderData;
    if (_getUserProfileProviderData == null) {
      ProfileService().getProfile().then((userData) {
        Provider.of<UserProfileProvider>(context, listen: false).setProfileData(userData);
        setState(() {
          user = userData;
        });
        user?.formatPhoneNumber();
        user?.formatDateOfBirth();
        user?.formatGender();
      });
    }

    notificationService.forgroundMessage();
    if (Platform.isAndroid) {
      devicePlatform = "android";
    } else {
      devicePlatform = "ios";
    }
    subscriptionID = OneSignal.User.pushSubscription.id;
    notificationService.requestNotificationPermission().then((isPermission) async {
      if (isPermission) {
        if (subscriptionID != null) {
          print("UUID: $subscriptionID");
          final response = await NotificationServiceUrl().postRegisterDevice(devicePlatform, subscriptionID);
          if (response.statusCode == 201) {
            print("Register device successfuly");
          } else if (response.statusCode == 400) {
            print("You already register device");
          } else {
            print(response.statusCode);
          }
        } else {
          print("UUID null");
        }
      } else {
        if (subscriptionID != null) {
          final response = await NotificationServiceUrl().deleteRegisterDevice(subscriptionID);
          if (response.statusCode == 200) {
            print("Register device delete successfuly");
          } else {
            print("Register device delete error ${response.body}");
            print("Register device delete error ${response.statusCode}");
          }
        } else {
          print("You do not have permission");
        }
      }
    });
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
                      size: 20.0,
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
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              //Slideshow
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: PageView.builder(
                  itemCount: images.length,
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      activePage = page;
                    });
                  },
                  itemBuilder: (context, pagePosition) {
                    bool active = pagePosition == activePage;
                    return slider(images, pagePosition, active);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicators(images.length, activePage),
              ),
              //Grid View
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: rmdScreen(context)
                      ? EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0)
                      : rxlScreen(context)
                          ? EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)
                          : EdgeInsets.all(20.0),
                  mainAxisSpacing: rmdScreen(context) ? MediaQuery.of(context).size.height * 0.02 : MediaQuery.of(context).size.height * 0.03,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.1,
                  crossAxisCount: 2,
                  children: [
                    for (int i = 0; i < 4; i++) GridCard(index: i),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 0),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    margin: EdgeInsets.all(active ? 10.0 : 20.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Image.asset(
        images[pagePosition],
        fit: BoxFit.fill,
      ),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3.0),
      width: 5.0,
      height: 5.0,
      decoration: BoxDecoration(color: currentIndex == index ? AppTheme.primary : AppTheme.primary.withOpacity(0.5), shape: BoxShape.circle),
    );
  });
}
