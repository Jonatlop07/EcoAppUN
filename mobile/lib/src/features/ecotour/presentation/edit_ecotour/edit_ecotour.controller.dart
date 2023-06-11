import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/ecotour_service.dart';
import 'ecotour_edit_details.input.dart';
import 'edit_ecotour.state.dart';

class EditEcotourController extends StateNotifier<EditEcotourState> {
  EditEcotourController({
    required this.ecotourService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditEcotourState());

  final EcotourService ecotourService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(EcotourEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitEcotour(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitEcotour(EcotourEditDetailsInput input) async {
    final EcotourEditDetailsInput ecotour = EcotourEditDetailsInput(
      id: input.id,
      authorId: input.authorId,
      title: input.title,
      description: input.description,
      date: input.date,
      startTime: input.startTime,
      endTime: input.endTime,
      meetupPoint: input.meetupPoint,
      organizers: input.organizers,
      createdAt: input.createdAt,
      updatedAt: input.updatedAt,
    );
    return await _editEcotour(ecotour);
  }

  Future<String> _editEcotour(
    EcotourEditDetailsInput ecotour,
  ) async {
    return await ecotourService.updateEcotour(ecotour);
  }
}

final editEcotourControllerProvider = StateNotifierProvider.autoDispose
    .family<EditEcotourController, EditEcotourState, void>((ref, _) {
  final ecotourService = ref.watch(ecotourServiceProvider);
  return EditEcotourController(
    ref: ref,
    ecotourService: ecotourService,
  );
});
