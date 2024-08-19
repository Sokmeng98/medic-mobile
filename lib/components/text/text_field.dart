import 'package:flutter/material.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';

TextFormField phoneTextFormField(Icon icon, String text, TextEditingController phoneNumberController, bool hasError) => TextFormField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        String patttern = r'^0[0-9]{8,11}$';
        RegExp regExp = new RegExp(patttern);
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );

TextFormField passwordTextFormField(Icon icon, String text, TextEditingController passwordController, bool obscureText, VoidCallback toggleObscureTextCallback, bool hasError) => TextFormField(
      controller: passwordController,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primary),
        suffixIcon: IconButton(
          splashColor: AppTheme.background,
          highlightColor: AppTheme.background,
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: AppTheme.primary),
          onPressed: toggleObscureTextCallback,
        ),
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        } else if (value.length < 4) {
          return 'At least 4 characters';
        } else if (value.length > 13) {
          return 'Maximum 13 characters';
        }
        return null;
      },
    );

TextFormField confirmPasswordTextFormField(Icon icon, String text, TextEditingController confirmPasswordController, TextEditingController passwordController, bool obscureText, VoidCallback toggleObscureTextCallback, bool hasError) => TextFormField(
      controller: confirmPasswordController,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primary),
        suffixIcon: IconButton(
          splashColor: AppTheme.background,
          highlightColor: AppTheme.background,
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: AppTheme.primary),
          onPressed: toggleObscureTextCallback,
        ),
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter confirm password';
        } else if (value != passwordController.text) {
          return 'Not match password';
        }
        return null;
      },
    );

TextFormField fullNameTextFormField(Icon icon, String text, TextEditingController fullNameController, bool hasError) => TextFormField(
      controller: fullNameController,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter username';
        } else if (value.length < 4) {
          return 'At least 4 characters';
        } else if (value.length > 13) {
          return 'Maximum 13 characters';
        }
        return null;
      },
    );

TextFormField dateOfBirthTextFormField(Icon icon, String text, TextEditingController dateOfBirthController, Function selectDate, bool hasError) => TextFormField(
      controller: dateOfBirthController,
      keyboardType: TextInputType.none,
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      onTap: () {
        selectDate();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date of birth';
        }
        return null;
      },
    );

TextFormField profileNameTextFormField(isDarkMode, Icon icon, String text, TextEditingController profileNameController) => TextFormField(
      controller: profileNameController,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter username';
        } else if (value.length < 4) {
          return 'At least 4 characters';
        } else if (value.length > 13) {
          return 'Maximum 13 characters';
        }
        return null;
      },
    );

TextFormField profileLocationTextFormField(isDarkMode, Icon icon, text, TextEditingController profileNameController) => TextFormField(
      enabled: false,
      controller: profileNameController,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: icon,
        label: text,
      ),
    );

TextFormField profilePhoneTextFormField(isDarkMode, Icon icon, String text, TextEditingController phoneNumberController, bool hasError) => TextFormField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      validator: (value) {
        String patttern = r'^0[0-9]{8,11}$';
        RegExp regExp = new RegExp(patttern);
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );

TextFormField prfileDateOfBirthTextFormField(isDarkMode, Icon icon, String text, TextEditingController dateOfBirthController, Function selectDate, bool hasError) => TextFormField(
      controller: dateOfBirthController,
      keyboardType: TextInputType.none,
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
        border: OutlineInputBorder(
          borderSide: hasError
              ? BorderSide(
                  color: Colors.red,
                  width: 1.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: icon,
        label: Text(
          text,
          style: subtitleFontSizeTextStyle(17.0),
        ),
      ),
      onTap: () {
        selectDate();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date of birth';
        }
        return null;
      },
    );
