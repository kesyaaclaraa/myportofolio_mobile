import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _onTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    void show(String message) =>
        messenger.showSnackBar(SnackBar(content: Text(message)));

    switch (item.name) {
      case 'Lihat Proyek':
        show('Kamu telah menekan tombol ${item.name}!');
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProjectListScreen()),
        );
      case 'Tambah Proyek':
        show('Kamu telah menekan tombol ${item.name}!');
        if (!await ensureLoggedIn(context) || !context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProjectFormPage()),
        );
      case 'Tambah Edukasi':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EducationFormPage()),
        );
      case 'Login':
        if (await ensureLoggedIn(context)) show('Login berhasil!');
      case 'Logout':
        await context.read<AuthState>().logout();
        show('Kamu telah logout.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
