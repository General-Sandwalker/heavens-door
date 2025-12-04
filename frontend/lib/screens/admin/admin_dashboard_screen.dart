import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../utils/theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  final _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.dio.get('/admin/dashboard');
      setState(() {
        _dashboardData = response.data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: JoJoTheme.standPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: JoJoTheme.standGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    '${user?.firstName?[0] ?? ''}${user?.lastName?[0] ?? ''}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: JoJoTheme.standPurple,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back, ${user?.firstName ?? ''}!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        user?.role == 'super_admin'
                                            ? 'Super Administrator'
                                            : 'Administrator',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: JoJoTheme.goldenWind,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '👑 ADMIN',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Statistics Cards
                    Text(
                      'Overview',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          'Total Users',
                          '${_dashboardData?['stats']?['totalUsers'] ?? 0}',
                          Icons.people,
                          JoJoTheme.starPlatinum,
                        ),
                        _buildStatCard(
                          'Properties',
                          '${_dashboardData?['stats']?['totalProperties'] ?? 0}',
                          Icons.home,
                          JoJoTheme.goldenWind,
                        ),
                        _buildStatCard(
                          'Messages',
                          '${_dashboardData?['stats']?['totalMessages'] ?? 0}',
                          Icons.message,
                          JoJoTheme.emeraldGreen,
                        ),
                        _buildStatCard(
                          'Favorites',
                          '${_dashboardData?['stats']?['totalFavorites'] ?? 0}',
                          Icons.favorite,
                          JoJoTheme.killerQueen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Users
                    Text(
                      'Recent Users',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (_dashboardData?['recentUsers'] as List?)?.length ??
                            0,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = _dashboardData!['recentUsers'][index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: JoJoTheme.standPurple,
                              child: Text(
                                '${user['first_name']?[0] ?? ''}${user['last_name']?[0] ?? ''}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              '${user['first_name']} ${user['last_name']}',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(user['email']),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: user['role'] == 'super_admin'
                                    ? JoJoTheme.menacing
                                    : user['role'] == 'admin'
                                    ? JoJoTheme.goldenWind
                                    : JoJoTheme.starPlatinum,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user['role'].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Properties
                    Text(
                      'Recent Properties',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (_dashboardData?['recentProperties'] as List?)
                                ?.length ??
                            0,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final property =
                              _dashboardData!['recentProperties'][index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: JoJoTheme.standPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.home,
                                color: JoJoTheme.standPurple,
                              ),
                            ),
                            title: Text(
                              property['title'],
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '\$${property['price']} • ${property['owner_name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: property['status'] == 'active'
                                    ? JoJoTheme.emeraldGreen
                                    : property['status'] == 'pending'
                                    ? Colors.orange
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                property['status'].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Management Actions
                    Text(
                      'Management',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2,
                      children: [
                        _buildActionCard(
                          'Manage Users',
                          Icons.people_alt,
                          JoJoTheme.standPurple,
                          () => Navigator.pushNamed(context, '/admin/users'),
                        ),
                        _buildActionCard(
                          'View Properties',
                          Icons.home_work,
                          JoJoTheme.goldenWind,
                          () =>
                              Navigator.pushNamed(context, '/admin/properties'),
                        ),
                        _buildActionCard(
                          'Messages',
                          Icons.message_outlined,
                          JoJoTheme.emeraldGreen,
                          () => Navigator.pushNamed(context, '/admin/messages'),
                        ),
                        _buildActionCard(
                          'Settings',
                          Icons.settings,
                          JoJoTheme.dio,
                          () => Navigator.pushNamed(context, '/admin/settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
