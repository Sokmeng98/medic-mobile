class ApiEndpoints {
  static const String baseUrl = "http://127.0.0.1:8000//api";

  //Authentication
  static const String login = "/login";
  static const String forgetPassword = "/forget_password";
  static const String verifiedOTP = "/verified_otp";
  static const String resetPassword = "/reset_password";
  static const String passwordReset = "/password_reset/";
  static const String passwordResetConfirm = "/password_reset/confirm/";
  static const String passwordResetValidate = "/password_reset/validate_token/";
  static const String refreshtoken = "/token/refresh";
  static const String changePassword = "/change_password";

  //Education
  static const String educationCategories = "/categories";
  static const String educations = "/educations";
  static const String tags = "/tags";

  //Questionnaire
  static const String questionnaireCategories = "/questionaire/categories";
  static const String questionnaires = "/questionaires";
  static const String options = "/options";

  //Counseling
  static const String counselingCategories = "/counseling/categories";

  //Appointment
  static const String appointmentCategories = "/appointment/categories";
  static const String appointments = "/appointment";
  static const String appointmentsUpcoming = "/appointments/upcoming";
  static const String appointmentsPrevious = "/appointments/previous";

  //Map
  static const String clinics = "/clinics";
  static const String locations = "/locations";
  static const String phoneSystems = "/phonesystems";
  static const String contacts = "/contacts";
  static const String services = "/services";

  // Notification
  static const String registerDevice = "/register_device";
  static const String notification = "/notification";
  static const String deleteRegisterDevice = "/register_device/delete_by_token";

  //Profile
  static const String users = "/users";
  static const String profile = "/profile";
  static const String favorites = "/favorites";
  static const String deletefavorite = "/favorites/education";
}
