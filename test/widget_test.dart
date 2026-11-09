import 'package:flutter_test/flutter_test.dart';
import 'package:teranusa/app.dart';

void main() {
  testWidgets('TeraNusa menampilkan halaman utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TeraNusa'), findsOneWidget);
  });
}
