import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/notification_model.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';
import 'package:paramedix/api/services/notification_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/cards/notification_card.dart';
import 'package:paramedix/components/current_location.dart';
import 'package:paramedix/components/error_screen.dart';
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

class MyNotification extends StatelessWidget {
  const MyNotification({super.key});

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
        home: const NotificationScreen(),
      );
    });
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool loading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 10;
  int notificationDataCount = 0;
  List<NotificationItem> notificationData = [];
  ProfileModel? user;
  final scrollController = ScrollController();

  Future fetchData() async {
    if (loading) return;
    loading = true;
    NotificationServiceUrl().getsNotificationCount(user?.id).then((dataCount) {
      setState(() {
        notificationDataCount = dataCount;
        NotificationServiceUrl().getsNotification(user?.id, page, pageSize).then((data) {
          setState(() {
            if (notificationData.length < notificationDataCount) {
              page++;
              loading = false;
              notificationData.addAll(data);
            }
            if (notificationData.length == notificationDataCount) {
              page--;
              hasMore = false;
            }
            if (notificationData.isEmpty) {
              page--;
              loading = false;
              hasMore = false;
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final _userProfileData = Provider.of<UserProfileProvider>(context, listen: false).profileProviderData;
    setState(() {
      user = _userProfileData;
    });
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
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
            children: [
              if (notificationData.isEmpty)
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : NoNotificationFound(),
                ),
              if (notificationData.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
                    itemCount: notificationData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < notificationData.length) {
                        NotificationItem notification = notificationData[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 25.0),
                          child: NotificationCard(notification: notification),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: hasMore ? CircularProgressIndicator(color: AppTheme.primary) : Text(AppLocalizations.of(context)!.noDataLoad),
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 2),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}
