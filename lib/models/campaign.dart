class Campaign {
  final String id;
  final String name;
  final String advertiserId;
  final List<String> screenIds;
  final String contentUrl;
  final String contentType; // 'image', 'video', 'html'
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> schedule; // Time slots per day
  final double budget;
  final double spent;
  final String status; // 'draft', 'active', 'paused', 'completed'
  final Map<String, int> analytics; // Views, clicks, etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  Campaign({
    required this.id,
    required this.name,
    required this.advertiserId,
    required this.screenIds,
    required this.contentUrl,
    required this.contentType,
    required this.startDate,
    required this.endDate,
    required this.schedule,
    required this.budget,
    required this.spent,
    required this.status,
    required this.analytics,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      advertiserId: json['advertiserId'] ?? '',
      screenIds: List<String>.from(json['screenIds'] ?? []),
      contentUrl: json['contentUrl'] ?? '',
      contentType: json['contentType'] ?? 'image',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      schedule: json['schedule'] ?? {},
      budget: (json['budget'] ?? 0.0).toDouble(),
      spent: (json['spent'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'draft',
      analytics: Map<String, int>.from(json['analytics'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'advertiserId': advertiserId,
      'screenIds': screenIds,
      'contentUrl': contentUrl,
      'contentType': contentType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'schedule': schedule,
      'budget': budget,
      'spent': spent,
      'status': status,
      'analytics': analytics,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  double get remainingBudget => budget - spent;
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
}