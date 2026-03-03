import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // URL açmak için gerekebilir, ama şimdilik manuel link vereceğiz

class UpdaterService {
  // SENİN GITHUB REPO BİLGİLERİN
  static const String _repoUrl = "https://raw.githubusercontent.com/frixionappstore/arc_raiders_tracker/main/version.json";
  static const String _downloadUrl = "https://github.com/frixionappstore/arc_raiders_tracker/releases/latest";

  // MEVCUT VERSİYON (Bunu her güncellemede artırmalıyız)
  static const double currentVersion = 1.04;

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(_repoUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double latestVersion = data['version'];
        final String updateNotes = data['notes'] ?? "Hata düzeltmeleri ve iyileştirmeler.";

        if (latestVersion > currentVersion) {
          if (context.mounted) {
            _showUpdateDialog(context, latestVersion.toString(), updateNotes);
          }
        }
      }
    } catch (e) {
      debugPrint("Güncelleme kontrolü başarısız: $e");
    }
  }

  static void _showUpdateDialog(BuildContext context, String version, String notes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Colors.orangeAccent),
            SizedBox(width: 10),
            Text("GÜNCELLEME VAR!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Yeni sürüm hazır: v$version", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Neler Yeni:", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            Text(notes, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 20),
            const Text("Güncellemek için lütfen GitHub'dan en son APK'yı indirin.", style: TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("DAHA SONRA", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // URL'yi tarayıcıda açmak için sistem (Gerçek linke gider)
              // Şimdilik linki gösteriyoruz
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("İndirme sayfası tarayıcıda açılıyor...")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black),
            child: const Text("ŞİMDİ İNDİR"),
          ),
        ],
      ),
    );
  }
}
