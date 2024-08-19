import 'package:flutter/material.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      bool isLanguageEnglish = Provider.of<LanguageProvider>(context, listen: false).isLanguageEnglish;

      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow.withOpacity(0.2),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.all(10.0),
          icon: isLanguageEnglish
              ? Image.asset(
                  "assets/images/khmer.png",
                  width: 30.0,
                  height: 25.0,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  "assets/images/english.png",
                  width: 30.0,
                  height: 25.0,
                  fit: BoxFit.contain,
                ),
          onPressed: () {
            setState(() {
              isLanguageEnglish = !isLanguageEnglish;
            });
            Provider.of<LanguageProvider>(context, listen: false).toggleLanguage();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
        ),
      );
    });
  }
}
