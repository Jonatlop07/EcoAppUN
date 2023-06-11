import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/ecorecovery_service.dart';
import '../common/ecorecovery_workshop_details.dart';
import 'create_ecorecovery_workshop.state.dart';
import 'ecorecovery_workshop_details.input.dart';

class CreateEcorecoveryWorkshopController extends StateNotifier<CreateEcorecoveryWorkshopState> {
  CreateEcorecoveryWorkshopController({
    required this.ecorecoveryService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateEcorecoveryWorkshopState());

  final EcorecoveryService ecorecoveryService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(EcorecoveryWorkshopDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitEcorecoveryWorkshop(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitEcorecoveryWorkshop(EcorecoveryWorkshopDetailsInput input) async {
    final EcorecoveryWorkshopDetails ecorecoveryWorkshopDetails = EcorecoveryWorkshopDetails(
      authorId: _currentUser!.id,
      title: input.title,
      description: input.description,
      date: input.date,
      startTime: input.startTime,
      endTime: input.endTime,
      meetupPoint: input.meetupPoint,
      organizers: input.organizers,
      instructions: input.instructions,
      objectives: input.objectives,
    );
    return await _createEcorecoveryWorkshop(ecorecoveryWorkshopDetails);
  }

  Future<String> _createEcorecoveryWorkshop(
      EcorecoveryWorkshopDetails ecorecoveryWorkshopDetails) async {
    return await ecorecoveryService.createWorkshop(ecorecoveryWorkshopDetails);
  }
}

final createEcorecoveryWorkshopControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateEcorecoveryWorkshopController, CreateEcorecoveryWorkshopState, void>((ref, _) {
  final ecorecoveryService = ref.watch(ecorecoveryServiceProvider);
  return CreateEcorecoveryWorkshopController(
    ref: ref,
    ecorecoveryService: ecorecoveryService,
  );
});
