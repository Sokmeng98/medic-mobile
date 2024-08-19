import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/facility_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/cards/facility_card.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/currentLocation_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/nearbyFacility_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyNearbyFacility extends StatelessWidget {
  const MyNearbyFacility({super.key});

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
        home: MyNearbyFacilityScreen(title: AppLocalizations.of(context)!.nearbyFacility),
      );
    });
  }
}

class MyNearbyFacilityScreen extends StatefulWidget {
  const MyNearbyFacilityScreen({super.key, required this.title});

  final String title;

  @override
  State<MyNearbyFacilityScreen> createState() => _MyNearbyFacilityScreenState();
}

class _MyNearbyFacilityScreenState extends State<MyNearbyFacilityScreen> {
  bool showNavigationBar = true;
  bool _isLoading = true;
  List<FacilityItem>? nearbyFacilityData;

  void _onBack() {
    Navigator.pushNamed(context, healthcareFacilityRoute);
  }

  @override
  void initState() {
    super.initState();
    int? service = Provider.of<NearbyFacilityProvider>(context, listen: false).serviceValueProviderData;
    int? location = Provider.of<NearbyFacilityProvider>(context, listen: false).locationValueProviderData;
    double? latitude = Provider.of<CurrentLocationProvider>(context, listen: false).latitudeValueProviderData;
    double? longitude = Provider.of<CurrentLocationProvider>(context, listen: false).longitudeValueProviderData;
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
    if (service != null && location != null) {
      HomeService().getsNearbyFacility(service, location, latitude, longitude).then((data) {
        setState(() {
          nearbyFacilityData = data;
        });
      });
    }
    if (service != null && location == null) {
      HomeService().getsNearbyFacilityService(service, latitude, longitude).then((data) {
        setState(() {
          nearbyFacilityData = data;
        });
      });
    }
    if (service == null && location != null) {
      HomeService().getsNearbyFacilityLocation(location, latitude, longitude).then((data) {
        setState(() {
          nearbyFacilityData = data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: nearbyFacilityData?.length != 0
              ? Skeletonizer(
                  enabled: _isLoading,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
                    itemCount: nearbyFacilityData?.length ?? 0,
                    itemBuilder: (context, index) {
                      FacilityItem nearbyFacility = nearbyFacilityData![index];

                      return FacilityCard(facility: nearbyFacility);
                    },
                  ),
                )
              : NoFacilityFound(),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 0),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}
