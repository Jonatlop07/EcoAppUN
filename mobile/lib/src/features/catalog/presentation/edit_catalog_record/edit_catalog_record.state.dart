import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/localization/string.hardcoded.dart';
import 'package:mobile/src/shared/validators/string.validator.dart';

mixin EditCatalogRecordValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator commonNameSubmitValidator = NonEmptyStringValidator();
  final StringValidator scientificNameSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class EditCatalogRecordState with EditCatalogRecordValidators {
  EditCatalogRecordState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  EditCatalogRecordState copyWith({AsyncValue<String>? value}) {
    return EditCatalogRecordState(value: value ?? this.value);
  }

  @override
  String toString() => 'EditCatalogRecordState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditCatalogRecordState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension EditCatalogRecordStateX on EditCatalogRecordState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Editar ficha de especie'.hardcoded;
  }

  String get commonNameHintText {
    return 'Nombre común'.hardcoded;
  }

  bool canSubmitCommonName(String commonName) {
    return commonNameSubmitValidator.isValid(commonName);
  }

  String? commonNameErrorText(String commonName) {
    final bool showErrorText = !canSubmitCommonName(commonName);
    final String errorText = 'Debes indicar el nombre común de la especie'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get scientificNameHintText {
    return 'Nombre científico'.hardcoded;
  }

  bool canSubmitScientificName(String scientificName) {
    return scientificNameSubmitValidator.isValid(scientificName);
  }

  String? scientificNameErrorText(String scientificName) {
    final bool showErrorText = !canSubmitScientificName(scientificName);
    final String errorText = 'Debes indicar el nombre científico de la especie'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get descriptionHintText {
    return 'Descripcion de la especie'.hardcoded;
  }

  bool canSubmitDescription(String description) {
    return descriptionSubmitValidator.isValid(description);
  }

  String? descriptionErrorText(String description) {
    final bool showErrorText = !canSubmitDescription(description);
    final String errorText = 'Debes indicar la descripción de la especie'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get sharePhotosText {
    return 'Fotos de esta especie'.hardcoded;
  }
}
