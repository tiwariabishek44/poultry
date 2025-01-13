// Vaccination schedule data model
class VaccinationSchedule {
  final List<VaccineDetail> schedule = [
    VaccineDetail(
        age: "1",
        ageUnit: "दिन",
        disease: "म्यारेक्स",
        vaccine: "CVI 988+HVT (Bivalent Respen)",
        method: "0.2 एम.एल. छालामा (ह्याचरीमा लगाउने)",
        required: false),
    VaccineDetail(
        age: "1",
        ageUnit: "दिन",
        disease: "आइ.बि.",
        vaccine: "IBH 120",
        method: "चल्लो छाउने बेलामा स्प्रेमा छर्ने दुबाउने",
        required: false),
    VaccineDetail(
        age: "1-3",
        ageUnit: "दिन",
        disease: "कक्सिडियोसिस",
        vaccine: "Coccidiosis Vaccine",
        method: "१ थोपा जिब्रोमा राख्ने",
        required: false),
    VaccineDetail(
        age: "3-5",
        ageUnit: "दिन",
        disease: "लिची हर्ट",
        vaccine: "Litchi Vaccle (Killed)",
        method: "0.3 एम.एल. मासुमा",
        required: false),
    VaccineDetail(
        age: "4-8",
        ageUnit: "दिन",
        disease: "सि.आर.डि.",
        vaccine: "Mycoplasma F1",
        method: "१ थोपा आँखामा राख्ने",
        required: true),
    VaccineDetail(
        age: "5-7",
        ageUnit: "दिन",
        disease: "रानीखेत",
        vaccine: "F1 or B1 Vaccine",
        method: "आँखा/नाकमा १ थोपा राख्ने",
        required: false),
    VaccineDetail(
        age: "10",
        ageUnit: "दिन",
        disease: "गम्बारो पहिलो",
        vaccine: "IBD Intermediate Plus",
        method: "आँखा/नाकमा १ थोपा राख्ने",
        required: false),
    VaccineDetail(
        age: "15-17",
        ageUnit: "दिन",
        disease: "आइ.बि.",
        vaccine: "IB491/CHB",
        method: "१ थोपा आँखामा राख्ने",
        required: false),
    VaccineDetail(
        age: "20-22",
        ageUnit: "दिन",
        disease: "गम्बारो दोस्रो",
        vaccine: "IBD Intermediate",
        method: "आँखा/नाकमा १ थोपा राख्ने वा दुध पाउडरमा पानीमा घोलेर खान दिने",
        required: false),
    VaccineDetail(
        age: "28",
        ageUnit: "दिन",
        disease: "रानीखेत",
        vaccine: "ND Lasota",
        method:
            "६ ग्राम स्किम मिल्क पाउडर प्रति लिटर पानीका दरले घोलेर भ्याक्सिन खुवाउने",
        required: false),
    VaccineDetail(
        age: "35",
        ageUnit: "दिन",
        disease: "आइ.बि.",
        vaccine: "IB491/CHB",
        method: "१ थोपा आँखामा राख्ने",
        required: false),
    VaccineDetail(
        age: "42-45",
        ageUnit: "दिन",
        disease: "फाउल पक्स",
        vaccine: "Fowl Pox",
        method: "पखेटामा खोपेर दिने",
        required: false),
    VaccineDetail(
        age: "45-50",
        ageUnit: "दिन",
        disease: "साल्मोनेला",
        vaccine: "SG9R Live",
        method: "0.25 एम.एल. छाला/मासु",
        required: false),
    VaccineDetail(
        age: "60",
        ageUnit: "दिन",
        disease: "रानीखेत र आइ.बि.",
        vaccine: "IB+Lasota",
        method: "दुध पाउडरमा पानीमा घोलेर खान दिने",
        required: false),
    VaccineDetail(
        age: "70",
        ageUnit: "दिन",
        disease: "रानीखेत र आइ.बि.",
        vaccine: "R2B Vaccine/IBND Killed",
        method: "मासुमा सुईद्वारा 0.5 एम.एल. दिने",
        required: false),
    VaccineDetail(
        age: "12",
        ageUnit: "हप्ता",
        disease: "साल्मोनेला",
        vaccine: "Salmonella Killed",
        method: "0.25 एम.एल. छाला/मासु",
        required: false),
    VaccineDetail(
        age: "14",
        ageUnit: "हप्ता",
        disease: "फाउल पक्स",
        vaccine: "Fowl Pox",
        method: "पखेटामा खोपेर दिने",
        required: false),
    VaccineDetail(
        age: "15",
        ageUnit: "हप्ता",
        disease: "रानीखेत र आइ.बि.",
        vaccine: "IB+Lasota",
        method: "दुध पाउडर पानीमा घोलेर खान दिने",
        required: false),
    VaccineDetail(
        age: "17-18",
        ageUnit: "हप्ता",
        disease: "रानीखेत र आइ.बि.",
        vaccine: "IB+ND Killed",
        method: "मासु/छालामा सुईद्वारा 0.5 एम.एल. दिने",
        required: false),
    VaccineDetail(
        age: "44-45",
        ageUnit: "हप्ता",
        disease: "रानीखेत र आइ.बि.",
        vaccine: "IB+ND Killed",
        method: "मासु/छालामा सुईद्वारा 0.5 एम.एल. दिने",
        required: false),
  ];
}

class VaccineDetail {
  final String age;
  final String ageUnit; // दिन or हप्ता
  final String disease;
  final String vaccine;
  final String method;
  final bool required;

  VaccineDetail({
    required this.age,
    required this.ageUnit,
    required this.disease,
    required this.vaccine,
    required this.method,
    required this.required,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'ageUnit': ageUnit,
      'disease': disease,
      'vaccine': vaccine,
      'method': method,
      'required': required,
    };
  }

  factory VaccineDetail.fromJson(Map<String, dynamic> json) {
    return VaccineDetail(
      age: json['age'],
      ageUnit: json['ageUnit'],
      disease: json['disease'],
      vaccine: json['vaccine'],
      method: json['method'],
      required: json['required'],
    );
  }
}
