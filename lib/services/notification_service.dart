import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:intl/intl.dart';
import 'ai_service.dart';

class LogItem {
  final String sender, message, reply, time;
  LogItem(this.sender, this.message, this.reply, this.time);
}

class NotificationService extends ChangeNotifier {
  bool _isListening = false;
  List<LogItem> _logs = [];
  AiService? _aiService;

  bool get isListening => _isListening;
  List<LogItem> get logs => _logs;

  void setAiService(AiService ai) => _aiService = ai;

  Future<void> toggle() async {
    if (_isListening) {
      await NotificationsListener.stopService();
      _isListening = false;
    } else {
      bool? hasPermission = await NotificationsListener.hasPermission;
      if (!hasPermission!) {
        await NotificationsListener.openPermissionSettings();
        return;
      }
      await NotificationsListener.startService(
        title: "Elok AI Listening",
        description: "Scanning WhatsApp...",
      );
      _isListening = true;
      NotificationsListener.receivePort?.listen((evt) => _onData(evt));
    }
    notifyListeners();
  }

  void _onData(dynamic event) {
    // Karena keterbatasan background process di Flutter murni,
    // Kita simulasi logika di sini saat aplikasi terbuka.
    // Di real production, ini butuh isolat native yang kompleks.
    print("Notifikasi masuk: $event");
  }

  Future<void> processManual(String sender, String msg) async {
    if (_aiService == null) return;
    String reply = await _aiService!.getReply(msg);
    _logs.insert(0, LogItem(sender, msg, reply, DateFormat('HH:mm').format(DateTime.now())));
    notifyListeners();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationEvent evt) {}