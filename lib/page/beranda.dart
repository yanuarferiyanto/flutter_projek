import 'package:flutter/material.dart';
import 'package:habit_tracker/page/login.dart';
import 'package:habit_tracker/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class BerandaPage extends StatefulWidget {
  final String role;
  final String name;

  const BerandaPage({
    super.key,
    required this.role,
    required this.name,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Future<void> _logout() async {
    final loginProvider = Provider.of<AuthProvider>(context, listen: false); // Pastikan AuthProvider digunakan sesuai konteks

    try {
      final success = await loginProvider.logout();

      if (success) {
        // Navigasi ke LoginPage setelah logout
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        // Menampilkan pesan error jika logout gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("eror")),
        );
      }
    } catch (e) {
      // Menangani error lain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: ${widget.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${widget.role}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _logout();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthProvider {
  String? get errorMessage => null;

  get isLoading => null;
  
  logout() {}

  register(String trim, String trim2, String trim3) {}
}


