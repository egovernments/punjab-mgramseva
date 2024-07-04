import { Loader, StatusTable, Row, Card, Header, SubmitBar, ActionBar, Toast } from "@egovernments/digit-ui-react-components";
import React, { Fragment, useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import { makePayment } from "../utils/payGov";
import $ from "jquery";

function anonymizeHalfString(input) {
  // Calculate the midpoint of the string
  const midpoint = Math.ceil(input.length / 2);

  // Replace the first 50% of the string with asterisks
  const anonymized = "*".repeat(midpoint) + input.substring(midpoint);

  return anonymized;
}

const OpenView = () => {
  const { t } = useTranslation();
  const [showToast, setShowToast] = useState(null);
  const queryParams = Digit.Hooks.useQueryParams();
  const requestCriteria = {
    url: "/billing-service/bill/v2/_fetchbill",
    params: queryParams,
    body: {},
    options: {
      userService: false,
      auth: false,
    },
    config: {
      enabled: !!queryParams.consumerCode && !!queryParams.tenantId && !!queryParams.businessService,
      select: (data) => {
        return data?.Bill?.[0];
      },
    },
  };

  const { isLoading, data: bill, revalidate, isFetching, error } = Digit.Hooks.useCustomAPIHook(requestCriteria);

  const requestCriteriaForConnectionSearch = {
    url: "/ws-services/wc/_search?",
    params: { tenantId:queryParams.tenantId,businessService:queryParams.businessService, connectionNumber: queryParams.consumerCode,isOpenPaymentSearch:true },
    body: {},
    options: {
      userService: false,
      auth: false,
    },
    config: {
      enabled: !!queryParams.consumerCode && !!queryParams.tenantId && !!queryParams.businessService,
      select: (data) => {
        return data?.WaterConnection?.[0];
      },
    },
  };
  const { isLoading: isLoadingConnection, data: connection, isFetching: isFetchingConnection, error: errorConnection } = Digit.Hooks.useCustomAPIHook(
    requestCriteriaForConnectionSearch
  );

  const requestCriteriaForPayments = {
    url: "/collection-services/payments/WS/_search",
    params: queryParams,
    body: {},
    options: {
      userService: false,
      auth: false,
    },
    config: {
      enabled: !!queryParams.consumerCode && !!queryParams.tenantId && !!queryParams.businessService,
      select: (data) => {
        const payments = data?.Payments;
        if (payments?.length === 0) {
          return null;
        } else if (payments?.length > 5) {
          return payments.slice(0, 5);
        } else {
          return payments;
        }
      },
    },
  };

  const { isLoading: isLoadingPayments, data: payments, isFetching: isFetchingPayments, error: isErrorPayments } = Digit.Hooks.useCustomAPIHook(
    requestCriteriaForPayments
  );

  const arrears =
    bill?.billDetails
      ?.sort((a, b) => b.fromPeriod - a.fromPeriod)
      ?.reduce((total, current, index) => (index === 0 ? total : total + current.amount), 0) || 0;

  const onSubmit = async () => {
    const filterData = {
      Transaction: {
        tenantId: bill?.tenantId,
        txnAmount: bill.totalAmount,
        module: bill.businessService,
        billId: bill.id,
        consumerCode: bill.consumerCode,
        productInfo: "Common Payment",
        gateway: "PAYGOV",
        taxAndPayments: [
          {
            billId: bill.id,
            amountPaid: bill.totalAmount,
          },
        ],
        user: {
          name: bill?.payerName,
          mobileNumber: bill?.mobileNumber,
          tenantId: bill?.tenantId,
          emailId: "sriranjan.srivastava@owc.com",
        },
        // success
        // callbackUrl: `${window.location.protocol}//${window.location.host}/${window.contextPath}/citizen/openpayment/success?consumerCode=${queryParams.consumerCode}&tenantId=${queryParams.tenantId}&businessService=${queryParams.businessService}`,
        callbackUrl: `${window.location.protocol}//${window.location.host}/${window.contextPath}/citizen/payment/success/${queryParams.businessService}/${queryParams.consumerCode}/${queryParams.tenantId}`,
        additionalDetails: {
          isWhatsapp: false,
        },
      },
    };

    try {
      const data = await Digit.PaymentService.createCitizenReciept(bill?.tenantId, filterData);

      const redirectUrl = data?.Transaction?.redirectUrl;
      // paygov
      try {
        const gatewayParam = redirectUrl
          ?.split("?")
          ?.slice(1)
          ?.join("?")
          ?.split("&")
          ?.reduce((curr, acc) => {
            var d = acc.split("=");
            curr[d[0]] = d[1];
            return curr;
          }, {});
        var newForm = $("<form>", {
          action: gatewayParam.txURL,
          method: "POST",
          target: "_top",
        });
        const orderForNDSLPaymentSite = [
          "checksum",
          "messageType",
          "merchantId",
          "serviceId",
          "orderId",
          "customerId",
          "transactionAmount",
          "currencyCode",
          "requestDateTime",
          "successUrl",
          "failUrl",
          "additionalField1",
          "additionalField2",
          "additionalField3",
          "additionalField4",
          "additionalField5",
        ];

        // override default date for UPYOG Custom pay
        gatewayParam["requestDateTime"] = gatewayParam["requestDateTime"]?.split(new Date().getFullYear()).join(`${new Date().getFullYear()} `);

        gatewayParam["successUrl"] = redirectUrl?.split("successUrl=")?.[1]?.split("eg_pg_txnid=")?.[0] + "eg_pg_txnid=" + gatewayParam?.orderId;
        gatewayParam["failUrl"] = redirectUrl?.split("failUrl=")?.[1]?.split("eg_pg_txnid=")?.[0] + "eg_pg_txnid=" + gatewayParam?.orderId;
        // gatewayParam["successUrl"]= data?.Transaction?.callbackUrl;
        // gatewayParam["failUrl"]= data?.Transaction?.callbackUrl;

        // var formdata = new FormData();

        for (var key of orderForNDSLPaymentSite) {
          // formdata.append(key,gatewayParam[key]);

          newForm.append(
            $("<input>", {
              name: key,
              value: gatewayParam[key],
              // type: "hidden",
            })
          );
        }
        $(document.body).append(newForm);
        newForm.submit();
        makePayment(gatewayParam.txURL, newForm);
      } catch (e) {
        console.log("Error in payment redirect ", e);
        //window.location = redirectionUrl;
      }

      // window.location = redirectUrl;
    } catch (error) {
      let messageToShow = "CS_PAYMENT_UNKNOWN_ERROR_ON_SERVER";
      if (error.response?.data?.Errors?.[0]) {
        const { code, message } = error.response?.data?.Errors?.[0];
        messageToShow = code;
      }
      setShowToast({ key: true, label: t(messageToShow) });
    }
  };

  if (isLoading || isLoadingPayments || isLoadingConnection) {
    return <Loader />;
  }

  return (
    <>
      <Header className="works-header-search" styles={{ marginLeft: "0.5rem" }}>
        {t("OP_PAYMENT_DETAILS")}
      </Header>
      <Card style={{ maxWidth: "95vw", paddingLeft: "1.5rem" }}>
        <StatusTable>
          {connection && (
            <>
              <Row
                label={t("OP_CONS_CODE")}
                text={connection?.connectionNo ? connection?.connectionNo : t("ES_COMMON_NA")}
                rowContainerStyle={{ border: "none" }}
              />
              <Row
                label={t("OP_CONSUMER_NAME")}
                text={connection?.connectionHolders?.[0]?.name ? anonymizeHalfString(connection?.connectionHolders?.[0]?.name) : t("ES_COMMON_NA")}
                rowContainerStyle={{ border: "none" }}
              />
              {/* <Row
                label={t("OP_CONSUMER_PHNO")}
                text={
                  connection?.connectionHolders?.[0]?.mobileNumber
                    ? anonymizeHalfString(connection?.connectionHolders?.[0]?.mobileNumber)
                    : t("ES_COMMON_NA")
                }
                rowContainerStyle={{ border: "none" }}
              /> */}
              <Row
                label={t("OP_CONNECTION_TYPE")}
                text={
                  connection?.connectionType
                    ? t(Digit.Utils.locale.getTransformedLocale(`OP_CONNECTION_TYPE_${connection?.connectionType}`))
                    : t("ES_COMMON_NA")
                }
                rowContainerStyle={{ border: "none" }}
              />
              <Row
                label={t("OP_METER_ID")}
                text={connection?.meterId ? connection?.meterId : t("ES_COMMON_NA")}
                rowContainerStyle={{ border: "none" }}
              />
              <Row
                label={t("OP_APPLICATION_STATUS")}
                text={
                  connection?.status
                    ? t(Digit.Utils.locale.getTransformedLocale(`OP_APPLICATION_STATUS_${connection?.status}`))
                    : t("ES_COMMON_NA")
                }
                rowContainerStyle={{ border: "none" }}
              />
            </>
          )}
          {bill ? (
            <>
              {/* <Row
                label={t("OP_CONSUMER_NAME")}
                text={bill?.payerName ? anonymizeHalfString(bill?.payerName) : t("ES_COMMON_NA")}
                rowContainerStyle={{ border: "none" }}
              />
              <Row
                label={t("OP_CONSUMER_PHNO")}
                text={bill?.mobileNumber ? anonymizeHalfString(bill?.mobileNumber) : t("ES_COMMON_NA")}
                rowContainerStyle={{ border: "none" }}
              /> */}
              <Row
                label={t("ES_PAYMENT_TAXHEADS")}
                labelStyle={{ fontWeight: "bold" }}
                textStyle={{ fontWeight: "bold" }}
                text={t("ES_PAYMENT_AMOUNT")}
                rowContainerStyle={{ border: "none" }}
              />
              {/* <hr style={{ width: "40%" }} className="underline" /> */}
              {bill?.billDetails?.[0]?.billAccountDetails
                ?.sort((a, b) => a.order - b.order)
                .map((amountDetails, index) => (
                  <Row
                    key={index + "taxheads"}
                    labelStyle={{ fontWeight: "normal" }}
                    textStyle={{ textAlign: "right", maxWidth: "100px" }}
                    label={t(`TAX_HC_${amountDetails.taxHeadCode}`)}
                    text={"₹ " + amountDetails.amount?.toFixed(2)}
                    rowContainerStyle={{ border: "none" }}
                  />
                ))}

              {arrears?.toFixed?.(2) ? (
                <Row
                  labelStyle={{ fontWeight: "normal" }}
                  textStyle={{ textAlign: "right", maxWidth: "100px" }}
                  label={t("COMMON_ARREARS")}
                  text={"₹ " + arrears?.toFixed?.(2) || Number(0).toFixed(2)}
                  rowContainerStyle={{ border: "none" }}
                />
              ) : null}

              <hr style={{ width: "40%" }} className="underline" />
              <Row
                label={t("CS_PAYMENT_TOTAL_AMOUNT")}
                labelStyle={{ fontWeight: "bold" }}
                textStyle={{ fontWeight: "bold", textAlign: "right", maxWidth: "100px" }}
                text={"₹ " + Number(bill?.totalAmount).toFixed(2)}
                rowContainerStyle={{ border: "none" }}
              />
            </>
          ) : (
            <div style={{ fontWeight: "bold", fontSize: "1.2rem", color: "red" }}>{t("NO_BILLS_AVAILABLE")}</div>
          )}
        </StatusTable>
      </Card>
      {payments && (
        <Header className="works-header-search" styles={{ marginLeft: "0.5rem", marginTop: "2rem", marginBottom: "-0.5rem" }}>
          {t("OP_CONSUMER_RECEIPTS")}
        </Header>
      )}
      {payments &&
        payments.map((payment) => {
          return (
            <Card style={{ maxWidth: "95vw", paddingLeft: "1.5rem", marginTop: "2rem" }}>
              <StatusTable>
                <Row
                  label={t("OP_RECEIPT_NO")}
                  text={payment?.paymentDetails?.[0]?.receiptNumber || t("ES_COMMON_NA")}
                  rowContainerStyle={{ border: "none" }}
                />
                <Row label={t("OP_RECEIPT_AMT")} text={payment?.totalAmountPaid || t("ES_COMMON_NA")} rowContainerStyle={{ border: "none" }} />
                <Row
                  label={t("OP_RECEIPT_PAID_DATE")}
                  // labelStyle={{ fontWeight: "bold" }}
                  // textStyle={{ fontWeight: "bold" }}
                  text={payment?.transactionDate ? Digit.DateUtils.ConvertEpochToDate(payment?.transactionDate) : t("ES_COMMON_NA")}
                  rowContainerStyle={{ border: "none" }}
                />
                {/* <Row
                  label={t("OP_TXN_NO")}
                  labelStyle={{ fontWeight: "bold" }}
                  textStyle={{ fontWeight: "bold" }}
                  text={payment?.transactionNumber ? payment?.transactionNumber : t("ES_COMMON_NA")}
                /> */}
              </StatusTable>
            </Card>
          );
        })}

      <ActionBar style={{ display: "flex", justifyContent: "flex-end", alignItems: "baseline" }}>
        {/* {displayMenu ? <Menu localeKeyPrefix={"ES_COMMON"} options={ACTIONS} t={t} onSelect={onActionSelect} /> : null} */}
        <SubmitBar disabled={Number(bill?.totalAmount) === 0 || !bill} onSubmit={onSubmit} label={t("OP_PROCEED_TO_PAY")} />
      </ActionBar>
      {showToast && (
        <Toast
          error={showToast.key}
          label={t(showToast.label)}
          onClose={() => {
            setShowToast(null);
          }}
          isDleteBtn={true}
        />
      )}
    </>
  );
};

export default OpenView;
