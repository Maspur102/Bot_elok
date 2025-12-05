import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _keyCtrl = TextEditingController();
  final _instCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ai = Provider.of<AiService>(context, listen: false);
    _keyCtrl.text = ai.currentApiKey;
    _instCtrl.text = ai.currentInstruction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Config")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _keyCtrl, decoration: const InputDecoration(labelText: "Gemini API Key")),
            const SizedBox(height: 20),
            TextField(controller: _instCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Instruksi AI")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AiService>(context, listen: false).saveSettings(_keyCtrl.text, _instCtrl.text);
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}