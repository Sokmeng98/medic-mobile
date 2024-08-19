import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/services/auth_service.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/loading_indicator.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/forgetPassword_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/screens/authentication/create_account.dart';
import 'package:provider/provider.dart';

class MyVerifyAccount extends StatelessWidget {
  const MyVerifyAccount({super.key});

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
      home: const MyVerifyAccountScreen(),
    );
  }
}

class MyVerifyAccountScreen extends StatefulWidget {
  const MyVerifyAccountScreen({super.key});

  @override
  State<MyVerifyAccountScreen> createState() => _MyVerifyAccountScreenState();
}

class _MyVerifyAccountScreenState extends State<MyVerifyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  String errorMessage = '';
  String? _phoneNumber;

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phoneNumber = Provider.of<ForgetPasswordProvider>(context, listen: false).phoneNumberProviderData;
    _configureFocusNodes();
  }

  void _configureFocusNodes() {
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].addListener(() {
        if (otpControllers[i].text.length == 1 && i < otpControllers.length - 1) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
      });
    }
  }

  bool isOTPValid(List<TextEditingController> controllers) {
    final otp = controllers.map((controller) => controller.text).join();
    return otp.length == 4 && RegExp(r'^[0-9]*$').hasMatch(otp);
  }

  void submitOTP() {
    if (isOTPValid(otpControllers)) {
      String otp = otpControllers.map((controller) => controller.text).join();
      LoadingIndicator().show(context);
      AuthService().postVerifiedOTP(_phoneNumber!, otp).then((response) {
        LoadingIndicator().dismiss();
        if (response.statusCode == 200) {
          Navigator.pushNamed(context, resetPasswordRoute);
        } else {
          setState(() {
            errorMessage = '';
          });
          DialogHelper.showErrorDialog(context, "Wrong OTP", "The OTP you entered is incorrect. Please try again.");
        }
      });
    } else {
      setState(() {
        errorMessage = "Invalid OTP. Please enter a 4-digit number.";
      });
    }
  }

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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.72,
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
                          "PARAMEDIX",
                          style: titleFontSizeLightTextStyle(24.0),
                        ),
                        if (rlgScreen(context)) SizedBox(height: 30.0),
                        if (lgScreen(context)) SizedBox(height: 50.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.verifyAccount1,
                                style: titleColorTextStyle(ThemeLightMode.title),
                              ),
                              Text(
                                AppLocalizations.of(context)!.app,
                                style: titleColorTextStyle(AppTheme.primary),
                              ),
                              Text(
                                AppLocalizations.of(context)!.verifyAccount2,
                                style: titleColorTextStyle(ThemeLightMode.title),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Text(
                          AppLocalizations.of(context)!.verifyAccountDescription,
                          style: subtitleFontSizeTextStyle(14.0),
                        ),
                        SizedBox(height: 30.0),
                        // Input Code
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    4,
                                    (index) => SizedBox(
                                      width: 55,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.shadow.withOpacity(0.3),
                                              blurRadius: 10.0,
                                              spreadRadius: -2.0,
                                              offset: Offset(0.0, -2.0),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: otpControllers[index],
                                          decoration: InputDecoration(
                                            counter: Offstage(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          showCursor: false,
                                          readOnly: false,
                                          autofocus: true,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          keyboardType: TextInputType.number,
                                          focusNode: focusNodes[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                // Text("The code is error", style: TextStyle(color: Colors.red)),
                                if (errorMessage.isNotEmpty)
                                  Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        //Resend Code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.receiveCode,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Poppins",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                LoadingIndicator().show(context);
                                AuthService().postForgetPassword(_phoneNumber!).then((response) {
                                  LoadingIndicator().dismiss();
                                  if (response.statusCode == 200) {
                                    Navigator.pushNamed(context, verifyAccountRoute);
                                  } else {
                                    print(response.body);
                                  }
                                });
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.resendCode,
                                      style: clickableTextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      // Back Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: outlineButton(
                                AppLocalizations.of(context)!.back,
                                context,
                                forgotPasswordRoute,
                                AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (rmdScreen(context)) SizedBox(height: 10.0),
                      if (mdScreen(context)) SizedBox(height: 15.0),
                      // Continue Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              // child: fillButton("Continue", context, resetPasswordRoute, AppTheme.primary),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: AppTheme.primary,
                                ),
                                onPressed: () async {
                                  submitOTP();
                                  // Navigator.pushNamed(context, resetPasswordRoute);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.continued,
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
}
