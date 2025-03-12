import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchCategories() async {
  final response = await Supabase.instance.client
      .from('category')
      .select()
      .order(
        'created_at',
        ascending: false,
      ); // Fetch categories sorted by latest

  if (response.isEmpty) {
    throw Exception('No categories found');
  }

  return List<Map<String, dynamic>>.from(response);
}
