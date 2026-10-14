import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Model sederhana untuk satu tugas
class Todo {
  String judul;
  bool selesai;

  Todo(this.judul, {this.selesai = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HalamanUtama(),
    );
  }
}

// Halaman utama yang menyimpan data tugas dan bar navigasi bawah
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int halamanAktif = 0;
  final List<Todo> daftarTugas = [];

  void tambahTugas(String judul) {
    setState(() => daftarTugas.add(Todo(judul)));
  }

  void ubahStatus(Todo todo) {
    setState(() => todo.selesai = !todo.selesai);
  }

  void hapusTugas(Todo todo) {
    setState(() => daftarTugas.remove(todo));
  }

  @override
  Widget build(BuildContext context) {
    final belumSelesai = daftarTugas.where((t) => !t.selesai).toList();
    final sudahSelesai = daftarTugas.where((t) => t.selesai).toList();

    final halaman = [
      HalamanTugas(
        tugas: belumSelesai,
        onTambah: tambahTugas,
        onCentang: ubahStatus,
        onHapus: hapusTugas,
      ),
      HalamanSelesai(
        tugas: sudahSelesai,
        onCentang: ubahStatus,
        onHapus: hapusTugas,
      ),
      HalamanProfil(
        total: daftarTugas.length,
        selesai: sudahSelesai.length,
      ),
    ];

    return Scaffold(
      body: halaman[halamanAktif],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: halamanAktif,
        onTap: (index) => setState(() => halamanAktif = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Selesai'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// Halaman 1: daftar tugas yang belum selesai + tombol tambah
class HalamanTugas extends StatelessWidget {
  final List<Todo> tugas;
  final void Function(String) onTambah;
  final void Function(Todo) onCentang;
  final void Function(Todo) onHapus;

  const HalamanTugas({
    super.key,
    required this.tugas,
    required this.onTambah,
    required this.onCentang,
    required this.onHapus,
  });

  void tampilkanDialogTambah(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Tugas'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nama tugas'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onTambah(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: DaftarTodo(
        tugas: tugas,
        pesanKosong: 'Belum ada tugas',
        onCentang: onCentang,
        onHapus: onHapus,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilkanDialogTambah(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Halaman 2: daftar tugas yang sudah selesai
class HalamanSelesai extends StatelessWidget {
  final List<Todo> tugas;
  final void Function(Todo) onCentang;
  final void Function(Todo) onHapus;

  const HalamanSelesai({
    super.key,
    required this.tugas,
    required this.onCentang,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Selesai')),
      body: DaftarTodo(
        tugas: tugas,
        pesanKosong: 'Belum ada tugas yang selesai',
        onCentang: onCentang,
        onHapus: onHapus,
      ),
    );
  }
}

// Halaman 3: profil sederhana dan ringkasan jumlah tugas
class HalamanProfil extends StatelessWidget {
  final int total;
  final int selesai;

  const HalamanProfil({super.key, required this.total, required this.selesai});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 16),
            const Text('Nama Saya', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            Text('Total tugas: $total'),
            Text('Selesai: $selesai'),
            Text('Belum selesai: ${total - selesai}'),
          ],
        ),
      ),
    );
  }
}

// Widget daftar yang dipakai di halaman Tugas dan Selesai
class DaftarTodo extends StatelessWidget {
  final List<Todo> tugas;
  final String pesanKosong;
  final void Function(Todo) onCentang;
  final void Function(Todo) onHapus;

  const DaftarTodo({
    super.key,
    required this.tugas,
    required this.pesanKosong,
    required this.onCentang,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    if (tugas.isEmpty) {
      return Center(child: Text(pesanKosong));
    }

    return ListView.builder(
      itemCount: tugas.length,
      itemBuilder: (context, index) {
        final todo = tugas[index];
        return ListTile(
          leading: Checkbox(
            value: todo.selesai,
            onChanged: (_) => onCentang(todo),
          ),
          title: Text(
            todo.judul,
            style: TextStyle(
              decoration: todo.selesai ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onHapus(todo),
          ),
        );
      },
    );
  }
}
