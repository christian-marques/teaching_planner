import 'package:hive_flutter/hive_flutter.dart';
import '../models/price_table.dart';

class PriceTableStorageService {
  static const String boxName = 'price_table_box';
  static const String priceTableKey = 'price_table_rows';

  static Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  static Future<List<PriceTableRow>> getPriceTable() async {
    final box = await _getBox();
    final rawList = box.get(priceTableKey, defaultValue: []) as List;

    return rawList
        .map((item) => PriceTableRow.fromMap(Map<dynamic, dynamic>.from(item as Map)))
        .toList();
  }

  static Future<void> savePriceTable(List<PriceTableRow> rows) async {
    final box = await _getBox();
    final data = rows.map((row) => row.toMap()).toList();
    await box.put(priceTableKey, data);
  }
}