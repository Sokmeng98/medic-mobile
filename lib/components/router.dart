import 'package:flutter/material.dart';

import 'package:paramedix/components/bottomNavigationBar/bottom_navigation.dart';
//Autentication
import 'package:paramedix/screens/authentication/login.dart';
import 'package:paramedix/screens/authentication/signup.dart';
import 'package:paramedix/screens/authentication/forgot_password.dart';
import 'package:paramedix/screens/authentication/verify_account.dart';
import 'package:paramedix/screens/authentication/reset_password.dart';
import 'package:paramedix/screens/authentication/congratulation.dart';
//Main Features
import 'package:paramedix/screens/home.dart';
import 'package:paramedix/screens/map.dart';
import 'package:paramedix/screens/notification.dart';
import 'package:paramedix/screens/profile.dart';
//Education
import 'package:paramedix/screens/education/education.dart';
import 'package:paramedix/screens/education/video_education.dart';
import 'package:paramedix/screens/education/news_article.dart';
import 'package:paramedix/screens/education/case_study.dart';
import 'package:paramedix/screens/education/life_story.dart';
import 'package:paramedix/screens/education/article.dart';
//Questionnaire
import 'package:paramedix/screens/questionnaire/questionnaire.dart';
import 'package:paramedix/screens/questionnaire/hiv_questionnaire.dart';
import 'package:paramedix/screens/questionnaire/question.dart';
import 'package:paramedix/screens/questionnaire/result.dart';
//Counseling
import 'package:paramedix/screens/counseling/counseling.dart';
import 'package:paramedix/screens/counseling/online_counseling.dart';
import 'package:paramedix/screens/counseling/healthcare_facility.dart';
import 'package:paramedix/screens/counseling/nearby_facility.dart';
//Appointment
import 'package:paramedix/screens/appointment/appointment.dart';
import 'package:paramedix/screens/appointment/meet_our_doctor.dart';
import 'package:paramedix/screens/appointment/hiv_testing.dart';
import 'package:paramedix/screens/appointment/appointment_history.dart';
import 'package:paramedix/screens/appointment/doctor_info.dart';
//Profile
import 'package:paramedix/screens/profile/edit_info.dart';
import 'package:paramedix/screens/profile/favorite.dart';
import 'package:paramedix/screens/profile/setting.dart';
import 'package:paramedix/screens/profile/terms_privacy.dart';

const String bottomNavigationRoute = "/bottom_navigation";
//Autentication
const String loginRoute = "/login";
const String signupRoute = "/signup";
const String createAccountRoute = "/create_account";
const String forgotPasswordRoute = "/forgot_password";
const String verifyAccountRoute = "/verify_account";
const String resetPasswordRoute = "/reset_password";
const String congratulationRoute = "/congratulation";
//Main Features
const String homeRoute = "/home";
const String mapRoute = "/map";
const String emergencyRoute = "/emergency";
const String notificationRoute = "/notification";
const String profileRoute = "/profile";
//Education
const String educationRoute = "$homeRoute/education";
const String videoEducationRoute = "$educationRoute/video_education";
const String newsArticleRoute = "$educationRoute/news_article";
const String caseStudyRoute = "$educationRoute/case_story";
const String lifeStoryRoute = "$educationRoute/life_story";
const String articleRoute = "$educationRoute/article";
//Questionnaire
const String questionnaireRoute = "$homeRoute/questionnaire";
const String hivQuestionnaireRoute = "$questionnaireRoute/hiv_questionnaire";
const String questionRoute = "$hivQuestionnaireRoute/question";
const String resultRoute = "$questionRoute/result";
//Counseling
const String counselingRoute = "$homeRoute/counseling";
const String onlineCounselingRoute = "$counselingRoute/online_counseling";
const String healthcareFacilityRoute = "$counselingRoute/healthcare_facility";
const String nearbyFacilityRoute = "$healthcareFacilityRoute/nearby_facility";
//Appointment
const String appointmentRoute = "$homeRoute/appointment";
const String meetOurDoctorRoute = "$appointmentRoute/meet_our_doctor";
const String hivTestingRoute = "$appointmentRoute/hiv_testing";
const String appointmentHistoryRoute = "$appointmentRoute/appointment_history";
const String doctorInfoRoute = "$meetOurDoctorRoute/doctor_info";
//Map
const String mapDetailRoute = "$mapRoute/map_detail";
//Profile
const String editInfoRoute = "$profileRoute/edit_info";
const String favoriteRoute = "$profileRoute/favorite";
const String settingRoute = "$profileRoute/setting";
const String termsPrivacyRoute = "$profileRoute/terms_privacy";

class RouterNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => MyLogin());
      case bottomNavigationRoute:
        return MaterialPageRoute(builder: (context) => MyBottomNavigation());
      //Autentication
      case loginRoute:
        return MaterialPageRoute(builder: (context) => MyLogin());
      case signupRoute:
        return MaterialPageRoute(builder: (context) => MySignup());
      case forgotPasswordRoute:
        return MaterialPageRoute(builder: (context) => MyForgotPassword());
      case verifyAccountRoute:
        return MaterialPageRoute(builder: (context) => MyVerifyAccount());
      case resetPasswordRoute:
        return MaterialPageRoute(builder: (context) => MyResetPassword());
      case congratulationRoute:
        return MaterialPageRoute(builder: (context) => MyCongratulation());
      //Main Features
      case homeRoute:
        return MaterialPageRoute(builder: (context) => MyHome());
      case mapRoute:
        return MaterialPageRoute(builder: (context) => MyMap());
      case notificationRoute:
        return MaterialPageRoute(builder: (context) => MyNotification());
      case profileRoute:
        return MaterialPageRoute(builder: (context) => MyProfile());
      //Education
      case educationRoute:
        return MaterialPageRoute(builder: (context) => MyEducation());
      case videoEducationRoute:
        return MaterialPageRoute(builder: (context) => MyVideoEducation());
      case newsArticleRoute:
        return MaterialPageRoute(builder: (context) => MyNewsArticle());
      case caseStudyRoute:
        return MaterialPageRoute(builder: (context) => MyCaseStudy());
      case lifeStoryRoute:
        return MaterialPageRoute(builder: (context) => MyLifeStory());
      case articleRoute:
        return MaterialPageRoute(builder: (context) => MyArticle());
      //Questionnaire
      case questionnaireRoute:
        return MaterialPageRoute(builder: (context) => MyQuestionnaire());
      case hivQuestionnaireRoute:
        return MaterialPageRoute(builder: (context) => MyHivQuestionnaire());
      case questionRoute:
        return MaterialPageRoute(builder: (context) => MyQuestion());
      case resultRoute:
        return MaterialPageRoute(builder: (context) => MyResult());
      //Counseling
      case counselingRoute:
        return MaterialPageRoute(builder: (context) => MyCounseling());
      case onlineCounselingRoute:
        return MaterialPageRoute(builder: (context) => MyOnlineCounseling());
      case healthcareFacilityRoute:
        return MaterialPageRoute(builder: (context) => MyHealthcareFacility());
      case nearbyFacilityRoute:
        return MaterialPageRoute(builder: (context) => MyNearbyFacility());
      //Appointment
      case appointmentRoute:
        return MaterialPageRoute(builder: (context) => MyAppointment());
      case meetOurDoctorRoute:
        return MaterialPageRoute(builder: (context) => MyMeetOurDoctor());
      case hivTestingRoute:
        return MaterialPageRoute(builder: (context) => MyHivTesting());
      case appointmentHistoryRoute:
        return MaterialPageRoute(builder: (context) => MyAppointmentHistory());
      case doctorInfoRoute:
        return MaterialPageRoute(builder: (context) => MyDoctorInfo());
      //Profile
      case editInfoRoute:
        return MaterialPageRoute(builder: (context) => MyEditInfo());
      case favoriteRoute:
        return MaterialPageRoute(builder: (context) => MyFavorite());
      case settingRoute:
        return MaterialPageRoute(builder: (context) => MySetting());
      case termsPrivacyRoute:
        return MaterialPageRoute(builder: (context) => MyTermsPrivacy());

      default:
        return MaterialPageRoute(builder: (context) => MyLogin());
    }
  }
}
