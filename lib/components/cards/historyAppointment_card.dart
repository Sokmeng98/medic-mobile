import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/home/appointment_model.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class HistoryAppointmentCard extends StatelessWidget {
  const HistoryAppointmentCard({super.key, required this.appointment});

  final AppointmentItem appointment;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      var historyFormat = DateTime.parse(appointment.date);
      String historyDate = DateFormat(r'''dd MMMM yyyy 'at' hh:mm a''').format(historyFormat);

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
                    appointment.specialistInfo.fullName,
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
                    appointment.mapInfo.name,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
