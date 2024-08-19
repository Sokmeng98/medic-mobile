import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/services/auth_service.dart';
import 'package:paramedix/components/loading_indicator.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/text/text_field.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

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
      home: const MyLoginScreen(),
    );
  }
}

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  bool _obscureText = true;
  bool _hasError = false;
  TextEditingController phoneNumberUserLogin = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final keyIsFirstLoaded = 'is_first_loaded';

  Future<void> saveTokenAndRefreshToken(String token, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('refreshToken', refreshToken);
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    phoneNumberUserLogin.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = phoneNumberUserLogin.text;
    // Remove leading '0' from the user's input
    phoneNumber = phoneNumber.replaceAll(RegExp('^0+'), '');
    // Add '+855' to the formatted phone number
    phoneNumber = '+855$phoneNumber';
    Future.delayed(Duration.zero, () => showChangeLanguageDialog(context));

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
                    height: rlgScreen(context) ? MediaQuery.of(context).size.height * 0.73 : MediaQuery.of(context).size.height * 0.75,
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.welcome,
                                style: titleColorTextStyle(ThemeLightMode.title),
                              ),
                              Text(
                                AppLocalizations.of(context)!.app,
                                style: titleColorTextStyle(AppTheme.primary),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Text(
                          AppLocalizations.of(context)!.accessAccount,
                          style: subtitleFontSizeTextStyle(14.0),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Phone Number
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: _hasError
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: AppTheme.shadow.withOpacity(0.3),
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                ),
                                child: phoneTextFormField(Icon(Icons.phone_outlined, color: AppTheme.primary), AppLocalizations.of(context)!.phoneNumber, phoneNumberUserLogin, _hasError),
                              ),
                              SizedBox(height: _hasError ? 10.0 : 20.0),
                              // Password
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(top: 10, right: 10.0, left: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: _hasError
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: AppTheme.shadow.withOpacity(0.3),
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                ),
                                child: passwordTextFormField(Icon(Icons.lock_outline, color: AppTheme.primary), AppLocalizations.of(context)!.password, password, _obscureText, toggleObscureText, _hasError),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        // Forgot Password
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, forgotPasswordRoute);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  textAlign: TextAlign.end,
                                  style: subtitleFontSizeTextStyle(14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      // Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.notMember,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "Poppins",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, signupRoute);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.createAnAccount,
                                    style: clickableTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      // Login Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: AppTheme.primary,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _hasError = false;
                                    });
                                    LoadingIndicator().show(context);
                                    final response = await AuthService().postLogin(
                                      phoneNumber,
                                      password.text.toString(),
                                    );
                                    LoadingIndicator().dismiss();
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> data = jsonDecode(response.body);
                                      final authToken = data['access_token'];
                                      final authRefreshToken = data['refresh_token'];
                                      saveTokenAndRefreshToken(authToken, authRefreshToken);
                                      Navigator.pushNamed(context, homeRoute);
                                    } else {
                                      DialogHelper.showErrorDialog(
                                        context,
                                        AppLocalizations.of(context)!.wrongCredentails,
                                        AppLocalizations.of(context)!.invalidPhoneNumberOrPassword,
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _hasError = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: buttonTextStyle(),
                                ),
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

  showChangeLanguageDialog(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final setIsLanguageEnglishProvider = Provider.of<LanguageProvider>(context, listen: false);
    bool? isFirstLoaded = pref.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          surfaceTintColor: Colors.grey,
          insetPadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(30),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  pref.setBool(keyIsFirstLoaded, false);
                  setIsLanguageEnglishProvider.setIsLanguageEnglish(false);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        "assets/images/khmer.png",
                        width: 110.0,
                        height: 70.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Text('ខ្មែរ', style: titleFontSizeLightTextStyle(20.0)),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  pref.setBool(keyIsFirstLoaded, false);
                  setIsLanguageEnglishProvider.setIsLanguageEnglish(true);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        "assets/images/english.png",
                        width: 110.0,
                        height: 70.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Text('English', style: titleFontSizeLightTextStyle(20.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class DialogHelper {
  static void showErrorDialog(BuildContext context, String title, String content) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          title,
          style: titleFontSizeLightTextStyle(20.0),
        ),
        content: Text(
          content,
          style: titleLightTextStyle(17.0, FontWeight.normal),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Ok",
              style: TextStyle(fontSize: 17.0, fontFamily: "Poppins"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
