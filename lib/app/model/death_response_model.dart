// First, let's create the death record model

// Note :-
// we have to add the age factor when record the flock death , so later can
// do the proper analysis. ok
// so we have to add the age factor in the flock death model

class FlockDeathModel {
  final String? deathId;
  final String batchId;
  final String adminId;
  final int deathCount;
  final String cause;
  final String date;
  final String yearMonth;
  final String? notes;

  FlockDeathModel({
    this.deathId,
    required this.batchId,
    required this.adminId,
    required this.deathCount,
    required this.cause,
    required this.date,
    required this.yearMonth,
    this.notes,
  });

  factory FlockDeathModel.fromJson(Map<String, dynamic> json,
      {String? deathId}) {
    return FlockDeathModel(
      deathId: deathId ?? json['deathId'],
      batchId: json['batchId'] ?? '',
      adminId: json['adminId'] ?? '',
      deathCount: json['deathCount'] ?? 0,
      cause: json['cause'] ?? '',
      date: json['date'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deathId': deathId,
      'batchId': batchId,
      'adminId': adminId,
      'deathCount': deathCount,
      'cause': cause,
      'date': date,
      'yearMonth': yearMonth,
      if (notes != null) 'notes': notes,
    };
  }
}
