import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> submit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Simpan'));
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

Future<void> fill(WidgetTester tester, List<String> values) async {
  final fields = find.byType(TextFormField);
  for (var i = 0; i < values.length; i++) {
    await tester.enterText(fields.at(i), values[i]);
  }
}

Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Education card pushes form and device back returns home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isTrue,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Shared drawer opens education, projects, and home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openDrawer(tester);
    await tester.tap(find.text('Tambah Edukasi').last);
    await tester.pumpAndSettle();
    expect(find.byType(EducationFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    await openDrawer(tester);
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    await openDrawer(tester);
    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();
    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
  });

  testWidgets('Rejects missing, whitespace, long names and invalid years', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
    await submit(tester);
    for (final label in [
      'Nama institusi',
      'Program studi',
      'Tahun mulai',
      'Tahun selesai',
    ]) {
      expect(find.text('$label tidak boleh kosong!'), findsOneWidget);
    }
    await fill(tester, ['   ', '   ', '   ', '   ']);
    await submit(tester);
    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await fill(tester, ['x' * 101, 'x' * 101, 'abcd', '20.5']);
    await submit(tester);
    expect(find.text('Nama institusi maksimal 100 karakter!'), findsOneWidget);
    expect(find.text('Program studi maksimal 100 karakter!'), findsOneWidget);
    expect(
      find.text('Tahun mulai harus berupa 4 digit angka!'),
      findsOneWidget,
    );
    expect(
      find.text('Tahun selesai harus berupa 4 digit angka!'),
      findsOneWidget,
    );
    final year = DateTime.now().year;
    await fill(tester, ['Sekolah', 'IPA', '1899', '${year + 1}']);
    await submit(tester);
    expect(
      find.text('Tahun mulai harus antara 1900 dan $year!'),
      findsOneWidget,
    );
    expect(
      find.text('Tahun selesai harus antara 1900 dan $year!'),
      findsOneWidget,
    );
    await fill(tester, ['Sekolah', 'IPA', '2024', '2023']);
    await submit(tester);
    expect(
      find.text('Tahun selesai tidak boleh sebelum tahun mulai!'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'Valid submission shows all data and allows editing after close',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
      await fill(tester, [' Sekolah Kesya ', ' IPA ', '2022', '2025']);
      await submit(tester);
      for (final text in [
        'Edukasi berhasil ditambahkan!',
        'Institusi: Sekolah Kesya',
        'Program Studi: IPA',
        'Tahun Mulai: 2022',
        'Tahun Selesai: 2025',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      await fill(tester, ['Sekolah Baru', 'IPS', '2023', '2023']);
      await submit(tester);
      expect(find.text('Institusi: Sekolah Baru'), findsOneWidget);
      expect(find.text('Program Studi: IPS'), findsOneWidget);
      expect(find.text('Tahun Selesai: 2023'), findsOneWidget);
    },
  );

  testWidgets('Phone screen with keyboard inset keeps Save reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Edukasi'));
    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 240);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await fill(tester, ['Sekolah', 'IPA', '2022', '2025']);
    await submit(tester);
    expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
