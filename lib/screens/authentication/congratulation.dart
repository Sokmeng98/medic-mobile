import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class MyCongratulation extends StatelessWidget {
  const MyCongratulation({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouterNavigator.generateRoute,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: languageProvider.getCurrentLocale(),
      title: "PARAMEDIX",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background),
        useMaterial3: true,
      ),
      home: const MyCongratulationScreen(),
    );
  }
}

class MyCongratulationScreen extends StatefulWidget {
  const MyCongratulationScreen({super.key});

  @override
  State<MyCongratulationScreen> createState() => _MyCongratulationScreenState();
}

class _MyCongratulationScreenState extends State<MyCongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // scroll keyboard dismiss
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: rlgScreen(context) ? MediaQuery.of(context).size.height * 0.78 : MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        if (lgScreen(context)) SizedBox(height: 30.0),
                        if (xlScreen(context)) SizedBox(height: 20.0),
                        Image.asset(
                          "assets/images/logo/paramedix.png",
                          width: 100.0,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          AppLocalizations.of(context)!.app,
                          style: titleFontSizeLightTextStyle(24.0),
                        ),
                        if (rlgScreen(context)) SizedBox(height: 30.0),
                        if (lgScreen(context)) SizedBox(height: 50.0),
                        Text(
                          AppLocalizations.of(context)!.congratulation,
                          style: titleColorTextStyle(ThemeLightMode.title),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Text(
                          AppLocalizations.of(context)!.congratulationDescription,
                          style: subtitleFontSizeTextStyle(14.0),
                        ),
                        SizedBox(height: 50.0),
                        Icon(
                          Icons.verified_user,
                          color: AppTheme.primary,
                          size: 100.0,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      // Login Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: fillButton(
                                AppLocalizations.of(context)!.backToLogin,
                                context,
                                loginRoute,
                                AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
