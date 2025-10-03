import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/app_router.dart';
import '../../../../core/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF2E7D32),
                            child: Text(
                              state.user.fullName?.isNotEmpty == true
                                  ? state.user.fullName![0].toUpperCase()
                                  : state.user.email[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Name
                          Text(
                            state.user.fullName ?? 'Tidak ada nama',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          
                          // Email
                          Text(
                            state.user.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Role badge
                          Chip(
                            label: Text(_getRoleDisplayName(state.user.role ?? 'user')),
                            backgroundColor: const Color(0xFFE8F5E9),
                            labelStyle: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          // Email verification status
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                state.user.isEmailVerified
                                    ? Icons.verified
                                    : Icons.pending,
                                color: state.user.isEmailVerified
                                    ? Colors.green
                                    : Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                state.user.isEmailVerified
                                    ? 'Email Terverifikasi'
                                    : 'Email Belum Diverifikasi',
                                style: TextStyle(
                                  color: state.user.isEmailVerified
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Profile information
                  Card(
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Informasi Pribadi'),
                          subtitle: Text('Kelola informasi profil Anda'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Nomor Telepon'),
                          subtitle: Text(
                            state.user.phoneNumber ?? 'Belum diisi',
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            // TODO: Implement edit phone number
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Alamat'),
                          subtitle: Text(
                            state.user.address ?? 'Belum diisi',
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            // TODO: Implement edit address
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Settings
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notifikasi'),
                          subtitle: const Text('Kelola preferensi notifikasi'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Implement notification settings
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.security),
                          title: const Text('Keamanan'),
                          subtitle: const Text('Ubah password dan keamanan'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Implement security settings
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Bantuan'),
                          subtitle: const Text('FAQ dan dukungan'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Implement help
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('Tentang'),
                          subtitle: const Text('Versi dan informasi aplikasi'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Implement about
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          
          // If not authenticated
          return const Center(
            child: Text('Tidak ada data profil'),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const SignOut());
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case AppConstants.roleBuyer:
        return 'Pembeli';
      case AppConstants.roleSupplier:
        return 'Pemasok';
      case AppConstants.roleDriver:
        return 'Kurir';
      default:
        return 'Pengguna';
    }
  }
}