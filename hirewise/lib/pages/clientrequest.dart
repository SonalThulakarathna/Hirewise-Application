import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRequestPage extends StatefulWidget {
  final String gigId;

  const ClientRequestPage({super.key, required this.gigId});

  @override
  State<ClientRequestPage> createState() => _ClientRequestPageState();
}

class _ClientRequestPageState extends State<ClientRequestPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _taskDetailsController = TextEditingController();
  String? _taskDifficulty = 'Easy';
  DateTime? _taskDeadline;
  bool _hasSpecialInstructions = false;
  bool _isUploading = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final Color _primaryColor = const Color(0xFF222325); // Primary Color
  final Color _accentColor = const Color(0xFFE74C3C); // Accent Color
  final Color _secondaryColor = const Color(0xFF3498DB); // Secondary Color
  final Color _lightColor = const Color(0xFFF3F3F3); // Light Background Color
  final Color _successColor = const Color(0xFF2ECC71); // Success Color

  final Map<String, Color> _difficultyColors = {
    'Easy': const Color(0xFF2ECC71),
    'Medium': const Color(0xFFF39C12),
    'Complex': const Color(0xFFE74C3C),
  };

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _taskDetailsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _secondaryColor,
              onPrimary: Colors.white,
              onSurface: _primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _secondaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _taskDeadline) {
      setState(() {
        _taskDeadline = picked;
      });
    }
  }

  Future<String?> _fetchSellerId() async {
    try {
      final response =
          await _supabase
              .from('Giginfo')
              .select('user_id')
              .eq('id', widget.gigId)
              .single();

      return response['user_id'] as String?;
    } catch (e) {
      throw Exception('Error fetching seller ID: $e');
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      setState(() {
        _isUploading = true;
      });

      try {
        final user = _supabase.auth.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final sellerId = await _fetchSellerId();
        if (sellerId == null) {
          throw Exception('Seller not found for this gig');
        }

        final requestData = {
          'client_name': user.email ?? 'Anonymous',
          'client_location': _locationController.text.trim(),
          'task_description': _taskDetailsController.text.trim(),
          'task_difficulty': _taskDifficulty,
          'desired_date': _taskDeadline?.toIso8601String(),
          'difficulty': _taskDifficulty,
          'created_at': DateTime.now().toIso8601String(),
          'gig_id': widget.gigId,
          'user_id': user.id,
          'seller_id': sellerId,
        };

        await _supabase.from('client_request').insert(requestData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task request submitted successfully!'),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        _formKey.currentState!.reset();
        setState(() {
          _locationController.clear();
          _taskDetailsController.clear();
          _taskDifficulty = 'Easy';
          _taskDeadline = null;
          _hasSpecialInstructions = false;
          _isUploading = false;
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_secondaryColor, _secondaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _secondaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_outlined, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                "New Task Request",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Fill in the details below to submit your task request. We'll match you with the perfect professional for the job.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Information",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _locationController,
              label: 'Client Location',
              hint: 'Enter your location',
              icon: Icons.location_on_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _taskDetailsController,
              label: 'Task Details',
              hint: 'Describe what you need help with',
              icon: Icons.description_outlined,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide task details';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Task Difficulty',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDifficultySelector(),
            const SizedBox(height: 24),
            Text(
              'Task Deadline',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDatePicker(),
            const SizedBox(height: 24),
            _buildCheckboxTile(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _primaryColor.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: _secondaryColor),
            filled: true,
            fillColor: _lightColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _secondaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _accentColor, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      decoration: BoxDecoration(
        color: _lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildDifficultyTile('Easy', 'Simple tasks, quick to complete'),
          Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          _buildDifficultyTile(
            'Medium',
            'Average complexity, requires some skill',
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          _buildDifficultyTile(
            'Complex',
            'Challenging tasks, requires expertise',
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyTile(String value, String description) {
    final bool isSelected = _taskDifficulty == value;
    final Color difficultyColor = _difficultyColors[value] ?? _primaryColor;

    return InkWell(
      onTap: () {
        setState(() {
          _taskDifficulty = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? difficultyColor : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected
                          ? difficultyColor
                          : Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Selected',
                  style: TextStyle(
                    color: difficultyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _lightColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: _secondaryColor, size: 20),
            const SizedBox(width: 12),
            Text(
              _taskDeadline == null
                  ? 'Select a deadline'
                  : DateFormat('MMMM dd, yyyy').format(_taskDeadline!),
              style: TextStyle(
                color:
                    _taskDeadline == null
                        ? Colors.grey.withOpacity(0.7)
                        : _primaryColor,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: _primaryColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile() {
    return Container(
      decoration: BoxDecoration(
        color: _lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _hasSpecialInstructions = !_hasSpecialInstructions;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color:
                      _hasSpecialInstructions
                          ? _secondaryColor
                          : Colors.transparent,
                  border: Border.all(
                    color:
                        _hasSpecialInstructions
                            ? _secondaryColor
                            : Colors.grey.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child:
                    _hasSpecialInstructions
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Instructions',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 16,
                        fontWeight:
                            _hasSpecialInstructions
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Check this if you have specific requirements or instructions',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_secondaryColor, _secondaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _secondaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isUploading ? null : _submitRequest,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child:
                      _isUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Submit Task Request',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightColor,
      appBar: AppBar(
        title: const Text("Client Task Request"),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildFormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
