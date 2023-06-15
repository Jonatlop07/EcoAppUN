import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';
import 'package:mobile/src/shared/validators/string.validator.dart';

mixin CreateDenouncementValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class CreateDenouncementState with CreateDenouncementValidators {
  CreateDenouncementState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  CreateDenouncementState copyWith({AsyncValue<String>? value}) {
    return CreateDenouncementState(value: value ?? this.value);
  }

  @override
  String toString() => 'CreateDenouncementState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateDenouncementState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension CreateDenouncementStateX on CreateDenouncementState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Nueva denuncia'.hardcoded;
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
    final String errorText = 'Debes indicar la descripción de la denuncia'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get initialDateLabelText {
    return 'Inicio de los sucesos'.hardcoded;
  }

  String get finalDateLabelText {
    return 'Fin de los sucesos'.hardcoded;
  }

  String get shareMediaText {
    return 'Añade fotos o videos de prueba'.hardcoded;
  }
}
