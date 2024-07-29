class LedgerReport {
  final List<LedgerData> ledgerReport;
  final String tenantName;
  final String financialYear;
  final LeadgeResponseInfo responseInfo;

  LedgerReport({
    required this.ledgerReport,
    required this.tenantName,
    required this.financialYear,
    required this.responseInfo,
  });

  factory LedgerReport.fromJson(Map<String, dynamic> json) {
    return LedgerReport(
      ledgerReport: (json['ledgerReport'] as List<dynamic>)
          .map((e) => LedgerData.fromJson(e))
          .toList(),
      tenantName: json['tenantName'],
      financialYear: json['financialYear'],
      responseInfo: LeadgeResponseInfo.fromJson(json['responseInfo']),
    );
  }
}

class LedgerData {
  final Map<String, MonthData> months;

  LedgerData({required this.months});

  factory LedgerData.fromJson(Map<String, dynamic> json) {
    final monthData = <String, MonthData>{};
    json.forEach((key, value) {
      monthData[key] = MonthData.fromJson(value);
    });
    return LedgerData(months: monthData);
  }
}

class MonthData {
  final LeadgerDemand demand;
  final List<LeadgerPayment> payment;

  MonthData({required this.demand, required this.payment});

  factory MonthData.fromJson(Map<String, dynamic> json)  {
    return MonthData(
      demand: LeadgerDemand.fromJson(json['demand']),
      payment: (json['payment'] as List<dynamic>)
          .map((e) => LeadgerPayment.fromJson(e))
          .toList(),
    );
  }
}

class LeadgerDemand {
  final String consumerName;
  final String connectionNo;
  final String oldConnectionNo;
  final String userId;
  final String month;
  final int demandGenerationDate;
  final String code;
  final double monthlyCharges;
  final double penalty;
  final double totalForCurrentMonth;
  final double previousMonthBalance;
  final double totalDues;
  final int dueDateOfPayment;
  final int penaltyAppliedOnDate;

  LeadgerDemand({
    required this.consumerName,
    required this.connectionNo,
    required this.oldConnectionNo,
    required this.userId,
    required this.month,
    required this.demandGenerationDate,
    required this.code,
    required this.monthlyCharges,
    required this.penalty,
    required this.totalForCurrentMonth,
    required this.previousMonthBalance,
    required this.totalDues,
    required this.dueDateOfPayment,
    required this.penaltyAppliedOnDate,
  });

  factory LeadgerDemand.fromJson(Map<String, dynamic> json) {
    return LeadgerDemand(
      consumerName: json['consumerName'],
      connectionNo: json['connectionNo'],
      oldConnectionNo: json['oldConnectionNo'],
      userId: json['userId'],
      month: json['month'],
      demandGenerationDate: json['demandGenerationDate'],
      code: json['code'],
      monthlyCharges: json['monthlyCharges'].toDouble(),
      penalty: json['penalty'].toDouble(),
      totalForCurrentMonth: json['totalForCurrentMonth'].toDouble(),
      previousMonthBalance: json['previousMonthBalance'].toDouble(),
      totalDues: json['totalDues'].toDouble(),
      dueDateOfPayment: json['dueDateOfPayment'],
      penaltyAppliedOnDate: json['penaltyAppliedOnDate'],
    );
  }
}

class LeadgerPayment {
  final dynamic paymentCollectionDate;
  final String receiptNo;
  final double amountPaid;
  final double balanceLeft;

  LeadgerPayment({
    required this.paymentCollectionDate,
    required this.receiptNo,
    required this.amountPaid,
    required this.balanceLeft,
  });

  factory LeadgerPayment.fromJson(Map<String, dynamic> json) {
    return LeadgerPayment(
      paymentCollectionDate: json['paymentCollectionDate'],
      receiptNo: json['receiptNo'],
      amountPaid: json['amountPaid'].toDouble(),
      balanceLeft: json['balanceLeft'].toDouble(),
    );
  }
}

class LeadgeResponseInfo {
  final String apiId;
  final String ver;
  final dynamic ts;
  final String resMsgId;
  final String msgId;
  final String status;

  LeadgeResponseInfo({
    required this.apiId,
    required this.ver,
    required this.ts,
    required this.resMsgId,
    required this.msgId,
    required this.status,
  });

  factory LeadgeResponseInfo.fromJson(Map<String, dynamic> json) {
    return LeadgeResponseInfo(
      apiId: json['apiId'],
      ver: json['ver'],
      ts: json['ts'],
      resMsgId: json['resMsgId'],
      msgId: json['msgId'],
      status: json['status'],
    );
  }
}
