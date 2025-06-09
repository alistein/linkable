import 'package:linkable/models/label_value_pair.dart';
import 'package:get/get.dart';

final List<LabelValuePair<int>> ticketSortTypes = [
  LabelValuePair(label: "sendDate".tr, value: 1),
  LabelValuePair(label: "lastUpdatedDate".tr, value: 3),
  LabelValuePair(label: "priority".tr, value: 4),
  LabelValuePair(label: "status".tr, value: 2),
];

double buttonHeight = 50;
double mediumButtonHeight = 45;
double smallButtonHeight = 35;

enum AppBarBackgroundColors {registrationVersion, mainVersion}