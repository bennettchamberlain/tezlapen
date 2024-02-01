
class Affiliate {
  final String affiliateName;
  final String affiliateUrl;
  Affiliate({
    required this.affiliateName,
    required this.affiliateUrl,
  });

  Affiliate copyWith({
    String? affiliateName,
    String? affiliateUrl,
  }) {
    return Affiliate(
      affiliateName: affiliateName ?? this.affiliateName,
      affiliateUrl: affiliateUrl ?? this.affiliateUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'affiliateName': affiliateName,
      'affiliateUrl': affiliateUrl,
    };
  }

  factory Affiliate.fromMap(Map<String, dynamic> map) {
    return Affiliate(
      affiliateName: map['affiliateName'] as String,
      affiliateUrl: map['affiliateUrl'] as String,
    );
  }

  @override
  String toString() =>
      'Affiliate(affiliateName: $affiliateName, affiliateUrl: $affiliateUrl)';

  @override
  bool operator ==(covariant Affiliate other) {
    if (identical(this, other)) return true;

    return other.affiliateName == affiliateName &&
        other.affiliateUrl == affiliateUrl;
  }

  @override
  int get hashCode => affiliateName.hashCode ^ affiliateUrl.hashCode;
}
