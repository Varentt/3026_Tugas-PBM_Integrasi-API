import 'package:flutter/material.dart';
import '../services/product_service.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final githubController = TextEditingController();

  final ProductService service = ProductService();
  bool isLoading = false;

  Future<void> submit() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descController.text.isEmpty ||
        githubController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await service.submitTugas(
      nameController.text,
      int.parse(priceController.text),
      descController.text,
      githubController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submit berhasil')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submit gagal')),
      );
    }
  }

  InputDecoration inputStyle(String label, IconData icon) {
    const burgundy = Color(0xFF800020);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: burgundy),
      filled: true,
      fillColor: const Color(0xFFF7F3F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const burgundy = Color(0xFF800020);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F5),

      appBar: AppBar(
        backgroundColor: burgundy,
        centerTitle: true,
        title: const Text('Submit Tugas'),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.send, size: 50, color: burgundy),

                const SizedBox(height: 10),

                const Text(
                  'Submit Tugas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: burgundy,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: inputStyle('Nama Produk', Icons.shopping_bag),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: inputStyle('Harga', Icons.attach_money),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: inputStyle('Deskripsi', Icons.description),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: githubController,
                  decoration: inputStyle('GitHub URL', Icons.link),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'SUBMIT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}