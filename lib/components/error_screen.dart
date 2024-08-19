import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paramedix/components/text/text.dart';
import 'package:paramedix/components/theme.dart';
import 'package:paramedix/providers/language_provider.dart';
import 'package:provider/provider.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLanguageEnglish = Provider.of<LanguageProvider>(context, listen: false).isLanguageEnglish;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isLanguageEnglish ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.content_paste_search,
          color: AppTheme.primary,
          size: 150.0,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Text(
          AppLocalizations.of(context)!.noData,
          style: notFoundTextStyle(),
        ),
      ],
    );
  }
}

class NoDescriptionFound extends StatelessWidget {
  const NoDescriptionFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_search,
            color: AppTheme.primary,
            size: 150.0,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Text(
            AppLocalizations.of(context)!.noDescription,
            style: notFoundTextStyle(),
          ),
        ],
      ),
    );
  }
}

class NoFacilityFound extends StatelessWidget {
  const NoFacilityFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.home_work_outlined,
          color: AppTheme.primary,
          size: 150.0,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Text(
          AppLocalizations.of(context)!.noFacility,
          style: notFoundTextStyle(),
        ),
      ],
    );
  }
}

class NoUpcomingFound extends StatelessWidget {
  const NoUpcomingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppTheme.primary,
            size: 150.0,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Text(
            AppLocalizations.of(context)!.noUpcoming,
            style: notFoundTextStyle(),
          ),
        ],
      ),
    );
  }
}

class NoHistoryFound extends StatelessWidget {
  const NoHistoryFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu_book,
          color: AppTheme.primary,
          size: 150.0,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Text(
          AppLocalizations.of(context)!.noHistory,
          style: notFoundTextStyle(),
        ),
      ],
    );
  }
}

class NoNotificationFound extends StatelessWidget {
  const NoNotificationFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_on_outlined,
          color: AppTheme.primary,
          size: 150.0,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Text(
          AppLocalizations.of(context)!.noNotification,
          style: notFoundTextStyle(),
        ),
      ],
    );
  }
}

class NoFavoriteFound extends StatelessWidget {
  const NoFavoriteFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_special_outlined,
          color: AppTheme.primary,
          size: 150.0,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        Text(
          AppLocalizations.of(context)!.noFavorite,
          style: notFoundTextStyle(),
        ),
      ],
    );
  }
}
