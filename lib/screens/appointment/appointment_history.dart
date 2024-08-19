import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/home/appointment_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/cards/historyAppointment_card.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:provider/provider.dart';

class MyAppointmentHistory extends StatelessWidget {
  const MyAppointmentHistory({super.key});

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
        home: MyAppointmentHistoryScreen(title: AppLocalizations.of(context)!.appointmentHistory),
      );
    });
  }
}

class MyAppointmentHistoryScreen extends StatefulWidget {
  const MyAppointmentHistoryScreen({super.key, required this.title});

  final String title;

  @override
  State<MyAppointmentHistoryScreen> createState() => _MyAppointmentHistoryScreenState();
}

class _MyAppointmentHistoryScreenState extends State<MyAppointmentHistoryScreen> {
  int? id;
  bool hasMore = true;
  bool loading = false;
  int page = 1;
  int pageSize = 5;
  int upcomingAppointmentDataCount = 0;
  int previousAppointmentDataCount = 0;
  List<AppointmentItem>? upcomingAppointmentData;
  List<AppointmentItem> previousAppointmentData = [];
  final scrollController = ScrollController();

  void _onBack() {
    Navigator.pushNamed(context, appointmentRoute);
  }

  void _onCancel() {
    Navigator.pushNamed(context, appointmentHistoryRoute);
  }

  Future fetchData() async {
    if (loading) return;
    loading = true;
    HomeService().getsUpcomingAppointmentCount().then((dataCount) {
      setState(() {
        upcomingAppointmentDataCount = dataCount;
        if (upcomingAppointmentDataCount < 5) pageSize = 10;
        HomeService().getsPreviousAppointmentCount().then((dataCount) {
          setState(() {
            previousAppointmentDataCount = dataCount;
            HomeService().getsPreviousAppointment(page, pageSize).then((data) {
              setState(() {
                if (previousAppointmentData.length < previousAppointmentDataCount) {
                  page++;
                  loading = false;
                  previousAppointmentData.addAll(data);
                }
                if (previousAppointmentData.length == previousAppointmentDataCount) {
                  page--;
                  hasMore = false;
                }
                if (previousAppointmentData.isEmpty) {
                  page--;
                  loading = false;
                  hasMore = false;
                }
              });
            });
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    HomeService().getsUpcomingAppointment().then((data) {
      setState(() {
        upcomingAppointmentData = data;
      });
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
            controller: scrollController,
            children: [
              //Upcoming Appointment
              Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 15.0, right: 20.0, left: 20.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.upcomingAppointment,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                  ],
                ),
              ),
              if (upcomingAppointmentData?.length == 0) NoUpcomingFound(),
              if (upcomingAppointmentData?.length != 0)
                Container(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: upcomingAppointmentData?.length ?? 0,
                    itemBuilder: (context, index) {
                      AppointmentItem upcomingAppointment = upcomingAppointmentData![index];

                      return _upcomingCard(upcomingAppointment, isDarkMode);
                    },
                  ),
                ),

              //History
              Container(
                padding: EdgeInsets.only(bottom: 15.0, right: 20.0, left: 20.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.history,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                  ],
                ),
              ),
              if (previousAppointmentData.isEmpty)
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : NoHistoryFound(),
                ),
              if (previousAppointmentData.isNotEmpty)
                Container(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: previousAppointmentData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < previousAppointmentData.length) {
                        AppointmentItem historyAppointment = previousAppointmentData[index];

                        return HistoryAppointmentCard(appointment: historyAppointment);
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
      bottomNavigationBar: NavigationsBar(screen: 0),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }

  Widget _upcomingCard(AppointmentItem upcomingAppointment, isDarkMode) {
    var appointmentFormat = DateTime.parse(upcomingAppointment.date);
    String appointmentDate = DateFormat(r'''dd MMMM yyyy 'at' hh:mm a''').format(appointmentFormat);

    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(bottom: 20.0),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.schedule_outlined,
                color: AppTheme.primary,
                size: 20.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
              Expanded(
                child: Text(
                  "$appointmentDate",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_4_outlined,
                color: AppTheme.primary,
                size: 20.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
              Expanded(
                child: Text(
                  upcomingAppointment.specialistInfo.fullName,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.home_work_outlined,
                color: AppTheme.primary,
                size: 20.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
              Expanded(
                child: Text(
                  upcomingAppointment.mapInfo.name,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          if (upcomingAppointment.status == 'appointment')
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    child: Text(
                      AppLocalizations.of(context)!.cancelAppointment,
                      style: buttonTextStyle(),
                    ),
                    onPressed: () {
                      Object updateAppointmentDatas = {
                        'user': upcomingAppointment.user,
                        'type': upcomingAppointment.type,
                        'date': '${upcomingAppointment.date}',
                        'specialist': upcomingAppointment.specialist,
                        'map': upcomingAppointment.map,
                        'status': 'cancel',
                      };
                      Object updateAppointmentData = {
                        'user': upcomingAppointment.user,
                        'type': upcomingAppointment.type,
                        'date': '${upcomingAppointment.date}',
                        'map': upcomingAppointment.map,
                        'status': 'cancel',
                      };
                      if (upcomingAppointment.type == 1) {
                        HomeService().updateAppointments(upcomingAppointment.id, updateAppointmentDatas).then((response) {
                          if (response.statusCode == 200) {
                            _onCancel();
                          } else {
                            print(response.body);
                          }
                        });
                      }
                      if (upcomingAppointment.type == 2) {
                        HomeService().updateAppointments(upcomingAppointment.id, updateAppointmentData).then((response) {
                          if (response.statusCode == 200) {
                            _onCancel();
                          } else {
                            print(response.body);
                          }
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (upcomingAppointment.status == 'cancel')
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.report_outlined,
                  color: Colors.red,
                  size: 24.0,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.appointmentCancel,
                    style: isDarkMode ? titleFontSizeDarkTextStyle(16.0) : titleFontSizeLightTextStyle(16.0),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
