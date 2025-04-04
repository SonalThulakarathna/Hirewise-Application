import 'package:flutter/material.dart';
import 'package:hirewise/pages/intropage.dart';
import 'package:hirewise/pages/popularservice.dart';
import 'package:hirewise/pages/profilepage.dart';
import 'package:hirewise/pages/taskrequestpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Intropagebottom extends StatefulWidget {
  const Intropagebottom({super.key});

  @override
  State<Intropagebottom> createState() => _IntropageState();
}

class _IntropageState extends State<Intropagebottom> {
  // Future variables to store data fetched from Supabase
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  late Future<List<Map<String, dynamic>>> _workersFuture;

  int _selectedIndex = 0; // Track selected tab index

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
    _workersFuture = fetchWorkers();
  }

  // Function to fetch categories from Supabase
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('category')
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No categories found');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Function to fetch workers from Supabase
  Future<List<Map<String, dynamic>>> fetchWorkers() async {
    final response = await Supabase.instance.client
        .from('Giginfo')
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No workers found');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Function to refresh categories data
  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = fetchCategories();
    });
  }

  // Function to refresh workers data
  Future<void> _refreshWorkers() async {
    setState(() {
      _workersFuture = fetchWorkers();
    });
  }

  // List of pages for Bottom Navigation Bar
  final List<Widget> _pages = [
    Intropage(), // Page 0 - Home
    PopularServicesPage(), // Page 1 - Categories
    PopularServicesPage(),
    EnhancedSellerTaskRequestPage(), // Page 3 - Order
    EnhancedProfileScreen(), // Page 4 - Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // Body - Display current selected page
      body: _pages[_selectedIndex],

      // 🔥 Modern Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Order',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Dummy Pages for Navigation

class chatpage extends StatelessWidget {
  const chatpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('👤 chatpage', style: TextStyle(fontSize: 20)));
  }
}

class orderpage extends StatelessWidget {
  const orderpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Order Page "));
  }
}
