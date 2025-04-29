// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/app.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:task_manager_app/features/auth/domain/user.dart';

void main() {
  testWidgets('App should start with login page', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that we start at the login page
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('App should navigate to signup page', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Tap the create account button
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // Verify that we're on the signup page
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('App should navigate to tasks page after login', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Mock successful login
    final authCubit = AuthCubit();
    authCubit.emit(AuthState(
      status: AuthStatus.authenticated,
      user: User(
        id: '1',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      ),
    ));

    // Pump the widget with the new state
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider(create: (_) => TasksCubit()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that we're on the tasks page
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });

  testWidgets('Tasks page should show add task button', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Mock authenticated state
    final authCubit = AuthCubit();
    authCubit.emit(AuthState(
      status: AuthStatus.authenticated,
      user: User(
        id: '1',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      ),
    ));

    // Pump the widget with the new state
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider(create: (_) => TasksCubit()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that the add task button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Profile page should show user info and sign out button', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Mock authenticated state
    final authCubit = AuthCubit();
    authCubit.emit(AuthState(
      status: AuthStatus.authenticated,
      user: User(
        id: '1',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      ),
    ));

    // Pump the widget with the new state
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider(create: (_) => TasksCubit()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to profile page
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify profile page elements
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });
}
