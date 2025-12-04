import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), elevation: 2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.username.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.username ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Full Name'),
                          subtitle: Text(user?.fullName ?? 'Not provided'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text('Email'),
                          subtitle: Text(user?.email ?? ''),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.account_circle_outlined),
                          title: const Text('Username'),
                          subtitle: Text(user?.username ?? ''),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            user?.isActive == true
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color: user?.isActive == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: const Text('Account Status'),
                          subtitle: Text(
                            user?.isActive == true ? 'Active' : 'Inactive',
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            user?.isVerified == true
                                ? Icons.verified
                                : Icons.info_outline,
                            color: user?.isVerified == true
                                ? Colors.blue
                                : Colors.orange,
                          ),
                          title: const Text('Verification'),
                          subtitle: Text(
                            user?.isVerified == true
                                ? 'Verified'
                                : 'Not verified',
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.calendar_today_outlined),
                          title: const Text('Member Since'),
                          subtitle: Text(
                            user?.createdAt.toString().split(' ')[0] ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile coming soon'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
