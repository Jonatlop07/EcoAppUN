import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/validators/string.validator.dart';

mixin CreateSowingWorkshopValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class CreateSowingWorkshopState with CreateSowingWorkshopValidators {
  CreateSowingWorkshopState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  CreateSowingWorkshopState copyWith({AsyncValue<String>? value}) {
    return CreateSowingWorkshopState(value: value ?? this.value);
  }

  @override
  String toString() => 'CreateSowingWorkshopState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateSowingWorkshopState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension CreateSowingWorkshopStateX on CreateSowingWorkshopState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Nuevo taller de siembra'.hardcoded;
  }

  String get titleHintText {
    return 'Título'.hardcoded;
  }

  bool canSubmitTitle(String title) {
    return titleSubmitValidator.isValid(title);
  }

  String? titleErrorText(String title) {
    final bool showErrorText = !canSubmitTitle(title);
    final String errorText = 'Debes indicar el título del taller'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get descriptionHintText {
    return 'Descripción del taller'.hardcoded;
  }

  bool canSubmitDescription(String description) {
    return descriptionSubmitValidator.isValid(description);
  }

  String? descriptionErrorText(String description) {
    final bool showErrorText = !canSubmitDescription(description);
    final String errorText = 'Debes indicar la descripción del taller'.hardcoded;
    return showErrorText ? errorText : null;
  }
}
