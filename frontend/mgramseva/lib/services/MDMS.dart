import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';

initRequestBody(tenantId) {
  return {
    "MdmsCriteria": {
      ...tenantId,
      "moduleDetails": [
        {
          "moduleName": "common-masters",
          "masterDetails": [
            {"name": "Department"},
            {"name": "Designation"},
            {"name": "StateInfo"},
            {"name": "wfSlaConfig"},
            {"name": "AppVersion"}
          ],
        },
        {
          "moduleName": "tenant",
          "masterDetails": [
            {"name": "tenants"},
            {"name": "citymodule"}
          ],
        },
        {
          "moduleName": "DIGIT-UI",
          "masterDetails": [
            {"name": "ApiCachingSettings"}
          ],
        },
      ],
    },
  };
}

Map getAppVersion(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "common-masters",
          "masterDetails": [
            {"name": "AppVersion"}
          ]
        }
      ]
    }
  };
}

Map getExpenseMDMS(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "Expense",
          "masterDetails": [
            {"name": "ExpenseType"},
          ]
        },
        {
          "moduleName": "BillingService",
          "masterDetails": [
            {"name": "BusinessService"},
            {"name": "TaxHeadMaster"},
          ]
        }
      ]
    }
  };
}

Map getConnectionTypePropertyTypeTaxPeriodMDMS(String tenantId, int datestamp) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "ws-services-masters",
          "masterDetails": [
            {"name": "connectionType"},
            {"name": "Category"},
            {"name": "SubCategory"},
          ]
        },
        {
          "moduleName": "PropertyTax",
          "masterDetails": [
            {"name": "PropertyType"},
          ]
        },
        {
          "moduleName": "BillingService",
          "masterDetails": [
            {"name": "TaxHeadMaster"},
            {"name": "TaxPeriod", "filter": "[?(@.service=='WS')]"}
          ]
        }
      ]
    }
  };
}

Map getTenantsMDMS(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "tenant",
          "masterDetails": [
            {"name": "tenants"}
          ]
        }
      ]
    }
  };
}

Map getServiceTypeConnectionTypePropertyTypeMDMS(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "ws-services-masters",
          "masterDetails": [
            {"name": "connectionType"},
          ]
        },
        {
          "moduleName": "PropertyTax",
          "masterDetails": [
            {"name": "PropertyType"},
          ]
        },
        {
          "moduleName": "BillingService",
          "masterDetails": [
            {"name": "TaxHeadMaster"},
            {"name": "TaxPeriod", "filter": "[?(@.service=='WS')]"}
          ],
        },
      ]
    }
  };
}

Map getMDMSPaymentModes(String tenantId) {
  return {
    "MdmsCriteria": {
      "tenantId": tenantId,
      "moduleDetails": [
        {
          "moduleName": "BillingService",
          "masterDetails": [
            {"name": "TaxHeadMaster"},
            {"name": "BusinessService", "filter": "[?(@.code=='WS')]"}
          ]
        }
      ]
    }
  };
}

