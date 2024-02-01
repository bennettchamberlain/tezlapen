class Testimonial {
  Testimonial({
    required this.testimonialName,
    required this.testimonialVideo,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      testimonialName: map['testimonialName'] as String,
      testimonialVideo: map['testimonialVideo'] as String,
    );
  }
  final String testimonialName;
  final String testimonialVideo;

  Testimonial copyWith({
    String? testimonialName,
    String? testimonialVideo,
  }) {
    return Testimonial(
      testimonialName: testimonialName ?? this.testimonialName,
      testimonialVideo: testimonialVideo ?? this.testimonialVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'testimonialName': testimonialName,
      'testimonialVideo': testimonialVideo,
    };
  }

  @override
  String toString() =>
      'Testimonial(testimonialName: $testimonialName, testimonialVideo: $testimonialVideo)';

  @override
  bool operator ==(covariant Testimonial other) {
    if (identical(this, other)) return true;

    return other.testimonialName == testimonialName &&
        other.testimonialVideo == testimonialVideo;
  }

  @override
  int get hashCode => testimonialName.hashCode ^ testimonialVideo.hashCode;
}
