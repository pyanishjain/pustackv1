class ApiConfigs {
  static final String baseQuerySuggestionUrl =
      "https://a3d547560b4f411db9ce080474ff941d.ent-search.asia-south1.gcp.elastic-cloud.com/api/as/v1/engines/doubt-search-engine/query_suggestion/";

  static final String baseSearchUrl =
      "https://a3d547560b4f411db9ce080474ff941d.ent-search.asia-south1.gcp.elastic-cloud.com/api/as/v1/engines/doubt-search-engine/search/";

  static final Map<String, dynamic> authorizationHeader = {
    "Authorization": "Bearer search-pxtbvaepxv73u1e7bwtkkum7"
  };
}

class RazorPayApiConfigs {
  static final String baseSubscriptionUrl =
      "https://api.razorpay.com/v1/subscriptions";
  static final Map<String, dynamic> authorizationHeader = {
    "Authorization":
        "auth_basic rzp_test_F7CpiOwZhVekGi:J2wM4GDvQz9I5nJxf7NdnyqS"
  };
}
