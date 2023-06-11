import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/ecorecovery_service.dart';
import 'ecorecovery_workshop_edit_details.input.dart';
import 'edit_ecorecovery_workshop.state.dart';

class EditEcorecoveryWorkshopController extends StateNotifier<EditEcorecoveryWorkshopState> {
  EditEcorecoveryWorkshopController({
    required this.ecorecoveryService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditEcorecoveryWorkshopState());

  final EcorecoveryService ecorecoveryService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(EcorecoveryWorkshopEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitEcorecoveryWorkshop(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitEcorecoveryWorkshop(EcorecoveryWorkshopEditDetailsInput input) async {
    final EcorecoveryWorkshopEditDetailsInput ecorecoveryWorkshop =
        EcorecoveryWorkshopEditDetailsInput(
      id: input.id,
      authorId: input.authorId,
      title: input.title,
      description: input.description,
      date: input.date,
      startTime: input.startTime,
      endTime: input.endTime,
      meetupPoint: input.meetupPoint,
      organizers: input.organizers,
      instructions: input.instructions,
      objectives: input.objectives,
      createdAt: input.createdAt,
      updatedAt: input.updatedAt,
    );
    return await _editEcorecoveryWorkshop(ecorecoveryWorkshop);
  }

  Future<String> _editEcorecoveryWorkshop(
      EcorecoveryWorkshopEditDetailsInput ecorecoveryWorkshop) async {
    return await ecorecoveryService.updateWorkshop(ecorecoveryWorkshop);
  }
}

final editEcorecoveryWorkshopControllerProvider = StateNotifierProvider.autoDispose
    .family<EditEcorecoveryWorkshopController, EditEcorecoveryWorkshopState, void>((ref, _) {
  final ecorecoveryService = ref.watch(ecorecoveryServiceProvider);
  return EditEcorecoveryWorkshopController(
    ref: ref,
    ecorecoveryService: ecorecoveryService,
  );
});
