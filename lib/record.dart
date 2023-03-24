import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String? tableName;
  DateTime? startDate;
  DateTime? endDate;
  int? total;
  int? beerCount;
  int? cigaretteCount;
  int? drink50Count;
  int? drink100Count;
  int? pockerCount;
  int? waterCount;

  Record(
      {this.tableName,
      this.startDate,
      this.endDate,
      this.total,
      this.beerCount,
      this.cigaretteCount,
      this.drink50Count,
      this.drink100Count,
      this.waterCount,
      this.pockerCount});

  factory Record.fromJSON(Map<dynamic, dynamic> json) {
    return Record(
        tableName: json["table_name"] ?? '1',
        startDate: (json["startDate"] as Timestamp).toDate(),
        endDate: (json["endDate"] as Timestamp).toDate(),
        total: json["total"] ?? 0,
        beerCount: json["beer"] ?? 0,
        cigaretteCount: json["cigarette"] ?? 0,
        drink50Count: json["drink50"] ?? 0,
        drink100Count: json["drink100"] ?? 0,
        waterCount: json["water"] ?? 0,
        pockerCount: json["pocker"] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['table_name'] = tableName;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data["total"] = total;
    data["beer"] = beerCount;
    data['cigarette'] = cigaretteCount;
    data['drink50'] = drink50Count;
    data['drink100'] = drink100Count;
    data["water"] = waterCount;
    data["pocker"] = pockerCount;
    return data;
  }
}
