import 'package:pustackv1/configs/api_configs.dart';
import 'package:pustackv1/services/request_service.dart';

class ApiService {
  final RequestService _requestService = RequestService();

  Future getSuggestionsFromQuery(String query) {
    return _requestService.getRequest(
      ApiConfigs.baseQuerySuggestionUrl,
      params: {'query': query},
    );
  }

  Future getSearchResults(String query) {
    return _requestService.getRequest(
      ApiConfigs.baseSearchUrl,
      params: {'query': query},
    );
  }
}
