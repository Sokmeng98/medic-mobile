import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paramedix/api/models/clinic_model.dart';
import 'package:paramedix/api/services/map_service.dart';
import 'package:paramedix/components/cards/map_card.dart';
import 'package:paramedix/components/cards/map_card_expand.dart';
import 'package:paramedix/components/current_location.dart';
import 'package:paramedix/components/button/language_button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class MyMap extends StatelessWidget {
  const MyMap({super.key});

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
        home: MyMapScreen(),
      );
    });
  }
}

class MyMapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MyMapScreen> {
  bool showMore = false;
  bool isLanguage = false;
  List<ClinicItem> clinicData = [];
  List<dynamic>? locationData = [];
  GoogleMapController? _controller;
  MapService _mapService = MapService();
  ScrollController _scrollController = ScrollController();
  final Set<Marker> _markers = {};

  void _onMarkerTapped(LatLng location) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15.0,
        ),
      ),
    );

    // Find the index of the marker in the list and scroll to it
    int clickedIndex = -1;
    for (final (
          index,
          marker
        ) in _markers.indexed) {
      if (marker.position == location) {
        clickedIndex = index;
      }
    }
    if (clickedIndex != -1) {
      _scrollController.animateTo(
        clickedIndex * MediaQuery.of(context).size.width, // Adjust the scroll position as needed
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _mapService.getClinics().then((data) {
      setState(() {
        clinicData = data;
      });
    });
    _mapService.getLocations().then((data2) {
      setState(() {
        locationData = data2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;
    if (locationData != null) {
      for (var item in locationData!) {
        LatLng latlg = LatLng(item['location']['coordinates'][1], item['location']['coordinates'][0]);
        _markers.add(
          Marker(
              markerId: MarkerId("marker${item['id']}"),
              position: latlg,
              onTap: () {
                _onMarkerTapped(latlg);
              }),
        );
      }
    }

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
        child: Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(target: LatLng(11.544544791788423, 104.91954922725033), zoom: 12.0),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
            Positioned(
              bottom: 110,
              left: 0,
              right: 0,
              child: Container(
                height: showMore ? 300.0 : 160.0,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: clinicData.length,
                  itemBuilder: (context, index) {
                    final clinic = clinicData.elementAt(index);
                    final marker = _markers.elementAt(index);
                    return GestureDetector(
                      onVerticalDragEnd: (details) {
                        setState(() {
                          showMore = !showMore;
                        });
                      },
                      onTap: () {
                        setState(() {
                          showMore = !showMore;
                        });
                      },
                      child: LocationCard(
                        location: marker.position,
                        showMore: showMore,
                        clinic: clinic,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({required this.location, required this.showMore, required this.clinic});

  final LatLng location;
  final bool showMore;
  final ClinicItem clinic;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 8),
      child: showMore ? MapCardExpand(clinic: this.clinic) : MapCard(clinic: this.clinic),
    );
  }
}
