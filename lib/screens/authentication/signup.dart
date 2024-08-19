import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/text/text_field.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/screens/authentication/create_account.dart';
import 'package:provider/provider.dart';

class UserData {
  final String phoneNumber;
  final String password;

  UserData({
    required this.phoneNumber,
    required this.password,
  });
}

TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class MySignup extends StatelessWidget {
  const MySignup({super.key});

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
      home: const MySignupScreen(),
    );
  }
}

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _hasError = false;

  final _formKey = GlobalKey<FormState>();

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void toggleObscureConfirmText() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  void formatPhoneNumber() {
    String userInput = phoneNumberController.text;
    // Remove leading '0' from the user's input
    userInput = userInput.replaceAll(RegExp('^0+'), '');
    // Add '+855' to the formatted phone number
    String formattedPhoneNumber = '+855$userInput';
    // Update the TextFormField with the formatted phone number
    phoneNumberController.text = formattedPhoneNumber;
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
                    height: _hasError
                        ? rlgScreen(context)
                            ? MediaQuery.of(context).size.height * 0.75
                            : MediaQuery.of(context).size.height * 0.77
                        : rlgScreen(context)
                            ? MediaQuery.of(context).size.height * 0.73
                            : MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      children: [
                        if (lgScreen(context)) SizedBox(height: _hasError ? 20.0 : 30.0),
                        if (xlScreen(context)) SizedBox(height: _hasError ? 10.0 : 20.0),
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
                        if (rlgScreen(context)) SizedBox(height: _hasError ? 20.0 : 30.0),
                        if (lgScreen(context)) SizedBox(height: _hasError ? 40.0 : 50.0),
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
                        SizedBox(height: _hasError ? 20.0 : 30.0),
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
                                child: phoneTextFormField(Icon(Icons.phone_outlined, color: AppTheme.primary), AppLocalizations.of(context)!.phoneNumber, phoneNumberController, _hasError),
                              ),
                              SizedBox(height: _hasError ? 10.0 : 20.0),
                              // Password
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
                                child: passwordTextFormField(Icon(Icons.lock_outline, color: AppTheme.primary), AppLocalizations.of(context)!.password, passwordController, _obscureText, toggleObscureText, _hasError),
                              ),
                              SizedBox(height: _hasError ? 10.0 : 20.0),
                              // Confirm Password
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
                                child: confirmPasswordTextFormField(Icon(Icons.lock_outline, color: AppTheme.primary), AppLocalizations.of(context)!.confirmPassword, confirmPasswordController, passwordController, _obscureConfirmText, toggleObscureConfirmText, _hasError),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      // Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alreadyMember,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "Poppins",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, loginRoute);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.existingAccount,
                                    style: clickableTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: _hasError ? 5.0 : 10.0)),
                      // Sign Up Button
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    print(this._hasError);
                                    setState(() {
                                      _hasError = false;
                                    });
                                    UserData userData = UserData(
                                      phoneNumber: phoneNumberController.text,
                                      password: passwordController.text,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyCreateAccount(data: userData),
                                      ),
                                    );
                                  } else {
                                    print(this._hasError);
                                    setState(() {
                                      _hasError = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.signUp,
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
