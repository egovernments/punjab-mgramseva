class WCBillingSlab {
  String? _id;
  String? _buildingType;
  String? _connectionType;
  String? _calculationAttribute;
  String? _minimumCharge;
  List<Slabs>? _slabs;

  WCBillingSlab(
      {String? id,
        String? buildingType,
        String? connectionType,
        String? calculationAttribute,
        String? minimumCharge,
        List<Slabs>? slabs}) {
    if (id != null) {
      this._id = id;
    }
    if (buildingType != null) {
      this._buildingType = buildingType;
    }
    if (connectionType != null) {
      this._connectionType = connectionType;
    }
    if (calculationAttribute != null) {
      this._calculationAttribute = calculationAttribute;
    }
    if (minimumCharge != null) {
      this._minimumCharge = minimumCharge;
    }
    if (slabs != null) {
      this._slabs = slabs;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get buildingType => _buildingType;
  set buildingType(String? buildingType) => _buildingType = buildingType;
  String? get connectionType => _connectionType;
  set connectionType(String? connectionType) =>
      _connectionType = connectionType;
  String? get calculationAttribute => _calculationAttribute;
  set calculationAttribute(String? calculationAttribute) =>
      _calculationAttribute = calculationAttribute;
  String? get minimumCharge => _minimumCharge;
  set minimumCharge(String? minimumCharge) => _minimumCharge = minimumCharge;
  List<Slabs>? get slabs => _slabs;
  set slabs(List<Slabs>? slabs) => _slabs = slabs;

  WCBillingSlab.fromJson(Map<String, dynamic> json) {
    _id = "${json['id']??''}";
    _buildingType = "${json['buildingType']??''}";
    _connectionType = "${json['connectionType']??''}";
    _calculationAttribute = "${json['calculationAttribute']??''}";
    _minimumCharge = "${json['minimumCharge']??''}";
    _slabs = <Slabs>[];
    if (json['slabs'] != null) {
      json['slabs'].forEach((v) {
        _slabs!.add(new Slabs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['buildingType'] = this._buildingType;
    data['connectionType'] = this._connectionType;
    data['calculationAttribute'] = this._calculationAttribute;
    data['minimumCharge'] = this._minimumCharge;
    if (this._slabs != null) {
      data['slabs'] = this._slabs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slabs {
  String? _from;
  String? _to;
  String? _charge;
  String? _meterCharge;

  Slabs({String? from, String? to, String? charge, String? meterCharge}) {
    if (from != null) {
      this._from = from;
    }
    if (to != null) {
      this._to = to;
    }
    if (charge != null) {
      this._charge = charge;
    }
    if (meterCharge != null) {
      this._meterCharge = meterCharge;
    }
  }

  String? get from => _from;
  set from(String? from) => _from = from;
  String? get to => _to;
  set to(String? to) => _to = to;
  String? get charge => _charge;
  set charge(String? charge) => _charge = charge;
  String? get meterCharge => _meterCharge;
  set meterCharge(String? meterCharge) => _meterCharge = meterCharge;

  Slabs.fromJson(Map<String, dynamic> json) {
    _from = "${json['from']}";
    _to = "${json['to']}";
    _charge = "${json['charge']}";
    _meterCharge = "${json['meterCharge']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this._from;
    data['to'] = this._to;
    data['charge'] = this._charge;
    data['meterCharge'] = this._meterCharge;
    return data;
  }
}