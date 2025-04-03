import 'package:flutter/material.dart';
import 'package:hirewise/auth/auth_service.dart';
import 'package:hirewise/pages/Gig%20related%20pages/gigform.dart'
    show EnhancedGigDetailsForm;
import 'package:hirewise/pages/Gig%20related%20pages/mygigpage.dart';
import 'package:hirewise/pages/editprofilepage.dart';
import 'package:hirewise/pages/taskrequestpage.dart';
import 'package:hirewise/userservice/userservice.dart';

// Main Profile Screen
class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({super.key});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  late Map<String, dynamic> userProfile;
  bool isSeller = false;
  bool isLoading = true;
  double balance = 500.00;

  final authService = AuthService();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => isLoading = true);
    final profile = await userService.getFullProfile();
    if (!mounted) return;
    setState(() {
      userProfile = profile;
      isLoading = false;
    });
  }

  void logout() async {
    try {
      setState(() => isLoading = true);
      await authService.signOut();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body:
          isLoading
              ? _buildLoadingState()
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    _buildAccountTypeSwitch(),
                    const SizedBox(height: 24),
                    Expanded(child: _buildMenuSection()),
                  ],
                ),
              ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          userProfile['avatar_url'] != null
                              ? NetworkImage(userProfile['avatar_url'])
                              : const AssetImage('assets/profile_picture.png')
                                  as ImageProvider,
                      child:
                          userProfile['avatar_url'] == null
                              ? Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey.shade400,
                              )
                              : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222325),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Navigate to the edit profile page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EnhancedEditProfilePage(
                                    currentUsername: userProfile['username'],
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile['username'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222325),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProfile['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const Text(
            "Account Type",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222325),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => isSeller = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          !isSeller
                              ? const Color(0xFF222325)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Buyer",
                      style: TextStyle(
                        color: !isSeller ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isSeller = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSeller
                              ? const Color(0xFF222325)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Seller",
                      style: TextStyle(
                        color: isSeller ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Account",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          if (isSeller) ...[
            _buildMenuItem(
              Icons.dashboard_outlined,
              "Dashboard",
              "View your seller statistics",
              const DashboardPage(),
            ),
            _buildMenuItem(
              Icons.add_circle_outline,
              "Create a Gig",
              "Offer your services to clients",
              const EnhancedGigDetailsForm(),
            ),
            _buildMenuItem(
              Icons.receipt_long_outlined,
              "Task Request",
              "Manage your client task request",
              const EnhancedSellerTaskRequestPage(),
            ),
            _buildMenuItem(
              Icons.work,
              "My Gigs",
              "View your saved gigs",
              const EnhancedGigPage(),
            ),
          ],
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Support",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          _buildMenuItem(
            Icons.report_outlined,
            "Report Seller",
            "Report problematic sellers",
            const ReportSellerPage(),
          ),
          _buildMenuItem(
            Icons.settings_outlined,
            "Settings",
            "Manage your account settings",
            const SettingsPage(),
          ),
          _buildMenuItem(
            Icons.group_add_outlined,
            "Invite Friends",
            "Share the app with friends",
            const InviteFriendsPage(),
          ),
          _buildMenuItem(
            Icons.help_outline,
            "Help & Support",
            "Get assistance with the app",
            const HelpSupportPage(),
          ),
          const Divider(height: 32),
          _buildMenuItem(
            Icons.logout,
            "Log Out",
            "Sign out of your account",
            null,
            showArrow: false,
            onTap: authService.signOut,
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "App Version 1.0.0",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Widget? page, {
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              onTap ??
              () {
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                }
              },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222325).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color:
                        title == "Log Out"
                            ? Colors.red
                            : const Color(0xFF222325),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              title == "Log Out" ? Colors.red : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfilePage({
    super.key,
    required this.userProfile,
    required currentUsername,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userProfile['username'],
    );
    _bioController = TextEditingController(
      text: widget.userProfile['bio'] ?? '',
    );
  }

  Future<void> _updateProfile() async {
    // Update profile in the backend/database using userProfile['id']
    // For example:
    // await userService.updateProfile(widget.userProfile['id'], _nameController.text, _bioController.text);

    // After updating, navigate back to the profile screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages (keep your existing implementations)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Dashboard")),
    body: const Center(child: Text("Dashboard Page")),
  );
}

class ReportSellerPage extends StatelessWidget {
  const ReportSellerPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Report Seller")),
    body: const Center(child: Text("Report Seller Page")),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Settings")),
    body: const Center(child: Text("Settings Page")),
  );
}

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Invite Friends")),
    body: const Center(child: Text("Invite Friends Page")),
  );
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Help & Support")),
    body: const Center(child: Text("Help & Support Page")),
  );
}
