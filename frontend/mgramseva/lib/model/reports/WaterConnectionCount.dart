class WaterConnectionCount {
  int? count;
  int? taxperiodto;

  WaterConnectionCount({this.count, this.taxperiodto});

  WaterConnectionCount.fromJson(Map<String, dynamic> json) {
    count = json['count']??0;
    taxperiodto = json['taxperiodto']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['taxperiodto'] = this.taxperiodto;
    return data;
  }
}