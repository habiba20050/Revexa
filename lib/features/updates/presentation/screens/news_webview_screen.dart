import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/shared/widgets/app_webview.dart';

class NewsWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const NewsWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<NewsWebViewScreen> createState() => _NewsWebViewScreenState();
}

class _NewsWebViewScreenState extends State<NewsWebViewScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final domain = Uri.tryParse(widget.url)?.host ?? '';
    return Scaffold(
      backgroundColor: Colors.transparent, // Allow backdrop blur to bleed through
      body: Stack(
        children: [
          // Background Backdrop blur for Liquid Glass look
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: AppColors.background.withValues(alpha: 0.5),
              ),
            ),
          ),
          // Main content container
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.70), // Translucent liquid glass
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Column(
                    children: [
                      // Liquid Glass Control Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.40),
                          border: Border(
                            bottom: BorderSide(color: AppColors.outline.withValues(alpha: 0.30)),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.outline),
                                ),
                                child: Icon(Icons.close_rounded, color: AppColors.onSurface, size: 20),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    domain,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 10,
                                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Quick reload action
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Force reload
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, _, __) => NewsWebViewScreen(url: widget.url, title: widget.title),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.outline),
                                ),
                                child: Icon(Icons.refresh_rounded, color: AppColors.onSurface, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Linear Loading Indicator
                      if (_isLoading)
                        LinearProgressIndicator(
                          color: AppColors.primary,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          minHeight: 2.5,
                        ),
                      // WebView Widget
                      Expanded(
                        child: Stack(
                          children: [
                            AppWebView(url: widget.url),
                            // Simulated load timeout to hide progress indicator
                            if (_isLoading)
                              FutureBuilder(
                                future: Future.delayed(const Duration(milliseconds: 1500)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted && _isLoading) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    });
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
