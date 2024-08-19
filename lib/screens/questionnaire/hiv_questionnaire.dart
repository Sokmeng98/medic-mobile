import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/questionnaire_model.dart';
import 'package:paramedix/api/services/home_service.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/questionnaire_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyHivQuestionnaire extends StatelessWidget {
  const MyHivQuestionnaire({super.key});

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
        home: const MyHivQuestionnaireScreen(title: "HIV Questionniare"),
      );
    });
  }
}

class MyHivQuestionnaireScreen extends StatefulWidget {
  const MyHivQuestionnaireScreen({super.key, required this.title});

  final String title;

  @override
  State<MyHivQuestionnaireScreen> createState() => _MyHivQuestionnaireScreenState();
}

class _MyHivQuestionnaireScreenState extends State<MyHivQuestionnaireScreen> {
  bool _isLoading = true;
  List<QuestionnaireItem>? hivQuestionnaireData;

  void _onBack() {
    Navigator.pushNamed(context, questionnaireRoute);
  }

  void _onStart() {
    Provider.of<QuestionnaireProvider>(context, listen: false).setQuestionnaireData(hivQuestionnaireData![0]);
    Navigator.pushNamed(context, questionRoute);
  }

  @override
  void initState() {
    super.initState();
    HomeService().getsHivQuestionnaire(1).then((data) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _isLoading = false;
        });
      });
      setState(() {
        hivQuestionnaireData = data;
      });
    });
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
          AppLocalizations.of(context)!.hivQuestionnaire,
          style: isDarkMode
              ? titleFontSizeDarkTextStyle(22.0)
              : isDarkMode
                  ? titleFontSizeDarkTextStyle(22.0)
                  : titleFontSizeLightTextStyle(22.0),
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
              if (hivQuestionnaireData?.length == 0)
                Container(
                  padding: EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.hivQuestionnaire,
                            style: titleFontSizeLightTextStyle(20.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: questionTitleTextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (hivQuestionnaireData?.length == 0) NoDescriptionFound(),
              if (hivQuestionnaireData?.length != 0)
                Expanded(
                  child: Skeletonizer(
                    enabled: _isLoading,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
                      itemCount: hivQuestionnaireData?.length ?? 0,
                      itemBuilder: (context, index) {
                        QuestionnaireItem hivQuestionnaire = hivQuestionnaireData![index];

                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hivQuestionnaire.name,
                                style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                              ),
                              SizedBox(height: 25.0),
                              Text(
                                AppLocalizations.of(context)!.description,
                                style: questionTitleTextStyle(),
                              ),
                              Text(
                                hivQuestionnaire.description,
                                style: questionSubtitleTextStyle(),
                              ),
                              SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: hivQuestionnaire.questionnaireQA
                                    .map(
                                      (qa) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            qa.question,
                                            style: questionTitleTextStyle(),
                                          ),
                                          Text(
                                            qa.answer,
                                            style: questionSubtitleTextStyle(),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              //Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: filledButton(
                        AppLocalizations.of(context)!.startQuestionnaire,
                        hivQuestionnaireData?.length != 0 ? _onStart : null,
                        AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
