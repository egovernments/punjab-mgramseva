import React from "react";

import { initDSSComponents } from "@egovernments/digit-ui-module-dss";
import { DigitUI } from "@egovernments/digit-ui-module-core";
import { initLibraries } from "@egovernments/digit-ui-libraries";

import { initHRMSComponents } from "@egovernments/digit-ui-module-hrms";
import {
  PaymentModule,
  PaymentLinks,
  paymentConfigs,
} from "@egovernments/digit-ui-module-common";
import { initUtilitiesComponents } from "@egovernments/digit-ui-module-utilities";
import { UICustomizations } from "./Customisations/UICustomizations";
import {
  initPGRComponents,
  PGRReducers,
} from "@egovernments/digit-ui-module-pgr";
window.contextPath = window?.globalConfigs?.getConfig("CONTEXT_PATH");

initLibraries();

const enabledModules = ["PGR", "Payment", "DSS", "HRMS", "Utilities"];
window.Digit.ComponentRegistryService.setupRegistry({
  ...paymentConfigs,
  PaymentModule,
  PaymentLinks,
});

initPGRComponents();
initDSSComponents();
initHRMSComponents();
initUtilitiesComponents();

const moduleReducers = (initData) => ({
  pgr: PGRReducers(initData),
});

window.Digit.Customizations = {
  commonUiConfig: UICustomizations,
};

function App() {
  window.contextPath = window?.globalConfigs?.getConfig("CONTEXT_PATH");
  const stateCode =
    window.globalConfigs?.getConfig("STATE_LEVEL_TENANT_ID") ||
    process.env.REACT_APP_STATE_LEVEL_TENANT_ID;
  if (!stateCode) {
    return <h1>stateCode is not defined</h1>;
  }
  return (
    <DigitUI
      stateCode={stateCode}
      enabledModules={enabledModules}
      moduleReducers={moduleReducers}
    />
  );
}

export default App;
