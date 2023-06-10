import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/sowing/common/seed_edit_details.input.dart';
import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/sowing_service.dart';
import 'edit_sowing_workshop.state.dart';
import 'sowing_workshop_edit_details.input.dart';

class EditSowingWorkshopController extends StateNotifier<EditSowingWorkshopState> {
  EditSowingWorkshopController({
    required this.sowingService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditSowingWorkshopState());

  final SowingService sowingService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(SowingWorkshopEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitSowingWorkshop(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitSowingWorkshop(SowingWorkshopEditDetailsInput input) async {
    final SowingWorkshopEditDetailsInput sowingWorkshop = SowingWorkshopEditDetailsInput(
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
      seeds: input.seeds
          .map(
            (seed) => SeedEditDetailsInput(
              id: seed.id,
              description: seed.description,
              imageLink: seed.imageLink,
              availableAmount: seed.availableAmount,
            ),
          )
          .toList(),
    );
    return await _editSowingWorkshop(sowingWorkshop);
  }

  Future<String> _editSowingWorkshop(SowingWorkshopEditDetailsInput sowingWorkshop) async {
    return await sowingService.updateSowingWorkshop(sowingWorkshop);
  }
}

final editSowingWorkshopControllerProvider = StateNotifierProvider.autoDispose
    .family<EditSowingWorkshopController, EditSowingWorkshopState, void>((ref, _) {
  final sowingService = ref.watch(sowingServiceProvider);
  return EditSowingWorkshopController(
    ref: ref,
    sowingService: sowingService,
  );
});
