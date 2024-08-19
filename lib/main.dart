import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/article_provider.dart';
import 'package:paramedix/providers/currentLocation_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/forgetPassword_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:paramedix/providers/nearbyFacility_provider.dart';
import 'package:paramedix/providers/notification_provider.dart';
import 'package:paramedix/providers/questionnaire_provider.dart';
import 'package:paramedix/providers/userProfile_provider.dart';
import 'package:paramedix/splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  OneSignal.initialize("b684263f-86e7-4938-ad22-9713445857bc");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CurrentLocationProvider()),
      ChangeNotifierProvider(create: (context) => NavigationBarProvider()),
      ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ChangeNotifierProvider(create: (context) => DarkModeProvider()),
      ChangeNotifierProvider(create: (context) => UserProfileProvider()),
      ChangeNotifierProvider(create: (context) => ForgetPasswordProvider()),
      ChangeNotifierProvider(create: (context) => ArticleProvider()),
      ChangeNotifierProvider(create: (context) => QuestionnaireProvider()),
      ChangeNotifierProvider(create: (context) => NearbyFacilityProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider())
    ],
    child: MyApp(navigatorKey),
  ));
}

void requestNotificationPermissionAndToken() async {
  // Request permission to receive notifications
  PermissionStatus permissionStatus = await Permission.notification.request();

  if (permissionStatus.isGranted) {
    // Permission granted, retrieve the device token
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device token: $token");
    // Use the token as needed (e.g., send it to your server)
  } else {
    // Permission not granted
    print("Permission not granted");
  }
}

class MyApp extends StatefulWidget {
  const MyApp(GlobalKey<NavigatorState> navigatorKey, {super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouterNavigator.generateRoute,
      initialRoute: "/",
      title: "PARAMEDIX",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background),
        useMaterial3: true,
      ),
      home: MySplash(),
    );
  }
}
