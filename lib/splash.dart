import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';
import 'package:paramedix/api/services/profile_service.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/userProfile_provider.dart';
import 'package:paramedix/screens/authentication/login.dart';
import 'package:paramedix/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplash extends StatelessWidget {
  const MySplash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PARAMEDIX",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background),
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _SplashState();
}

class _SplashState extends State<MySplashScreen> {
  ProfileModel? user;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<http.Response> refreshToken() async {
    final String? refreshToken = await getRefreshToken();
    print("Resfresh token: $refreshToken");
    final response = http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.refreshtoken), body: {
      'refresh': refreshToken,
    });
    return response;
  }

  Future fetchData() async {
    ProfileService().getProfile().then((userData) {
      Provider.of<UserProfileProvider>(context, listen: false).setProfileData(userData);
      setState(() {
        user = userData;
      });
      user?.formatPhoneNumber();
      user?.formatDateOfBirth();
      user?.formatGender();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHome()));
    });
  }

  void autoLogin() async {
    final String? token = await getToken();
    print("Token: $token");

    if (token != null) {
      final middleware = Middleware();
      final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.profile, method: 'GET');
      if (response.statusCode == 200) {
        fetchData();
      } else {
        final response = await middleware.refreshToken();
        if (response.statusCode == 200) {
          fetchData();
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyLogin()));
        }
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyLogin()));
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    autoLogin();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Image.asset(
              "assets/images/logo/paramedix.png",
              width: 90.0,
              height: 90.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
