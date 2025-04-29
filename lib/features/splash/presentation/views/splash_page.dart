import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:task_manager_app/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:task_manager_app/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      context.read<SplashCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext cnt) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.status == SplashStatus.authenticated) {
          Navigator.pushReplacementNamed(context, '/tasks');
        } else if (state.status == SplashStatus.unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: PlatformScaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlatformCircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Task Manager',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
