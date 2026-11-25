import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const validToken = 'test-token';

/// In-memory stand-in for the Django API used by widget tests.
class FakeBackend {
  FakeBackend({List<Map<String, dynamic>>? projects, this.createStatus = 201})
    : projects = projects ?? [];

  final List<Map<String, dynamic>> projects;

  /// Status returned by POST /api/v1/projects/ when the token is valid.
  int createStatus;

  bool failProjectList = false;
  final List<http.Request> requests = [];

  late final ApiClient apiClient = ApiClient(
    client: MockClient(_handle),
    baseUrl: 'http://test',
  );

  MyApp app({String? initialToken}) =>
      MyApp(apiClient: apiClient, initialToken: initialToken);

  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    final authorized = request.headers['Authorization'] == 'Token $validToken';
    final route = '${request.method} ${request.url.path}';

    switch (route) {
      case 'GET /api/v1/projects/':
        if (failProjectList) return http.Response('boom', 500);
        return _json(projects);
      case 'POST /api/v1/projects/':
        if (!authorized) return _json({'detail': 'Invalid token.'}, 401);
        if (createStatus != 201) {
          return _json({'detail': 'error'}, createStatus);
        }
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final created = {'id': 'uuid-${projects.length}', ...body};
        projects.add(created);
        return _json(created, 201);
      case 'POST /api/v1/auth/token/':
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (body['username'] == 'owner' && body['password'] == 'secret') {
          return _json({'token': validToken});
        }
        return _json({
          'non_field_errors': ['Unable to log in.'],
        }, 400);
      case 'POST /api/v1/auth/logout/':
        return authorized
            ? http.Response('', 204)
            : _json({'detail': 'Invalid token.'}, 401);
    }
    return http.Response('Not found', 404);
  }

  static http.Response _json(Object body, [int status = 200]) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );
}
