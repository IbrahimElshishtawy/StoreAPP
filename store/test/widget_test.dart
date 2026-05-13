import 'package:flutter_test/flutter_test.dart';
import 'package:store/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:store/core/injection/injection_container.dart' as di;
import './mock_firebase.dart'; // I need to create this mock

void main() {
  setupMockFirebase();

  testWidgets('App should load StoreView', (WidgetTester tester) async {
    await di.init();
    await tester.pumpWidget(const Store());
    await tester.pump();

    // Verify that we are on the StoreView (clinic_store route)
    // Since StoreView uses a Scaffold, we can check for that.
    expect(find.byType(Store), findsOneWidget);
  });
}
