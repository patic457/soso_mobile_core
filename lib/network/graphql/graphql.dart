// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_rethrow_when_possible
import 'dart:async';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:core/network/utils/constant.dart';
import 'package:core/network/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Helper GraphQl
class GraphQlHelper {
  String? endpoint;

  /// The default [header]
  /// Defaults to
  /// [baseHeaders] is as follows:
  /// ```
  /// Map<String, String> baseHeaders = {
  /// "Accept": "application/json",
  /// "Content-Type": "application/json; charset=utf-8",
  /// };
  /// ```
  Map<String, String>? header;

  /// GraphQL execution interface if you want to config by self
  GraphQLClient? graphQLClient;

  GraphQlHelper({
    Key? key,
    this.endpoint,
    this.header,
    this.graphQLClient,
  });

  ///set httpLink endpoint and header
  HttpLink get httpLink => HttpLink(
        endpoint ?? graphqlEndpoint,
        defaultHeaders: setHeader(header),
      );

  ///Authentication token
  Link setAuthentication(String token) {
    /// Authentication callback.
    /// [authString] must include prefixes, e.g. 'Bearer $token'
    AuthLink authLink = AuthLink(
      getToken: () async => token,
    );
    return authLink.concat(httpLink);
  }

  ///set based GraphQL execution interface
  ///To connect our Flutter app to the GraphQL server, we need to create a GraphQLClient, which requires a Link and a GraphQLCache
  GraphQLClient _graphQlClient({
    HttpLink? httplink,
  }) {
    GraphQLClient graphQlClient = GraphQLClient(
      // defaultPolicies: DefaultPolicies(),
      // Or use [setAuthentication(String token)]
      link: httplink ?? httpLink,
      cache: GraphQLCache(),
    );
    return graphQlClient;
  }

  ///base method for query Graphql data.
  ///
  ///example config fetchPolicy
  ///`fetchPolicy: GqlFetchPolicy.networkOnly`
  /// The default `fetchPolicy` for get method are: [cacheFirst]
  Future<dynamic> get(
    String query,
    bool cache, {
    Map<String, String>? header,
    GqlFetchPolicy? fetchPolicy,
    // Duration for clear cache
    Duration? cacheDuration,

    /// String? accessToken,
    ///Other parameter for setting graphQL
  }) async {
    // Or QueryOptions
    QueryOptions options = QueryOptions(
      document: gql(query),
      // //The time interval on which this query should be re-fetched from the server.
      // pollInterval: const Duration(seconds: 5),
    );
    late QueryResult queryResult;
    dynamic cacheData;
    fetchPolicy ?? GqlFetchPolicy.cacheFirst;

    if (fetchPolicy == GqlFetchPolicy.cacheFirst) {
      cacheData = GqlCacheManager().getCacheManager(query);
      if (cacheData == null) {
        queryResult = await _graphQlClient().query(options);
        if (cache) {
          GqlCacheManager().cacheData(
            queryResult.data,
            query,
            cacheDuration!,
          );
        }
        return queryResult.data;
      }
      return cacheData;
    }

    if (fetchPolicy == GqlFetchPolicy.networkOnly) {
      queryResult = await _graphQlClient().query(options);
      if (queryResult.hasException) {
        NetworkManager errorMessage = NetworkManager.fromGqlError(queryResult);
        log(errorMessage.message.toString());
        cacheData = GqlCacheManager().getCacheManager(query);
        return cacheData;
      }

      await GqlCacheManager().cacheData(
        queryResult.data,
        query,
        cacheDuration,
      );
      cacheData = GqlCacheManager().getCacheManager(query);
      return cacheData;
    }
  }

  ///base method for post GraphqlData
  Future<dynamic> post(
    String query,
    Map<String, dynamic> variables,
    bool cache, {
    Map<String, String>? header,
    // String? accessToken,
    //Other parameter for setting graphQL
  }) async {
    //get graphQlData
    try {
      QueryResult queryResult = await _graphQlClient().mutate(
        MutationOptions(
          document: gql(query),
          variables: variables,
        ),
      );
      return queryResult.data;
    } catch (e) {
      throw e;
    }
  }


  // pollInterval(QueryResult queryResult) async {
  //   Future.delayed(
  //     Duration(seconds: interval),
  //     () async {
  //       function;
  //     },
  //   );
  // }
}

///The default fetchPolicy are:
/// `FetchPolicy.networkOnly`
enum GqlFetchPolicy {
  /// Return result from cache. Only fetch from network if cached result is not available.
  cacheFirst,

  /// Return result from network and save to cache.
  networkOnly,
}
