import 'package:flutter/material.dart';
import 'package:habit_tracker/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final TextEditingController _habitController = TextEditingController();
  List<Habit> _habits = [];
  int _currentIndex = 0;
  bool _isDarkMode = false;

  String _selectedMood = 'Senang'; // Default mood

  void _addHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        _habits.add(Habit(name: _habitController.text, date: DateTime.now()));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kebiasaan "${_habitController.text}" ditambahkan!')),
      );
      _habitController.clear();
    }
  }

  void _toggleHabitStatus(int index) {
    setState(() {
      _habits[index].isCompleted = !_habits[index].isCompleted;
    });
  }

  void _removeHabit(int index) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kebiasaan "${_habits[index].name}" dihapus!')),
      );
      _habits.removeAt(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: Colors.orange,
      ),
      drawer: _buildDrawer(),
   body: _currentIndex == 0 
    ? _buildHome() 
    : (_currentIndex == 1 ? _buildInspiration() : _buildSettings()),

      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _addHabit,
              child: const Icon(Icons.add),
              backgroundColor: Colors.orange,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_sharp),
            label: 'Inspirasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          )
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        onTap: _onPageChanged,
      ),
    );
  }

  Widget _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://raw.githubusercontent.com/yanuarferiyanto/gambar-aset/refs/heads/main/IMG_20201120_093357.jpg',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Yanuar Feriyanto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Beranda'),
          onTap: () {
            Navigator.pop(context);
            _onPageChanged(0);
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Riwayat'),
          onTap: () {
            Navigator.pop(context);
            // Implementasikan navigasi ke riwayat jika diperlukan
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Keluar'),
          onTap: () {
            _showExitDialog();
          },
        ),
      ],
    ),
  );
}

void _showExitDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: const Text('Batal'),
          ),
         TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ); // Arahkan ke halaman login
              },
              child: const Text('Keluar'),
            ),
          ],

      );
    },
  );
}


  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            'Total Kebiasaan: ${_habits.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Kebiasaan Selesai: ${_habits.where((habit) => habit.isCompleted).length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      _habits[index].name,
                      style: TextStyle(
                        decoration: _habits[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Ditambahkan pada: ${_habits[index].date.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _habits[index].isCompleted
                                ? Icons.check_circle
                                : Icons.circle,
                            color: _habits[index].isCompleted
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: () => _toggleHabitStatus(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeHabit(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _habitController,
              decoration: InputDecoration(
                labelText: 'Tambahkan kebiasaan baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


//menu inspirasi
Widget _buildInspiration() {
  final List<Map<String, String>> inspirations = [
    {
      'highlight': 'Mulailah hari dengan bersyukur.',
      'detail': 'Ketika kamu bersyukur, kamu menciptakan suasana hati yang positif dan semangat untuk menjalani hari.'
    },
    {
      'highlight': 'Konsistensi adalah kunci untuk kebiasaan baik.',
      'detail': 'Dengan konsistensi, kamu bisa membangun kebiasaan yang berdampak besar pada kehidupanmu dalam jangka panjang.'
    },
    {
      'highlight': 'Setiap langkah kecil membawa perubahan besar.',
      'detail': 'Jangan remehkan langkah kecil, karena mereka adalah fondasi untuk perubahan besar di masa depan.'
    },
    {
      'highlight': 'Berhenti menunda, mulai sekarang!',
      'detail': 'Semakin lama kamu menunda, semakin jauh kamu dari tujuan. Mulailah sekarang, sekecil apapun aksimu.'
    },
    {
      'highlight': 'Kamu lebih kuat dari yang kamu pikirkan.',
      'detail': 'Terkadang kamu meragukan dirimu sendiri, tetapi kamu memiliki kekuatan yang lebih besar dari yang kamu sadari.'
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView.builder(
      itemCount: inspirations.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          leading: const Icon(
            Icons.lightbulb_outline,
            color: Colors.orange,
          ),
          title: Text(
            inspirations[index]['highlight']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                inspirations[index]['detail']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}




//menu pengaturan
Widget _buildSettings() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Notifikasi
        SwitchListTile(
          title: const Text('Notifikasi'),
          subtitle: const Text('Aktifkan atau nonaktifkan notifikasi harian'),
          value: _isNotificationEnabled,
          onChanged: (bool value) {
            setState(() {
              _isNotificationEnabled = value;
            });
          },
        ),
        const Divider(),

        // Bahasa yang Digunakan
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Bahasa'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showLanguageDialog(),
        ),
        const Divider(),

        // Tema yang Dipakai
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Tema'),
          subtitle: Text(_selectedTheme),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showThemeDialog(),
        ),
        const Divider(),

        // Cadangkan dan Pemulihan
        ListTile(
          title: const Text('Cadangkan Data'),
          leading: const Icon(Icons.backup),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cadangan berhasil dibuat!')),
            );
          },
        ),

        ListTile(
          title: const Text('Pulihkan Data'),
          leading: const Icon(Icons.restore),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil dipulihkan!')),
            );
          },
        ),
      ],
    ),
  );
}

// Dialog untuk memilih bahasa
void _showLanguageDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text('Indonesia'),
              value: 'Indonesia',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

// Dialog untuk memilih tema
void _showThemeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text('Tema Terang'),
              value: 'Terang',
              groupValue: _selectedTheme,
              onChanged: (String? value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Tema Gelap'),
              value: 'Gelap',
              groupValue: _selectedTheme,
              onChanged: (String? value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}


}

// Variabel untuk notifikasi, bahasa, dan tema
bool _isNotificationEnabled = true;
String _selectedLanguage = 'Indonesia';
String _selectedTheme = 'Default';

// 



class _showLanguageDialog {
}

class _showThemeDialog {
} 
class Habit {
  String name;
  DateTime date;
  bool isCompleted;

  Habit({required this.name, required this.date, this.isCompleted = false});
}