import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_router.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await supabase.Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(PalmShellTrackerApp(
    sharedPreferences: sharedPreferences,
  ));
}

class PalmShellTrackerApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  
  const PalmShellTrackerApp({
    super.key,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepositoryImpl(supabase.Supabase.instance.client),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepositoryImpl(supabase.Supabase.instance.client),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
            )..add(const CheckAuthStatus()),
          ),
        ],
        child: MaterialApp.router(
          title: 'PalmShell Tracker',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
