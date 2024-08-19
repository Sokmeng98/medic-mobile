import 'package:flutter/material.dart';
import 'package:paramedix/components/text/text.dart';

OutlinedButton outlineButton(String text, BuildContext context, String route, Color color) => OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: "Poppins",
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(color: color, width: 2.0),
        foregroundColor: color,
      ),
    );

FilledButton fillButton(String text, BuildContext context, String route, Color color) => FilledButton(
      child: Text(
        text,
        style: buttonTextStyle(),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

FilledButton filledButton(String text, onPressed, Color color) => FilledButton(
      child: Text(
        text,
        style: buttonTextStyle(),
      ),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
