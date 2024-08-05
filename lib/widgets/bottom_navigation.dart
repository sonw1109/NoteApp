import 'package:flutter/material.dart';
import 'package:note_app/providers/theme_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigation extends ConsumerWidget {
  final VoidCallback onSave;

  const BottomNavigation({super.key, required this.onSave});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                ref.read(changeThemeProvider.notifier).changeTheme();
              },
              icon: Image.asset('assets/images/darkmode_icon.png'),
            ),
            IconButton(
              onPressed: onSave, 
              icon: Image.asset('assets/images/storage_icon.png'),
            ),
          ],
        ),
      ),
    );
  }
}
