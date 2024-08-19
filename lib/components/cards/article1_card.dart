import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/components/video_player.dart';
import 'package:paramedix/providers/article_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class Article1Card extends StatelessWidget {
  const Article1Card({super.key, required this.article});

  final EducationItem article;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;
      var inputFormat = DateTime.parse(article.updatedAt);
      String formatDate = DateFormat('dd MMM yyyy').format(inputFormat);

      return GestureDetector(
        onTap: () {
          Provider.of<ArticleProvider>(context, listen: false).setArticleData(article);
          Navigator.of(context, rootNavigator: true).pushNamed(articleRoute);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 20.0),
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
                child: article.image == null && article.video == ""
                    ? Image.asset(
                        "assets/images/no_image_available.png",
                        width: 400.0,
                        fit: BoxFit.fill,
                      )
                    : article.image != null && article.video == ""
                        ? Image.network(
                            "${article.image}",
                            width: 400.0,
                            fit: BoxFit.fill,
                          )
                        : VideoPlayer(url: article.video),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    Text(
                      article.title,
                      overflow: TextOverflow.ellipsis,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(18.0) : titleFontSizeLightTextStyle(18.0),
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
                                  article.tagInfo.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: article.view <= 1000 ? 1 : 2,
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
                                child: Text("${article.view}"),
                              ),
                            ],
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
    });
  }
}
