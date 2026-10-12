import 'package:flutter/material.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';
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
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text(widget.costume == null ? 'Tambah Item' : 'Edit Item',
            style: AppTheme.heading(20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: StudioBackground(
        showGlow: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.costume == null ? 'Tambah Kostum' : 'Ubah Kostum',
                  style: AppTheme.heading(24),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lengkapi detail kostum untuk inventaris studio.',
                  style: AppTheme.body(13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 26),
                _buildLabel('Nama Item'),
                TextFormField(
                  initialValue: _name,
                  style: AppTheme.body(14),
                  cursorColor: AppColors.primary,
                  validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 18),
                // Dropdown untuk Kategori
                _buildLabel('Kategori'),
                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: AppColors.cardDarkAlt,
                  style: AppTheme.body(14),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_rounded, color: AppColors.textMuted, size: 20),
                  ),
                  items: ['Baju', 'Aksesoris']
                      .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  onSaved: (value) => _category = value!,
                ),
                const SizedBox(height: 18),
                _buildLabel('URL Gambar'),
                TextFormField(
                  initialValue: _imageUrl,
                  style: AppTheme.body(14),
                  cursorColor: AppColors.primary,
                  validator: (value) => value!.isEmpty ? 'URL Gambar tidak boleh kosong' : null,
                  onSaved: (value) => _imageUrl = value!,
                ),
                const SizedBox(height: 18),
                _buildLabel('Deskripsi'),
                TextFormField(
                  initialValue: _description,
                  style: AppTheme.body(14),
                  cursorColor: AppColors.primary,
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 18),
                _buildLabel('Ukuran (S, M, L, dll)'),
                TextFormField(
                  initialValue: _size,
                  style: AppTheme.body(14),
                  cursorColor: AppColors.primary,
                  validator: (value) => value!.isEmpty ? 'Ukuran tidak boleh kosong' : null,
                  onSaved: (value) => _size = value!,
                ),
                const SizedBox(height: 18),
                _buildLabel('Harga Sewa'),
                TextFormField(
                  initialValue: _price.toString(),
                  style: AppTheme.body(14),
                  cursorColor: AppColors.primary,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: 'Rp ',
                    prefixIcon: Icon(Icons.payments_rounded, color: AppColors.textMuted, size: 20),
                  ),
                  validator: (value) =>
                  value!.isEmpty || int.tryParse(value) == null ? 'Harga harus berupa angka' : null,
                  onSaved: (value) => _price = int.parse(value!),
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Simpan',
                  icon: Icons.save_rounded,
                  onPressed: _saveForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label,
        style: AppTheme.body(12, color: AppColors.textSecondary, weight: FontWeight.w600),
      ),
    );
  }
}