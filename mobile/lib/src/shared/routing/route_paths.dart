import 'package:mobile/src/shared/routing/routes.dart';

class RoutePaths {
  static const home = '/';
  static const catalog = '/${Routes.catalog}';
  static const createCatalogRecord = '/${Routes.catalog}/create';
  static queryCatalogRecord(String catalogRecordId) => '/${Routes.catalog}/$catalogRecordId';
}
