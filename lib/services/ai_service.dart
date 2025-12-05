import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiService extends ChangeNotifier {
  String _apiKey = '';
  String _instruction = 'Jawab singkat dan sopan.';
  GenerativeModel? _model;

  AiService() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('api_key') ?? '';
    _instruction = prefs.getString('instruction') ?? _instruction;
    if (_apiKey.isNotEmpty) _initModel();
    notifyListeners();
  }

  void _initModel() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  Future<void> saveSettings(String key, String inst) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', key);
    await prefs.setString('instruction', inst);
    _apiKey = key;
    _instruction = inst;
    _initModel();
    notifyListeners();
  }

  String get currentApiKey => _apiKey;
  String get currentInstruction => _instruction;

  Future<String> getReply(String message) async {
    if (_model == null) return "AI Belum Aktif (Set API Key)";
    try {
      final content = [Content.text('$_instruction. Pesan: "$message".')];
      final res = await _model!.generateContent(content);
      return res.text ?? "...";
    } catch (e) {
      return "Error: $e";
    }
  }
}