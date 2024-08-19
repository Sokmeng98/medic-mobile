import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/clinic_model.dart';
import 'package:paramedix/api/models/home/user_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyMeetOurDoctor extends StatelessWidget {
  const MyMeetOurDoctor({super.key});

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
        home: const MyMeetOurDoctorScreen(title: "Meet Our Doctor"),
      );
    });
  }
}

class MyMeetOurDoctorScreen extends StatefulWidget {
  const MyMeetOurDoctorScreen({super.key, required this.title});

  final String title;

  @override
  State<MyMeetOurDoctorScreen> createState() => _MyMeetOurDoctorScreenState();
}

class _MyMeetOurDoctorScreenState extends State<MyMeetOurDoctorScreen> {
  bool _hasError = false;
  bool isButtonPressed = false;
  DateTime today = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<UserItem>? doctorInfoData;
  List<ClinicItem>? nearbyFacilityData;
  String formatTime() {
    final hour = selectedTime.hour.toString().padLeft(2, "0");
    final min = selectedTime.minute.toString().padLeft(2, "0");
    return "T$hour:$min:00Z";
  }

  final _formKey = GlobalKey<FormState>();
  var specialistValue;
  var facilityValue;

  void _onBack() {
    Navigator.pushNamed(context, appointmentRoute);
  }

  void _makeAppointment() {
    Navigator.pushNamed(context, appointmentHistoryRoute);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void initState() {
    super.initState();
    HomeService().getsSpecialist().then((data) {
      setState(() {
        doctorInfoData = data;
      });
    });
    HomeService().getsFacility().then((data) {
      setState(() {
        nearbyFacilityData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatDate = DateFormat('yyyy-MM-dd').format(today);
    String selectTime = formatDate + formatTime();
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
          AppLocalizations.of(context)!.meetOurDoctor,
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
              _calendar(isDarkMode),
              SizedBox(height: 20.0),
              //Dropdown
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _selectSpecialist(isDarkMode),
                    SizedBox(height: 15.0),
                    _selectTime(isDarkMode),
                    SizedBox(height: 15.0),
                    _selectFacility(isDarkMode),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.appointmentNote,
                      style: subtitleFontSizeTextStyle(13.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: rxlScreen(context) ? 30.0 : 50.0),
              //Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: outlineButton(
                        AppLocalizations.of(context)!.doctorInfo,
                        context,
                        doctorInfoRoute,
                        AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: FilledButton(
                        child: Text(
                          AppLocalizations.of(context)!.makeAppointment,
                          style: buttonTextStyle(),
                        ),
                        onPressed: () {
                          setState(() {
                            isButtonPressed = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _hasError = false;
                            });
                            HomeService().postMeetOurDoctorAppointment(1, specialistValue, selectTime, facilityValue);
                            _makeAppointment();
                          } else {
                            setState(() {
                              _hasError = true;
                            });
                          }
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calendar(isDarkMode) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 20.0, right: 20.0, left: 20.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow.withOpacity(0.3),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 40.0,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: isDarkMode ? calendarHeaderDarkTextStyle() : calendarHeaderLightTextStyle(),
          leftChevronIcon: Icon(
            Icons.keyboard_double_arrow_left,
            color: AppTheme.primary,
          ),
          rightChevronIcon: Icon(
            Icons.keyboard_double_arrow_right,
            color: AppTheme.primary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: isDarkMode ? calendarDaysOfWeekStyleDarkTextStyle() : calendarDaysOfWeekStyleLightTextStyle(),
          weekendStyle: isDarkMode ? calendarDaysOfWeekStyleDarkTextStyle() : calendarDaysOfWeekStyleLightTextStyle(),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.5)),
          selectedDecoration: BoxDecoration(color: AppTheme.primary),
          outsideTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDarkMode ? ThemeDarkMode.title.withOpacity(0.3) : ThemeLightMode.title.withOpacity(0.3),
          ),
          defaultTextStyle: isDarkMode ? calendarStyleDarkTextStyle() : calendarStyleLightTextStyle(),
          weekendTextStyle: isDarkMode ? calendarStyleDarkTextStyle() : calendarStyleLightTextStyle(),
        ),
        availableGestures: AvailableGestures.all,
        selectedDayPredicate: (day) => isSameDay(day, today),
        focusedDay: today,
        firstDay: DateTime.utc(1900, 01, 01),
        lastDay: DateTime.utc(2900, 01, 01),
        onDaySelected: _onDaySelected,
      ),
    );
  }

  Widget _selectSpecialist(isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: _hasError
            ? null
            : [
                BoxShadow(
                  color: AppTheme.shadow.withOpacity(0.3),
                  blurRadius: 10.0,
                ),
              ],
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField(
          isExpanded: true,
          menuMaxHeight: 260.0,
          hint: Text(
            AppLocalizations.of(context)!.selectSpecialist,
            style: subtitleFontSizeTextStyle(17.0),
          ),
          validator: (value) => value == null ? AppLocalizations.of(context)!.fieldRequired : null,
          icon: Icon(Icons.expand_more, size: 25.0),
          iconEnabledColor: isButtonPressed && specialistValue == null ? Colors.red.shade900 : AppTheme.primary,
          borderRadius: BorderRadius.circular(20.0),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDarkMode ? Colors.black : Colors.white,
            border: OutlineInputBorder(
              borderSide: _hasError
                  ? BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(20.0),
            ),
            prefixIcon: Icon(Icons.person_4_outlined, color: AppTheme.primary, size: 20.0),
          ),
          value: specialistValue,
          items: doctorInfoData?.map((item) {
            return DropdownMenuItem(
              value: item.id,
              child: Text(
                item.fullName,
                overflow: TextOverflow.ellipsis,
                style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              specialistValue = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _selectTime(isDarkMode) {
    String format12Time = selectedTime.format(context).toString();

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (timeOfDay != null) {
          setState(() {
            selectedTime = timeOfDay;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
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
        child: Row(
          children: [
            Icon(Icons.schedule_outlined, color: AppTheme.primary, size: 20.0),
            Padding(padding: EdgeInsets.symmetric(horizontal: 15.0)),
            Text(
              format12Time,
              style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectFacility(isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: _hasError
            ? null
            : [
                BoxShadow(
                  color: AppTheme.shadow.withOpacity(0.3),
                  blurRadius: 10.0,
                ),
              ],
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField(
          isExpanded: true,
          menuMaxHeight: 260.0,
          hint: Text(
            AppLocalizations.of(context)!.selectFacility,
            style: subtitleFontSizeTextStyle(17.0),
          ),
          validator: (value) => value == null ? AppLocalizations.of(context)!.fieldRequired : null,
          icon: Icon(Icons.expand_more, size: 25.0),
          iconEnabledColor: isButtonPressed && facilityValue == null ? Colors.red.shade900 : AppTheme.primary,
          borderRadius: BorderRadius.circular(20.0),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDarkMode ? Colors.black : Colors.white,
            border: OutlineInputBorder(
              borderSide: _hasError
                  ? BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(20.0),
            ),
            prefixIcon: Icon(Icons.home_work_outlined, color: AppTheme.primary, size: 20.0),
          ),
          value: facilityValue,
          items: nearbyFacilityData?.map((item) {
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
              facilityValue = newValue;
            });
          },
        ),
      ),
    );
  }
}
