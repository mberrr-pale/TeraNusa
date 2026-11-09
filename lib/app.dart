
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeraNusa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TeraNusa'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    const SupabaseConnectionTestPage(),
              ),
            );
          },
          child: const Text('Uji Koneksi Supabase'),
        ),
      ),
    );
  }
}

class SupabaseConnectionTestPage extends StatefulWidget {
  const SupabaseConnectionTestPage({super.key});

  @override
  State<SupabaseConnectionTestPage> createState() =>
      _SupabaseConnectionTestPageState();
}

class _SupabaseConnectionTestPageState
    extends State<SupabaseConnectionTestPage> {
  late Future<List<Map<String, dynamic>>> _regionsFuture;

  @override
  void initState() {
    super.initState();
    _regionsFuture = _loadRegions();
  }

  Future<List<Map<String, dynamic>>> _loadRegions() async {
    final response = await Supabase.instance.client
        .from('regions')
        .select()
        .limit(5);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes Koneksi Supabase'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _regionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Koneksi atau pembacaan data gagal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final regions = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Permintaan ke Supabase berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Jumlah data yang diterima: ${regions.length}'),
                const SizedBox(height: 16),
                const Text(
                  'Data wilayah:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: regions.length,
                    itemBuilder: (context, index) {
                      final region = regions[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            region['village']?.toString() ?? '-',
                          ),
                          subtitle: Text(
                            '${region['district'] ?? '-'}, '
                            '${region['city'] ?? '-'}, '
                            '${region['province'] ?? '-'}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
