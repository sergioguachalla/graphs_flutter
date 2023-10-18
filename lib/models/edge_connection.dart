class EdgeConnection {
  final String source;
  final String target;
  final int cost;

  EdgeConnection({required this.source, required this.target, required this.cost});

  EdgeConnection copyWith({
    String? source,
    String? target,
    int? cost,
  }) {
    return EdgeConnection(
      source: source ?? this.source,
      target: target ?? this.target,
      cost: cost ?? this.cost,
    );
  }
}