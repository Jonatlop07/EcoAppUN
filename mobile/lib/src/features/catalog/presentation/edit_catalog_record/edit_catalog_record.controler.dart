import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/catalog/data/catalog.service.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';
import '../common/image_edit_details.input.dart';
import 'catalog_record_edit_details.input.dart';
import 'edit_catalog_record.state.dart';

class EditCatalogRecordController extends StateNotifier<EditCatalogRecordState> {
  EditCatalogRecordController({
    required this.catalogService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(EditCatalogRecordState());

  final CatalogService catalogService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(CatalogRecordEditDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitCatalogRecord(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitCatalogRecord(CatalogRecordEditDetailsInput input) async {
    final CatalogRecordEditDetailsInput catalogRecord = CatalogRecordEditDetailsInput(
      id: input.id,
      authorId: input.authorId,
      commonName: input.commonName,
      scientificName: input.scientificName,
      description: input.description,
      createdAt: input.createdAt,
      updatedAt: input.updatedAt,
      locations: input.locations,
      images: input.images
          .map(
            (imageInput) => ImageEditDetailsInput(
              id: imageInput.id,
              authorId: imageInput.authorId ?? _currentUser!.id,
              authorName: imageInput.authorName ?? _currentUser!.username,
              description: imageInput.description,
              url: imageInput.url,
              submittedAt: imageInput.submittedAt,
            ),
          )
          .toList(),
    );
    return await _editCatalogRecord(catalogRecord);
  }

  Future<String> _editCatalogRecord(CatalogRecordEditDetailsInput catalogRecord) async {
    return await catalogService.updateCatalogRecord(catalogRecord);
  }
}

final editCatalogRecordControllerProvider = StateNotifierProvider.autoDispose
    .family<EditCatalogRecordController, EditCatalogRecordState, void>((ref, _) {
  final catalogService = ref.watch(catalogServiceProvider);
  return EditCatalogRecordController(
    ref: ref,
    catalogService: catalogService,
  );
});
