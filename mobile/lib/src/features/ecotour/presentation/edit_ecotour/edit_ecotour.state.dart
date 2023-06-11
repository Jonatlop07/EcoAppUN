import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/localization/string.hardcoded.dart';
import '../../../../shared/validators/string.validator.dart';

mixin EditEcotourValidators {
  final StringValidator titleSubmitValidator = NonEmptyStringValidator();
  final StringValidator descriptionSubmitValidator = NonEmptyStringValidator();
}

class EditEcotourState with EditEcotourValidators {
  EditEcotourState({
    this.value = const AsyncValue.data(''),
  });

  final AsyncValue<String> value;

  bool get isLoading => value.isLoading;

  EditEcotourState copyWith({AsyncValue<String>? value}) {
    return EditEcotourState(value: value ?? this.value);
  }

  @override
  String toString() => 'CreateEcotourState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditEcotourState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension EditEcotourStateX on EditEcotourState {
  int get textFieldMaxLength => 1024;
  int get textFieldMinLines => 1;
  int get textFieldMaxLines => 3;

  String get formTitle {
    return 'Nuevo tour ecológico'.hardcoded;
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
    final String errorText = 'Debes indicar la descripción del evento'.hardcoded;
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

  String get organizersLabelText {
    return 'Organizadores'.hardcoded;
  }

  String get organizersHintText {
    return 'Agrega un organizador'.hardcoded;
  }
}
