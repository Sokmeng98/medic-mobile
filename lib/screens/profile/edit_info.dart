import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';
import 'package:paramedix/api/services/profile_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/current_location.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/text/text_field.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:paramedix/providers/userProfile_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyEditInfo extends StatelessWidget {
  const MyEditInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      final languageProvider = Provider.of<LanguageProvider>(context);

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouterNavigator.generateRoute,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: languageProvider.getCurrentLocale(),
        title: "PARAMEDIX",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background, brightness: isDarkMode ? Brightness.dark : Brightness.light),
          useMaterial3: true,
        ),
        home: MyEditInfoScreen(title: AppLocalizations.of(context)!.editInfo),
      );
    });
  }
}

class MyEditInfoScreen extends StatefulWidget {
  const MyEditInfoScreen({super.key, required this.title});

  final String title;

  @override
  State<MyEditInfoScreen> createState() => _MyEditInfoScreenState();
}

class _MyEditInfoScreenState extends State<MyEditInfoScreen> {
  bool _isLoading = true;
  bool isSelected = false;
  bool _hasError = false;
  int? id;
  ProfileModel? user;
  DateTime selectedDate = new DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileLocationController = TextEditingController();
  final TextEditingController profilePhoneNumberController = TextEditingController();
  final TextEditingController profileDateController = TextEditingController();

  void _onBack() {
    Navigator.pushNamed(context, profileRoute);
  }

  String? _image;
  File? imageUpload;
  String? imageUploadString;

