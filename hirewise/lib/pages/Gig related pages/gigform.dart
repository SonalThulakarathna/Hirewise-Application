import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GigDetailsForm extends StatefulWidget {
  const GigDetailsForm({super.key});

  @override
  State<GigDetailsForm> createState() => _GigDetailsFormState();
}

class _GigDetailsFormState extends State<GigDetailsForm> {
  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Function to submit the form and insert data into Supabase
  Future<void> _submitForm() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id; // Fetch logged-in user ID

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in. Please log in first.'),
        ),
      );
      return;
    }

    // Validate required fields
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Prepare the data to be sent to Supabase
    final gigData = {
      'Title': _titleController.text,
      'Description': _descriptionController.text,
      'Price': _priceController.text,
      'Instruction': _instructionController.text,
      'servicedescript': _serviceDescriptionController.text,
      'category':
          int.tryParse(_categoryController.text) ??
          0, // Default to 0 if invalid
      'user_id': userId, // Store the user ID in the database
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
        const SnackBar(content: Text('Gig submitted successfully!')),
      );
      _clearForm(); // Clear the form after successful submission
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a New Gig'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gig Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Gig Title',
                hintText: 'Enter the title of your gig',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Gig Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Gig Description',
                hintText: 'Describe your gig in detail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Enter the price of your gig',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Instruction
            TextFormField(
              controller: _instructionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instruction',
                hintText: 'Enter instructions for the gig',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Service Description
            TextFormField(
              controller: _serviceDescriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Service Description',
                hintText: 'Describe the service in detail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            TextFormField(
              controller: _categoryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                hintText: 'Enter the category ID (e.g., 1, 2, 3)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Gig'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
