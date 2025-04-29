import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../bloc/profile_cubit.dart';
import '../../../../shared/utils/ui_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: UiConstants.subHeaderStyle,
        ),
        trailingActions: const [],
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.white,
          border: const Border(bottom: BorderSide(color: Colors.transparent)),
          automaticallyImplyLeading: true,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return Center(child: PlatformCircularProgressIndicator());
          }

          if (state.status == ProfileStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }

          if (state.status == ProfileStatus.signedOut) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const Center(child: Text('Signed out'));
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          return Container(
            padding: UiConstants.defaultPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.photoUrl != null ? NetworkImage(profile.photoUrl!) : null,
                        child: profile.photoUrl == null ? const Icon(Icons.person, size: 50) : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        profile.name,
                        style: UiConstants.headerStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        profile.email,
                        style: UiConstants.subHeaderStyle.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoSection(
                      'Account Info',
                      [
                        if (profile.lastLoginAt != null) _buildInfoRow('Last login', profile.lastLoginAt!),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, UiConstants.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiConstants.buttonBorderRadius),
                    ),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: UiConstants.buttonTextStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: UiConstants.subHeaderStyle,
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
