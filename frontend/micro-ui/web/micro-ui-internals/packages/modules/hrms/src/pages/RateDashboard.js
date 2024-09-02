import React, { useState, useEffect } from "react";
import IFrameInterface from "../../../utilities/src/pages/employee/IFrameInterface/index";

const RateDashboard = () => {
  const queryString = window.location.search;
  const params = new URLSearchParams(queryString);
  const moduleName = params.get("moduleName");
  const pageName = params.get("pageName");
  const stateCode = window?.globalConfigs?.getConfig("STATE_LEVEL_TENANT_ID") || "pb";

  return (
    <div className="rate-dashboard">
      <IFrameInterface
        wrapperClassName="custom-iframe-wrapper"
        className="custom-iframe"
        moduleName={moduleName}
        pageName={pageName}
        stateCode={stateCode}
        filters={null}
      />
    </div>
  );
};

export default RateDashboard;
