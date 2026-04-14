enum SideRevenueCategory {
  icloud('icloud', 'iCloud'),
  consultation('consultation', 'استشارة'),
  maintenance('maintenance', 'صيانة'),
  other('other', 'أخرى');

  final String value;
  final String arabicLabel;

  const SideRevenueCategory(this.value, this.arabicLabel);

  static SideRevenueCategory fromString(String value) {
    return SideRevenueCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SideRevenueCategory.other,
    );
  }

  String getLabel(bool isArabic) => isArabic ? arabicLabel : value;

  static List<SideRevenueCategory> get allCategories => [
    SideRevenueCategory.icloud,
    SideRevenueCategory.consultation,
    SideRevenueCategory.maintenance,
    SideRevenueCategory.other,
  ];
}
