import 'package:flutter_test/flutter_test.dart';
import 'package:tezlapen_v2/app/app.dart';
import 'package:tezlapen_v2/src/product_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget( const App());
      expect(find.byType(ProductScreen), findsOneWidget);
    });
  });
}
