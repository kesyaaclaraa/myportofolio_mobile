import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> save(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Save'));
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Menu preserves identity and snackbar actions', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Kesya Clara Dania'), findsOneWidget);
    expect(find.text('2506656892'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);
    for (final label in ['Lihat Proyek', 'Logout']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add button pushes form and system back returns to menu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!'),
      findsOneWidget,
    );
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isTrue,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Drawer replaces routes in both directions and closes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openDrawer(tester);
    expect(
      find.text('Explore personal projects and experiences!'),
      findsOneWidget,
    );
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });

  testWidgets('Required fields reject empty and whitespace input', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '   ');
    await tester.enterText(fields.at(1), '   ');
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Dialog shows all inputs and OK resets next submission', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portofolio Kesya');
    await tester.enterText(fields.at(1), 'Aplikasi portofolio pribadi');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    for (final category in [
      'Web Development',
      'Mobile Development',
      'Machine Learning',
      'Data Science',
      'Other',
    ]) {
      expect(find.text(category), findsWidgets);
    }
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(2), 'Flutter, Django');
    await tester.enterText(fields.at(3), 'https://example.com/portfolio');
    await save(tester);
    for (final text in [
      'Proyek berhasil ditambahkan!',
      'Nama Proyek: Portofolio Kesya',
      'Deskripsi: Aplikasi portofolio pribadi',
      'Kategori: Mobile Development',
      'Teknologi: Flutter, Django',
      'Tautan: https://example.com/portfolio',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    for (final editable in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(editable.controller.text, isEmpty);
    }
    expect(find.text('Web Development'), findsOneWidget);
    await tester.enterText(fields.at(0), 'Proyek kedua');
    await tester.enterText(fields.at(1), 'Deskripsi kedua');
    await save(tester);
    expect(find.text('Nama Proyek: Proyek kedua'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('Narrow screen supports scrolling without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
