import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";
import Hamburger from "./Hamburger";
import { NotificationBell } from "./svgindex";
import { useLocation } from "react-router-dom";
import BackButton from "./BackButton";

const TopBar = ({
  img,
  isMobile,
  logoUrl,
  onLogout,
  toggleSidebar,
  ulb,
  userDetails,
  notificationCount,
  notificationCountLoaded,
  cityOfCitizenShownBesideLogo,
  onNotificationIconClick,
  hideNotificationIconOnSomeUrlsWhenNotLoggedIn,
  changeLanguage,
}) => {
  const { pathname } = useLocation();

  // const showHaburgerorBackButton = () => {
  //   if (pathname === "/digit-ui/citizen" || pathname === "/digit-ui/citizen/" || pathname === "/digit-ui/citizen/select-language") {
  //     return <Hamburger handleClick={toggleSidebar} />;
  //   } else {
  //     return <BackButton className="top-back-btn" />;
  //   }
  // };


  const url = window.location.pathname; // Get the current URL pathname
  const isPaymentPath = url.includes('/payment/'); // Check for payment path

  const paymentlogoUrl = isPaymentPath
    ? window?.globalConfigs?.getConfig?.("LOGO_URL") // Show payment logo if path matches
    : logoUrl;
    console.log(isPaymentPath,"isPaymentPath");
  return (
    <div className="navbar">
      <div className="center-container back-wrapper">
        <div className="hambuger-back-wrapper" style={{
          justifyContent: "center",
          alignItems: "center"
        }}>
          {isMobile && !isPaymentPath && <Hamburger handleClick={toggleSidebar} />}
          <img
            className="city"
            id="topbar-logo"
            src={paymentlogoUrl || "https://cdn.jsdelivr.net/npm/@egovernments/digit-ui-css@1.0.7/img/m_seva_white_logo.png"}
            alt="mSeva"
          />
          {isPaymentPath && <img className="state" src={logoUrl} />}
          {!isPaymentPath && <h3>{cityOfCitizenShownBesideLogo}</h3>}
        </div>

        <div className="RightMostTopBarOptions">
          {!hideNotificationIconOnSomeUrlsWhenNotLoggedIn || isPaymentPath  ? changeLanguage : null}
          {/* {!hideNotificationIconOnSomeUrlsWhenNotLoggedIn ? (
            <div className="EventNotificationWrapper" onClick={onNotificationIconClick}>
              {notificationCountLoaded && notificationCount ? (
                <span>
                  <p>{notificationCount}</p>
                </span>
              ) : null}
              <NotificationBell />
            </div>
          ) : null} */}
        </div>
      </div>
    </div>
  );
};

TopBar.propTypes = {
  img: PropTypes.string,
};

TopBar.defaultProps = {
  img: undefined,
};

export default TopBar;
