import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/categories/categories.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class EditServiceScreen extends StatefulWidget {
  final Product product;
  const EditServiceScreen({super.key, required this.product});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _selectedCategoryId;

  static const List<Map<String, String>> _governorates = [
    {'en': 'Cairo', 'ar': 'القاهرة'},
    {'en': 'Giza', 'ar': 'الجيزة'},
    {'en': 'Alexandria', 'ar': 'الإسكندرية'},
    // ... other governorates
  ];
  final List<Map<String, String>> _selectedLocations = [];

  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().loadCategories();

    _titleCtrl.text = widget.product.title;
    _descriptionCtrl.text = widget.product.description;
    _priceCtrl.text = widget.product.price.toStringAsFixed(0);
    _selectedCategoryId = widget.product.category;

    // Parse location string back to list of maps
    final locations = (widget.product.location ?? '').split(',').map((e) => e.trim()).toList();
    for (final loc in locations) {
      final gov = _governorates.firstWhere(
        (g) => g['en']?.toLowerCase() == loc.toLowerCase(),
        orElse: () => {'en': loc, 'ar': loc},
      );
      _selectedLocations.add(gov);
    }
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
    if (price == null) return;

    final locationString = _selectedLocations.map((gov) => gov['en']!).join(', ');

    final updateData = {
      'title': _titleCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'price': price.toString(),
      'category': _selectedCategoryId,
      'location': locationString,
    };

    context.read<ProductsCubit>().updateProduct(widget.product.id, updateData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductUpdated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Service updated successfully!'), backgroundColor: Colors.green),
            );
          Navigator.of(context).pop(true); // Pop with success
        }
        if (state is ProductsError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Edit Service', // Placeholder - Add to l10n
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, productState) {
          final isSaving = productState is ProductsLoading;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _titleCtrl,
                    label: l10n.serviceTitle,
                    hint: l10n.serviceTitlePlaceholder,
                    validator: (val) => (val == null || val.trim().length < 3) ? l10n.minCharacters(3) : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionCtrl,
                    label: l10n.serviceDescription,
                    hint: l10n.serviceDescriptionPlaceholder,
                    maxLines: 4,
                    validator: (val) => (val == null || val.trim().length < 10) ? l10n.minCharacters(10) : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceCtrl,
                    label: l10n.servicePrice,
                    hint: '99.99',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icons.attach_money_rounded,
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.passwordRequired;
                      if (double.tryParse(val) == null) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Image editing is complex, let's skip for now and show current images
                  _buildImageSection(),
                  const SizedBox(height: 16),
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }
                      if (state is CategoriesLoaded) {
                        return _buildCategoryDropdown(l10n, state.categories);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLocationSelector(Localizations.localeOf(context).languageCode == 'ar'),
                  const SizedBox(height: 32),
                  PrimaryButton( // Placeholder - Add to l10n
                    label: 'Save Changes',
                    onPressed: isSaving ? null : _onSave,
                    isLoading: isSaving,
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
    // Ensure the selected ID is valid
    final validId = categories.any((c) => c.id == _selectedCategoryId) ? _selectedCategoryId : null;

    return DropdownButtonFormField<String>(
      initialValue: validId,
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

  Widget _buildImageSection() {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'صور الخدمة الحالية' : 'Current Service Images',
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
          child: widget.product.images.isEmpty
              ? Center(child: Text(isArabic ? 'لا توجد صور لهذه الخدمة' : 'No images for this service'))
              : SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = widget.product.images[index].url;
                      return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (c, u) => Container(color: AppColors.surfaceContainerLow),
                            errorWidget: (c, u, e) => const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            isArabic ? 'ملاحظة: تعديل الصور غير مدعوم حاليًا. لحذف أو إضافة صور، يرجى حذف الخدمة وإضافتها من جديد.' : 'Note: Image editing is not currently supported. To change images, please delete and re-create the service.',
            style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ),
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
      ],
    );
  }

  void _showLocationMultiSelect(bool isArabic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _governorates.length,
                        itemBuilder: (context, index) {
                          final gov = _governorates[index];
                          final isSelected = _selectedLocations.any((e) => e['en'] == gov['en']);
                          return CheckboxListTile(
                            title: Text(gov[isArabic ? 'ar' : 'en']!),
                            value: isSelected,
                            onChanged: (checked) {
                              setModalState(() {
                                if (checked == true) {
                                  _selectedLocations.add(gov);
                                } else {
                                  _selectedLocations.removeWhere((e) => e['en'] == gov['en']);
                                }
                              });
                              setState(() {});
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