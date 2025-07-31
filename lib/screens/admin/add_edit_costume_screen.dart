import 'package:flutter/material.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:provider/provider.dart';

class AddEditCostumeScreen extends StatefulWidget {
  final Costume? costume;

  const AddEditCostumeScreen({super.key, this.costume});

  @override
  State<AddEditCostumeScreen> createState() => _AddEditCostumeScreenState();
}

class _AddEditCostumeScreenState extends State<AddEditCostumeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _imageUrl;
  late String _description;
  late String _size;
  late int _price;
  // --- TAMBAHAN: State untuk kategori ---
  late String _category;

  @override
  void initState() {
    super.initState();
    if (widget.costume != null) {
      _name = widget.costume!.name;
      _imageUrl = widget.costume!.imageUrl;
      _description = widget.costume!.description;
      _size = widget.costume!.size;
      _price = widget.costume!.price;
      _category = widget.costume!.category; // Ambil kategori yang ada
    } else {
      _name = '';
      _imageUrl = '';
      _description = '';
      _size = '';
      _price = 0;
      _category = 'Baju'; // Default kategori saat menambah baru
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final costumeProvider = Provider.of<CostumeProvider>(context, listen: false);

      final costumeData = Costume(
        id: widget.costume?.id ?? '', // ID akan dibuat di provider jika baru
        name: _name,
        imageUrl: _imageUrl,
        description: _description,
        size: _size,
        price: _price,
        rating: widget.costume?.rating ?? 0,
        reviewCount: widget.costume?.reviewCount ?? 0,
        isAvailable: widget.costume?.isAvailable ?? true,
        category: _category, // <-- PERBAIKAN: Masukkan kategori
      );

      if (widget.costume == null) {
        costumeProvider.addCostume(costumeData);
      } else {
        costumeProvider.updateCostume(costumeData);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.costume == null ? 'Tambah Item' : 'Edit Item'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nama Item'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                onSaved: (value) => _name = value!,
              ),
              // --- TAMBAHAN: Dropdown untuk Kategori ---
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: ['Baju', 'Aksesoris']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) => value!.isEmpty ? 'URL Gambar tidak boleh kosong' : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _size,
                decoration: const InputDecoration(labelText: 'Ukuran (S, M, L, dll)'),
                validator: (value) => value!.isEmpty ? 'Ukuran tidak boleh kosong' : null,
                onSaved: (value) => _size = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Harga Sewa'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty || int.tryParse(value) == null ? 'Harga harus berupa angka' : null,
                onSaved: (value) => _price = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}