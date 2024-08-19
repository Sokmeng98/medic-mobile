import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/api/models/profile/favorite_model.dart';
import 'package:paramedix/api/services/profile_service.dart';
import 'package:paramedix/components/bottomNavigationBar/emergency_screen.dart';
import 'package:paramedix/components/bottomNavigationBar/navigations_bar.dart';
import 'package:paramedix/components/error_screen.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/components/video_player.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:paramedix/providers/navigationBar_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

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
        home: MyFavoriteScreen(title: AppLocalizations.of(context)!.favorite),
      );
    });
  }
}

class MyFavoriteScreen extends StatefulWidget {
  const MyFavoriteScreen({super.key, required this.title});

  final String title;

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  bool loading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 5;
  List<FavoriteItem> favoriteData = [];
  YoutubePlayerController? controller;
  final scrollController = ScrollController();

  void _onBack() {
    Navigator.pushNamed(context, profileRoute);
  }

  void unFavorite(int educationId) {
    ProfileService().deleteFavorite(educationId).then((response) {
      if (response.statusCode == 204) {
        setState(() {
          favoriteData.removeWhere((element) => element.educationFavorite.id == educationId);
        });
      } else {
        print('Failed to delete favorite from API');
      }
    });
  }

  Future fetchData() async {
    if (loading) return;
    loading = true;
    ProfileService().getsFavoriteCount().then((dataCount) {
      ProfileService().getsFavorite(page, pageSize).then((data) {
        setState(() {
          if (favoriteData.length < dataCount) {
            page++;
            loading = false;
            favoriteData.addAll(data);
          }
          if (favoriteData.length == dataCount) {
            page--;
            hasMore = false;
          }
          if (favoriteData.isEmpty) {
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
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
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
                      AppLocalizations.of(context)!.allFavorites,
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
                          AppLocalizations.of(context)!.allPost,
                          style: subtitleColorTextStyle(AppTheme.subtitle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Body
              if (favoriteData.isEmpty)
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : NoFavoriteFound(),
                ),
              if (favoriteData.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    itemCount: favoriteData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < favoriteData.length) {
                        FavoriteItem favorite = favoriteData[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: _articleCard(favorite, isDarkMode),
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
      bottomNavigationBar: NavigationsBar(screen: 3),
      bottomSheet: showNavigationBar ? null : EmergencyScreen(),
    );
  }

  Widget _articleCard(FavoriteItem favorite, isDarkMode) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(articleRoute);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadow.withOpacity(0.3),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              child: favorite.educationFavorite.image == null && favorite.educationFavorite.video == ""
                  ? Image.asset(
                      "assets/images/no_image_available.png",
                      width: 400.0,
                      fit: BoxFit.fill,
                    )
                  : favorite.educationFavorite.image != null && favorite.educationFavorite.video == ""
                      ? Image.network(
                          "${favorite.educationFavorite.image}",
                          width: 400.0,
                          fit: BoxFit.fill,
                        )
                      : VideoPlayer(url: favorite.educationFavorite.video),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          favorite.educationFavorite.title,
                          overflow: TextOverflow.ellipsis,
                          style: isDarkMode ? titleFontSizeDarkTextStyle(18.0) : titleFontSizeLightTextStyle(18.0),
                        ),
                      ),
                      IconButton(
                        splashColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                        highlightColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                        onPressed: () {
                          unFavorite(favorite.educationFavorite.id);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: AppTheme.primary,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
