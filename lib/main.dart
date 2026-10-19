import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  // Garante que os bindings do Flutter estejam inicializados antes de chamadas de sistema
  WidgetsFlutterBinding.ensureInitialized();

  // Força orientação retrato e modo de imersão de tela (Anti-distração)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const EduSecureApp());
}

class EduSecureApp extends StatelessWidget {
  const EduSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSecure Assessment',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}
