import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfiguration {
  static Link link;
  static HttpLink httpLink = HttpLink('api_url');

  static void setToken(String token) {
    var aLink = AuthLink(getToken: () async => token);
    GraphQLConfiguration.link = aLink.concat(GraphQLConfiguration.httpLink);
  }

  static void removeToken() {
    GraphQLConfiguration.link = null;
  }

  static Link getLink() {
    return GraphQLConfiguration.link ?? GraphQLConfiguration.httpLink;
  }

  static Future<GraphQLClient> getAuthClient() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('TOKEN');

    if (token != null) {
      final aLink = AuthLink(getToken: () async => token);
      final link = aLink.concat(GraphQLConfiguration.httpLink);
      final client = GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: link,
      );

      return client;
    }

    final client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: GraphQLConfiguration.httpLink,
    );

    return client;
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: getLink(),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: getLink(),
    );
  }
}
