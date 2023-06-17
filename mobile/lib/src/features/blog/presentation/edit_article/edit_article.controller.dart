import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';

import '../../data/blog_service.dart';
import 'article_edit_details.input.dart';
import 'edit_article.state.dart';

class EditArticleController extends StateNotifier<EditArticleState> {
  EditArticleController({
    required this.blogService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditArticleState());

  final BlogService blogService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(ArticleEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitArticle(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitArticle(ArticleEditDetailsInput input) async {
    return await _editArticle(input);
  }

  Future<String> _editArticle(ArticleEditDetailsInput articleDetails) async {
    return await blogService.updateArticle(articleDetails);
  }
}

final editArticleControllerProvider = StateNotifierProvider.autoDispose
    .family<EditArticleController, EditArticleState, void>((ref, _) {
  final blogService = ref.watch(blogServiceProvider);
  return EditArticleController(
    ref: ref,
    blogService: blogService,
  );
});
