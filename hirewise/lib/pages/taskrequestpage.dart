import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnhancedSellerTaskRequestPage extends StatefulWidget {
  const EnhancedSellerTaskRequestPage({super.key});

  @override
  State<EnhancedSellerTaskRequestPage> createState() =>
      _EnhancedSellerTaskRequestPageState();
}

class _EnhancedSellerTaskRequestPageState
    extends State<EnhancedSellerTaskRequestPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _taskRequests = [];
  final SupabaseClient _supabase = Supabase.instance.client;
  late TabController _tabController;

  // Filter options
  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Accepted',
    'Rejected',
  ];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterOptions.length, vsync: this);
    _checkAuthState();
    _fetchTaskRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to check the authentication state
  Future<void> _checkAuthState() async {
    final session = _supabase.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
    });
  }

  // Function to fetch task requests for the current seller
  Future<void> _fetchTaskRequests() async {
    if (!_isLoggedIn) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUserId = _supabase.auth.currentUser?.id ?? '';
      if (currentUserId.isEmpty) {
        throw Exception('User not logged in');
      }

      final response = await _supabase
          .from('client_request')
          .select('*')
          .eq('seller_id', currentUserId)
          .order('created_at', ascending: false);

      setState(() {
        _taskRequests = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching requests: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Error fetching task requests: $e');
    }
  }

  // Function to handle task acceptance
  Future<void> _acceptTask(String taskId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Update in Supabase
      await _supabase
          .from('client_request')
          .update({'status': 'Accepted'})
          .eq('id', taskId);

      // Update local state
      setState(() {
        final taskIndex = _taskRequests.indexWhere(
          (task) => task['id'] == taskId,
        );
        if (taskIndex != -1) {
          _taskRequests[taskIndex]['status'] = 'Accepted';
        }
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task accepted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting task: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to handle task rejection
  Future<void> _rejectTask(String taskId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Update in Supabase
      await _supabase
          .from('client_request')
          .update({'status': 'Rejected'})
          .eq('id', taskId);

      // Update local state
      setState(() {
        final taskIndex = _taskRequests.indexWhere(
          (task) => task['id'] == taskId,
        );
        if (taskIndex != -1) {
          _taskRequests[taskIndex]['status'] = 'Rejected';
        }
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task rejected'),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting task: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to refresh task requests
  Future<void> _refreshTaskRequests() async {
    await _fetchTaskRequests();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task requests refreshed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0,
              title: Text(
                'Client Request',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
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
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    // Search functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Search functionality'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: _refreshTaskRequests,
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorWeight: 3,
                tabs:
                    _filterOptions.map((filter) => Tab(text: filter)).toList(),
                onTap: (index) {
                  setState(() {
                    _selectedFilter = _filterOptions[index];
                  });
                },
              ),
            ),
          ];
        },
        body:
            _isLoading
                ? _buildLoadingState()
                : !_isLoggedIn
                ? _buildNotLoggedInState()
                : _taskRequests.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(),
      ),
      floatingActionButton:
          _isLoggedIn
              ? FloatingActionButton(
                onPressed: () {
                  // Action to create a new task request
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create new task request'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  // Task list UI
  Widget _buildTaskList() {
    // Filter tasks based on selected filter
    final filteredTasks =
        _selectedFilter == 'All'
            ? _taskRequests
            : _taskRequests
                .where((task) => task['status'] == _selectedFilter)
                .toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No $_selectedFilter Tasks',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different filter',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshTaskRequests,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return _buildTaskRequestCard(filteredTasks[index]);
        },
      ),
    );
  }

  // Task request card UI
  Widget _buildTaskRequestCard(Map<String, dynamic> task) {
    // Format date
    final deadlineString = task['desired_date'];
    String formattedDeadline = "No deadline provided";
    int daysRemaining = 0;

    if (deadlineString != null) {
      try {
        final deadline = DateTime.parse(deadlineString);
        formattedDeadline = DateFormat('MMM dd, yyyy').format(deadline);
        daysRemaining = deadline.difference(DateTime.now()).inDays;
      } catch (e) {
        formattedDeadline = "Invalid deadline";
      }
    }

    // Determine status color
    Color statusColor;
    switch (task['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Accepted':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        task['status'] == 'Pending'
                            ? Icons.hourglass_empty
                            : task['status'] == 'Accepted'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: statusColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task['status'] ?? 'Unknown',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Request #${task['id']}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),

          // Client info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Client avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        task['client_avatar'] != null
                            ? NetworkImage(task['client_avatar'])
                            : null,
                    backgroundColor: Colors.grey.shade200,
                    child:
                        task['client_avatar'] == null
                            ? const Icon(Icons.person, size: 24)
                            : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Client name and gig title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['client_name'] ?? 'Unknown Client',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Requested on ${_formatCreatedDate(task['created_at'])}',
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
          ),

          const Divider(height: 1),

          // Task details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Task Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    task['task_description'] ?? 'No details provided',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Task metadata
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        Icons.calendar_today,
                        'Deadline',
                        formattedDeadline,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (task['budget'] != null)
                      Expanded(
                        child: _buildInfoTile(
                          Icons.attach_money,
                          'Budget',
                          '\$${task['budget'].toStringAsFixed(0)}',
                          Colors.green,
                        ),
                      ),
                  ],
                ),
                if (daysRemaining > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildInfoTile(
                      Icons.timer,
                      'Time Remaining',
                      '$daysRemaining ${daysRemaining == 1 ? 'day' : 'days'} left',
                      daysRemaining < 3 ? Colors.red : Colors.orange,
                    ),
                  ),

                const SizedBox(height: 24),

                // Action buttons (only for pending tasks)
                if (task['status'] == 'Pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _rejectTask(task['id']),
                          icon: const Icon(Icons.close),
                          label: const Text('Decline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade400),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _acceptTask(task['id']),
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // View details button (for accepted/rejected tasks)
                if (task['status'] != 'Pending')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // View task details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'View details for task ${task['id']}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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

  String _formatCreatedDate(dynamic createdAt) {
    if (createdAt == null) return 'Unknown date';

    try {
      final date = DateTime.parse(createdAt.toString());
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Loading State UI
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading task requests...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Empty State UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Task Requests Found',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You don\'t have any task requests at the moment. Check back later or refresh to update.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _refreshTaskRequests,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Not Logged In State UI
  Widget _buildNotLoggedInState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Authentication Required',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Please log in to view your task requests and manage client inquiries',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to login page
              // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            icon: const Icon(Icons.login),
            label: const Text('Log In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
