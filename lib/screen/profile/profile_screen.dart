import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // -------- Avatar --------
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.15),
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1A1A2E)
                              : Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(Icons.edit,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Student Name',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('student@example.com',
                style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 24),

            // -------- Stats Row --------
            Row(
              children: [
                _statBox(context, '5', 'Subjects'),
                const SizedBox(width: 10),
                _statBox(context, '12', 'Tasks'),
                const SizedBox(width: 10),
                _statBox(context, '36h', 'Studied'),
              ],
            ),
            const SizedBox(height: 28),

            // -------- Account Section --------
            _sectionTitle('Account'),
            _settingsTile(
              context,
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _settingsTile(
              context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {},
            ),
            _settingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // -------- Preferences Section --------
            _sectionTitle('Preferences'),

            // Dark mode toggle
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252540) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                secondary: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: const Text('Dark Mode',
                    style: TextStyle(fontSize: 14)),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),
            _settingsTile(
              context,
              icon: Icons.language,
              title: 'Language',
              trailing: const Text('English',
                  style: TextStyle(fontSize: 13)),
              onTap: () {},
            ),
            _settingsTile(
              context,
              icon: Icons.storage_outlined,
              title: 'Storage',
              trailing: const Text('120 MB',
                  style: TextStyle(fontSize: 13)),
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // -------- Support Section --------
            _sectionTitle('Support'),
            _settingsTile(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
            _settingsTile(
              context,
              icon: Icons.info_outline,
              title: 'About StudyDesk',
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // -------- Logout --------
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()),
                  (_) => false,
                ),
                icon: const Icon(Icons.logout, color: Color(0xFFFF5C5C)),
                label: const Text('Logout',
                    style: TextStyle(color: Color(0xFFFF5C5C))),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFFF5C5C)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------- Helpers ----------

  Widget _statBox(BuildContext context, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252540) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}