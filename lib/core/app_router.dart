import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/products/presentation/pages/product_list_page.dart';
import '../features/products/presentation/pages/product_detail_page.dart';
import '../features/orders/presentation/pages/order_list_page.dart';
import '../features/orders/presentation/pages/order_detail_page.dart';
import '../features/orders/presentation/pages/tracking_page.dart';
import '../features/articles/presentation/pages/article_list_page.dart';
import '../features/articles/presentation/pages/article_detail_page.dart';
import '../features/chat/presentation/pages/chat_list_page.dart';
import '../features/chat/presentation/pages/chat_detail_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Authentication
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main Navigation
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // Products
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: '/products/:id',
        name: 'product_detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailPage(productId: productId);
        },
      ),
      
      // Orders
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrderListPage(),
      ),
      GoRoute(
        path: '/orders/:id',
        name: 'order_detail',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:id/tracking',
        name: 'tracking',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return TrackingPage(orderId: orderId);
        },
      ),
      
      // Articles
      GoRoute(
        path: '/articles',
        name: 'articles',
        builder: (context, state) => const ArticleListPage(),
      ),
      GoRoute(
        path: '/articles/:id',
        name: 'article_detail',
        builder: (context, state) {
          final articleId = state.pathParameters['id']!;
          return ArticleDetailPage(articleId: articleId);
        },
      ),
      
      // Chat
      GoRoute(
        path: '/chat',
        name: 'chat_list',
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chat_detail',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return ChatDetailPage(chatId: chatId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}