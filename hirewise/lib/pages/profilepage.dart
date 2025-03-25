import 'package:flutter/material.dart';
import 'package:hirewise/pages/Gig%20related%20pages/gigform.dart'
    show GigDetailsForm;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  bool isSeller = false; // Default mode is Buyer

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response =
          await supabase
              .from('users')
              .select('name')
              .eq('id', user.id)
              .single();

      setState(() {
        userName = response['name'] ?? "Guest";
      });
    } catch (error) {
      print("Error fetching user name: $error");
      setState(() {
        userName = "Guest";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? "Loading...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Deposit Balance: \$500.00",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Switch(
                    value: isSeller,
                    onChanged: (value) {
                      setState(() {
                        isSeller = value;
                      });
                    },
                  ),
                  Text(isSeller ? "Seller" : "Buyer"),
                ],
              ),
            ),

            Divider(),

            Expanded(
              child: ListView(
                children: [
                  if (isSeller)
                    buildMenuItem(
                      Icons.dashboard,
                      "Dashboard",
                      context,
                      DashboardPage(),
                    ),

                  if (isSeller)
                    buildMenuItem(
                      Icons.receipt_long,
                      "Create a Gig",
                      context,
                      GigDetailsForm(),
                    ),
                  if (isSeller)
                    buildMenuItem(
                      Icons.document_scanner_outlined,
                      "Orders",
                      context,
                      TransactionPage(),
                    ),

                  buildMenuItem(
                    Icons.favorite,
                    "Favorite",
                    context,
                    FavoritePage(),
                  ),
                  buildMenuItem(
                    Icons.report,
                    "Report Seller",
                    context,
                    ReportSellerPage(),
                  ),
                  buildMenuItem(
                    Icons.settings,
                    "Settings",
                    context,
                    SettingsPage(),
                  ),
                  buildMenuItem(
                    Icons.group_add,
                    "Invite Friends",
                    context,
                    InviteFriendsPage(),
                  ),
                  buildMenuItem(
                    Icons.help,
                    "Help & Support",
                    context,
                    HelpSupportPage(),
                  ),
                  buildMenuItem(
                    Icons.logout,
                    "Log Out",
                    context,
                    LogoutPage(),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
    IconData icon,
    String title,
    BuildContext context,
    Widget page, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget buildExpandableMenuItem(
    IconData icon,
    String title,
    List<Map<String, dynamic>> subItems,
    BuildContext context,
  ) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: 16)),
      children:
          subItems
              .map(
                (subItem) => buildSubMenuItem(
                  subItem["title"],
                  context,
                  subItem["page"],
                ),
              )
              .toList(),
    );
  }

  Widget buildSubMenuItem(String title, BuildContext context, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

class MyProfilePage {}

// Dummy Pages for Navigation
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Center(child: Text("Profile Page")),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(child: Text("Dashboard Page")),
    );
  }
}

class AddDepositPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Deposit")),
      body: Center(child: Text("Add Deposit Page")),
    );
  }
}

class DepositHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deposit History")),
      body: Center(child: Text("Deposit History Page")),
    );
  }
}

class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction")),
      body: Center(child: Text("Transaction Page")),
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite")),
      body: Center(child: Text("Favorite Page")),
    );
  }
}

class ReportSellerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Seller")),
      body: Center(child: Text("Report Seller Page")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(child: Text("Settings Page")),
    );
  }
}

class InviteFriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invite Friends")),
      body: Center(child: Text("Invite Friends Page")),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help & Support")),
      body: Center(child: Text("Help & Support Page")),
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log Out")),
      body: Center(child: Text("Logging out...")),
    );
  }
}
