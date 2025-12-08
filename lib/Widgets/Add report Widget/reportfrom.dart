import 'package:flutter/material.dart';
import 'package:rebuild/Model/CategoryMode.dart';
import 'package:rebuild/Model/CityModel.dart';

class ReportForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final List<Category> categories;
  final List<City> cities;

  final int? selectedCategoryId;
  final int? selectedCityId;

  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onCityChanged;
  final ValueChanged<List<String>> onImagesSelected;
  final VoidCallback onSubmit;

  const ReportForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.categories,
    required this.cities,
    required this.selectedCategoryId,
    required this.selectedCityId,
    required this.onCategoryChanged,
    required this.onCityChanged,
    required this.onImagesSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "عنوان البلاغ"),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: "وصف البلاغ"),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<int>(
            value: selectedCategoryId,
            decoration: const InputDecoration(labelText: "اختيار الفئة"),
            items: categories
                .map(
                  (cat) =>
                      DropdownMenuItem(value: cat.id, child: Text(cat.name)),
                )
                .toList(),
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<int>(
            value: selectedCityId,
            decoration: const InputDecoration(labelText: "اختيار المدينة"),
            items: cities
                .map(
                  (city) =>
                      DropdownMenuItem(value: city.id, child: Text(city.name)),
                )
                .toList(),
            onChanged: onCityChanged,
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: onSubmit,
            child: const Text("إرسال البلاغ"),
          ),
        ],
      ),
    );
  }
}
