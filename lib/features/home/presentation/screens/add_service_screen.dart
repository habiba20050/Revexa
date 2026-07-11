import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
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

  static const List<Map<String, String>> _governorates = [
    {'en': 'Cairo', 'ar': 'القاهرة'},
    {'en': 'Giza', 'ar': 'الجيزة'},
    {'en': 'Alexandria', 'ar': 'الإسكندرية'},
    {'en': 'Assiut', 'ar': 'أسيوط'},
    {'en': 'Sohag', 'ar': 'سوهاج'},
    {'en': 'Qena', 'ar': 'قنا'},
    {'en': 'Aswan', 'ar': 'أسوان'},
    {'en': 'Minya', 'ar': 'المنيا'},
    {'en': 'Fayoum', 'ar': 'الفيوم'},
    {'en': 'Beni Suef', 'ar': 'بني سويف'},
    {'en': 'Qalyubia', 'ar': 'القليوبية'},
    {'en': 'Monufia', 'ar': 'المنوفية'},
    {'en': 'Gharbia', 'ar': 'الغربية'},
    {'en': 'Dakahlia', 'ar': 'الدقهلية'},
    {'en': 'Sharqia', 'ar': 'الشرقية'},
    {'en': 'Beheira', 'ar': 'البحيرة'},
    {'en': 'Damietta', 'ar': 'دمياط'},
    {'en': 'Kafr El-Sheikh', 'ar': 'كفر الشيخ'},
    {'en': 'Port Said', 'ar': 'بورسعيد'},
    {'en': 'Suez', 'ar': 'السويس'},
    {'en': 'Ismailia', 'ar': 'الإسماعيلية'},
    {'en': 'Red Sea', 'ar': 'البحر الأحمر'},
    {'en': 'Matrouh', 'ar': 'مطروح'},
    {'en': 'New Valley', 'ar': 'الوادي الجديد'},
    {'en': 'North Sinai', 'ar': 'شمال سيناء'},
    {'en': 'South Sinai', 'ar': 'جنوب سيناء'},
    {'en': 'Luxor', 'ar': 'الأقصر'},
  ];
  final List<Map<String, String>> _selectedLocations = [];

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

    if (_selectedLocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == 'ar'
              ? 'يرجى اختيار محافظة واحدة على الأقل'
              : 'Please select at least one governorate'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceCtrl.text);
    if (price == null) {
      return;
    }

    final locationString = _selectedLocations.map((gov) => gov['en']!).join(', ');

    // If no images selected, backend requires at least one image — show error
    if (_selectedImages.isEmpty) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isArabic ? 'الرجاء رفع صورة واحدة على الأقل' : 'Please upload at least one image'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    // The backend expects a single multipart request. We no longer upload images separately.
    // We pass the XFile list directly to the cubit.
    context.read<ProductsCubit>().createProduct(
          title: _titleCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          price: price,
          category: _selectedCategoryId!,
          location: locationString,
          images: _selectedImages,
        );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    // يمكنك استخدام pickMultipleMedia للسماح باختيار صور وفيديوهات
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (!mounted) return;
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
                  _buildImageSection(),

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
                  const SizedBox(height: 16),
                  _buildLocationSelector(Localizations.localeOf(context).languageCode == 'ar'),
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
          child: Row(
            children: [
              if (category.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.surfaceContainerLow),
                    errorWidget: (context, url, error) => const Icon(Icons.category_outlined, size: 20),
                  ),
                ),
              const SizedBox(width: 12),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: l10n.serviceCategory,
        prefixIcon: const Icon(Icons.category_outlined, size: 20),
      ),
    );
  }

  Widget _buildImageSection() {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'صور الخدمة' : 'Service Images',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              if (_selectedImages.isNotEmpty)
                SizedBox(
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: kIsWeb
                                        ? FutureBuilder<Uint8List>(
                                            future: imageFile.readAsBytes(),
                                            builder: (context, snap) {
                                              if (snap.connectionState != ConnectionState.done) return Container(color: AppColors.surfaceContainerLow);
                                              if (snap.hasError || snap.data == null) return Container(color: AppColors.surfaceContainerLow);
                                              return Image.memory(snap.data!, fit: BoxFit.cover);
                                            },
                                          )
                                        : Image.file(File(imageFile.path), fit: BoxFit.cover),
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
                ),
              if (_selectedImages.isNotEmpty) const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(isArabic ? 'إضافة أو تغيير الصور' : 'Add / Change Images'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLocationSelector(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _showLocationMultiSelect(isArabic),
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: isArabic ? 'المحافظات المتاحة' : 'Available Governorates',
              prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
            ),
            child: Text(
              _selectedLocations.isEmpty
                  ? (isArabic ? 'اختر المحافظات' : 'Select Governorates')
                  : isArabic
                      ? 'تم اختيار ${_selectedLocations.length} محافظات'
                      : '${_selectedLocations.length} Governorates selected',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: _selectedLocations.isEmpty ? AppColors.onSurfaceVariant : AppColors.onSurface,
              ),
            ),
          ),
        ),
        if (_selectedLocations.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedLocations.map((gov) {
              return Chip(
                label: Text(gov[isArabic ? 'ar' : 'en']!),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  setState(() {
                    _selectedLocations.remove(gov);
                  });
                },
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                labelStyle: GoogleFonts.urbanist(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _showLocationMultiSelect(bool isArabic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? 'اختر المحافظات' : 'Select Governorates',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              isArabic ? 'تم' : 'Done',
                              style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _governorates.length,
                        itemBuilder: (context, index) {
                          final gov = _governorates[index];
                          final isSelected = _selectedLocations.contains(gov);
                          return CheckboxListTile(
                            title: Text(
                              gov[isArabic ? 'ar' : 'en']!,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: AppColors.onSurface,
                              ),
                            ),
                            value: isSelected,
                            activeColor: AppColors.primary,
                            onChanged: (checked) {
                              setModalState(() {
                                if (checked == true) {
                                  _selectedLocations.add(gov);
                                } else {
                                  _selectedLocations.remove(gov);
                                }
                              });
                              setState(() {}); // Refresh parent tag list
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}