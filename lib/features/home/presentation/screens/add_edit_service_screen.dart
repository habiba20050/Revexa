import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class AddEditServiceScreen extends StatefulWidget {
  final Product? service;

  const AddEditServiceScreen({super.key, this.service});

  @override
  State<AddEditServiceScreen> createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends State<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.service?.title);
    _descriptionCtrl = TextEditingController(text: widget.service?.description);
    _priceCtrl =
        TextEditingController(text: widget.service?.price.toString() ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'title': _titleCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'price': double.tryParse(_priceCtrl.text.trim()) ?? 0,
    };

    final cubit = context.read<ProductsCubit>();
    if (widget.service != null) {
      cubit.updateProduct(widget.service!.id, data);
    } else {
      // createProduct requires more fields, this will fail if not provided.
      // This screen should be split or enhanced to gather all required data.
      cubit.createProduct(
        title: data['title'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        // category, location, and images are missing.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.service != null;
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductCreated || state is ProductUpdated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(isEditing ? 'Service updated successfully' : 'Service added successfully'),
              backgroundColor: Colors.green,
            ));
          Navigator.of(context).pop(true);
        } else if (state is ProductsError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Service' : 'Add New Service'), // Fallback text
          centerTitle: true,
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            final isLoading = state is ProductsLoading;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _titleCtrl,
                      label: 'Service Title', // Fallback text
                      hint: 'e.g., Premium Car Wash', // Fallback text
                      validator: (val) => val == null || val.isEmpty ? 'This field is required' : null, // Fallback text
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionCtrl,
                      label: 'Description', // Fallback text
                      hint: 'Describe the service details...', // Fallback text
                      maxLines: 4,
                      validator: (val) => val == null || val.isEmpty ? 'This field is required' : null, // Fallback text
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _priceCtrl,
                      label: 'Price', // Fallback text
                      hint: 'e.g., 150.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'This field is required'; // Fallback text
                        if (double.tryParse(val) == null) return 'Please enter a valid number'; // Fallback text
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: isEditing ? 'Save Changes' : 'Add Service', // Fallback text
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurfaceVariant.withValues(alpha: 0.45)),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.25), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
   
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(
            fontSize: 14,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.45)),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppColors.primary.withValues(alpha: 0.25), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  
}