import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/shared/common_widgets/custom_text_editor.dart';
import 'package:mobile/src/shared/common_widgets/navbar.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';
import 'package:zefyrka/zefyrka.dart';
import '../../../../shared/async/async_value_ui.dart';
import '../../../../shared/common_widgets/done_button.dart';
import '../../../../shared/common_widgets/dropdown_input_list.dart';
import '../../../../shared/common_widgets/responsive_scrollable_card.dart';
import '../../../../shared/common_widgets/custom_text_form_field.dart';
import '../../../../shared/common_widgets/screen_title.dart';
import '../../../../shared/routing/routes.dart';
import '../../domain/blog.dart';
import 'article_edit_details.input.dart';
import 'edit_article.controller.dart';
import 'edit_article.state.dart';

class EditArticleScreen extends StatelessWidget {
  const EditArticleScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  static const titleKey = Key('title');
  static const contentKey = Key('content');
  static const categoriesKey = Key('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: _EditArticleForm(
        article: article,
        onArticleEdited: (articleId) => context.pushNamed(
          Routes.queryArticle,
          pathParameters: {"articleId": articleId},
        ),
      ),
    );
  }
}

class _EditArticleForm extends ConsumerStatefulWidget {
  const _EditArticleForm({
    Key? key,
    required this.article,
    required this.onArticleEdited,
  }) : super(key: key);

  final Article article;
  final Function(String) onArticleEdited;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditArticleFormState();
}

class _EditArticleFormState extends ConsumerState<_EditArticleForm> {
  final List<String> categoryOptions = ['Ecosistemas', 'Especies', 'Cambio climático'];
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _titleController = TextEditingController();
  ZefyrController _contentController = ZefyrController();

  String get title => _titleController.text;
  String get content => jsonEncode(_contentController.document.toDelta().toJson());

  List<String> _categories = [];

  var _submitted = false;

  @override
  void didChangeDependencies() {
    _titleController.text = widget.article.title;
    if (widget.article.content.isNotEmpty) {
      _contentController = ZefyrController(
        NotusDocument.fromJson(
          jsonDecode(widget.article.content),
        ),
      );
    }
    _categories = widget.article.categories;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _node.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _focusNextInput() {
    _node.nextFocus();
  }

  void _handleOnCategoryListChanged(List<String> categories) {
    _categories = categories;
  }

  Future<void> _submit(EditArticleState state) async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(editArticleControllerProvider(null).notifier);
      final success = await controller.submit(
        ArticleEditDetailsInput(
          id: widget.article.id,
          authorId: widget.article.authorId,
          createdAt: widget.article.createdAt,
          updatedAt: widget.article.updatedAt,
          title: title,
          content: content,
          categories: _categories,
        ),
      );
      if (success) {
        String articleId = state.value as String;
        widget.onArticleEdited.call(articleId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editArticleControllerProvider(null).select((state) => state.value),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editArticleControllerProvider(null));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: insetsAll24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ScreenTitle(text: state.formTitle),
                gapH12,
                Padding(
                  padding: insetsAll12,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        key: EditArticleScreen.titleKey,
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: state.titleLabelText,
                          hintText: state.titleHintText,
                          enabled: !state.isLoading,
                        ),
                        maxLength: state.textFieldMaxLength,
                        minLines: state.textFieldMinLines,
                        maxLines: state.textFieldMaxLines,
                        validator: (title) =>
                            !_submitted ? null : state.titleErrorText(title ?? ''),
                        onEditingComplete: _focusNextInput,
                      ),
                    ],
                  ),
                ),
                gapH16,
                Text(
                  state.articleBodyLabelText,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                CustomTextEditor(
                  key: EditArticleScreen.contentKey,
                  controller: _contentController,
                ),
                gapH16,
                DropdownInputListWidget(
                  key: EditArticleScreen.categoriesKey,
                  items: _categories,
                  initialOptionIndex: 0,
                  options: categoryOptions,
                  decoration: InputDecoration(
                    labelText: state.categoriesLabelText,
                    hintText: state.categoriesHintText,
                    enabled: !state.isLoading,
                  ),
                  onChange: _handleOnCategoryListChanged,
                ),
                gapH16,
                DoneButton(
                  isLoading: state.isLoading,
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          await _submit(state);
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
