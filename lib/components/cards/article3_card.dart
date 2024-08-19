import 'package:flutter/material.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/components/video_player.dart';
import 'package:paramedix/providers/article_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class Article3Card extends StatelessWidget {
  const Article3Card({super.key, required this.article});

  final EducationItem article;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return GestureDetector(
        onTap: () {
          Provider.of<ArticleProvider>(context, listen: false).setArticleData(article);
          Navigator.of(context, rootNavigator: true).pushNamed(articleRoute);
        },
        child: Container(
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
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      overflow: TextOverflow.ellipsis,
                      style: isDarkMode ? titleFontSizeDarkTextStyle(18.0) : titleFontSizeLightTextStyle(18.0),
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
