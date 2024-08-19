import 'package:flutter/material.dart';
import 'package:paramedix/api/models/home/category_model.dart';
import 'package:paramedix/components/media_query.dart';
import 'package:paramedix/components/router.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/darkMode_provider.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, darkModeProvider, _) {
      bool isDarkMode = darkModeProvider.isDarkMode;

      return GestureDetector(
        onTap: () {
          //Education
          if (category.name == "Video Education") {
            Navigator.pushNamed(context, videoEducationRoute);
          }
          if (category.name == "News Article") {
            Navigator.pushNamed(context, newsArticleRoute);
          }
          if (category.name == "Case Study") {
            Navigator.pushNamed(context, caseStudyRoute);
          }
          if (category.name == "Life Story") {
            Navigator.pushNamed(context, lifeStoryRoute);
          }
          //Questionniare
          if (category.name == "HIV Questionnaire") {
            Navigator.pushNamed(context, hivQuestionnaireRoute);
          }
          if (category.name == "Contraception Method") {
            Navigator.pushNamed(context, questionnaireRoute);
          }
          //Counseling
          if (category.name == "Online Counseling") {
            Navigator.pushNamed(context, onlineCounselingRoute);
          }
          if (category.name == "Healthcare Facility") {
            Navigator.pushNamed(context, healthcareFacilityRoute);
          }
          //Appointment
          if (category.name == "Meet Our Doctor") {
            Navigator.pushNamed(context, meetOurDoctorRoute);
          }
          if (category.name == "HIV Testing") {
            Navigator.pushNamed(context, hivTestingRoute);
          }
          if (category.name == "Appointment History") {
            Navigator.pushNamed(context, appointmentHistoryRoute);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadow.withOpacity(0.3),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: isDarkMode ? titleFontSizeDarkTextStyle(19.0) : titleFontSizeLightTextStyle(19.0),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text(
                        category.description,
                        style: subtitleFontSizeTextStyle(13.0),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
                    child: Image.network(
                      category.image,
                      height: rmdScreen(context)
                          ? 60.0
                          : rxlScreen(context)
                              ? 70.0
                              : 80.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
