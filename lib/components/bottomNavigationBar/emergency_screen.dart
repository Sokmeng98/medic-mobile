import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 170.0,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: outlineButton(
                              AppLocalizations.of(context)!.emergency1,
                              context,
                              bottomNavigationRoute,
                              AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (rmdScreen(context)) SizedBox(height: 10.0),
                    if (mdScreen(context)) SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: fillButton(
                              AppLocalizations.of(context)!.emergency2,
                              context,
                              bottomNavigationRoute,
                              AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
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
