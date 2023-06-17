import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import '../../../../shared/common_widgets/list_item_container.dart';
import '../../../../shared/common_widgets/navbar.dart';
import '../../../../shared/common_widgets/popup_menu_item_text.dart';
import '../../../../shared/time/datetime.format.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/common_widgets/async_value.dart';
import '../../data/blog_service.dart';
import '../../domain/blog.dart';
import '../common/blog.builder.dart';

enum ArticleAction { query, edit, delete }

class BlogScreen extends ConsumerWidget {
  const BlogScreen({
    Key? key,
    required this.onArticleSelected,
    required this.onEditArticle,
    required this.onDeleteArticle,
    required this.onCreateNewArticle,
  }) : super(key: key);

  final Function(Article) onArticleSelected;
  final Function(Article) onEditArticle;
  final Function(String) onDeleteArticle;
  final Function() onCreateNewArticle;

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
    AsyncValue<List<Article>> articlesAsync = ref.watch(
      getAllArticlesProvider,
    );
    return AsyncValueWidget<List<Article>>(
      value: articlesAsync,
      data: (articles) {
        return Scaffold(
          appBar: const NavBar(),
          body: BlogBuilder(
            articles: articles,
            articleBuilder: (_, article, index) => Padding(
              padding: insetsH12,
              child: ListItemContainer(
                child: SizedBox(
                  width: double.infinity,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl:
                          'https://www.shutterstock.com/image-vector/cute-flutter-butterflies-tattoo-art-600w-2240487227.jpg',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    title: Text(
                      article.title,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                DateTimeFormat.toYYYYMMDD(article.createdAt),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                article.authorId,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<ArticleAction>(
                      onSelected: (ArticleAction selectedAction) async {
                        switch (selectedAction) {
                          case ArticleAction.query:
                            {
                              onArticleSelected.call(article);
                            }
                            break;
                          case ArticleAction.edit:
                            {
                              onEditArticle.call(article);
                            }
                            break;
                          case ArticleAction.delete:
                            {
                              await _handleOnDelete(article, blogService);
                            }
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<ArticleAction>(
                          value: ArticleAction.query,
                          child: PopupMenuItemText(
                            text: 'Ver'.hardcoded,
                          ),
                        ),
                        PopupMenuItem<ArticleAction>(
                          value: ArticleAction.edit,
                          child: PopupMenuItemText(
                            text: 'Editar'.hardcoded,
                          ),
                        ),
                        PopupMenuItem<ArticleAction>(
                          value: ArticleAction.delete,
                          child: PopupMenuItemText(
                            text: 'Eliminar'.hardcoded,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      onArticleSelected.call(article);
                    },
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: onCreateNewArticle,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
