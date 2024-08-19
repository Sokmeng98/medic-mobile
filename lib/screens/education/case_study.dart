import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/cards/article3_card.dart';
import 'package:paramedix/components/debounce.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyCaseStudy extends StatelessWidget {
  const MyCaseStudy({super.key});

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
        home: MyCaseStudyScreen(title: AppLocalizations.of(context)!.caseStory),
      );
    });
  }
}

class MyCaseStudyScreen extends StatefulWidget {
  const MyCaseStudyScreen({super.key, required this.title});

  final String title;

  @override
  State<MyCaseStudyScreen> createState() => _MyCaseStudyScreenState();
}

class _MyCaseStudyScreenState extends State<MyCaseStudyScreen> {
  bool loading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 5;
  List<EducationItem> caseStudyAllData = [];
  List<EducationItem> caseStudyData = [];
  List<EducationItem> caseStudyDataSearch = [];
  YoutubePlayerController? controller;
  final debouncer = Debouncer(milliseconds: 100);
  final textController = TextEditingController();
  final scrollController = ScrollController();

  void _onBack() {
    Navigator.pushNamed(context, educationRoute);
  }

  void _search(String enteredKeyword) {
    debouncer.run(() {
      if (enteredKeyword.isEmpty) {
        loading = false;
        hasMore = true;
        caseStudyData = caseStudyDataSearch;
      } else {
        hasMore = false;
        caseStudyData = caseStudyAllData.where((article) => (article.title.toLowerCase().startsWith(enteredKeyword.toLowerCase()))).toList();
        if (caseStudyData.isEmpty) {
          loading = false;
        } else {
          loading = true;
        }
      }
    });
  }

  Future fetchAllData() async {
    HomeService().getsEducationCount(3).then((dataCount) {
      HomeService().getsEducationSearch(3, dataCount).then((data) {
        setState(() {
          caseStudyAllData = data;
        });
      });
    });
  }

  Future fetchData() async {
    if (loading) return;
    loading = true;
    HomeService().getsEducationCount(3).then((dataCount) {
      HomeService().getsEducation(3, page, pageSize).then((data) {
        setState(() {
          if (caseStudyData.length < dataCount) {
            page++;
            loading = false;
            caseStudyDataSearch.addAll(data);
            caseStudyData = caseStudyDataSearch;
          }
          if (caseStudyData.length == dataCount) {
            page--;
            hasMore = false;
          }
          if (caseStudyData.isEmpty) {
            page--;
            loading = false;
            hasMore = false;
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllData();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetchAllData();
        fetchData();
      }
    });
  }

  @override
  void deactivate() {
    controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showNavigationBar = Provider.of<NavigationBarProvider>(context).showNavigationBar;
    bool isDarkMode = Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: rmdScreen(context) ? 150.0 : 170.0,
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
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: isDarkMode ? Colors.black : Colors.white,
                          hintText: AppLocalizations.of(context)!.search,
                          contentPadding: EdgeInsets.only(top: 13.0, bottom: 13.0, left: 20.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5, color: AppTheme.primary),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primary),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        onChanged: (value) => _search(value),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white,
                      icon: Icon(Icons.search_outlined),
                      iconSize: 28.0,
                      onPressed: () {
                        fetchAllData();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Divider(height: 1.0),
            ],
          ),
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
                      AppLocalizations.of(context)!.allCaseStudy,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.tag,
                          style: subtitleColorTextStyle(AppTheme.primary),
                        ),
                        Text(
                          AppLocalizations.of(context)!.all,
                          style: subtitleColorTextStyle(AppTheme.subtitle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Body
              if (caseStudyData.isEmpty)
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : NoDataFound(),
                ),
              if (caseStudyData.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    itemCount: caseStudyData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < caseStudyData.length) {
                        final EducationItem caseStudy = caseStudyData[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Article3Card(article: caseStudy),
                        );
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
      bottomNavigationBar: NavigationsBar(screen: 0),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }
}
