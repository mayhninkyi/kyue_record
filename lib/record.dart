import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String? tableName;
  DateTime? startDate;
  DateTime? endDate;
  int? total;
  int? beerCount;
  int? cigaretteCount;
  int? drink50Count;
  int? lighterCount;
  int? pockerCount;
  int? waterCount;
  String? note;

  Record(
      {this.tableName,
      this.startDate,
      this.endDate,
      this.total,
      this.beerCount,
      this.cigaretteCount,
      this.drink50Count,
      this.lighterCount,
      this.waterCount,
      this.pockerCount,
      this.note});

  factory Record.fromJSON(Map<dynamic, dynamic> json) {
    return Record(
        tableName: json["table_name"] ?? '1',
        startDate: (json["startDate"] as Timestamp).toDate(),
        endDate: json["endDate"] != null
            ? (json["endDate"] as Timestamp).toDate()
            : null,
        total: json["total"] ?? 0,
        beerCount: json["beer"] ?? 0,
        cigaretteCount: json["cigarette"] ?? 0,
        drink50Count: json["drink50"] ?? 0,
        lighterCount: json["lighter"] ?? 0,
        waterCount: json["water"] ?? 0,
        pockerCount: json["pocker"] ?? 0,
        note: json["note"] ?? '');
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
    data['lighter'] = lighterCount;
    data["water"] = waterCount;
    data["pocker"] = pockerCount;
    data["note"] = note;
    return data;
  }
}
