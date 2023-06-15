import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';

import '../../data/denouncement_details.dart';
import '../../data/denouncement_service.dart';
import 'create_denouncement.state.dart';
import 'denouncement_details.input.dart';

class CreateDenouncementController extends StateNotifier<CreateDenouncementState> {
  CreateDenouncementController({
    required this.denouncementService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateDenouncementState());

  final DenouncementService denouncementService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(DenouncementDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitDenouncement(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitDenouncement(DenouncementDetailsInput input) async {
    final DenouncementDetails denouncementDetails = DenouncementDetails(
      denouncerId: _currentUser!.id,
      title: input.title,
      description: input.description,
      multimediaElements: input.multimediaElements
          .map(
            (multimediaElement) => MultimediaDetails(
              description: multimediaElement.description,
              uri: multimediaElement.uri,
            ),
          )
          .toList(),
    );
    return await _createDenouncement(denouncementDetails);
  }

  Future<String> _createDenouncement(DenouncementDetails denouncementDetails) async {
    return await denouncementService.createDenouncement(denouncementDetails);
  }
}

final createDenouncementControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateDenouncementController, CreateDenouncementState, void>((ref, _) {
  final denouncementService = ref.watch(denouncementServiceProvider);
  return CreateDenouncementController(
    ref: ref,
    denouncementService: denouncementService,
  );
});
