import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/notification_model.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationItem notification;

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      String capitalizeFirstOfEach = capitalizeAllWord(notification.type);
      var historyFormat = DateTime.parse(notification.appointmentInfo.date);
      String historyDate = DateFormat(r'''dd MMMM yyyy 'at' hh:mm a''').format(historyFormat);

      return Container(
        padding: rlgScreen(context) ? EdgeInsets.all(5.0) : EdgeInsets.all(10.0),
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
        child: ExpansionTile(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          collapsedBackgroundColor: isDarkMode ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            capitalizeFirstOfEach,
            style: rxlScreen(context)
                ? isDarkMode
                    ? titleFontSizeDarkTextStyle(18.0)
                    : titleFontSizeLightTextStyle(18.0)
                : isDarkMode
                    ? titleFontSizeDarkTextStyle(20.0)
                    : titleFontSizeLightTextStyle(20.0),
          ),
          children: [
            if (notification.type == "new announcement")
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 10.0, right: 15.0, left: 15.0),
                child: Text(
                  notification.message,
                  style: isDarkMode ? subtitleColorTextStyle(Colors.white) : subtitleColorTextStyle(Colors.black),
                ),
              ),
            if (notification.type == "appointment alert")
              if (notification.appointmentInfo.status == 'appointment')
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(bottom: 10.0, right: 15.0, left: 15.0),
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
                              "$historyDate",
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
                              notification.appointmentInfo.specialistInfo.fullName,
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
                              notification.appointmentInfo.mapInfo.name,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (notification.appointmentInfo.status == 'cancel')
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(bottom: 10.0, right: 15.0, left: 15.0),
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
                              "$historyDate",
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
                              notification.appointmentInfo.specialistInfo.fullName,
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
                              notification.appointmentInfo.mapInfo.name,
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
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
                ),
          ],
        ),
      );
    });
  }
}
