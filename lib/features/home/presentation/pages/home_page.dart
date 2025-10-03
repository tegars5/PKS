import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/app_router.dart';
import '../../../../core/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PalmShell Tracker - ${_getRoleDisplayName(state.user.role ?? 'user')}'),
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // TODO: Implement notifications
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'profile') {
                      context.goNamed('profile');
                    } else if (value == 'logout') {
                      context.read<AuthBloc>().add(const SignOut());
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text('Profil'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Keluar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: _buildPages(state.user),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF2E7D32),
              unselectedItemColor: const Color(0xFF757575),
              items: _buildBottomNavItems(state.user.role ?? 'user'),
            ),
          );
        }
        
        // If not authenticated, show loading
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  List<Widget> _buildPages(AuthUser user) {
    switch (user.role ?? 'user') {
      case AppConstants.roleBuyer:
        return [
          _buildBuyerDashboard(),
          _buildProductsPage(),
          _buildOrdersPage(),
          _buildArticlesPage(),
        ];
      case AppConstants.roleSupplier:
        return [
          _buildSupplierDashboard(),
          _buildProductsPage(),
          _buildOrdersPage(),
          _buildArticlesPage(),
        ];
      case AppConstants.roleDriver:
        return [
          _buildDriverDashboard(),
          _buildOrdersPage(),
          _buildArticlesPage(),
        ];
      default:
        return [
          _buildBuyerDashboard(),
          _buildProductsPage(),
          _buildOrdersPage(),
          _buildArticlesPage(),
        ];
    }
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(String role) {
    switch (role) {
      case AppConstants.roleBuyer:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Produk',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ];
      case AppConstants.roleSupplier:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produk',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ];
      case AppConstants.roleDriver:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Pengiriman',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ];
      default:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Produk',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ];
    }
  }

  Widget _buildBuyerDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 100,
            color: Color(0xFF2E7D32),
          ),
          SizedBox(height: 16),
          Text(
            'Dashboard Pembeli',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jelajahi dan beli cangkang kelapa sawit berkualitas',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 100,
            color: Color(0xFF2E7D32),
          ),
          SizedBox(height: 16),
          Text(
            'Dashboard Pemasok',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kelola produk dan pantau pesanan Anda',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping,
            size: 100,
            color: Color(0xFF2E7D32),
          ),
          SizedBox(height: 16),
          Text(
            'Dashboard Kurir',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kelola pengiriman dan update lokasi',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsPage() {
    return const Center(
      child: Text(
        'Halaman Produk',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildOrdersPage() {
    return const Center(
      child: Text(
        'Halaman Pesanan',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildArticlesPage() {
    return const Center(
      child: Text(
        'Halaman Artikel',
        style: TextStyle(fontSize: 24),
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