import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class OnlineCounselingCard extends StatelessWidget {
  const OnlineCounselingCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      List route = [
        onlineCounselingRoute,
        onlineCounselingRoute,
      ];
      List title = [
        AppLocalizations.of(context)!.counselFacebook,
        AppLocalizations.of(context)!.counselTelegram,
      ];
      List subtitle = [
        AppLocalizations.of(context)!.counselFacebookDescription,
        AppLocalizations.of(context)!.counselTelegramDescription,
      ];
      List image = [
        "assets/images/counseling/facebook_counsel.png",
        "assets/images/counseling/telegram_counsel.png",
      ];

      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route[index]);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 25.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title[index],
                        style: isDarkMode ? titleFontSizeDarkTextStyle(19.0) : titleFontSizeLightTextStyle(19.0),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text(
                        subtitle[index],
                        style: subtitleFontSizeTextStyle(13.0),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
                    child: Image.asset(
                      image[index],
                      height: rmdScreen(context)
                          ? 60.0
                          : rxlScreen(context)
                              ? 70.0
                              : 80.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
