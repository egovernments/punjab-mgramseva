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
          ],
        },
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

Map getMdmsPaymentModes(String tenantId) {
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
