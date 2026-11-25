import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

import 'helpers.dart';

Map<String, dynamic> projectJson({
  String id = 'p1',
  String title = 'Portfolio',
  String imageUrl = '',
}) => {
  'id': id,
  'title': title,
  'description': 'Personal website',
  'category': 'web',
  'link': 'https://example.com',
  'tech_stack': 'Django, Flutter',
  'project_image_url': imageUrl,
};

Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).last);
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester, {String password = 'secret'}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'owner');
  await tester.enterText(fields.at(1), password);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> fillProjectForm(WidgetTester tester, List<String> values) async {
  final fields = find.byType(TextFormField);
  for (var i = 0; i < values.length; i++) {
    await tester.enterText(fields.at(i), values[i]);
  }
}

void main() {
  group('Project model', () {
    test('maps snake_case JSON and tolerates missing optional fields', () {
      final project = Project.fromJson({
        'id': 'abc',
        'title': 'T',
        'description': 'D',
        'link': null,
      });
      expect(project.id, 'abc');
      expect(project.techStack, '');
      expect(project.projectUrl, '');
      expect(project.projectImageUrl, '');
    });

    test('toJson excludes the server-generated id', () {
      const project = Project(
        id: 'abc',
        title: 'T',
        description: 'D',
        techStack: 'Dart',
        projectUrl: 'https://x.dev',
      );
      expect(project.toJson(), {
        'title': 'T',
        'description': 'D',
        'tech_stack': 'Dart',
        'link': 'https://x.dev',
        'project_image_url': '',
      });
    });
  });

  testWidgets('Menu shows identity and Login/Logout follows auth state', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(backend.app());
    expect(find.text('Kesya Clara Dania'), findsOneWidget);
    expect(find.text('2506656892'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);
    expect(find.text('Logout'), findsNothing);

    await tapText(tester, 'Login');
    expect(find.byType(LoginScreen), findsOneWidget);
    await login(tester);
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.text('Login berhasil!'), findsOneWidget);

    await tapText(tester, 'Logout');
    expect(find.text('Kamu telah logout.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    final logoutRequest = backend.requests.last;
    expect(logoutRequest.url.path, '/api/v1/auth/logout/');
    expect(logoutRequest.headers['Authorization'], 'Token $validToken');
  });

  testWidgets('Login validates fields and reports wrong credentials', (
    tester,
  ) async {
    await tester.pumpWidget(FakeBackend().app());
    await tapText(tester, 'Login');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Username cannot be empty!'), findsOneWidget);
    expect(find.text('Password cannot be empty!'), findsOneWidget);

    await login(tester, password: 'wrong');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      find.text('Username atau password salah (HTTP 400).'),
      findsOneWidget,
    );
  });

  testWidgets('Add Project redirects guests to login, then opens the form', (
    tester,
  ) async {
    await tester.pumpWidget(FakeBackend().app());
    await tapText(tester, 'Tambah Proyek');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);

    // Backing out of login leaves the user on the menu.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);

    await tapText(tester, 'Tambah Proyek');
    await login(tester);
    expect(find.byType(ProjectFormPage), findsOneWidget);
  });

  testWidgets('Logged-in user opens the form directly from the drawer', (
    tester,
  ) async {
    await tester.pumpWidget(FakeBackend().app(initialToken: validToken));
    await openDrawer(tester);
    await tapText(tester, 'Add Project');
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    await openDrawer(tester);
    await tapText(tester, 'Home');
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Project list loads from the API without login', (tester) async {
    final backend = FakeBackend(
      projects: [
        projectJson(),
        projectJson(id: 'p2', title: 'Second', imageUrl: 'https://img.test/a'),
      ],
    );
    await tester.pumpWidget(backend.app());
    await tapText(tester, 'Lihat Proyek');
    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(find.text('Django, Flutter'), findsNWidgets(2));
    expect(backend.requests.single.headers['Authorization'], isNull);

    await tapText(tester, 'Portfolio');
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('https://example.com'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Detail screen shows the image only when a URL is present', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProjectDetailScreen(
          project: Project.fromJson(
            projectJson(imageUrl: 'https://img.test/a'),
          ),
        ),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Project list shows errors with retry and an empty state', (
    tester,
  ) async {
    final backend = FakeBackend()..failProjectList = true;
    await tester.pumpWidget(backend.app());
    await tapText(tester, 'Lihat Proyek');
    expect(find.textContaining('HTTP 500'), findsOneWidget);

    backend.failProjectList = false;
    await tapText(tester, 'Retry');
    expect(find.text('No projects found.'), findsOneWidget);
    expect(backend.requests, hasLength(2));
  });

  testWidgets('Project form validates required fields and URLs', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(backend.app(initialToken: validToken));
    await openDrawer(tester);
    await tapText(tester, 'Add Project');
    await tapText(tester, 'Save');
    for (final label in ['Title', 'Description', 'Tech Stack', 'Project URL']) {
      expect(find.text('$label tidak boleh kosong!'), findsOneWidget);
    }
    await fillProjectForm(tester, ['T', 'D', 'Dart', 'not a url', 'ftp://x']);
    await tapText(tester, 'Save');
    expect(
      find.text('Masukkan URL yang valid (http:// atau https://)!'),
      findsNWidgets(2),
    );
    expect(backend.requests, isEmpty);
  });

  testWidgets('Project form POSTs with token and confirms creation', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(backend.app(initialToken: validToken));
    await openDrawer(tester);
    await tapText(tester, 'Add Project');
    await fillProjectForm(tester, [
      ' MyPortfolio ',
      'Aplikasi portofolio',
      'Flutter, Django',
      'https://github.com/kesya/portfolio',
    ]);
    await tapText(tester, 'Save');

    final request = backend.requests.single;
    expect(request.method, 'POST');
    expect(request.headers['Authorization'], 'Token $validToken');
    expect(jsonDecode(request.body), {
      'title': 'MyPortfolio',
      'description': 'Aplikasi portofolio',
      'tech_stack': 'Flutter, Django',
      'link': 'https://github.com/kesya/portfolio',
      'project_image_url': '',
    });
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Tech Stack: Flutter, Django'), findsOneWidget);

    await tapText(tester, 'OK');
    expect(find.byType(AlertDialog), findsNothing);
    for (final editable in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(editable.controller.text, isEmpty);
    }
  });

  testWidgets('Expired token (401) logs out and asks to log in again', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(backend.app(initialToken: 'expired'));
    await openDrawer(tester);
    await tapText(tester, 'Add Project');
    await fillProjectForm(tester, ['T', 'D', 'Dart', 'https://x.dev']);
    await tapText(tester, 'Save');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sesi berakhir, silakan login kembali.'), findsOneWidget);

    await login(tester);
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await tapText(tester, 'Save');
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
  });

  testWidgets('Non-owner (403) sees an error and stays on the form', (
    tester,
  ) async {
    final backend = FakeBackend(createStatus: 403);
    await tester.pumpWidget(backend.app(initialToken: validToken));
    await openDrawer(tester);
    await tapText(tester, 'Add Project');
    await fillProjectForm(tester, ['T', 'D', 'Dart', 'https://x.dev']);
    await tapText(tester, 'Save');
    expect(
      find.text('Akun ini tidak punya izin menambah proyek (HTTP 403).'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ProjectFormPage), findsOneWidget);
  });

  testWidgets('Narrow screen renders menu and form without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(FakeBackend().app(initialToken: validToken));
    expect(tester.takeException(), isNull);
    await tapText(tester, 'Tambah Proyek');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tapText(tester, 'Save');
    expect(find.text('Title tidak boleh kosong!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
