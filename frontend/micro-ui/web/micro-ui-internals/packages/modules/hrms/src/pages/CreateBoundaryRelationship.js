import React, { useState, useRef } from "react";
import {
  FormComposerV2,
  TextInput,
  Button,
  Card,
  CardLabel,
  CardSubHeader,
  LabelFieldPair,
  Header,
  Toast,
  Dropdown,
  InputCard,
  ActionBar,
  SubmitBar,
} from "@egovernments/digit-ui-react-components";
import { useTranslation } from "react-i18next";

const CreateBoundaryRelationship = () => {
  const { t } = useTranslation();
  const [showToast, setShowToast] = useState(null);
  const [hierarchyOptions, setHierarchyOptions] = useState(null);
  const [level, setLevel] = useState(null);
  const [parentOptions, setParentOptions] = useState(null);
  const stateId = Digit.ULBService.getStateId();

  let validation = {};

  //   const reqCriteriaBoundaryHierarchyTypeAdd = {
  //     url: `/boundary-service/boundary-relationships/_create`,
  //     params: {},
  //     body: {},
  //     config: {
  //       enabled: true,
  //     },
  //   };

  const reqCriteriaBoundaryHierarchySearch = {
    url: "/boundary-service/boundary-hierarchy-definition/_search",
    params: {},
    body: {
      BoundaryTypeHierarchySearchCriteria: {
        tenantId: stateId,
      },
    },
    // config: {
    //   enabled: true,
    // },
  };

  const requestCriteria = {
    url: "/mdms-v2/v1/_search",
    params: { tenantId: Digit.ULBService.getStateId() },
    body: {
      MdmsCriteria: {
        tenantId: Digit.ULBService.getStateId(),
        moduleDetails: [
          {
            moduleName: "tenant",
            masterDetails: [
              {
                name: "tenants",
              },
            ],
          },
          {
            moduleName: "ws-services-masters",
            masterDetails: [
              {
                name: "WSServiceRoles",
              },
            ],
          },
        ],
      },
    },
    config: {
      cacheTime: Infinity,
      select: (data) => {
        const requiredKeys = [
          "code",
          "name",
          "zoneCode",
          "zoneName",
          "circleCode",
          "circleName",
          "divisionCode",
          "divisionName",
          "subDivisionCode",
          "subDivisionName",
          "sectionCode",
          "sectionName",
          "schemeCode",
          "schemeName",
        ];
        const result = data?.MdmsRes?.tenant?.tenants;
        const filteredResult = filterKeys(result, requiredKeys);
        const resultInTree = buildTree(filteredResult, hierarchy);
        const excludeCodes = ["HRMS_ADMIN", "LOC_ADMIN", "MDMS_ADMIN", "EMPLOYEE", "SYSTEM"];
        const DIV_ADMIN = Digit.UserService.hasAccess(["DIV_ADMIN"]);

        setRolesOptions(
          data?.MdmsRes?.["ws-services-masters"]?.["WSServiceRoles"]?.filter(
            (row) =>
              !excludeCodes.includes(row?.code) &&
              (row?.name === "Secretary" ||
                row?.name === "Sarpanch" ||
                row?.name === "Revenue Collector" ||
                (!DIV_ADMIN && row?.name === "DIVISION ADMIN"))
          )
        );
        setTree(resultInTree);
        return result;
      },
    },
  };

  //   const mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryHierarchyTypeAdd);

  const { data: hierarchyTypeData } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryHierarchySearch);
  const { data: mdmsData } = Digit.Hooks.useCustomAPIHook(requestCriteria);

  //   const formattedHierarchyTypes = hierarchyTypeData?.BoundaryHierarchy?.map((item) => ({ hierarchyType: item.hierarchyType }));

  //   const handleHierarchyTypeChange = (selectedValue) => {
  //     setSelectedValue(selectedValue);
  //   };

  console.log("mdmsdata", mdmsData);

  console.log("hierarchyData", hierarchyTypeData);

  //   const hierarchyTypeDropdownConfig = {
  //     label: "WBH_LOC_LANG",
  //     type: "dropdown",
  //     isMandatory: false,
  //     disable: false,
  //     populators: {
  //       name: "hierarchyType",
  //       optionsKey: "hierarchyType",
  //       options: formattedHierarchyTypes,
  //       optionsCustomStyle: { top: "2.3rem" },
  //       styles: { width: "50%" },
  //     },
  //   };

  //   const closeToast = () => {
  //     setTimeout(() => {
  //       setShowToast(null);
  //     }, 5000);
  //   };

  return (
    <React.Fragment>
      <Header className="works-header-search">{t("MGRAMSEVA_UPLOAD_BOUNDARY")}</Header>
      <Card className="workbench-create-form">
        <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
          <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t("MGRAMSEVA_HIERARCHY_TYPE")} *</CardLabel>
          <Dropdown
            className="form-field"
            isMandatory={true}
            //   option={hierarchyOptions} selected={selected} select={(value) => select(value, key)} optionKey={optionKey}
          />
        </LabelFieldPair>
        <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem" }}>
          <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t("MGRAMSEVA_HIERARCHY_LEVEL")} *</CardLabel>
          <TextInput
            t={t}
            value={level || ""}
            onChange={(e) => {
              const value = e.target.value.replace(/[^0-9]/g, "");
              setLevel(value);
            }}
          />
        </LabelFieldPair>
        {level && level > 1 && (
          <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1rem" }}>
            <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t("MGRAMSEVA_HIERARCHY_PARENT")} *</CardLabel>
            <Dropdown
              className="form-field"
              //   option={hierarchyOptions} selected={selected} select={(value) => select(value, key)} optionKey={optionKey}
            />
          </LabelFieldPair>
        )}
      </Card>
      <ActionBar>
        <SubmitBar
          label={t("MGRAMSEVA_BOUNDARY_UPLOAD")}
          // onSubmit={() => onSubmit(files)}
          //  disabled={files.length === 0}
        />
      </ActionBar>
      {showToast && <Toast label={showToast} isDleteBtn={true} onClose={() => setShowToast(null)} />}
    </React.Fragment>
  );
};

export default CreateBoundaryRelationship;
