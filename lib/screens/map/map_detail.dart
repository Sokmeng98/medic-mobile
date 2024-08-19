import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/services/map_service.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class MyMapDetail extends StatefulWidget {
  const MyMapDetail({super.key, required this.clinicId});

  final int clinicId;

  @override
  State<MyMapDetail> createState() => _MyMapDetailScreenState();
}

class _MyMapDetailScreenState extends State<MyMapDetail> {
  bool loading = true;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  dynamic clinic;
  List<Widget> phoneNumberWidgets = [];
  List<Widget> serviceWidgets = [];

  void _onBack() {
    Navigator.pushNamed(context, mapRoute);
  }

  @override
  void initState() {
    super.initState();
    MapService().getClinicById(widget.clinicId).then((data) {
      setState(() {
        clinic = data;
      });
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;
    if (!loading) {
      if (this.clinic.containsKey("clinic_contacts")) {
        for (var phoneNumber in this.clinic["clinic_contacts"]) {
          String phoneSystem = "";
          switch (phoneNumber["phone_system"]) {
            case 1:
              phoneSystem = "assets/images/map/smart.png";
              break;
            case 2:
              phoneSystem = "assets/images/map/cellcard.png";
              break;
            case 3:
              phoneSystem = "assets/images/map/metfone.png";
              break;
          }

          phoneNumberWidgets.add(
            Container(
              child: Row(
                children: [
                  Image.asset(
                    phoneSystem,
                    width: 20.0,
                    fit: BoxFit.contain,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                  Text(phoneNumber["phone"]),
                ],
              ),
            ),
          );
          phoneNumberWidgets.add(Padding(padding: EdgeInsets.symmetric(vertical: 3.0)));
        }
      }
      if (this.clinic.containsKey("clinic_services")) {
        for (var service in this.clinic["clinic_services"]) {
          serviceWidgets.add(
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          );
          serviceWidgets.add(
            Row(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 13.0)),
                Image.network(
                  service["icon"],
                  width: 20.0,
                  fit: BoxFit.contain,
                  color: isDarkMode ? AppTheme.background : null,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                Expanded(
                  child: Text(
                    service["name"],
                  ),
                ),
              ],
            ),
          );
        }
      }
    }

    if (loading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        ),
      );
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              //Header
              SliverAppBar(
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                toolbarHeight: 350,
                title: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
                      child: this.clinic["image"] == null
                          ? Image.asset(
                              "assets/images/no_image_available.png",
                              width: 420.0,
                              height: 350.0,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.network(
                              this.clinic["image"],
                              width: 420.0,
                              height: 350.0,
                              fit: BoxFit.fill,
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(10.0),
                            color: AppTheme.primary,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              _onBack();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: AppTheme.shadow.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 100.0)),
                          Text(
                            this.clinic["name"],
                            style: TextStyle(fontSize: 24.0, fontFamily: "Poppins", color: Colors.white),
                          ),
                          Text(
                            this.clinic["clinic_location"]["name"],
                            style: TextStyle(fontSize: 24.0, fontFamily: "Poppins", color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                titleSpacing: 0.0,
              ),
              //Body
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(height: 20.0),
                        //Location
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.pin_drop_outlined,
                                color: AppTheme.primary,
                                size: 20.0,
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                              Expanded(
                                child: Text(
                                  this.clinic["clinic_location"]["address"],
                                  style: isDarkMode ? titleDarkTextStyle(15.0, FontWeight.w500) : titleLightTextStyle(15.0, FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        //Phone number
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: AppTheme.primary,
                                size: 20.0,
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.phoneNumber,
                                  style: isDarkMode ? titleDarkTextStyle(15.0, FontWeight.w500) : titleLightTextStyle(15.0, FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.77,
                          child: Column(children: phoneNumberWidgets),
                        ),
                        SizedBox(height: 20.0),
                        //Available service
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                color: AppTheme.primary,
                                size: 20.0,
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.availableServices,
                                  style: isDarkMode ? titleDarkTextStyle(15.0, FontWeight.w500) : titleLightTextStyle(15.0, FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: serviceWidgets),
                        ),
                        SizedBox(height: 30.0),
                        //Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 10, left: 20.0),
                                child: FilledButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.appointment,
                                    style: buttonTextStyle(),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pushNamed(meetOurDoctorRoute);
                                  },
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    backgroundColor: AppTheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 20.0, left: 10.0),
                                child: OutlinedButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.hivTest,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pushNamed(hivTestingRoute);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: AppTheme.primary, width: 2.0),
                                    foregroundColor: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
