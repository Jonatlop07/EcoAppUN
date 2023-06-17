import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';

import '../../data/article_details.dart';
import '../../data/blog_service.dart';
import 'article_details.input.dart';
import 'create_article.state.dart';

class CreateArticleController extends StateNotifier<CreateArticleState> {
  CreateArticleController({
    required this.blogService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateArticleState());

  final BlogService blogService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(ArticleDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitArticle(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitArticle(ArticleDetailsInput input) async {
    final ArticleDetails articleDetails = ArticleDetails(
      authorId: _currentUser!.id,
      title: input.title,
      content: input.content,
      categories: input.categories,
    );
    return await _createArticle(articleDetails);
  }

  Future<String> _createArticle(ArticleDetails articleDetails) async {
    return await blogService.createArticle(articleDetails);
  }
}

final createArticleControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateArticleController, CreateArticleState, void>((ref, _) {
  final blogService = ref.watch(blogServiceProvider);
  return CreateArticleController(
    ref: ref,
    blogService: blogService,
  );
});
