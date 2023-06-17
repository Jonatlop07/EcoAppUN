import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';

import '../../../../shared/validators/string.validator.dart';

mixin CreateArticleValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
}

class CreateArticleState with CreateArticleValidators {
  CreateArticleState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  CreateArticleState copyWith({AsyncValue<String>? value}) {
    return CreateArticleState(value: value ?? this.value);
  }

  @override
  String toString() => 'CreateArticleState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateArticleState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension CreateArticleStateX on CreateArticleState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 1;

  String get formTitle {
    return 'Nuevo artículo del blog'.hardcoded;
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
