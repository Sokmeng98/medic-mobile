import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/home/questionnaire_model.dart';
import 'package:paramedix/components/button/button.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/questionnaire_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyQuestion extends StatelessWidget {
  const MyQuestion({super.key});

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
        home: const MyQuestionScreen(),
      );
    });
  }
}

class MyQuestionScreen extends StatefulWidget {
  const MyQuestionScreen({super.key});

  @override
  State<MyQuestionScreen> createState() => _MyQuestionScreenState();
}

class _MyQuestionScreenState extends State<MyQuestionScreen> with TickerProviderStateMixin {
  int _questionNumber = 1;
  int? selectedOptionPrevious;
  bool _isLoading = true;
  Map<int, int> selectedOptions = {};
  Map<int, List> allOptions = {};
  List<int> questionOptions = [];
  late PageController _controller;
  var optionSelected;

  void _onBack() {
    Navigator.pushNamed(context, hivQuestionnaireRoute);
  }

  void _onResult() {
    Navigator.pushNamed(context, resultRoute);
  }

  void _questionOptions(mapValue) {
    // Get the value the match user used to select and option id
    if (mapValue != null) {
      questionOptions.forEach((element) {
        if (element == mapValue) {
          selectedOptionPrevious = element;
          print("Match option: $element");
        }
      });
    } else {
      print("Map value is null");
    }
  }

  void _onPreviousPage() {
    _controller.previousPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInExpo,
    );
    QuestionnaireItem? questionPrevious = Provider.of<QuestionnaireProvider>(context, listen: false).selectedQuestionnaireData;
    setState(() {
      _questionNumber--;
      questionOptions = [];
      int questionId = questionPrevious!.questionnaireQCM[_questionNumber - 1].id;
      // Get value from user selected store in map
      int? mapValue = selectedOptions[questionId];
      // Get option
      final allOption = questionPrevious.questionnaireQCM[_questionNumber - 1].qcmOptions;
      // Add option id to the list
      for (var option in allOption) {
        questionOptions.add(option.id);
      }
      print("questionOptions: $questionOptions");
      _questionOptions(mapValue);
    });
  }

  void _onNextPage() {
    _controller.nextPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInExpo,
    );
    QuestionnaireItem? questionNext = Provider.of<QuestionnaireProvider>(context, listen: false).selectedQuestionnaireData;
    setState(() {
      _questionNumber++;
      questionOptions = [];
      int questionId = questionNext!.questionnaireQCM[_questionNumber - 1].id;
      // Get value from user selected store in map
      int? mapValue = selectedOptions[questionId];
      // Get option
      final allOption = questionNext.questionnaireQCM[_questionNumber - 1].qcmOptions;
      // Add option id to the list
      for (var option in allOption) {
        questionOptions.add(option.id);
      }
      print("questionOptions: $questionOptions");
      _questionOptions(mapValue);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    QuestionnaireItem? questionnaireData = Provider.of<QuestionnaireProvider>(context).selectedQuestionnaireData;
    int questionnaireLength = questionnaireData!.questionnaireQCM.length;
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
                  onPressed: _questionNumber == 1 ? _onBack : _onPreviousPage,
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
        actions: <Widget>[
          Container(
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
              color: Colors.red,
              icon: Icon(Icons.logout),
              onPressed: _onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Progress Indicator
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _questionNumber / questionnaireLength,
                      borderRadius: BorderRadius.circular(10.0),
                      minHeight: 7.0,
                      color: AppTheme.primary,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                    Text(
                      "$_questionNumber / $questionnaireLength",
                      style: subtitleFontSizeTextStyle(14.0),
                    ),
                  ],
                ),
              ),
              //Question
              Expanded(
                child: Skeletonizer(
                  enabled: _isLoading,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: questionnaireLength,
                    itemBuilder: (context, index) {
                      final _question = questionnaireData.questionnaireQCM[index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _question.question,
                              style: isDarkMode ? titleDarkTextStyle(16.0, FontWeight.w500) : titleLightTextStyle(16.0, FontWeight.w500),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _question.qcmOptions
                                  .map(
                                    (option) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        OutlinedButton(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                option.name,
                                                style: isDarkMode ? titleDarkTextStyle(14.0, FontWeight.normal) : titleLightTextStyle(14.0, FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              optionSelected = option.id;
                                              selectedOptions[_question.id] = option.id;
                                              selectedOptionPrevious = 0;
                                              print("selectedOptions: $selectedOptions");
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: isDarkMode ? ThemeDarkMode.accent : ThemeLightMode.accent,
                                            padding: EdgeInsets.all(15.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            side: BorderSide(
                                              color: optionSelected == option.id || selectedOptionPrevious == option.id ? AppTheme.primary : AppTheme.secondary,
                                              width: 2.0,
                                            ),
                                            foregroundColor: AppTheme.primary,
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
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
                        _questionNumber < questionnaireLength ? AppLocalizations.of(context)!.next : AppLocalizations.of(context)!.result,
                        _questionNumber < questionnaireLength ? _onNextPage : _onResult,
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
