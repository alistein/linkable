enum Milestones {
  starter(1, "Starter", 0, 0),
  beginner(2, "Beginner", 1000, 0.5),
  risingStart(3, "Rising Star", 2000, 1),
  expert(4, "Expert", 10000, 1.25),
  legend(5, "Legend", 20000, 1.5);

  final int order;
  final String name;
  final int points;
  final double amount;

  const Milestones(this.order, this.name, this.points, this.amount);

  static List<Milestones> get sortedValues => List<Milestones>.from(values)
    ..sort((a, b) => a.points.compareTo(b.points));

  Milestones? get next {
    final sorted = Milestones.sortedValues;
    int currentIndex = sorted.indexOf(this);
    if (currentIndex < sorted.length - 1) {
      return sorted[currentIndex + 1];
    }
    return null;
  }

}

extension MilestoneExtension on Milestones {
  double get convertFullBalanceToAmount => points * amount;

  double convertToAmount(String enteredPoints){

    double pointsValue = double.tryParse(enteredPoints) ?? 0;

    return pointsValue * amount;
  }
}
