enum SuggestionType {
  search,
  category,
  subcategory,
  product,
  brand,
  style,
}

class SearchSuggestion {
  final String text;
  final SuggestionType type;
  final String? category;
  final String? subcategory;
  final String? productId;

  const SearchSuggestion({
    required this.text,
    required this.type,
    this.category,
    this.subcategory,
    this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type.name,
      'category': category,
      'subcategory': subcategory,
      'productId': productId,
    };
  }

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      text: json['text'] as String,
      type: SuggestionType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      productId: json['productId'] as String?,
    );
  }

  @override
  String toString() => text;
}