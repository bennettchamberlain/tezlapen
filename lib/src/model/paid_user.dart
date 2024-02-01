
class PaidUser {
  PaidUser({
    required this.userUuid,
    required this.boughtProduct,
    required this.createdAt,
  });
  final String userUuid;
  final bool boughtProduct;
  final DateTime createdAt;

  PaidUser copyWith({
    String? userUuid,
    bool? boughtProduct,
    DateTime? createdAt,
  }) {
    return PaidUser(
      userUuid: userUuid ?? this.userUuid,
      boughtProduct: boughtProduct ?? this.boughtProduct,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userUuid': userUuid,
      'boughtProduct': boughtProduct,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PaidUser.fromMap(Map<String, dynamic> map) {
    return PaidUser(
      userUuid: map['userUuid'] as String,
      boughtProduct: map['boughtProduct'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

 
  @override
  String toString() => 'PaidUser(userUuid: $userUuid, boughtProduct: $boughtProduct, createdAt: $createdAt)';

  @override
  bool operator ==(covariant PaidUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.userUuid == userUuid &&
      other.boughtProduct == boughtProduct &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode => userUuid.hashCode ^ boughtProduct.hashCode ^ createdAt.hashCode;
}
