import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';

import '../../data/denouncement_service.dart';
import '../common/multimedia_edit_details.input.dart';
import 'denouncement_edit_details.input.dart';
import 'edit_denouncement.state.dart';

class EditDenouncementController extends StateNotifier<EditDenouncementState> {
  EditDenouncementController({
    required this.denouncementService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditDenouncementState());

  final DenouncementService denouncementService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(DenouncementEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitDenouncement(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitDenouncement(DenouncementEditDetailsInput input) async {
    final DenouncementEditDetailsInput denouncement = DenouncementEditDetailsInput(
      id: input.id,
      denouncerId: input.denouncerId,
      title: input.title,
      description: input.description,
      createdAt: input.createdAt,
      updatedAt: input.updatedAt,
      multimediaElements: input.multimediaElements
          .map(
            (multimediaElement) => MultimediaEditDetailsInput(
              description: multimediaElement.description,
              uri: multimediaElement.uri,
              submittedAt: multimediaElement.submittedAt,
            ),
          )
          .toList(),
    );
    return await _editDenouncement(denouncement);
  }

  Future<String> _editDenouncement(DenouncementEditDetailsInput denouncement) async {
    return await denouncementService.updateDenouncement(denouncement);
  }
}

final editDenouncementControllerProvider = StateNotifierProvider.autoDispose
    .family<EditDenouncementController, EditDenouncementState, void>((ref, _) {
  final denouncementService = ref.watch(denouncementServiceProvider);
  return EditDenouncementController(
    ref: ref,
    denouncementService: denouncementService,
  );
});
