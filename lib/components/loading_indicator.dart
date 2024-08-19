import 'package:flutter/material.dart';
import 'package:paramedix/components/theme.dart';

class LoadingIndicator {
  bool isDisplayed = false;
  late BuildContext _context;
  static final LoadingIndicator _singleton = LoadingIndicator._internal();

  LoadingIndicator._internal();

  factory LoadingIndicator() {
    return _singleton;
  }

  show(BuildContext context) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        isDisplayed = true;
        return Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        );
      },
    );
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
