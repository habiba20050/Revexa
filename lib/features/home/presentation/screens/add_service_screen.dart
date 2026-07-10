import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/categories/categories.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

/// شاشة لإضافة خدمة جديدة من قبل الشركة.
class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _selectedCategoryId;

  // قائمة لتخزين مسارات الصور المختارة
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    // جلب التصنيفات عند تحميل الشاشة
    context.read<CategoriesCubit>().loadCategories();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = double.tryParse(_priceCtrl.text);
    if (price == null) {
      // يمكن عرض رسالة خطأ هنا إذا لزم الأمر
      return;
    }

    context.read<ProductsCubit>().createProduct(
          title: _titleCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          price: price,
          category: _selectedCategoryId!,
          // سنقوم بتمرير مسارات الصور هنا
          // ملاحظة: ستحتاج إلى تحديث ProductsCubit لرفع هذه الصور أولاً
          // ثم إرسال الـ URLs المستلمة إلى API إنشاء المنتج.
          // هذا مثال مبسط، التنفيذ الفعلي يتطلب منطق رفع.
        );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    // يمكنك استخدام pickMultipleMedia للسماح باختيار صور وفيديوهات
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        // إضافة الصور الجديدة إلى القائمة الحالية
        _selectedImages.addAll(images);
        // يمكنك وضع حد أقصى لعدد الصور إذا أردت
        // if (_selectedImages.length > 5) { _selectedImages.removeRange(5, _selectedImages.length); }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          l10n.addServiceTitle,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductsError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
              );
          }
          if (state is ProductCreated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.serviceAddedSuccessfully), backgroundColor: Colors.green),
              );
            Navigator.of(context).pop(true); // إرجاع `true` للإشارة إلى النجاح
          }
        },
        builder: (context, productState) {
          final isSaving = productState is ProductsLoading;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // حقل عنوان الخدمة
                  _buildTextField(
                    controller: _titleCtrl,
                    label: l10n.serviceTitle,
                    hint: l10n.serviceTitlePlaceholder,
                    validator: (val) => (val == null || val.trim().length < 3) ? l10n.minCharacters(3) : null,
                  ),
                  const SizedBox(height: 16),

                  // حقل وصف الخدمة
                  _buildTextField(
                    controller: _descriptionCtrl,
                    label: l10n.serviceDescription,
                    hint: l10n.serviceDescriptionPlaceholder,
                    maxLines: 4,
                    validator: (val) => (val == null || val.trim().length < 10) ? l10n.minCharacters(10) : null,
                  ),
                  const SizedBox(height: 16),

                  // حقل السعر
                  _buildTextField(
                    controller: _priceCtrl,
                    label: l10n.servicePrice,
                    hint: '99.99',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icons.attach_money_rounded,
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.passwordRequired; // يمكن استخدام نص مخصص للسعر
                      if (double.tryParse(val) == null) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // قسم رفع الصور
                  _buildImagePicker(),
                  if (_selectedImages.isNotEmpty) _buildImagePreview(),

                  const SizedBox(height: 24),

                  // قائمة التصنيفات المنسدلة
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }
                      if (state is CategoriesLoaded) {
                        return _buildCategoryDropdown(l10n, state.categories);
                      }
                      if (state is CategoriesError) {
                        return Text('Error loading categories: ${state.message}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 32),

                  // زر الحفظ
                  PrimaryButton(
                    label: l10n.saveService,
                    onPressed: isSaving ? null : _onSave,
                    isLoading: isSaving,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return OutlinedButton.icon(
      onPressed: _pickImages,
      icon: const Icon(Icons.add_photo_alternate_outlined),
      label: const Text('Upload Service Images'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final imageFile = _selectedImages[index];
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(imageFile.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              IconButton(
                icon: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
                onPressed: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n, List<Category> categories) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategoryId,
      hint: Text(l10n.serviceCategoryHint),
      onChanged: (newValue) {
        setState(() {
          _selectedCategoryId = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: l10n.serviceCategory,
        prefixIcon: const Icon(Icons.category_outlined, size: 20),
      ),
    );
  }
}