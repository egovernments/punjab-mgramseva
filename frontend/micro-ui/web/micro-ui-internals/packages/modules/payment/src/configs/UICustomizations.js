import { Link, useHistory } from "react-router-dom";
import _ from "lodash";
import React from "react";

export const UICustomizations = {
  OpenPaymentSearch:{
    preProcess: (data, additionalDetails) => {
      
      //we need to get three things -> consumerCode,businessService,tenantId
      // businessService and tenantId can be either in queryParams or in form
      let {consumerCode,businessService,tenantId} = data?.state?.searchForm || {};
      businessService = businessService?.code
      tenantId = tenantId?.[0]?.code
      if(!businessService){
        businessService = additionalDetails?.queryParams?.businessService
      }
      if(!tenantId){
        tenantId = additionalDetails?.queryParams?.tenantId
      }
      const finalParams = {
        consumerCode,
        tenantId,
        businessService
      }
      data.params = finalParams
      // const tenantId = Digit.ULBService.getCurrentTenantId();
      // data.body = { RequestInfo: data.body.RequestInfo };
      // const { limit, offset } = data?.state?.tableForm || {};
      // const { campaignName, campaignType } = data?.state?.searchForm || {};
      // data.body.CampaignDetails = {
      //   tenantId: tenantId,
      //   status: ["failed"],
      //   createdBy: Digit.UserService.getUser().info.uuid,
      //   pagination: {
      //     sortBy: "createdTime",
      //     sortOrder: "desc",
      //     limit: limit,
      //     offset: offset,
      //   },
      // };
      // if (campaignName) {
      //   data.body.CampaignDetails.campaignName = campaignName;
      // }
      // if (campaignType) {
      //   data.body.CampaignDetails.projectType = campaignType?.[0]?.code;
      // }
      delete data.body.custom;
      delete data.body.pagination;
      data.options = {
        userService:false,
        auth:false
      }
      // delete data.body.inbox;
      // delete data.params;
      return data;
    },
    additionalCustomizations: (row, key, column, value, t, searchResult) => {
      if (key === "OP_BILL_DATE") {
        return Digit.DateUtils.ConvertEpochToDate(value);
      }

      if(key === "OP_BILL_TOTAL_AMT"){
        return <span>{`₹ ${value}`}</span>
      }

      if(key === "OP_CONS_CODE") {
        return <span className="link">
            <Link
              to={`/${window.contextPath}/citizen/payment/open-view?tenantId=${row.tenantId}&businessService=${row.businessService}&consumerCode=${row.consumerCode}`}
            >
              {String(value ? (column.translate ? t(column.prefix ? `${column.prefix}${value}` : value) : value) : t("ES_COMMON_NA"))}
            </Link>
          </span> 
      }
    },
    populateReqCriteria: () => {
      const tenantId = Digit.ULBService.getCurrentTenantId();
      return {
        url: "/mdms-v2/v1/_search",
        params: { tenantId },
        body: {
          MdmsCriteria: {
            tenantId,
            moduleDetails: [
              {
                moduleName: "tenant",
                masterDetails: [
                  {
                    name: "tenants",
                  },
                ],
              },
            ],
          },
        },
        config: {
          enabled: true,
          select: (data) => {
            const result = data?.MdmsRes?.tenant?.tenants?.filter(row => row?.divisionCode && row?.divisionName)?.map(row => {
              return {
                ...row,
                updatedCode:`${row.divisionName} - ${row?.name}`
              }
            });
            return result;
          },
        },
      };
    },
  }
};
