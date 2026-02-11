/// Vaccine Education Content
/// Simple, parent-friendly explanations for each vaccine
/// Based on WHO and Indian National Immunization Schedule

class VaccineEducation {
  final String disease;
  final String whyImportant;
  final String ifMissed;
  final String? safety;

  const VaccineEducation({
    required this.disease,
    required this.whyImportant,
    required this.ifMissed,
    this.safety,
  });
}

class VaccineEducationHelper {
  static const _educationContent = {
    // Birth Doses
    'BCG': VaccineEducation(
      disease: 'Tuberculosis (TB)',
      whyImportant:
          'BCG is given at birth to protect newborns from severe forms of tuberculosis, especially TB meningitis and disseminated TB. Newborns have weaker immune systems, making early protection crucial.',
      ifMissed:
          'If BCG is missed at birth, it can still be given up to 1 year of age, though earlier is better. Children who miss BCG are at higher risk of severe TB infections.',
      safety:
          'BCG is one of the oldest and safest vaccines, used worldwide for over 100 years.',
    ),
    'OPV-0': VaccineEducation(
      disease: 'Polio',
      whyImportant:
          'OPV-0 (Zero Dose) is given at birth to provide early protection against polio. This first dose helps build immunity in the first few days of life when babies are most vulnerable.',
      ifMissed:
          'If OPV-0 is missed, the child should receive it as soon as possible. The regular OPV schedule (6, 10, 14 weeks) will still provide protection.',
      safety: 'OPV is extremely safe and has been used to nearly eliminate polio worldwide.',
    ),
    'HEPATITIS B': VaccineEducation(
      disease: 'Hepatitis B (liver infection)',
      whyImportant:
          'The Hepatitis B birth dose is critical because it prevents mother-to-child transmission of the virus during delivery. Giving the vaccine within 24 hours of birth provides the best protection.',
      ifMissed:
          'If the birth dose is missed, it should be given as soon as possible. The regular Hepatitis B schedule (6, 10, 14 weeks) will still provide protection.',
      safety: 'Hepatitis B vaccine is very safe and well-tolerated.',
    ),
    // 6 Weeks Vaccines
    'DPT': VaccineEducation(
      disease: 'Diphtheria, Pertussis (Whooping Cough), and Tetanus',
      whyImportant:
          'DPT protects against three serious diseases. Starting at 6 weeks ensures your baby is protected early when they\'re most vulnerable.',
      ifMissed:
          'If missed, DPT can be given at the next visit. It\'s important to complete all three doses (6, 10, 14 weeks) plus boosters.',
      safety: 'DPT is very safe. Some babies may have mild fever or fussiness, which is normal.',
    ),
    'MMR': VaccineEducation(
      disease: 'Measles, Mumps, and Rubella',
      whyImportant:
          'MMR vaccine protects against three common childhood diseases. This vaccine is given at 9 months to provide strong immunity.',
      ifMissed:
          'If missed, MMR should be given as soon as possible. It\'s crucial to get both doses for full protection.',
      safety: 'MMR is a very safe and effective vaccine.',
    ),
  };

  static VaccineEducation? getEducation(String vaccineName, {String? vaccineCode}) {
    final normalizedName = vaccineName.toUpperCase().trim();
    final normalizedCode = vaccineCode?.toUpperCase().trim();

    // Try exact match
    if (_educationContent.containsKey(normalizedName)) {
      return _educationContent[normalizedName];
    }

    // Try partial matches
    if (normalizedName.contains('BCG')) {
      return _educationContent['BCG'];
    }
    if (normalizedName.contains('OPV') && (normalizedName.contains('0') || normalizedName.contains('ZERO'))) {
      return _educationContent['OPV-0'];
    }
    if (normalizedName.contains('HEPATITIS B') || normalizedName.contains('HEPB')) {
      return _educationContent['HEPATITIS B'];
    }
    if (normalizedName.contains('DPT')) {
      return _educationContent['DPT'];
    }
    if (normalizedName.contains('MMR')) {
      return _educationContent['MMR'];
    }

    // Generic fallback
    return const VaccineEducation(
      disease: 'Various diseases',
      whyImportant:
          'This vaccination is important for protecting your child against specific diseases at a crucial stage of their development.',
      ifMissed:
          'If this vaccination is missed, please consult your doctor to get advice on a catch-up schedule.',
    );
  }
}












