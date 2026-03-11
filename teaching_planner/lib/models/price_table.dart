class PriceTableRow {
  final String label;
  final int price2Days;
  final int price3Days;
  final int price5Days;

  PriceTableRow({
    required this.label,
    required this.price2Days,
    required this.price3Days,
    required this.price5Days,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'price2Days': price2Days,
      'price3Days': price3Days,
      'price5Days': price5Days,
    };
  }

  factory PriceTableRow.fromMap(Map<dynamic, dynamic> map) {
    return PriceTableRow(
      label: map['label'] as String,
      price2Days: (map['price2Days'] as int?) ?? 0,
      price3Days: (map['price3Days'] as int?) ?? 0,
      price5Days: (map['price5Days'] as int?) ?? 0,
    );
  }
}