import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/widgets/widgets.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';
import 'package:validatorless/validatorless.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _nameVN = ValueNotifier<String>('');

  @override
  void dispose() {
    _nameVN.dispose();
    super.dispose();
  }

  void _handleChangeName() {
    showDialog<Object>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar nome'),
        content: CustomInput(
          label: 'Nome',
          onChanged: (value) => _nameVN.value = value,
          validator: Validatorless.required('Nome obrigatório'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              final nameValue = _nameVN.value;
              if (nameValue.isEmpty) return;
              Loader.show(context);
              try {
                await context.read<UserService>().updateDisplayName(nameValue);
              } catch (_) {
                Messages.of(context).showError('Erro ao alterar nome');
              } finally {
                Loader.hide();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  builder: (_, url, __) => CircleAvatar(
                    backgroundImage: url.isEmpty ? null : NetworkImage(url),
                    radius: 30,
                  ),
                  selector: (context, authProvider) {
                    final user = authProvider.user;
                    if (user == null) return '';
                    return user.photoURL ??
                        'https://api.dicebear.com/6.x/identicon/png?seed=${user.email}';
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Selector<AuthProvider, String>(
                      builder: (_, name, __) => Text(
                        name,
                        style: context.textTheme.titleSmall
                            ?.copyWith(overflow: TextOverflow.ellipsis),
                      ),
                      selector: (context, authProvider) {
                        final user = authProvider.user;
                        if (user == null) return '';
                        return user.displayName ?? user.email!;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Alterar nome'),
            onTap: _handleChangeName,
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: context.read<AuthProvider>().logout,
          ),
        ],
      ),
    );
  }
}
