import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';
import 'package:mobile/src/shared/validators/string.validator.dart';

mixin EditDenouncementValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class EditDenouncementState with EditDenouncementValidators {
  EditDenouncementState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  EditDenouncementState copyWith({AsyncValue<String>? value}) {
    return EditDenouncementState(value: value ?? this.value);
  }

  @override
  String toString() => 'EditDenouncementState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditDenouncementState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension EditDenouncementStateX on EditDenouncementState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Editar denuncia'.hardcoded;
  }

  String get titleLabelText {
    return 'Título'.hardcoded;
  }

  String get titleHintText {
    return 'Título de la denuncia'.hardcoded;
  }

  bool canSubmitTitle(String title) {
    return titleSubmitValidator.isValid(title);
  }

  String? titleErrorText(String title) {
    final bool showErrorText = !canSubmitTitle(title);
    final String errorText = 'Debes indicar título de la denuncia'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get descriptionLabelText {
    return 'Descripcion'.hardcoded;
  }

  String get descriptionHintText {
    return 'Descripción de la denuncia y narración de los hechos'.hardcoded;
  }

  bool canSubmitDescription(String description) {
    return descriptionSubmitValidator.isValid(description);
  }

  String? descriptionErrorText(String description) {
    final bool showErrorText = !canSubmitDescription(description);
    final String errorText = 'Debes indicar la descripción de la especie'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get initialDateLabelText {
    return 'Inicio de los sucesos'.hardcoded;
  }

  String get finalDateLabelText {
    return 'Fin de los sucesos'.hardcoded;
  }

  String get shareMediaText {
    return 'Fotos o videos de prueba'.hardcoded;
  }
}
