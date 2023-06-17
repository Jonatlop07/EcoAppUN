import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/validators/string.validator.dart';

mixin EditArticleValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
}

class EditArticleState with EditArticleValidators {
  EditArticleState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  EditArticleState copyWith({AsyncValue<String>? value}) {
    return EditArticleState(value: value ?? this.value);
  }

  @override
  String toString() => 'EditArticleState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditArticleState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension EditArticleStateX on EditArticleState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 1;

  String get formTitle {
    return 'Edición del artículo'.hardcoded;
  }

  String get titleLabelText {
    return 'Título'.hardcoded;
  }

  String get titleHintText {
    return 'Título del artículo'.hardcoded;
  }

  bool canSubmitTitle(String title) {
    return titleSubmitValidator.isValid(title);
  }

  String? titleErrorText(String title) {
    final bool showErrorText = !canSubmitTitle(title);
    final String errorText = 'Debes indicar el título de tu artículo'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get articleBodyLabelText {
    return 'Cuerpo del artículo'.hardcoded;
  }

  String get categoriesLabelText {
    return 'Categorías'.hardcoded;
  }

  String get categoriesHintText {
    return 'Temas de los que trata el artículo'.hardcoded;
  }
}
