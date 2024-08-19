import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paramedix/api/models/home/location_model.dart';
import 'package:paramedix/api/models/home/services_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/cards/allFacilities_card.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/currentLocation_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:paramedix/providers/nearbyFacility_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyHealthcareFacility extends StatelessWidget {
  const MyHealthcareFacility({super.key});

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
        home: MyHealthcareFacilityScreen(title: AppLocalizations.of(context)!.rhacFacility),
      );
    });
  }
}

class MyHealthcareFacilityScreen extends StatefulWidget {
  const MyHealthcareFacilityScreen({super.key, required this.title});

  final String title;

  @override
  State<MyHealthcareFacilityScreen> createState() => _MyHealthcareFacilityScreenState();
}

class _MyHealthcareFacilityScreenState extends State<MyHealthcareFacilityScreen> {
  bool _isLoading = true;
  List<ServicesItem>? serviceData;
  List<LocationItem>? locationData;
  Position? _currentPosition;
  var serviceValue;
  var locationValue;
  var latitudeValue;
  var longitudeValue;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      latitudeValue = _currentPosition?.latitude;
      longitudeValue = _currentPosition?.longitude;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _onBack() {
    Navigator.pushNamed(context, counselingRoute);
  }

  void _onFind() {
    if (serviceValue != null && locationValue != null) {
      Provider.of<NearbyFacilityProvider>(context, listen: false).setServiceValueData(serviceValue);
      Provider.of<NearbyFacilityProvider>(context, listen: false).setLocationValueData(locationValue);
    }
    if (serviceValue != null && locationValue == null) {
      Provider.of<NearbyFacilityProvider>(context, listen: false).setServiceValueData(serviceValue);
      Provider.of<NearbyFacilityProvider>(context, listen: false).setLocationNullValueData(locationValue);
    }
    if (serviceValue == null && locationValue != null) {
      Provider.of<NearbyFacilityProvider>(context, listen: false).setServiceNullValueData(serviceValue);
      Provider.of<NearbyFacilityProvider>(context, listen: false).setLocationValueData(locationValue);
    }
    Provider.of<CurrentLocationProvider>(context, listen: false).setLatitudeValueData(latitudeValue);
    Provider.of<CurrentLocationProvider>(context, listen: false).setLongitudeValueData(longitudeValue);
    Navigator.pushNamed(context, nearbyFacilityRoute);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
    HomeService().getsServiceCount().then((dataCount) {
      HomeService().getsService(dataCount).then((data) {
        setState(() {
          serviceData = data;
        });
      });
    });
    HomeService().getsLocationCount().then((dataCount) {
      HomeService().getsLocation(dataCount).then((data) {
        setState(() {
          locationData = data;
        });
      });
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
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            children: <Widget>[
              AllFacilitiesCard(),
              SizedBox(height: 25.0),
              //Find Facility
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletonizer(
                      enabled: _isLoading,
                      child: Container(
                        padding: EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.findFacility,
                              style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                            Text(
                              AppLocalizations.of(context)!.searchClinic,
                              style: subtitleFontSizeTextStyle(15.0),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            _selectService(isDarkMode),
                            Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            _selectLocation(isDarkMode),
                            Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            Text(
                              AppLocalizations.of(context)!.currentLocationNote,
                              style: subtitleFontSizeTextStyle(13.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30.0),
                            child: filledButton(
                              AppLocalizations.of(context)!.find,
                              // serviceValue != null || locationValue != null ? _onFind : null,
                              _onFind,
                              AppTheme.primary,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
                              child: Image.asset(
                                "assets/images/counseling/find_facility.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  Widget _selectService(isDarkMode) {
    return DropdownButtonFormField(
      isExpanded: true,
      menuMaxHeight: 260.0,
      hint: Text(
        AppLocalizations.of(context)!.selectService,
        style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
      ),
      icon: Icon(Icons.expand_more),
      iconEnabledColor: AppTheme.primary,
      style: TextStyle(color: AppTheme.primary),
      borderRadius: BorderRadius.circular(20.0),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(Icons.medical_services_outlined, color: AppTheme.primary, size: 20.0),
      ),
      value: serviceValue,
      items: serviceData?.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          serviceValue = newValue;
        });
      },
    );
  }

  Widget _selectLocation(isDarkMode) {
    return DropdownButtonFormField(
      isExpanded: true,
      menuMaxHeight: 260.0,
      hint: Text(
        AppLocalizations.of(context)!.selectLocation,
        style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
      ),
      icon: Icon(Icons.expand_more),
      iconEnabledColor: AppTheme.primary,
      style: TextStyle(color: AppTheme.primary),
      borderRadius: BorderRadius.circular(20.0),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(Icons.pin_drop_outlined, color: AppTheme.primary, size: 20.0),
      ),
      value: locationValue,
      items: locationData?.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          locationValue = newValue;
        });
      },
    );
  }
}
