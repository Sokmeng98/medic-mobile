import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/clinic_model.dart';
import 'package:paramedix/components/cards/map_card.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/screens/map/map_detail.dart';

class MapCardExpand extends StatelessWidget {
  const MapCardExpand({required this.clinic});

  final ClinicItem clinic;

  @override
  Widget build(BuildContext context) {
    List<Widget> servicesWidget = [];
    for (ServiceInfo service in clinic.serviceInfo) {
      servicesWidget.add(
        Text(
          "• " + service.name,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MapCard(clinic: clinic),
              SizedBox(height: 10),
              //Available service
              Text(
                AppLocalizations.of(context)!.availableServices,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: servicesWidget,
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
              child: FilledButton(
                child: Text(
                  AppLocalizations.of(context)!.viewDetails,
                  style: buttonTextStyle(),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyMapDetail(clinicId: this.clinic.id)));
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
          ],
        ),
      ],
    );
  }
}
