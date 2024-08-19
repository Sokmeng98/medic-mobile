class QuestionnaireModel {
  final List<QuestionnaireItem> results;

  QuestionnaireModel({
    required this.results,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => QuestionnaireItem.fromJson(item)).toList();

    return QuestionnaireModel(
      results: result,
    );
  }

  List<QuestionnaireItem> getResults() {
    return results;
  }
}

class QuestionnaireItem {
  final int id;
  final int category;
  final String name;
  final String description;
  final List<QuestionnaireQA> questionnaireQA;
  final List<QuestionnaireQCM> questionnaireQCM;
  final bool isActive;

  QuestionnaireItem({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.questionnaireQA,
    required this.questionnaireQCM,
    required this.isActive,
  });

  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    List listQA = json['questionaire_qa'];
    List<QuestionnaireQA> questionaireQAList = listQA.map((i) => QuestionnaireQA.fromJson(i)).toList();
    List listQCM = json['questionaire_qcm'];
    List<QuestionnaireQCM> questionaireQCMList = listQCM.map((i) => QuestionnaireQCM.fromJson(i)).toList();

    return QuestionnaireItem(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      description: json['description'],
      questionnaireQA: questionaireQAList,
      questionnaireQCM: questionaireQCMList,
      isActive: json['is_active'],
    );
  }
}

class QuestionnaireQA {
  final int id;
  final String question;
  final String answer;

  QuestionnaireQA({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QuestionnaireQA.fromJson(Map<String, dynamic> json) {
    return QuestionnaireQA(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class QuestionnaireQCM {
  final int id;
  final String question;
  final int answer;
  final List<QCMOptions> qcmOptions;

  QuestionnaireQCM({
    required this.id,
    required this.question,
    required this.answer,
    required this.qcmOptions,
  });

  factory QuestionnaireQCM.fromJson(Map<String, dynamic> json) {
    List listOptions = json['qcm_options'];
    List<QCMOptions> questionaireOptionsList = listOptions.map((i) => QCMOptions.fromJson(i)).toList();

    return QuestionnaireQCM(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      qcmOptions: questionaireOptionsList,
    );
  }
}

class QCMOptions {
  final int id;
  final String name;

  QCMOptions({
    required this.id,
    required this.name,
  });

  factory QCMOptions.fromJson(Map<String, dynamic> json) {
    return QCMOptions(
      id: json['id'],
      name: json['name'],
    );
  }
}
