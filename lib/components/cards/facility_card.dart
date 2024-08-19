import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/facility_model.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({super.key, required this.facility});

  final FacilityItem facility;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      double distance = double.parse((facility.distance).toStringAsFixed(2));

      return Container(
        height: 210.0,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(bottom: 20.0),
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
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: facility.image != ""
                        ? Image.network(
                            facility.image,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            "assets/images/no_image_available.png",
                            width: 105.0,
                            height: 100.0,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                  //Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
                          style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
                        ),
                        Text(
                          facility.description,
                          style: isDarkMode ? titleFontSizeDarkTextStyle(17.0) : titleFontSizeLightTextStyle(17.0),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
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
                              Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                              Expanded(
                                child: Text(
                                  facility.locationInfo.address,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                color: AppTheme.primary,
                                size: 20.0,
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                              Expanded(child: Text("$distance km away")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Button
            Row(
              children: [
                Expanded(
                  child: fillButton(
                    AppLocalizations.of(context)!.viewMap,
                    context,
                    bottomNavigationRoute,
                    AppTheme.primary,
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
