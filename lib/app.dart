import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/views/login_page.dart';
import 'features/auth/presentation/views/signup_page.dart';
import 'features/splash/presentation/bloc/splash_cubit.dart';
import 'features/splash/presentation/views/splash_page.dart';
import 'features/tasks/presentation/bloc/tasks_cubit.dart';
import 'features/tasks/presentation/views/tasks_page.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/profile/presentation/views/profile_page.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => TasksCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: PlatformApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        material: (_, __) => MaterialAppData(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.lightTheme,
        ),
        cupertino: (_, __) => CupertinoAppData(
          theme: const CupertinoThemeData(
            primaryColor: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/tasks': (context) => const TasksPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
