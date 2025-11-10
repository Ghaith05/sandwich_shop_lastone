import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen shows fields and saves when valid',
      (WidgetTester tester) async {
    final Completer completer = Completer<dynamic>();

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              child: const Text('open'),
              onPressed: () async {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
                completer.complete(result);
              },
            ),
          ),
        );
      }),
    ));

    // open profile
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Fields exist
    expect(find.byKey(const Key('profile_name')), findsOneWidget);
    expect(find.byKey(const Key('profile_email')), findsOneWidget);
    expect(find.byKey(const Key('profile_phone')), findsOneWidget);
    expect(find.byKey(const Key('profile_address')), findsOneWidget);

    // Initially Save button should be disabled (empty fields)
    final Finder saveButton = find.byKey(const Key('profile_save'));
    expect(saveButton, findsOneWidget);
    ElevatedButton btn = tester.widget<ElevatedButton>(saveButton);
    expect(btn.onPressed, isNull);

    // Enter valid name and email
    await tester.enterText(find.byKey(const Key('profile_name')), 'Alice');
    await tester.enterText(
        find.byKey(const Key('profile_email')), 'alice@example.com');
    await tester.pumpAndSettle();

    // Save button should now be enabled
    btn = tester.widget<ElevatedButton>(saveButton);
    expect(btn.onPressed, isNotNull);

    // Tap save
    await tester.tap(saveButton);
    await tester.pump();

    // SnackBar appears (may appear more than once in test environment)
    expect(find.text('Profile saved'), findsWidgets);

    // Allow Navigator.pop to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    final result = await completer.future;
    expect(result, isA<Map>());
    expect(result['name'], 'Alice');
    expect(result['email'], 'alice@example.com');
  });
}
