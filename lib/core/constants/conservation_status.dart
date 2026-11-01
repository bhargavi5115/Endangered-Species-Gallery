import 'package:flutter/material.dart';
import 'app_colors.dart';

enum ConservationStatus {
  ex('EX', 'Extinct', 'No known living individuals remaining worldwide.', AppColors.statusEX),
  ew('EW', 'Extinct in the Wild', 'Survives only in captivity or as a naturalized population.', AppColors.statusEW),
  cr('CR', 'Critically Endangered', 'Extremely high risk of extinction in the wild in immediate future.', AppColors.statusCR),
  en('EN', 'Endangered', 'Very high risk of extinction in the wild in near future.', AppColors.statusEN),
  vu('VU', 'Vulnerable', 'High risk of endangerment in the wild over medium term.', AppColors.statusVU),
  nt('NT', 'Near Threatened', 'Close to qualifying for a threatened category in the near future.', AppColors.statusNT),
  lc('LC', 'Least Concern', 'Lowest risk; does not qualify for a more at-risk category.', AppColors.statusLC),
  dd('DD', 'Data Deficient', 'Inadequate information to make a direct assessment of risk.', AppColors.statusDD),
  ne('NE', 'Not Evaluated', 'Has not yet been assessed against the IUCN criteria.', AppColors.statusNE);

  final String code;
  final String fullName;
  final String description;
  final Color color;

  const ConservationStatus(this.code, this.fullName, this.description, this.color);

  bool get isThreatened => this == cr || this == en || this == vu;
  bool get isExtinctOrWild => this == ex || this == ew;

  static ConservationStatus fromString(String? input) {
    if (input == null || input.trim().isEmpty) return ConservationStatus.ne;
    final normalized = input.trim().toUpperCase();

    for (final status in ConservationStatus.values) {
      if (status.code == normalized) return status;
      if (status.fullName.toUpperCase() == normalized) return status;
    }

    if (normalized.contains('CRITIC')) return ConservationStatus.cr;
    if (normalized.contains('ENDANG')) return ConservationStatus.en;
    if (normalized.contains('VULNER')) return ConservationStatus.vu;
    if (normalized.contains('NEAR')) return ConservationStatus.nt;
    if (normalized.contains('LEAST')) return ConservationStatus.lc;
    if (normalized.contains('WILD')) return ConservationStatus.ew;
    if (normalized.contains('EXTINCT')) return ConservationStatus.ex;
    if (normalized.contains('DEFICIENT')) return ConservationStatus.dd;

    return ConservationStatus.ne;
  }
}
