import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/common_widgets/editor_content_presenter.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import 'package:zefyrka/zefyrka.dart';
import '../../../../shared/common_widgets/custom_text.dart';
import '../../../../shared/common_widgets/secondary_icon_button.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/common_rich_text.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/common_widgets/subtitle.dart';
import '../../../../shared/constants/app.sizes.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../data/blog_service.dart';
import '../../domain/blog.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({
    Key? key,
    required this.article,
    required this.onEditArticle,
    required this.onDeleteArticle,
  }) : super(key: key);

  final Article article;
  final Function onEditArticle;
  final Function onDeleteArticle;

  Future<void> _handleOnDelete(
    Article article,
    BlogService blogService,
  ) async {
    await blogService.deleteArticle(article.id);
    onDeleteArticle.call(article.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BlogService blogService = ref.watch(blogServiceProvider);
    return Scaffold(
        appBar: const NavBar(),
        body: ResponsiveScrollableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: insetsAll4,
                child: ScreenTitle(text: article.title),
              ),
              gapH4,
              Padding(
                padding: insetsAll4,
                child: CommonRichText(
                  children: <TextSpanDetails>[
                    TextSpanDetails(
                      text: DateTimeFormat.toYYYYMMDD(article.createdAt),
                      fontStyle: FontStyle.italic,
                    ),
                    const TextSpanDetails(text: ' por '),
                    TextSpanDetails(
                      text: article.authorId,
                      fontStyle: FontStyle.normal,
                    )
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
              gapH16,
              EditorContentPresenter(
                controller: ZefyrController(
                  article.content.isNotEmpty
                      ? NotusDocument.fromJson(
                          jsonDecode(article.content),
                        )
                      : null,
                ),
              ),
              gapH16,
              Padding(
                padding: insetsAll4,
                child: Subtitle(
                  text: 'Categorías:'.hardcoded,
                  textAlign: TextAlign.center,
                ),
              ),
              gapH4,
              Padding(
                padding: insetsAll8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: article.categories.isEmpty
                      ? [
                          CustomText(
                            text: 'No hay categorias registradas'.hardcoded,
                            textAlign: TextAlign.center,
                          ),
                        ]
                      : article.categories
                          .map(
                            (location) => Padding(
                              padding: insetsV4,
                              child: CustomText(text: location),
                            ),
                          )
                          .toList(),
                ),
              ),
              gapH16,
              Padding(
                padding: insetsAll16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SecondaryIconButton(
                      onPressed: () {
                        onEditArticle.call(article);
                      },
                      icon: const Icon(Icons.edit),
                      text: 'Editar'.hardcoded,
                    ),
                    gapH16,
                    SecondaryIconButton(
                      onPressed: () async {
                        await _handleOnDelete(article, blogService);
                      },
                      icon: const Icon(Icons.delete),
                      text: 'Eliminar'.hardcoded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
