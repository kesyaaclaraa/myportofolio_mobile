import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institution = TextEditingController();
  final _program = TextEditingController();
  final _startYear = TextEditingController();
  final _endYear = TextEditingController();

  @override
  void dispose() {
    _institution.dispose();
    _program.dispose();
    _startYear.dispose();
    _endYear.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong!';
    if (text.length > 100) return '$label maksimal 100 karakter!';
    return null;
  }

  String? _validateYear(String? value, {bool isEnd = false}) {
    final label = isEnd ? 'Tahun selesai' : 'Tahun mulai';
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong!';
    final year = int.tryParse(text);
    if (!RegExp(r'^\d{4}$').hasMatch(text) || year == null) {
      return '$label harus berupa 4 digit angka!';
    }
    if (year < 1900 || year > DateTime.now().year) {
      return '$label harus antara 1900 dan ${DateTime.now().year}!';
    }
    final start = int.tryParse(_startYear.text.trim());
    if (isEnd && start != null && year < start) {
      return 'Tahun selesai tidak boleh sebelum tahun mulai!';
    }
    return null;
  }

  void _saveEducation() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edukasi berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institusi: ${_institution.text.trim()}'),
              Text('Program Studi: ${_program.text.trim()}'),
              Text('Tahun Mulai: ${_startYear.text.trim()}'),
              Text('Tahun Selesai: ${_endYear.text.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    bool isYear = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: isYear ? 'Contoh: 2025' : label,
          border: const OutlineInputBorder(),
          errorMaxLines: 3,
        ),
        keyboardType: isYear ? TextInputType.number : TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Riwayat pendidikan yang telah diselesaikan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Semua kolom wajib diisi. Nama institusi dan program studi '
                'maksimal 100 karakter. Tahun harus antara 1900 dan tahun ini.',
              ),
              const SizedBox(height: 24),
              _field(
                label: 'Nama Institusi',
                controller: _institution,
                validator: (value) => _validateName(value, 'Nama institusi'),
              ),
              _field(
                label: 'Program Studi',
                controller: _program,
                validator: (value) => _validateName(value, 'Program studi'),
              ),
              _field(
                label: 'Tahun Mulai',
                controller: _startYear,
                isYear: true,
                validator: (value) => _validateYear(value),
              ),
              _field(
                label: 'Tahun Selesai',
                controller: _endYear,
                isYear: true,
                validator: (value) => _validateYear(value, isEnd: true),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveEducation,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
