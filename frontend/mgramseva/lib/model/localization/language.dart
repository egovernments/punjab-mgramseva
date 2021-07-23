class LanguageList {
  dynamic? responseInfo;
  MdmsRes? mdmsRes;

  LanguageList({this.responseInfo, this.mdmsRes});

  LanguageList.fromJson(Map<String, dynamic> json) {
    responseInfo = json['ResponseInfo'];
    mdmsRes =
        json['MdmsRes'] != null ? new MdmsRes.fromJson(json['MdmsRes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResponseInfo'] = this.responseInfo;
    if (this.mdmsRes != null) {
      data['MdmsRes'] = this.mdmsRes?.toJson();
    }
    return data;
  }
}

class MdmsRes {
  CommonMasters? commonMasters;

  MdmsRes({this.commonMasters});

  MdmsRes.fromJson(Map<String, dynamic> json) {
    commonMasters = json['common-masters'] != null
        ? new CommonMasters.fromJson(json['common-masters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commonMasters != null) {
      data['common-masters'] = this.commonMasters?.toJson();
    }
    return data;
  }
}

class CommonMasters {
  List<StateInfo>? stateInfo;

  CommonMasters({this.stateInfo});

  CommonMasters.fromJson(Map<String, dynamic> json) {
    if (json['StateInfo'] != null) {
      stateInfo = <StateInfo>[];
      json['StateInfo'].forEach((v) {
        stateInfo?.add(new StateInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stateInfo != null) {
      data['StateInfo'] = this.stateInfo?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateInfo {
  String? name;
  String? code;
  String? qrCodeURL;
  String? bannerUrl;
  String? logoUrl;
  String? logoUrlWhite;
  bool? hasLocalisation;
  bool? enableWhatsApp;
  DefaultUrl? defaultUrl;
  List<Languages>? languages;
  // List<LocalizationModules>? localizationModules;

  StateInfo({
    this.name,
    this.code,
    this.qrCodeURL,
    this.bannerUrl,
    this.logoUrl,
    this.logoUrlWhite,
    this.hasLocalisation,
    this.enableWhatsApp,
    this.defaultUrl,
    this.languages,
    // this.localizationModules
  });

  StateInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    qrCodeURL = json['qrCodeURL'];
    bannerUrl = json['bannerUrl'];
    logoUrl = json['logoUrl'];
    logoUrlWhite = json['logoUrlWhite'];
    hasLocalisation = json['hasLocalisation'];
    enableWhatsApp = json['enableWhatsApp'];
    defaultUrl = json['defaultUrl'] != null
        ? new DefaultUrl.fromJson(json['defaultUrl'])
        : null;
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages?.add(new Languages.fromJson(v));
      });
    }
    // if (json['localizationModules'] != null) {
    //   localizationModules = <LocalizationModules>[];
    //   json['localizationModules'].forEach((v) {
    //     localizationModules?.add(LocalizationModules?.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['qrCodeURL'] = this.qrCodeURL;
    data['bannerUrl'] = this.bannerUrl;
    data['logoUrl'] = this.logoUrl;
    data['logoUrlWhite'] = this.logoUrlWhite;
    data['hasLocalisation'] = this.hasLocalisation;
    data['enableWhatsApp'] = this.enableWhatsApp;
    if (this.defaultUrl != null) {
      data['defaultUrl'] = this.defaultUrl?.toJson();
    }
    if (this.languages != null) {
      data['languages'] = this.languages?.map((v) => v.toJson()).toList();
    }
    // if (this.localizationModules != null) {
    //   data['localizationModules'] =
    //       this.localizationModules?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class DefaultUrl {
  String? citizen;
  String? employee;

  DefaultUrl({this.citizen, this.employee});

  DefaultUrl.fromJson(Map<String, dynamic> json) {
    citizen = json['citizen'];
    employee = json['employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['citizen'] = this.citizen;
    data['employee'] = this.employee;
    return data;
  }
}

class Languages {
  String? label;
  String? value;
  bool isSelected = false;

  Languages({this.label, this.value, this.isSelected = false});

  Languages.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class LocalizationModules {
  String? label;
  String? value;

  LocalizationModules({this.label, this.value});

  LocalizationModules.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
