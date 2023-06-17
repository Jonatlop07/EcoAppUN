import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/state/app_user.dart';
import '../../../../shared/state/auth_state.accesor.dart';
import '../../data/ecotour_service.dart';
import '../common/ecotour_details.dart';
import 'create_ecotour.state.dart';
import 'ecotour_details.input.dart';

class CreateEcotourController extends StateNotifier<CreateEcotourState> {
  CreateEcotourController({
    required this.ecotourService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateEcotourState());

  final EcotourService ecotourService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(EcotourDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitEcotour(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitEcotour(EcotourDetailsInput input) async {
    final EcotourDetails ecotourDetails = EcotourDetails(
      authorId: _currentUser!.id,
      title: input.title,
      description: input.description,
      date: input.date,
      startTime: input.startTime,
      endTime: input.endTime,
      meetupPoint: input.meetupPoint,
      organizers: input.organizers,
    );
    return await _createEcotour(ecotourDetails);
  }

  Future<String> _createEcotour(EcotourDetails ecotourDetails) async {
    return await ecotourService.createEcotour(ecotourDetails);
  }
}

final createEcotourControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateEcotourController, CreateEcotourState, void>((ref, _) {
  final ecotourService = ref.watch(ecotourServiceProvider);
  return CreateEcotourController(
    ref: ref,
    ecotourService: ecotourService,
  );
});
