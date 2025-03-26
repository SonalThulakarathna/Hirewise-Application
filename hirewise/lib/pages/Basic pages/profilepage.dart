import 'package:flutter/material.dart';
import 'package:hirewise/pages/Gig%20related%20pages/gigform.dart'
    show EnhancedGigDetailsForm, GigDetailsForm;
import 'package:supabase_flutter/supabase_flutter.dart';

class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({super.key});

  @override
  _EnhancedProfileScreenState createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  String? userName;
  bool isSeller = false; // Default mode is Buyer
  bool isLoading = true;
  String? userEmail;
  String? userAvatar;
  double balance = 500.00; // Placeholder balance

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          userName = "Guest";
          userEmail = "guest@example.com";
          isLoading = false;
        });
        return;
      }

      final response =
          await supabase
              .from('profile')
              .select('username, email, avatar_url')
              .eq('id', user.id)
              .single();

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        userName = response['name'] ?? "Guest";
        userEmail = response['email'] ?? user.email ?? "No email";
        userAvatar = response['avatar_url'];
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching user data: $error");
      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        userName = "Guest";
        userEmail = "guest@example.com";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body:
          isLoading
              ? _buildLoadingState()
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    _buildAccountTypeSwitch(),
                    const SizedBox(height: 8),

                    const SizedBox(height: 16),
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
            spreadRadius: 0,
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
                      border: Border.all(color: Colors.blue.shade100, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          userAvatar != null
                              ? NetworkImage(userAvatar!)
                              : const AssetImage('assets/profile_picture.png')
                                  as ImageProvider,
                      child:
                          userAvatar == null
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
                        color: Colors.blue.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
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
                      userName ?? "Loading...",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail ?? "Loading...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 16,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "\$${balance.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 28),
                onPressed: () {
                  // Handle notifications
                },
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  onTap: () {
                    setState(() {
                      isSeller = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          !isSeller ? Colors.blue.shade700 : Colors.transparent,
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
                  onTap: () {
                    setState(() {
                      isSeller = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSeller ? Colors.blue.shade700 : Colors.transparent,
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
          if (isSeller)
            _buildMenuItem(
              Icons.dashboard_outlined,
              "Dashboard",
              "View your seller statistics",
              context,
              DashboardPage(),
              iconColor: Colors.blue,
            ),
          if (isSeller)
            _buildMenuItem(
              Icons.add_circle_outline,
              "Create a Gig",
              "Offer your services to clients",
              context,
              EnhancedGigDetailsForm(),
              iconColor: Colors.green,
            ),
          if (isSeller)
            _buildMenuItem(
              Icons.receipt_long_outlined,
              "Orders",
              "Manage your client orders",
              context,
              TransactionPage(),
              iconColor: Colors.orange,
            ),
          _buildMenuItem(
            Icons.favorite_border_outlined,
            "Favorites",
            "View your saved gigs",
            context,
            FavoritePage(),
            iconColor: Colors.red,
          ),
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
            context,
            ReportSellerPage(),
            iconColor: Colors.amber,
          ),
          _buildMenuItem(
            Icons.settings_outlined,
            "Settings",
            "Manage your account settings",
            context,
            SettingsPage(),
            iconColor: Colors.grey,
          ),
          _buildMenuItem(
            Icons.group_add_outlined,
            "Invite Friends",
            "Share the app with friends",
            context,
            InviteFriendsPage(),
            iconColor: Colors.indigo,
          ),
          _buildMenuItem(
            Icons.help_outline,
            "Help & Support",
            "Get assistance with the app",
            context,
            HelpSupportPage(),
            iconColor: Colors.teal,
          ),
          const Divider(height: 32),
          _buildMenuItem(
            Icons.logout,
            "Log Out",
            "Sign out of your account",
            context,
            LogoutPage(),
            iconColor: Colors.red,
            showArrow: false,
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
    BuildContext context,
    Widget page, {
    Color iconColor = Colors.black,
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
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

// Dummy Pages for Navigation (unchanged)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(child: Text("Dashboard Page")),
    );
  }
}

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction")),
      body: Center(child: Text("Transaction Page")),
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite")),
      body: Center(child: Text("Favorite Page")),
    );
  }
}

class ReportSellerPage extends StatelessWidget {
  const ReportSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Seller")),
      body: Center(child: Text("Report Seller Page")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(child: Text("Settings Page")),
    );
  }
}

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invite Friends")),
      body: Center(child: Text("Invite Friends Page")),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help & Support")),
      body: Center(child: Text("Help & Support Page")),
    );
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log Out")),
      body: Center(child: Text("Logging out...")),
    );
  }
}
