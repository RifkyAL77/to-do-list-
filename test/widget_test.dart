import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist/main.dart';

void main() {
  testWidgets('Tambah tugas lalu tandai selesai', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Belum ada tugas'), findsOneWidget);

    // Tambah tugas baru
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Belajar Flutter');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Belajar Flutter'), findsOneWidget);

    // Centang tugas, lalu pindah ke halaman Selesai
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Belajar Flutter'), findsOneWidget);
  });
}
