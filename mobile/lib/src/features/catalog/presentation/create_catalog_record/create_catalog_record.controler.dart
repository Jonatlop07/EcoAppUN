import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/catalog/data/catalog.service.dart';
import 'package:mobile/src/features/catalog/data/catalog_record_details.dart';
import 'package:mobile/src/features/catalog/presentation/create_catalog_record/create_catalog_record.state.dart';
import 'package:mobile/src/shared/state/auth_state.accesor.dart';
import 'package:mobile/src/shared/state/app_user.dart';
import 'catalog_record_details.input.dart';

class CreateCatalogRecordController extends StateNotifier<CreateCatalogRecordState> {
  CreateCatalogRecordController({
    required this.catalogService,
    required Ref ref,
  })  : _authStateAccessor = AuthStateAccessor(ref),
        super(CreateCatalogRecordState());

  final CatalogService catalogService;

  final AuthStateAccessor _authStateAccessor;
  AppUser? get _currentUser => _authStateAccessor.getAuthStateController().state;

  Future<bool> submit(CatalogRecordDetailsInput input) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _submitCatalogRecord(input));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  Future<String> _submitCatalogRecord(CatalogRecordDetailsInput input) async {
    final CatalogRecordDetails catalogRecordDetails = CatalogRecordDetails(
      authorId: _currentUser!.id,
      commonName: input.commonName,
      scientificName: input.scientificName,
      description: input.description,
      locations: input.locations,
      images: input.images
          .map(
            (imageInput) => ImageDetails(
              authorId: _currentUser!.id,
              authorName: _currentUser!.username,
              description: imageInput.description,
              url: imageInput.url,
            ),
          )
          .toList(),
    );
    return await _createCatalogRecord(catalogRecordDetails);
  }

  Future<String> _createCatalogRecord(CatalogRecordDetails catalogRecordDetails) async {
    return await catalogService.createCatalogRecord(catalogRecordDetails);
  }
}

final createCatalogRecordControllerProvider = StateNotifierProvider.autoDispose
    .family<CreateCatalogRecordController, CreateCatalogRecordState, void>((ref, _) {
  final catalogService = ref.watch(catalogServiceProvider);
  return CreateCatalogRecordController(
    ref: ref,
    catalogService: catalogService,
  );
});
