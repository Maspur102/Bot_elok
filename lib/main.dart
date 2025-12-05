import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/ai_service.dart';
import 'services/notification_service.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AiService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elok AI',
        home: DashboardScreen(),
      ),
    ),
  );
  // Inject AI ke Notification
  // Note: Di real app, gunakan ProxyProvider, tapi ini shortcut agar simple
  Future.delayed(Duration.zero, () {
    // Logic injection sederhana bisa ditaruh di sini jika pakai GlobalKey,
    // tapi karena stateless, kita inject di build Dashboard saja.
  });
}