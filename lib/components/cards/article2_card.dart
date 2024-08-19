import 'package:flutter/material.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/api/services/profile_service.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/components/video_player.dart';
import 'package:paramedix/providers/article_provider.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class Article2Card extends StatefulWidget {
  const Article2Card({super.key, required this.article});

  final EducationItem article;

  @override
  _Article2CardState createState() => _Article2CardState();
}

class _Article2CardState extends State<Article2Card> {
  void addToFavorites(int educationId) {
    ProfileService().postFavorite(educationId).then((response) {
      if (response.statusCode != 201) {
        print("Failed to add favorite from API");
      }
    });
  }

  void removeFromFavorites(int educationId) {
    ProfileService().deleteFavorite(educationId).then((response) {
      if (response.statusCode != 204) {
        print("Failed to delete favorite from API");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return GestureDetector(
        onTap: () {
          Provider.of<ArticleProvider>(context, listen: false).setArticleData(widget.article);
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
                child: widget.article.image == null && widget.article.video == ""
                    ? Image.asset(
                        "assets/images/no_image_available.png",
                        width: 400.0,
                        fit: BoxFit.fill,
                      )
                    : widget.article.image != null && widget.article.video == ""
                        ? Image.network(
                            "${widget.article.image}",
                            width: 400.0,
                            fit: BoxFit.fill,
                          )
                        : VideoPlayer(url: widget.article.video),
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
                            widget.article.title,
                            overflow: TextOverflow.ellipsis,
                            style: isDarkMode ? titleFontSizeDarkTextStyle(18.0) : titleFontSizeLightTextStyle(18.0),
                          ),
                        ),
                        IconButton(
                          splashColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                          highlightColor: isDarkMode ? ThemeDarkMode.neutral : ThemeLightMode.neutral,
                          onPressed: () {
                            setState(() {
                              if (widget.article.isFavorite) {
                                removeFromFavorites(widget.article.id);
                              } else {
                                addToFavorites(widget.article.id);
                              }
                              widget.article.isFavorite = !widget.article.isFavorite;
                            });
                          },
                          icon: Icon(
                            widget.article.isFavorite ? Icons.favorite : Icons.favorite_outline,
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
    });
  }
}
