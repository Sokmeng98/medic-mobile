import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/user_model.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key, required this.specialist});

  final UserItem specialist;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.all(5.0),
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
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: specialist.profile != ""
                ? Image.network(
                    specialist.profile,
                    width: 60.0,
                    height: 70.0,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    "assets/images/profile/profile.png",
                    width: 60.0,
                    height: 80.0,
                    fit: BoxFit.fill,
                  ),
          ),
          title: Text(
            specialist.fullName,
            style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    color: AppTheme.primary,
                    size: 20.0,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.specialty,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
              Row(
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    color: AppTheme.primary,
                    size: 20.0,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                  Expanded(
                    child: Text(
                      specialist.mapInfo.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                    child: fillButton(
                      AppLocalizations.of(context)!.checkAvailability,
                      context,
                      meetOurDoctorRoute,
                      AppTheme.primary,
                    ),
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
