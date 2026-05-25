class AppConstants {
  AppConstants._();

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 40.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusRound = 9999.0;
  static const double iconSM = 14.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 28.0;
  static const double inputHeight = 56.0;
  static const double buttonHeight = 56.0;
  static const double bottomNavHeight = 72.0;
  static const double designWidth = 390.0;
  static const double designHeight = 884.0;

  // ── Image URLs ──────────────────────────────────────────────────────────

  /// Profile avatar — Home & Bookings app-bar
  static const String imgProfileAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBckCwm5GEJoCV8V0lqtsnvQOTouvvPJ-_PF1ran3h91QzOkHAcr1m34iuMb9qh-N5Xfcp9ZH82f42E1UIVZbMKkAkhnmtIUDX0oVddlApeJPKPE74F9AFD5kO5OHG_jk6f-PCKJrbJB_0EP5ykSWi8Nrky78I4aORdM-AcrhfCHHjRsrgadTn9_s6OAN7y-vgg-XdA9v-CB5kD8VDh9ni3zjD3xeiLeTmzbFOq1QS5a2tfjsEiNpHFG_Wa9ah1AO1GGBO8OyCW2Mk';

  /// Home promo banner — Summer Shine Package car
  static const String imgPromoCarBanner =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC6_RHDaOeg3eZ5MsI9Vywpe838X1ZhNP_YAGON_WCzNqczo0Ppn-UP-YKxOTpsHn0RbvYnsId6ZbGhC60xEf6nq8LDysEp_hLBuGIGmoJq2zf2ipySRXaVkCSuek_gfhNkO7qlKpdGKb8qwNoQOAXghPCLE6IRAJbLS_ZLcEiNcUh9PhtoO2lfEyMCiT8UlhA98ILNNVJsM8ZVVlh1ipE3vsVajN-HSZFpOwtdilRXebMjWypl0SeyNihoUTlJ3RB1YAF7e59TWlc';

  /// Onboarding booking — top-right floating card (luxury car dashboard)
  static const String imgOnboardingCarDashboard =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBET98sARTNmd0wKVxhEceImbSPddDRtnmz_lzLpWxfheVSPYY5SeEsJ-6lbIRkoccvNls8t4UMkq2eeCSMuQiFizMKc8Yz6iX4DAgZqlJoyxmzfjMhpkKqmFrtXmMGClQ6YEtVdLOiHMuZYOafrGVRYvaCBI-KApmYd-L81zLbpGKsDN2UfYmqYXQ7dge0A5Fy8CoQy7YYHIQVgbjtUCZDc0fP0NpY5mN-hwn5mg9dc57P0QoLGfKXfCZd08E95qwulibOSWY67Dk';

  /// Onboarding booking — bottom-left floating circle (mechanic with tablet)
  static const String imgOnboardingMechanic =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAC4OtidhfnPkywqxBeTkF7Mn3SOY3s3YRkodFqCAoS8J1AwXooyM29lDNS16KGUWDHPvuoeTWfFzDA0D5MoC2p4qYWeoLWDb7dlyDgZDI2eyyVPViXKLDs9GnDVi3iWfvtBY5ThEkVu1kLnc40nG_9c6Vb2_D7ou6cD57fJ8sF4JcdufFoHYreZ4APP_9JRPqIUhcO1cCGMYWDr6MnWlz4e7V4ocKFdKDKMCuDJt7DvedHEveLiNhXwHXHcgqWObGyy-avdXeM3z0';

  /// Onboarding tracking — full map background
  static const String imgOnboardingMap =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdjvwzSPsB7b5PBx_NIgyqRmLKjOzlwKGPF9lnKCF1e-44CXz5p2ZNTO_xsCAD-ek6t_eoXZ-GtUon_bWYLYTyjtuwM93-Qi-S9dgRkPF4I1F4gcCD7vGIz17YkzpNrHk_aopv66JNMPRJBLmLPERNtXioPmzPHTaD7m3xojCHTSKfKY31iHAWXM1hhB7aFx3k67HCL9Z0Rc7sbaeIccf4-6tJlwQkBOoyyX6Tm3UZooqJ8y-9Ly-7fVEp8jtj_ZP04vPS9YvYuXM';

  /// Onboarding tracking floating card + Bookings card — technician (Marcus Chen)
  static const String imgTechnicianAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDjf16670slRFkZP2nBbxh_5VdDJXIDbhJw3QFxPCtHP8gS_Syg1K9MulCLJRMiTv7sr6m4_b0YEav3ssPi0sa7PWUBdR8jUaDK3lniqgdGaq99rUJrw-3MyEq1xe8VhDD3GY-CIW6-oZarlACjwALsWWWhsp1BXpKorKdp1ldzCG21Vib3cZRKD9uJiTXoudV_LkPNwhuQkPNHneIdltz5QKFMxeJhv79BJnwhiPmwy0VnXVtqqCA19rYxVoytBFqJ2RpdWuBqNxs';

  /// Sign-In — Google logo button image
  static const String imgGoogleLogo =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBxr3ij99BvUJMNc8JpfFFtAPL3CsFmUgtV7MSf3ttVht9J17EiA6PLve_cijzmZLL2sRBiJ9Wgz6RDSsrXkB7Q0WHskH4zWEcE26CHyjUO8DqJZb93wHFOvWHomFVXgoCSzwOfbu62VPzKxG-q8f2kIjyId-3UnaHmWoJi0ybtdMnad086BaHbTeI9Zs6kweODL5r9ZhKbPO25XOr4l2IiNDrbd74WWSQtz2vg0XwXlbWQn0dW4FOCxaSbdyLSRwaReqZ9gfbl4nE';

  /// Updates app-bar profile avatar
  static const String imgUpdatesProfileAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB-eSfCWYrAi5vxnFIrGCNOmkWGDS4hMsQkqTFErCQ1whn7ppoql2ytY4MLbJ8MSycC-MO9Czmx0N7PPM8ctcLnKLHciIXyPiAiJduBwypHvjjp0LnmdF0K3AkP99k7w20_HIz-PYfrSAWfnKBSzw0Ttfzft8cNYB3kSqQdiQM5K5Q7lX90Ir-kTzphtN2Gqql1zHrocFxvaTcYHokoS3fDdmrwPFzhlDm0OB8uEOAOq-_9YD54GQyfJ3AG66cvwe4r_cXlWgl1BaM';

  /// Updates Platform News card — car interior image
  static const String imgUpdatesCarInterior =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDfZrQte_Asehstz0JfzBMaX0kS0UrIN0u4JlxWhOqKPgaHxNlcksd3Kw7GdCluQEMm4HBsYN8BSXTKptECPvA41Cno03CkAhrCgEQHFBLlvBWjLb8ByC_1t1Ro2RoDjeMBxCQpumN5ZPgkaaFM2KGEzejuR90Ccl2JcIys0A-gndnnHIQ1KVTbuCSbCvf_T_NFDzQwpEy7Thv2IPmTLwO4a3BGuqKj9w2VwYaz9SrLSqyZAH6UL-lvyW3t35uQYTyXnHm7JtafIEM';

  /// Settings app-bar profile avatar
  static const String imgSettingsProfileAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDDZcHUnU7LJUt6du8uUsGb7m0sbAAylGpCm1yo2NbYgOjbyz29TzHLnRDoMQIGi7H5o-5xpXuERz8oWs2N-ZLZ9wr7gKg3vr19XSvghC5BsM10ms9RpvoBvvBzOZtU_QrwmOE_aot685rLzyIiETWXfErCz8gV27wer7xtE206tXh6hSexQPO6tWsksnJOGRXyFwF5hAv5nO53E6PiQvF7Nb_bKewQ6yTuUaGtLD0PD9fGKS-7KrjLGCVR0Moeb9w1RTUvt82w2OU';

  /// Settings Help Center banner image
  static const String imgSettingsHelpCenter =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAQ7h0qTKMlNehdXBlM5RTev_1cajDjubU86hcUht6IZnv5hDK1s3hHabRLFEI0en9red4qkquzE_qL3_qS6BOn3BZsRTmJKViEFNJDK_cFbxMNDIvpOIP5xpU0TnH0y6iztWUKaEpg1J_I9fPXOQ3dhcXtU8GuceHv2G5Xiv23UuzCJwyeZwGRC-p0E9w2r2bTHXLj-4wb1i3JadKHpsd89VbywoyiA8FCFWA15ICgcbovsnKv-WXeSOg_lUOSvFaBmHAh2QBgCeM';

  // Legacy aliases
  static const String profileImageUrl = imgProfileAvatar;
  static const String technicianImageUrl = imgTechnicianAvatar;
}
