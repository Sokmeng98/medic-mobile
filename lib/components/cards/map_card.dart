import 'package:flutter/material.dart';
import 'package:paramedix/api/models/clinic_model.dart';
import 'package:paramedix/components/theme.dart';

class MapCard extends StatelessWidget {
  const MapCard({required this.clinic});

  final ClinicItem clinic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: 3,
            color: AppTheme.subtitle,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: this.clinic.image == ""
                  ? Image.asset(
                      "assets/images/no_image_available.png",
                      width: 100.0,
                      height: 90.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Image.network(
                      this.clinic.image,
                      width: 100.0,
                      height: 90.0,
                      fit: BoxFit.fitHeight,
                    ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.clinic.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    this.clinic.description,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  Row(
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
                          this.clinic.locationInfo.address,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