  Future<void> pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imageUpload = File(image.path);
          imageUploadString = image.path;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'^0+'), '');
    phoneNumber = '+855$phoneNumber';
    return phoneNumber;
  }

  String formatDate(String? date) {
    if (date != null) {
      final parsedDate = DateFormat('d MMM y').parse(date);
      final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      return formattedDate;
    } else {
      print("Cannot formdat date");
      return '';
    }
  }

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
          profileDateController.text = formattedDate;
        });
      });
    }
  }

  // test for toggle button
  List<bool> selectedGenders = [
    false,
    false,
    false
  ]; // Initially, no gender is selected
  Function(String) onGenderSelected = (gender) {}; // Callback function to capture the selected gender
  String selectedGender = '';

  void selectGender(int index) {
    setState(() {
      for (int i = 0; i < selectedGenders.length; i++) {
        selectedGenders[i] = i == index; // Select the gender at the specified index
      }
    });
    // Notify the parent widget of the selected gender
    if (selectedGenders[0]) {
      selectedGender = "female";
    } else if (selectedGenders[1]) {
      selectedGender = "male";
    } else if (selectedGenders[2]) {
      selectedGender = "other";
    }
  }

  @override
  void initState() {
    super.initState();
    CurrentLocation(fullLocation: true);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
    final _userProfileProviderData = Provider.of<UserProfileProvider>(context, listen: false).profileProviderData;
    id = _userProfileProviderData?.id;
    profileNameController.text = _userProfileProviderData!.fullName.toString();
    profileLocationController.text = _userProfileProviderData.map?.toString() ?? '';
    profilePhoneNumberController.text = _userProfileProviderData.phoneNumber.toString().replaceAll(' ', '');
    profileDateController.text = formatDate(_userProfileProviderData.dateOfBirth);
    _image = _userProfileProviderData.profile;

    // Determine the initial state based on the data obtained from a source
    if (_userProfileProviderData.gender == "Female") {
      selectedGenders[0] = true;
      selectedGender = 'female';
    } else if (_userProfileProviderData.gender == "Male") {
      selectedGenders[1] = true;
      selectedGender = 'male';
    } else if (_userProfileProviderData.gender == "Other") {
      selectedGenders[2] = true;
      selectedGender = 'other';
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationBar = Provider.of<NavigationBarProvider>(context).showNavigationBar;
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: rlgScreen(context) ? 90.0 : 100.0,
        scrolledUnderElevation: 0.0,
        leading: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 13.0),
                decoration: BoxDecoration(
                  boxShadow: isDarkMode
                      ? [
                          BoxShadow(
                            color: AppTheme.shadow.withOpacity(0.3),
                            blurRadius: 20.0,
                            spreadRadius: -5.0,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppTheme.shadow.withOpacity(0.3),
                            blurRadius: 20.0,
                          ),
                        ],
                ),
                child: IconButton(
                  padding: EdgeInsets.all(10.0),
                  color: AppTheme.primary,
                  icon: Icon(Icons.arrow_back),
                  onPressed: _onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          widget.title,
          style: isDarkMode ? titleFontSizeDarkTextStyle(22.0) : titleFontSizeLightTextStyle(22.0),
        ),
        titleSpacing: 8.0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0),
        ),
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(top: 50.0),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadow.withOpacity(0.3),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 25.0)),
                              profileNameTextFormField(isDarkMode, Icon(Icons.person_outline, color: AppTheme.primary), AppLocalizations.of(context)!.fullName, profileNameController),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              profileLocationTextFormField(isDarkMode, Icon(Icons.pin_drop_outlined, color: AppTheme.primary), CurrentLocation(fullLocation: true), profileLocationController),
                              Padding(padding: EdgeInsets.only(top: 3.0)),
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)!.userCurrentLocation,
                                  style: subtitleFontSizeTextStyle(13.0),
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              profilePhoneTextFormField(isDarkMode, Icon(Icons.phone_outlined, color: AppTheme.primary), AppLocalizations.of(context)!.phoneNumber, profilePhoneNumberController, _hasError),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              prfileDateOfBirthTextFormField(isDarkMode, Icon(Icons.calendar_month_outlined, color: AppTheme.primary), AppLocalizations.of(context)!.dateOfBirth, profileDateController, selectDate, _hasError),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 15.0,
                                      runSpacing: 5.0,
                                      children: [
                                        ToggleButton(
                                          label: AppLocalizations.of(context)!.female,
                                          icon: Icons.female_outlined,
                                          isSelected: selectedGenders[0],
                                          onPressed: () => selectGender(0),
                                        ),
                                        ToggleButton(
                                          label: AppLocalizations.of(context)!.male,
                                          icon: Icons.male_outlined,
                                          isSelected: selectedGenders[1],
                                          onPressed: () => selectGender(1),
                                        ),
                                        ToggleButton(
                                          label: AppLocalizations.of(context)!.other,
                                          icon: Icons.transgender,
                                          isSelected: selectedGenders[2],
                                          onPressed: () => selectGender(2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _hasError = false;
                                          });
                                          String formattedPhoneNumber = formatPhoneNumber(profilePhoneNumberController.text);
                                          Object updateProfileData = {
                                            'phone_number': formattedPhoneNumber,
                                            'full_name': profileNameController.text,
                                            'date_of_birth': profileDateController.text,
                                            'gender': selectedGender,
                                            // 'map': profileLocationController.text
                                          };
                                          ProfileService().updateUsers(id!, updateProfileData, 'profile', imageUploadString).then((response) async {
                                            if (response.statusCode == 200) {
                                              final userData = await ProfileService().getProfile();
                                              userData.formatPhoneNumber();
                                              userData.formatDateOfBirth();
                                              userData.formatGender();
                                              Provider.of<UserProfileProvider>(context, listen: false).setProfileData(userData);
                                              // Navigate after updating data
                                              Navigator.pushNamed(context, profileRoute);
                                            } else {
                                              print(response.body);
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            _hasError = true;
                                          });
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 2.0, color: AppTheme.primary),
                                          padding: EdgeInsets.symmetric(vertical: 15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          )),
                                      child: Text(AppLocalizations.of(context)!.saveInfo, style: TextStyle(color: AppTheme.primary)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: imageUpload != null
                              ? Image.file(
                                  imageUpload!,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                )
                              : _image != null
                                  ? Image.network(
                                      _image!,
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.center,
                                    )
                                  : Image.asset(
                                      "assets/images/profile/profile.png",
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.fill,
                                    ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
                          ),
                          child: Icon(
                            Icons.photo_camera_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationsBar(screen: 3),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  ToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          side: BorderSide(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2.0,
          ),
          foregroundColor: AppTheme.primary,
          backgroundColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              label,
              style: isDarkMode ? titleDarkTextStyle(15.0, FontWeight.normal) : titleLightTextStyle(15.0, FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
