class LedgerReport {
  final List<LedgerData>? ledgerReport;
  final String? tenantName;
  final String? financialYear;
  final LeadgeResponseInfo? responseInfo;

  LedgerReport({
    this.ledgerReport,
    this.tenantName,
    this.financialYear,
    this.responseInfo,
  });

  factory LedgerReport.fromJson(Map<String, dynamic> json) {
    return LedgerReport(
      ledgerReport: (json['ledgerReport'] as List<dynamic>?)
          ?.map((e) => LedgerData.fromJson(e))
          .toList(),
      tenantName: json['tenantName'] as String?,
      financialYear: json['financialYear'] as String?,
      responseInfo: LeadgeResponseInfo.fromJson(json['responseInfo']),
    );
  }
}

class LedgerData {
  final Map<String, MonthData>? months;
  LedgerData({this.months});
  factory LedgerData.fromJson(Map<String, dynamic> json) {
    final monthData = <String, MonthData>{};
    json.forEach((key, value) {
      monthData[key] = MonthData.fromJson(value);
    });
    return LedgerData(months: monthData);
  }
}

class MonthData {
  final LeadgerDemand? demand;
  final List<LeadgerPayment>? payment;

  MonthData({this.demand, this.payment});

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      demand: LeadgerDemand.fromJson(json['demand']),
      payment: (json['payment'] as List<dynamic>?)
          ?.map((e) => LeadgerPayment.fromJson(e))
          .toList(),
    );
  }
}

class LeadgerDemand {
  final String? consumerName;
  final String? connectionNo;
  final String? oldConnectionNo;
  final String? userId;
  final String? month;
  final int? demandGenerationDate;
  final String? code;
  final double? monthlyCharges;
  final double? penalty;
  final double? totalForCurrentMonth;
  final double? previousMonthBalance;
  final double? totalDues;
  final int? dueDateOfPayment;
  final int? penaltyAppliedOnDate;

  LeadgerDemand({
    this.consumerName="",
    this.connectionNo,
    this.oldConnectionNo="",
    this.userId="",
    this.month,
    this.demandGenerationDate,
    this.code="",
    this.monthlyCharges,
    this.penalty,
    this.totalForCurrentMonth,
    this.previousMonthBalance,
    this.totalDues,
    this.dueDateOfPayment,
    this.penaltyAppliedOnDate,
  });

  factory LeadgerDemand.fromJson(Map<String, dynamic> json) {
    return LeadgerDemand(
      consumerName: json['consumerName'] as String?,
      connectionNo: json['connectionNo'] as String?,
      oldConnectionNo: json['oldConnectionNo'] as String?,
      userId: json['userId'] as String?,
      month: json['month'] as String?,
      demandGenerationDate: json['demandGenerationDate'] as int?,
      code: json['code'] as String?,
      monthlyCharges: json['monthlyCharges'] as double?,
      penalty: json['penalty'] as double?,
      totalForCurrentMonth: json['totalForCurrentMonth'] as double?,
      previousMonthBalance: json['previousMonthBalance'] as double?,
      totalDues: json['totalDues'] as double?,
      dueDateOfPayment: json['dueDateOfPayment'] as int?,
      penaltyAppliedOnDate: json['penaltyAppliedOnDate'] as int?,
    );
  }
}

class LeadgerPayment {
  final dynamic paymentCollectionDate;
  final String? receiptNo;
  final double? amountPaid;
  final double? balanceLeft;

  LeadgerPayment({
    this.paymentCollectionDate,
    this.receiptNo,
    this.amountPaid,
    this.balanceLeft,
  });

  factory LeadgerPayment.fromJson(Map<String, dynamic> json) {
    return LeadgerPayment(
      paymentCollectionDate: json['paymentCollectionDate'],
      receiptNo: json['receiptNo'] as String?,
      amountPaid: json['amountPaid'] as double?,
      balanceLeft: json['balanceLeft'] as double?,
    );
  }
}

class LeadgeResponseInfo {
  final String? apiId;
  final String? ver;
  final dynamic ts;
  final String? resMsgId;
  final String? msgId;
  final String? status;

  LeadgeResponseInfo({
    this.apiId,
    this.ver,
    this.ts,
    this.resMsgId,
    this.msgId,
    this.status,
  });

  factory LeadgeResponseInfo.fromJson(Map<String, dynamic> json) {
    return LeadgeResponseInfo(
      apiId: json['apiId'] as String?,
      ver: json['ver'] as String?,
      ts: json['ts'],
      resMsgId: json['resMsgId'] as String?,
      msgId: json['msgId'] as String?,
      status: json['status'] as String?,
    );
  }
}
