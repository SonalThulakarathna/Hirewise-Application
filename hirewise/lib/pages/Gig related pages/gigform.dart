import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnhancedGigDetailsForm extends StatefulWidget {
  const EnhancedGigDetailsForm({super.key});

  @override
  State<EnhancedGigDetailsForm> createState() => _EnhancedGigDetailsFormState();
}

class _EnhancedGigDetailsFormState extends State<EnhancedGigDetailsForm> {
  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // New state variables
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final int _currentStep = 0;
  String? _selectedCategory;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _instructionController.dispose();
    _serviceDescriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Fetch categories from Supabase
  Future<void> _fetchCategories() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('category')
          .select('id, category_name');

      setState(() {
        _categories = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      print('Error fetching categories: $error');
      // Set some default categories in case of error
      setState(() {
        _categories = [
          {'id': 1, 'category_name': 'Design'},
          {'id': 2, 'category_name': 'Development'},
          {'id': 3, 'category_name': 'Writing'},
          {'id': 4, 'category_name': 'Marketing'},
        ];
      });
    }
  }

  // Function to submit the form and insert data into Supabase
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in. Please log in first.'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Prepare the data to be sent to Supabase
      final gigData = {
        'Title': _titleController.text,
        'Description': _descriptionController.text,
        'Price': double.tryParse(_priceController.text) ?? 0,
        'Instruction': _instructionController.text,
        'servicedescript': _serviceDescriptionController.text,
        'category':
            int.tryParse(_selectedCategory ?? _categoryController.text) ?? 0,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Insert data into the Supabase table
      final response = await supabase.from('Giginfo').insert([gigData]);

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit gig: ${response.error?.message}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gig submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm(); // Clear the form after successful submission
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to clear the form fields
  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _instructionController.clear();
    _serviceDescriptionController.clear();
    _categoryController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Gig'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitForm,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('Publish'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(),
              const SizedBox(height: 24),

              // Basic Information Section
              _buildSectionCard(
                title: 'Basic Information',
                isExpanded: true,
                onToggle: () {},
                content: Column(
                  children: [
                    // Gig Title
                    _buildTextField(
                      controller: _titleController,
                      label: 'Gig Title',
                      hint:
                          'I will design a professional logo for your business',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.length < 10) {
                          return 'Title should be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category ID
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items:
                          _categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category['id'].toString(),
                              child: Text(category['category_name']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          _categoryController.text = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Section
              _buildSectionCard(
                title: 'Description & Details',
                isExpanded: true,
                onToggle: () {},
                content: Column(
                  children: [
                    // Gig Description
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Gig Description',
                      hint:
                          'Describe your gig in detail. What makes your service unique?',
                      icon: Icons.description,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 50) {
                          return 'Description should be at least 50 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Service Description
                    _buildTextField(
                      controller: _serviceDescriptionController,
                      label: 'Service Description',
                      hint: 'What specific services are included?',
                      icon: Icons.miscellaneous_services,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Instruction for Buyers
                    _buildTextField(
                      controller: _instructionController,
                      label: 'Instructions for Buyers',
                      hint:
                          'What information do you need from buyers to get started?',
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pricing Section
              _buildSectionCard(
                title: 'Pricing',
                isExpanded: true,
                onToggle: () {},
                content: Column(
                  children: [
                    // Price
                    _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: 'Enter your price',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Submit Gig',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 0,
        ),
      ),
      validator: validator,
    );
  }

  // Helper method to build a section card with expandable content
  Widget _buildSectionCard({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Section header
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
        ],
      ),
    );
  }

  // Helper method to build the header card
  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.blue.shade700,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Your Gig',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fill in the details below to create your gig and start selling your services.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
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
