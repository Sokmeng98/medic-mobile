import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/user_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/cards/doctorInfo_card.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class MyDoctorInfo extends StatelessWidget {
  const MyDoctorInfo({super.key});

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
        home: MyDoctorInfoScreen(title: AppLocalizations.of(context)!.doctorInfo),
      );
    });
  }
}

class MyDoctorInfoScreen extends StatefulWidget {
  const MyDoctorInfoScreen({super.key, required this.title});

  final String title;

  @override
  State<MyDoctorInfoScreen> createState() => _MyDoctorInfoScreenState();
}

class _MyDoctorInfoScreenState extends State<MyDoctorInfoScreen> {
  bool loading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 10;
  int doctorInfoDataCount = 0;
  List<UserItem> doctorInfoData = [];
  final scrollController = ScrollController();

  void _onBack() {
    Navigator.pushNamed(context, meetOurDoctorRoute);
  }

  Future fetchData() async {
    if (loading) return;
    loading = true;
    HomeService().getsDoctorInfoCount().then((dataCount) {
      setState(() {
        doctorInfoDataCount = dataCount;
        HomeService().getsDoctorInfo(page, pageSize).then((data) {
          setState(() {
            if (doctorInfoData.length < doctorInfoDataCount) {
              page++;
              loading = false;
              doctorInfoData.addAll(data);
            }
            if (doctorInfoData.length == doctorInfoDataCount) {
              page--;
              hasMore = false;
            }
            if (doctorInfoData.isEmpty) {
              page--;
              loading = false;
              hasMore = false;
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Header
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.allDoctors,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.filter,
                          style: subtitleColorTextStyle(AppTheme.primary),
                        ),
                        Text(
                          AppLocalizations.of(context)!.defaults,
                          style: subtitleColorTextStyle(AppTheme.subtitle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Body
              if (doctorInfoData.isEmpty)
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : NoDataFound(),
                ),
              if (doctorInfoData.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    itemCount: doctorInfoData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < doctorInfoData.length) {
                        UserItem doctorInfo = doctorInfoData[index];

                        return DoctorInfoCard(specialist: doctorInfo);
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: hasMore ? CircularProgressIndicator(color: AppTheme.primary) : Text(AppLocalizations.of(context)!.noDataLoad),
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
