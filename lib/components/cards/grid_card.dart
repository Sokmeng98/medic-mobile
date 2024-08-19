import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class GridCard extends StatelessWidget {
  const GridCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      List route = [
        educationRoute,
        questionnaireRoute,
        counselingRoute,
        appointmentRoute,
      ];
      List image = [
        "assets/images/home/education.png",
        "assets/images/home/questionnaire.png",
        "assets/images/home/counseling.png",
        "assets/images/home/appointment.png",
      ];
      List title = [
        AppLocalizations.of(context)!.education,
        AppLocalizations.of(context)!.questionnaire,
        AppLocalizations.of(context)!.counseling,
        AppLocalizations.of(context)!.appointment,
      ];
      List subtitle = [
        AppLocalizations.of(context)!.educationDescription,
        AppLocalizations.of(context)!.questionnaireDescription,
        AppLocalizations.of(context)!.counselingDescription,
        AppLocalizations.of(context)!.appointmentDescription,
      ];

      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route[index]);
        },
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: rmdScreen(context)
                    ? EdgeInsets.only(top: 15.0, right: 5.0, left: 15.0)
                    : r2xlScreen(context)
                        ? EdgeInsets.only(top: 15.0, bottom: 5.0, right: 10.0, left: 15.0)
                        : EdgeInsets.only(top: 20.0, bottom: 20.0, right: 5.0, left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title[index],
                      style: rxsScreen(context)
                          ? isDarkMode
                              ? titleFontSizeDarkTextStyle(13.0)
                              : titleFontSizeLightTextStyle(13.0)
                          : r2xlScreen(context)
                              ? isDarkMode
                                  ? titleFontSizeDarkTextStyle(16.0)
                                  : titleFontSizeLightTextStyle(16.0)
                              : isDarkMode
                                  ? titleFontSizeDarkTextStyle(18.0)
                                  : titleFontSizeLightTextStyle(18.0),
                    ),
                    Padding(padding: r2xlScreen(context) ? EdgeInsets.symmetric(vertical: 3.0) : EdgeInsets.symmetric(vertical: 10.0)),
                    if (rmdScreen(context))
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Opacity(
                            opacity: 0.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
                              child: Image.asset(
                                image[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            subtitle[index],
                            style: rxsScreen(context) ? subtitleFontSizeTextStyle(12.0) : subtitleFontSizeTextStyle(14.0),
                          ),
                        ],
                      ),
                    if (mdScreen(context))
                      Text(
                        subtitle[index],
                        style: r2xlScreen(context) ? subtitleFontSizeTextStyle(14.0) : subtitleFontSizeTextStyle(16.0),
                      ),
                  ],
                ),
              ),
              if (mdScreen(context))
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
                        child: Image.asset(
                          image[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
