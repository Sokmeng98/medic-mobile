import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/article_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyArticle extends StatelessWidget {
  const MyArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouterNavigator.generateRoute,
        title: "PARAMEDIX",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.background, brightness: isDarkMode ? Brightness.dark : Brightness.light),
          useMaterial3: true,
        ),
        home: const MyArticleScreen(),
      );
    });
  }
}

class MyArticleScreen extends StatefulWidget {
  const MyArticleScreen({super.key});

  @override
  State<MyArticleScreen> createState() => _MyArticleScreenState();
}

class _MyArticleScreenState extends State<MyArticleScreen> {
  bool _isLoading = true;
  YoutubePlayerController? controller;

  void _onBack() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    EducationItem? articleData = Provider.of<ArticleProvider>(context).selectedArticleData;
    var inputFormat = DateTime.parse("${articleData?.updatedAt}");
    String formatDate = DateFormat('dd MMM yyyy').format(inputFormat);
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
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Skeletonizer(
            enabled: _isLoading,
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                if (articleData?.image == null && articleData?.video == "")
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/no_image_available.png",
                      width: 350.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ClipRRect(
                  child: articleData?.image == null && articleData?.video != ""
                      ? _videoPlayer(articleData?.video)
                      : Image.network(
                          "${articleData?.image}",
                          width: 350.0,
                          fit: BoxFit.fill,
                        ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Text(
                  "${articleData?.title}",
                  overflow: TextOverflow.ellipsis,
                  style: isDarkMode ? titleFontSizeDarkTextStyle(20.0) : titleFontSizeLightTextStyle(20.0),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                          Expanded(
                            child: Text("$formatDate"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sell_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                          Expanded(
                            child: Text(
                              "${articleData?.tagInfo.name}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: articleData!.view <= 10000 ? 1 : 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            color: AppTheme.primary,
                            size: 20.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
                          Expanded(
                            child: Text("${articleData.view}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 30, color: AppTheme.primary),
                Text(
                  "${articleData.description}",
                  style: isDarkMode ? titleDarkTextStyle(17.0, FontWeight.normal) : titleLightTextStyle(17.0, FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoPlayer(url) {
    return (YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url) ?? '',
        flags: YoutubePlayerFlags(autoPlay: false, loop: true),
      ),
      bottomActions: [
        CurrentPosition(),
        ProgressBar(isExpanded: true),
        RemainingDuration(),
        PlaybackSpeedButton(),
      ],
    ));
  }
}
