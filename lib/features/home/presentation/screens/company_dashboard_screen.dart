import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:revexa/features/ads/presentation/cubit/ads_state.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsCubit>().loadAds();
    });
  }

  void _showAdForm(BuildContext context, {AdEntity? ad}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<AdsCubit>()),
          ],
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(modalContext).viewInsets.bottom,
            ),
            child: _AdFormSheet(ad: ad),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AdEntity ad) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            l10n.deleteUserConfirmationTitle,
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppColors.onSurface),
          ),
          content: Text(
            'Are you sure you want to delete this promotion/ad?',
            style: GoogleFonts.urbanist(color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: GoogleFonts.urbanist(color: AppColors.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AdsCubit>().deleteAd(ad.id);
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(l10n.delete, style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Company Panel',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: AppColors.onSurfaceVariant),
            tooltip: l10n.signOut,
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: Text(l10n.confirmSignOut, style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  content: Text(l10n.confirmSignOutMessage, style: GoogleFonts.urbanist(color: AppColors.onSurfaceVariant)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l10n.cancel, style: GoogleFonts.urbanist(color: AppColors.onSurfaceVariant)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(l10n.confirmSignOut, style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildAdsTab(l10n),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdForm(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Offer',
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAdsTab(AppLocalizations l10n) {
    return BlocConsumer<AdsCubit, AdsState>(
      listener: (context, state) {
        if (state is AdsError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
          if (state is AdsLoading || state is AdsInitial) {
            return _buildShimmerList();
          } else if (state is AdsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load promotions', style: GoogleFonts.urbanist(fontSize: 16, color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<AdsCubit>().loadAds(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text(l10n.retry, style: GoogleFonts.urbanist(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (state is AdsLoaded) {
            final ads = state.ads;
            if (ads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.campaign_outlined, color: AppColors.primary.withValues(alpha: 0.4), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No promotional offers created yet',
                      style: GoogleFonts.urbanist(fontSize: 16, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Click the button below to add your first offer!',
                      style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdsCubit>().loadAds();
              },
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return _AdListItemCard(
                    ad: ad,
                    onEdit: () => _showAdForm(context, ad: ad),
                    onDelete: () => _confirmDelete(context, ad),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContainerLow,
      highlightColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _AdListItemCard extends StatelessWidget {
  final AdEntity ad;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdListItemCard({
    required this.ad,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: ad.imageUrl,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.surfaceContainerLow),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.error.withValues(alpha: 0.1),
                  child: Icon(Icons.broken_image_outlined, color: AppColors.error, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (ad.description != null && ad.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      ad.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: ad.isActive
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.onSurfaceVariant.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ad.isActive ? 'ACTIVE' : 'INACTIVE',
                          style: GoogleFonts.urbanist(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: ad.isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (ad.actionUrl != null && ad.actionUrl!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.link_rounded, size: 14, color: AppColors.primary),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdFormSheet extends StatefulWidget {
  final AdEntity? ad;
  const _AdFormSheet({this.ad});

  @override
  State<_AdFormSheet> createState() => _AdFormSheetState();
}

class _AdFormSheetState extends State<_AdFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imgUrlCtrl;
  late final TextEditingController _actionUrlCtrl;
  bool _isActive = true;
  bool _isUploading = false;
  XFile? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.ad?.title ?? '');
    _descCtrl = TextEditingController(text: widget.ad?.description ?? '');
    _imgUrlCtrl = TextEditingController(text: widget.ad?.imageUrl ?? '');
    _actionUrlCtrl = TextEditingController(text: widget.ad?.actionUrl ?? '');
    _isActive = widget.ad?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _imgUrlCtrl.dispose();
    _actionUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    if (widget.ad == null) {
      // Create mode: save image file reference locally and display name
      setState(() {
        _selectedImageFile = file;
        _imgUrlCtrl.text = file.name;
      });
      return;
    }

    // Edit mode: upload immediately to get a URL for update request
    setState(() {
      _isUploading = true;
    });

    try {
      final adsCubit = context.read<AdsCubit>();
      final imageUrl = await adsCubit.uploadAdImage(file.path, folder: 'products');
      if (imageUrl != null && imageUrl.isNotEmpty) {
        setState(() {
          _imgUrlCtrl.text = imageUrl;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!'), backgroundColor: Colors.green),
          );
        }
      } else {
        throw Exception('Server did not return url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image. Enter URL manually: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final adsCubit = context.read<AdsCubit>();
    if (widget.ad != null) {
      // Update
      adsCubit.updateAd(
        widget.ad!.id,
        title: _titleCtrl.text.trim(),
        imageUrl: _imgUrlCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        actionUrl: _actionUrlCtrl.text.trim(),
        isActive: _isActive,
      );
      Navigator.pop(context);
    } else {
      // Create
      if (_selectedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Please select an image file first'), backgroundColor: AppColors.error),
        );
        return;
      }
      adsCubit.createAd(
        title: _titleCtrl.text.trim(),
        imageFile: _selectedImageFile!,
        description: _descCtrl.text.trim(),
        actionUrl: _actionUrlCtrl.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.ad != null;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Promotion' : 'Add Promotion',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            TextFormField(
              controller: _titleCtrl,
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Title is required' : null,
              style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
              decoration: const InputDecoration(
                labelText: 'Promotion Title *',
                hintText: 'e.g. 20% Off Maintenance Services',
              ),
            ),
            const SizedBox(height: 16),
            // Description
            TextFormField(
              controller: _descCtrl,
              maxLines: 2,
              style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'e.g. Valid until next Sunday. Book now and save.',
              ),
            ),
            const SizedBox(height: 16),
            // Image Upload + Url Input
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _imgUrlCtrl,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Image URL is required' : null,
                    style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
                    decoration: const InputDecoration(
                      labelText: 'Image URL *',
                      hintText: 'Paste direct link or click upload',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isUploading ? null : _pickAndUploadImage,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: _isUploading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.photo_library_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action URL
            TextFormField(
              controller: _actionUrlCtrl,
              style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
              decoration: const InputDecoration(
                labelText: 'Action Redirect URL (Optional)',
                hintText: 'e.g. https://revexa.com/special-offer',
              ),
            ),
            if (isEdit) ...[
              const SizedBox(height: 16),
              // Status Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Promotion Status',
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                  ),
                    Switch(
                    value: _isActive,
                    onChanged: (val) {
                      setState(() {
                        _isActive = val;
                      });
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            PrimaryButton(
              label: isEdit ? 'Save Changes' : 'Publish Promotion',
              onPressed: _isUploading ? null : _onSave,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
