import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/services/auth_service.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/loading_indicator.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/text/text_field.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/screens/authentication/signup.dart';
import 'package:provider/provider.dart';

TextEditingController genderController = TextEditingController();
TextEditingController fullNameController = TextEditingController();
TextEditingController dateController = TextEditingController();
Gender? selectedGender;

class MyCreateAccount extends StatelessWidget {
  final UserData data;
  const MyCreateAccount({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    String phoneNumber = data.phoneNumber;
    String password = data.password;
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
      home: MyCreateAccountScreen(data: UserData(phoneNumber: phoneNumber, password: password)),
    );
  }
}

class MyCreateAccountScreen extends StatefulWidget {
  final UserData data;
  const MyCreateAccountScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<MyCreateAccountScreen> createState() => _MyCreateAccountScreenState();
}

class _MyCreateAccountScreenState extends State<MyCreateAccountScreen> {
  bool _hasError = false;

  DateTime selectedDate = new DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool isButtonPressed = false;

  Future selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2024),
    );
    if (picked != null) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          selectedDate = picked;
          String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
          dateController.text = formattedDate;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = widget.data.phoneNumber;
    String password = widget.data.password;
    // Remove leading '0' from the user's input
    phoneNumber = phoneNumber.replaceAll(RegExp('^0+'), '');
    // Add '+855' to the formatted phone number
    phoneNumber = '+855$phoneNumber';

    final List<DropdownMenuEntry<Gender>> genderEntries = <DropdownMenuEntry<Gender>>[];
    for (final Gender gender in Gender.values) {
      genderEntries.add(DropdownMenuEntry<Gender>(
        value: gender,
        label: gender.label,
      ));
    }

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
                                AppLocalizations.of(context)!.beAMember1,
                                style: titleColorTextStyle(ThemeLightMode.title),
                              ),
                              Text(
                                AppLocalizations.of(context)!.app,
                                style: titleColorTextStyle(AppTheme.primary),
                              ),
                              Text(
                                AppLocalizations.of(context)!.beAMember2,
                                style: titleColorTextStyle(ThemeLightMode.title),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Text(
                          AppLocalizations.of(context)!.createAccountDescription,
                          style: subtitleFontSizeTextStyle(14.0),
                        ),
                        SizedBox(height: _hasError ? 20.0 : 30.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
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
                                child: fullNameTextFormField(Icon(Icons.person_outline, color: AppTheme.primary), AppLocalizations.of(context)!.fullName, fullNameController, _hasError),
                              ),
                              SizedBox(height: _hasError ? 10.0 : 20.0),
                              // Date of Birth
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
                                child: dateOfBirthTextFormField(Icon(Icons.calendar_month_outlined, color: AppTheme.primary), AppLocalizations.of(context)!.dateOfBirth, dateController, selectDate, _hasError),
                              ),
                              SizedBox(height: _hasError ? 10.0 : 20.0),
                              // Gender
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: isButtonPressed && selectedGender == null
                                      ? [
                                          BoxShadow(
                                            color: AppTheme.shadow.withOpacity(0.1),
                                            blurRadius: 200.0,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: AppTheme.shadow.withOpacity(0.3),
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                ),
                                child: DropdownMenu<Gender>(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  leadingIcon: Icon(Icons.transgender, color: AppTheme.primary),
                                  trailingIcon: Icon(Icons.expand_more, color: isButtonPressed && selectedGender == null ? Colors.red.shade900 : AppTheme.primary, size: 30.0),
                                  selectedTrailingIcon: Icon(Icons.expand_less, color: isButtonPressed && selectedGender == null ? Colors.red.shade900 : AppTheme.primary, size: 30.0),
                                  controller: genderController,
                                  label: Text(AppLocalizations.of(context)!.gender, style: subtitleFontSizeTextStyle(17.0)),
                                  textStyle: titleLightTextStyle(15.0, FontWeight.normal),
                                  errorText: isButtonPressed && selectedGender == null ? "Please select Gender" : null,
                                  dropdownMenuEntries: genderEntries,
                                  menuStyle: MenuStyle(
                                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                    shape: MaterialStatePropertyAll<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  inputDecorationTheme: InputDecorationTheme(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: isButtonPressed && selectedGender == null
                                          ? BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            )
                                          : BorderSide.none,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  onSelected: (Gender? gender) {
                                    setState(() {
                                      selectedGender = gender;
                                    });
                                  },
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
                      // Back Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: outlineButton(
                                AppLocalizations.of(context)!.back,
                                context,
                                signupRoute,
                                AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (rmdScreen(context)) SizedBox(height: 10.0),
                      if (mdScreen(context)) SizedBox(height: 15.0),
                      // Create Account Button
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
                                  setState(() {
                                    isButtonPressed = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _hasError = false;
                                    });
                                    LoadingIndicator().show(context);
                                    AuthService().postUsers(phoneNumber.toString(), fullNameController.text.toString(), dateController.text.toString(), selectedGender!.value, password.toString()).then((response) {
                                      LoadingIndicator().dismiss();
                                      if (response.statusCode == 201) {
                                        Navigator.pushNamed(context, bottomNavigationRoute);
                                      } else if (response.statusCode == 400) {
                                        DialogHelper.showErrorDialog(
                                          context,
                                          AppLocalizations.of(context)!.phoneNumberExist,
                                          AppLocalizations.of(context)!.phoneNumberExistDescription,
                                        );
                                      } else {
                                        DialogHelper.showErrorDialog(
                                          context,
                                          AppLocalizations.of(context)!.failedLoadUserData,
                                          AppLocalizations.of(context)!.failedLoadUserDataDescription,
                                        );
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      _hasError = true;
                                    });
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.createAccount,
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

enum Gender {
  male('Male', 'male'),
  female('Female', 'female'),
  other('Other', 'other');

  const Gender(this.label, this.value);
  final String label;
  final String value;
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
              'Ok',
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
