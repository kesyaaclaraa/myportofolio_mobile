import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _techStack = TextEditingController();
  final _projectUrl = TextEditingController();
  final _projectImageUrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final controller in [
      _title,
      _description,
      _techStack,
      _projectUrl,
      _projectImageUrl,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      errorMaxLines: 3,
    );
  }

  static String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong!';
    }
    return null;
  }

  /// Accepts only absolute http(s) URLs, matching Django's URLField.
  static String? _validateUrl(String? value, {required bool required}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return required ? 'Project URL tidak boleh kosong!' : null;
    }
    final uri = Uri.tryParse(text);
    final isValid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return isValid ? null : 'Masukkan URL yang valid (http:// atau https://)!';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _errorMessage(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return 'Data proyek tidak valid (HTTP 400).';
      case 403:
        return 'Akun ini tidak punya izin menambah proyek (HTTP 403).';
      default:
        return 'Gagal menyimpan proyek (HTTP ${e.statusCode}).';
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    for (final controller in [
      _title,
      _description,
      _techStack,
      _projectUrl,
      _projectImageUrl,
    ]) {
      controller.clear();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    if (!await ensureLoggedIn(context) || !mounted) return;
    final token = context.read<AuthState>().token;
    if (token == null) return;

    final newProject = Project(
      title: _title.text.trim(),
      description: _description.text.trim(),
      techStack: _techStack.text.trim(),
      projectUrl: _projectUrl.text.trim(),
      projectImageUrl: _projectImageUrl.text.trim(),
    );

    setState(() => _isSubmitting = true);
    Project? created;
    Object? error;
    try {
      created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
    } on Exception catch (e) {
      error = e;
    }
    if (!mounted) return;
    // Stop the spinner before showing a dialog or pushing the login screen.
    setState(() => _isSubmitting = false);

    if (created != null) {
      _resetForm();
      await _showCreatedDialog(created);
    } else if (error is ApiException && error.statusCode == 401) {
      // Token expired or revoked: clear it and ask the user to log in again.
      await context.read<AuthState>().logout();
      if (!mounted) return;
      _showSnackBar('Sesi berakhir, silakan login kembali.');
      await ensureLoggedIn(context);
    } else if (error is ApiException) {
      _showSnackBar(_errorMessage(error));
    } else {
      _showSnackBar('Tidak dapat terhubung ke server.');
    }
  }

  Future<void> _showCreatedDialog(Project created) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ${created.title}'),
              Text('Description: ${created.description}'),
              Text('Tech Stack: ${created.techStack}'),
              Text('Project URL: ${created.projectUrl}'),
              if (created.projectImageUrl.isNotEmpty)
                Text('Image URL: ${created.projectImageUrl}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: _decoration(label, hint: hint),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                label: 'Title',
                controller: _title,
                validator: (value) => _required(value, 'Title'),
              ),
              _field(
                label: 'Description',
                controller: _description,
                maxLines: 5,
                validator: (value) => _required(value, 'Description'),
              ),
              _field(
                label: 'Tech Stack',
                hint: 'Contoh: Flutter, Django',
                controller: _techStack,
                validator: (value) => _required(value, 'Tech Stack'),
              ),
              _field(
                label: 'Project URL',
                hint: 'https://github.com/username/project',
                controller: _projectUrl,
                keyboardType: TextInputType.url,
                validator: (value) => _validateUrl(value, required: true),
              ),
              _field(
                label: 'Project Image URL (Optional)',
                hint: 'https://example.com/image.png',
                controller: _projectImageUrl,
                keyboardType: TextInputType.url,
                validator: (value) => _validateUrl(value, required: false),
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
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
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
