class ProductFilters {
  final String? categoryId;
  final String? subcategory;
  final String? sortBy;
  final double? minPrice;
  final double? maxPrice;
  final String? searchQuery;
  final List<String>? selectedSizes;
  final List<String>? selectedColors;
  final List<String>? selectedStyles;
  final List<String>? selectedOccasions;

  const ProductFilters({
    this.categoryId,
    this.subcategory,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.searchQuery,
    this.selectedSizes,
    this.selectedColors,
    this.selectedStyles,
    this.selectedOccasions,
  });

  ProductFilters copyWith({
    String? categoryId,
    String? subcategory,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
    List<String>? selectedSizes,
    List<String>? selectedColors,
    List<String>? selectedStyles,
    List<String>? selectedOccasions,
  }) {
    return ProductFilters(
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      sortBy: sortBy ?? this.sortBy,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      selectedColors: selectedColors ?? this.selectedColors,
      selectedStyles: selectedStyles ?? this.selectedStyles,
      selectedOccasions: selectedOccasions ?? this.selectedOccasions,
    );
  }
}
