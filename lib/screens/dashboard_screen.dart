import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart'; // Import service AI
import '../services/notification_service.dart'; // Import service Notifikasi
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- BAGIAN PENTING (INJECTION) ---
    // Kita ambil service AI
    final aiService = Provider.of<AiService>(context, listen: false);
    
    // Kita masukkan service AI ke dalam service Notifikasi
    // Agar Notifikasi bisa memerintahkan AI untuk membalas pesan
    Provider.of<NotificationService>(context, listen: false).setAiService(aiService);
    // ----------------------------------

    // Ambil state notifikasi untuk update tampilan UI (listen: true)
    final notif = Provider.of<NotificationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ELOK AI DASHBOARD"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const SettingsScreen())
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // KARTU STATUS (HIJAU/MERAH)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: notif.isListening 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                border: Border.all(
                  color: notif.isListening ? Colors.green : Colors.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif.isListening ? "SYSTEM ACTIVE" : "SYSTEM OFFLINE",
                        style: TextStyle(
                          color: notif.isListening ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notif.isListening ? "Listening for WhatsApp..." : "Touch switch to start",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: notif.isListening,
                    activeColor: Colors.green,
                    onChanged: (_) => notif.toggle(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // TOMBOL SIMULASI MANUAL
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => notif.processManual("Test User", "Halo Elok, apa kabar?"),
                icon: const Icon(Icons.message),
                label: const Text("Simulasi Pesan Masuk (Test AI)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const Divider(height: 30, color: Colors.white24),
            
            // JUDUL LOG
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("LIVE LOGS:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),

            // DAFTAR LOG PESAN
            Expanded(
              child: notif.logs.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada aktivitas...", 
                        style: TextStyle(color: Colors.white30),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notif.logs.length,
                      itemBuilder: (ctx, i) {
                        final log = notif.logs[i];
                        return Card(
                          color: Colors.white10,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      log.sender, 
                                      style: const TextStyle(
                                        color: Colors.greenAccent, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    Text(
                                      log.time, 
                                      style: const TextStyle(color: Colors.grey, fontSize: 12)
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "User: ${log.message}", 
                                  style: const TextStyle(color: Colors.white70)
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border(left: BorderSide(color: Colors.blueAccent, width: 2))
                                  ),
                                  child: Text(
                                    "AI: ${log.reply}", 
                                    style: const TextStyle(color: Colors.white)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}