import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/services/auth_service.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/text/text_field.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/forgetPassword_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class MyResetPassword extends StatelessWidget {
  const MyResetPassword({super.key});

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
      home: const MyResetPasswordScreen(),
    );
  }
}

class MyResetPasswordScreen extends StatefulWidget {
  const MyResetPasswordScreen({super.key});

  @override
  State<MyResetPasswordScreen> createState() => _MyResetPasswordScreenState();
}

class _MyResetPasswordScreenState extends State<MyResetPasswordScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _hasError = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                          AppLocalizations.of(context)!.app,
                          style: titleFontSizeLightTextStyle(24.0),
                        ),
                        if (rlgScreen(context)) SizedBox(height: 30.0),
                        if (lgScreen(context)) SizedBox(height: 50.0),
                        Text(
                          AppLocalizations.of(context)!.resetPassword,
                          style: titleColorTextStyle(ThemeLightMode.title),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Text(
                          AppLocalizations.of(context)!.resetPasswordDescription,
                          style: subtitleFontSizeTextStyle(14.0),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                              SizedBox(height: 20.0),
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
                        )
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
                                verifyAccountRoute,
                                AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (rmdScreen(context)) SizedBox(height: 10.0),
                      if (mdScreen(context)) SizedBox(height: 15.0),
                      // Reset Password Button
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
                                    String? _phoneNumber = Provider.of<ForgetPasswordProvider>(context, listen: false).phoneNumberProviderData;
                                    AuthService().postResetPassword(_phoneNumber!, passwordController.text).then((response) => {
                                          if (response.statusCode == 200)
                                            {
                                              Navigator.pushNamed(context, congratulationRoute)
                                            }
                                          else
                                            {
                                              print(response.body)
                                            }
                                        });
                                  } else {
                                    setState(() {
                                      _hasError = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.resetPassword,
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
