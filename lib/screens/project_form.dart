import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _description = '';
  String _category = 'Web Development';
  String _technologies = '';
  String _projectLink = '';

  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Proyek: $_projectName'),
              Text('Deskripsi: $_description'),
              Text('Kategori: $_category'),
              Text('Teknologi: $_technologies'),
              Text('Tautan: $_projectLink'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _formKey.currentState!.reset();
              setState(() {
                _projectName = '';
                _description = '';
                _category = 'Web Development';
                _technologies = '';
                _projectLink = '';
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration('Nama Proyek'),
                  onChanged: (value) => _projectName = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Nama proyek tidak boleh kosong!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _decoration('Deskripsi Proyek'),
                  onChanged: (value) => _description = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Deskripsi proyek tidak boleh kosong!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration('Kategori Proyek'),
                  initialValue: _categories.first,
                  isExpanded: true,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration(
                    'Teknologi yang Digunakan',
                    hint: 'Contoh: Flutter, Django, Figma',
                  ),
                  onChanged: (value) => _technologies = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration(
                    'Tautan Proyek',
                    hint: 'URL Proyek (opsional)',
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) => _projectLink = value,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveProject,
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
