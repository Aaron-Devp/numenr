import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final String userName;
  final String profilePicUrl;
  final VoidCallback onMenuTap; // Acción para abrir el menú
  final VoidCallback onProfileTap; // Acción para gestionar el perfil

  const TopBar({
    super.key,
    required this.pageTitle,
    required this.userName,
    required this.profilePicUrl,
    required this.onMenuTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[300], // Color de fondo gris
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.deepPurple),
        onPressed: onMenuTap, // Acción para abrir el menú
      ),
      title: Text(
        pageTitle,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      centerTitle: true,
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                backgroundImage: NetworkImage(profilePicUrl),
                onBackgroundImageError: (_, __) {
                  // Imagen predeterminada si falla
                  const AssetImage('assets/default_profile.png');
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
