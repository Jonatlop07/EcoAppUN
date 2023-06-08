import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/sowing_service.dart';
import '../../data/sowing_workshop_details.dart';
import 'create_sowing_workshop.state.dart';
import 'sowing_workshop_details.input.dart';

class CreateSowingWorkshopController extends StateNotifier<CreateSowingWorkshopState> {
  CreateSowingWorkshopController({
    required this.sowingService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateSowingWorkshopState());

  final SowingService sowingService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(SowingWorkshopDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitSowingWorkshop(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitSowingWorkshop(SowingWorkshopDetailsInput input) async {
    final SowingWorkshopDetails sowingWorkshopDetails = SowingWorkshopDetails(
      authorId: _currentUser!.id,
      title: input.title,
      description: input.description,
      startTime: input.startTime,
      endTime: input.endTime,
      meetupPoint: input.meetupPoint,
      organizers: input.organizers,
      instructions: input.instructions,
      objectives: input.objectives,
      seeds: input.seeds
          .map(
            (seed) => SeedDetails(
              description: seed.description,
              imageLink: seed.imageLink,
              availableAmount: seed.availableAmount,
            ),
          )
          .toList(),
    );
    return await _createSowingWorkshop(sowingWorkshopDetails);
  }

  Future<String> _createSowingWorkshop(SowingWorkshopDetails sowingWorkshopDetails) async {
    return await sowingService.createSowingWorkshop(sowingWorkshopDetails);
  }
}

final createSowingWorkshopControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateSowingWorkshopController, CreateSowingWorkshopState, void>((ref, _) {
  final sowingService = ref.watch(sowingServiceProvider);
  return CreateSowingWorkshopController(
    ref: ref,
    sowingService: sowingService,
  );
});
