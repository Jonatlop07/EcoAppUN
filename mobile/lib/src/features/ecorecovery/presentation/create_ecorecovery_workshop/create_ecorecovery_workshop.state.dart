import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/validators/string.validator.dart';

mixin CreateEcorecoveryWorkshopValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class CreateEcorecoveryWorkshopState with CreateEcorecoveryWorkshopValidators {
  CreateEcorecoveryWorkshopState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  CreateEcorecoveryWorkshopState copyWith({AsyncValue<String>? value}) {
    return CreateEcorecoveryWorkshopState(value: value ?? this.value);
  }

  @override
  String toString() => 'CreateEcorecoveryWorkshopState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateEcorecoveryWorkshopState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension CreateEcorecoveryWorkshopStateX on CreateEcorecoveryWorkshopState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Nueva jornada de restauración'.hardcoded;
  }

  String get generalDetailsSubtitle {
    return 'Datos generales'.hardcoded;
  }

  String get titleLabelText {
    return 'Título'.hardcoded;
  }

  String get titleHintText {
    return 'Ingresa un título descriptivo del evento'.hardcoded;
  }

  bool canSubmitTitle(String title) {
    return titleSubmitValidator.isValid(title);
  }

  String? titleErrorText(String title) {
    final bool showErrorText = !canSubmitTitle(title);
    final String errorText = 'Debes indicar el título del evento'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get descriptionLabelText {
    return 'Descripción'.hardcoded;
  }

  String get descriptionHintText {
    return 'Describe las características principales del evento'.hardcoded;
  }

  bool canSubmitDescription(String description) {
    return descriptionSubmitValidator.isValid(description);
  }

  String? descriptionErrorText(String description) {
    final bool showErrorText = !canSubmitDescription(description);
    final String errorText = 'Debes indicar la descripción del evento '.hardcoded;
    return showErrorText ? errorText : null;
  }

  String get logisticDetailsSubtitle {
    return 'Datos logísticos'.hardcoded;
  }

  String get dateLabelText {
    return 'Fecha de realización'.hardcoded;
  }

  String get startTimeLabelText {
    return 'Inicia'.hardcoded;
  }

  String get endTimeLabelText {
    return 'Finaliza'.hardcoded;
  }

  String get meetupPointLabelText {
    return 'Punto de encuentro'.hardcoded;
  }

  String get instructionsLabelText {
    return 'Instrucciones de la jornada'.hardcoded;
  }

  String get instructionsHintText {
    return 'Añade una instrucción a seguir'.hardcoded;
  }

  String get objectivesLabelText {
    return 'Objetivos de la jornada'.hardcoded;
  }

  String get objectivesHintText {
    return 'Añade un objetivo de la jornada'.hardcoded;
  }

  String get organizersLabelText {
    return 'Organizadores'.hardcoded;
  }

  String get organizersHintText {
    return 'Agrega un organizador'.hardcoded;
  }
}
