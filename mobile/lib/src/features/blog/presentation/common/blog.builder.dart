import 'package:flutter/material.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/common_widgets/responsive_center.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/constants/breakpoints.dart';
import '../../domain/blog.dart';

class BlogBuilder extends StatelessWidget {
  const BlogBuilder({
    Key? key,
    required this.articles,
    required this.articleBuilder,
  }) : super(key: key);

  final List<Article> articles;
  final Widget Function(BuildContext, Article, int) articleBuilder;

  @override
  Widget build(BuildContext context) {
    String screenTitle = 'Blog'.hardcoded;
    if (articles.isEmpty) {
      return ResponsiveCenter(
        child: Column(
          children: [
            gapH20,
            ScreenTitle(text: screenTitle),
            gapH16,
            Text('Ningún artículo del blog ha sido creado hasta el momento.'.hardcoded),
          ],
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: insetsH4,
        child: Column(
          children: [
            ScreenTitle(text: screenTitle),
            gapH16,
            Expanded(
              child: ListView.builder(
                padding: insetsV4,
                itemBuilder: (context, index) {
                  final item = articles[index];
                  return articleBuilder(context, item, index);
                },
                itemCount: articles.length,
              ),
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        gapH20,
        ScreenTitle(text: screenTitle),
        gapH16,
        Expanded(
          child: ListView.builder(
            padding: insetsAll4,
            itemBuilder: (context, index) {
              final item = articles[index];
              return articleBuilder(context, item, index);
            },
            itemCount: articles.length,
          ),
        ),
      ],
    );
  }
}
