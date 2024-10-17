import React, { useState, useRef, useEffect } from "react";
import {
  FormComposerV2,
  TextInput,
  Card,
  CardLabel,
  CardSubHeader,
  LabelFieldPair,
  Header,
  Dropdown,
  InputCard,
  ActionBar,
  SubmitBar,
  Toast,
  // PopUp,
} from "@egovernments/digit-ui-react-components";

import { PopUp, Button } from "@egovernments/digit-ui-components";

import { useTranslation } from "react-i18next";
import { useHistory } from "react-router-dom/cjs/react-router-dom.min";
import { Controller } from "react-hook-form";
import ApplicationTable from "../components/inbox/ApplicationTable";

const CreateBoundaryRelationship = () => {
  const { t } = useTranslation();
  const [showToast, setShowToast] = useState(null);
  const [hierarchyType, setHierarchyType] = useState(null);
  const [level, setLevel] = useState(null);
  const [parent, setParent] = useState(null);
  const [boundaryEntry, setBoundaryEntry] = useState("");
  const stateId = Digit.ULBService.getStateId();
  const [showPopUp, setShowPopUp] = useState(false);
  const [refetchTrigger, setRefetchTrigger] = useState(0);
  const GetCell = (value) => <span className="cell-text">{t(value)}</span>;

  const [formData, setFormData] = useState(new Map());
  const formDataRef = useRef(formData);

  const history = useHistory();

  const reqCriteriaBoundaryHierarchySearch = {
    url: "/boundary-service/boundary-hierarchy-definition/_search",
    params: {},
    body: {
      BoundaryTypeHierarchySearchCriteria: {
        tenantId: stateId,
      },
      changeQueryName: "hierarchyData",
    },
    config: {
      select: (data) => {
        const result = data?.BoundaryHierarchy;
        return result;
      },
    },
  };

  const reqCriteriaBoundaryRelationshipCreate = {
    url: "/boundary-service/boundary-relationships/_create",
    params: {},
    body: {},
    config: {
      enabled: true,
    },
  };

  const reqCriteriaBoundaryEntityCreate = {
    url: "/boundary-service/boundary/_create",
    params: {},
    body: {},
    config: {
      enabled: true,
    },
  };

  const [reqCriteriaBoundaryRelationshipSearch, setReqCriteriaBoundaryRelationshipSearch] = useState({
    url: "/boundary-service/boundary-relationships/_search",
    params: { tenantId: stateId, hierarchyType: null, includeChildren: true },
    body: {},
    config: {
      select: (data) => {
        const result = data?.TenantBoundary;
        return result?.[0]?.boundary;
      },
    },
    changeQueryName: "relationshipData",
  });

  useEffect(() => {
    if (hierarchyType && hierarchyType?.hierarchyType) {
      setReqCriteriaBoundaryRelationshipSearch((prevState) => ({
        ...prevState,
        params: {
          ...prevState.params,
          hierarchyType: hierarchyType.hierarchyType,
        },
        changeQueryName: prevState.changeQueryName + "a",
      }));
    }
  }, [hierarchyType, refetchTrigger]);

  useEffect(() => {
    if (level && hierarchyType && hierarchyType.boundaryHierarchy) {
      const newFormData = new Map();

      for (let i = 0; i < hierarchyType.boundaryHierarchy.length; i++) {
        const currentType = hierarchyType.boundaryHierarchy[i].boundaryType;
        if (currentType === level.boundaryType) {
          break;
        }
        newFormData.set(currentType, "");
      }
      setFormData(newFormData);
      formDataRef.current = newFormData;
    }
  }, [hierarchyType, level]);

  const { data: hierarchyTypeData } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryHierarchySearch);
  const relation_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryRelationshipCreate);
  const entity_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryEntityCreate);
  const { data: relationshipData, error, isLoading } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryRelationshipSearch);

  console.log("hierarchyTypeData", hierarchyTypeData);
  console.log("relationshipData", relationshipData);

  const handleHierarchyTypeChange = (selectedValue) => {
    setHierarchyType(selectedValue);
    setLevel(null);
    setParent(null);
    setFormData(new Map());
    formDataRef.current = new Map();
  };

  const handleLevelChange = (selectedValue) => {
    setLevel(selectedValue);

    const newFormData = new Map();
    for (let i = 0; i < hierarchyType?.boundaryHierarchy?.length; i++) {
      const currentType = hierarchyType?.boundaryHierarchy[i]?.boundaryType;
      if (currentType === selectedValue.boundaryType) {
        break;
      }
      newFormData.set(currentType, formData.get(currentType) || "");
    }
    setFormData(newFormData);
    formDataRef.current = newFormData;
  };

  const createRelationship = async () => {
    try {
      await relation_mutation.mutate(
        {
          params: {},
          body: {
            BoundaryRelationship: {
              tenantId: stateId,
              code: boundaryEntry,
              hierarchyType: hierarchyType?.hierarchyType,
              boundaryType: level?.boundaryType,
              parent: parent,
            },
          },
        },
        {
          onError: (resp) => {
            let label = `${t("WBH_BOUNDARY_CREATION_FAIL")}: `;
            resp?.response?.data?.Errors?.map((err, idx) => {
              if (idx === resp?.response?.data?.Errors?.length - 1) {
                label = label + t(Digit.Utils.locale.getTransformedLocale(err?.code)) + ".";
              } else {
                label = label + t(Digit.Utils.locale.getTransformedLocale(err?.code)) + ", ";
              }
            });
            setShowToast({ label, isError: true });
            closeToast();
            setShowPopUp(false);
            setBoundaryEntry("");
          },
          onSuccess: () => {
            setShowToast({ label: `${t("WBH_BOUNDARY_UPSERT_SUCCESS")}` });
            closeToast();
            setShowPopUp(false);
            setRefetchTrigger((prev) => prev + 1);
            setBoundaryEntry("");

            // setHierarchyType(null);
            // setTimeout(() => {
            //   setShowPopUp(false);
            //   // history.push(`/${window?.contextPath}/employee`);
            // }, 2000);
          },
        }
      );
    } catch {}
  };

  console.log("boundaryEntry", boundaryEntry);

  const submitBoundaryEntry = async () => {
    // console.log("Submit BUtton is Entered");
    try {
      if (!hierarchyType || !level || !boundaryEntry) {
        setShowToast({ label: `${t("MGRAMSEVA_FILLOUT_IS_MANDATORY")}`, isError: true });
        closeToast();
        return;
      }

      if (hierarchyType && level && hierarchyType?.boundaryHierarchy?.[0] !== level && !parent) {
        setShowToast({ label: `${t("MGRAMSEVA_FILLOUT_IS_MANDATORY")}`, isError: true });
        closeToast();
        return;
      }

      await entity_mutation.mutate(
        {
          params: {},
          body: {
            Boundary: [
              {
                tenantId: stateId,
                code: boundaryEntry,
                geometry: null,
              },
            ],
          },
        },
        {
          onError: (resp) => {
            let label = `${t("WBH_BOUNDARY_CREATION_FAIL")}: `;
            resp?.response?.data?.Errors?.map((err, idx) => {
              if (idx === resp?.response?.data?.Errors?.length - 1) {
                label = label + t(Digit.Utils.locale.getTransformedLocale(err?.code)) + ".";
              } else {
                label = label + t(Digit.Utils.locale.getTransformedLocale(err?.code)) + ", ";
              }
            });
            setShowToast({ label, isError: true });
            closeToast();
            setShowPopUp(false);
            setBoundaryEntry("");
          },
          onSuccess: () => {
            createRelationship();
          },
        }
      );
    } catch {}
  };

  const handleSelect = (boundaryType, selectedValue) => {
    setFormData((prevFormData) => {
      const updatedFormData = new Map(prevFormData);
      updatedFormData.set(boundaryType, selectedValue);
      formDataRef.current = updatedFormData;
      return updatedFormData;
    });

    const hierarchyLevels = hierarchyType.boundaryHierarchy.map(({ boundaryType }) => boundaryType);
    const boundaryIndex = hierarchyLevels.indexOf(boundaryType);
    const levelIndex = hierarchyType.boundaryHierarchy.indexOf(level);

    if (boundaryIndex === levelIndex - 1) {
      const lastEntry = Array.from(formDataRef.current).pop();
      if (lastEntry) {
        const [lastKey, lastValue] = lastEntry;
        setParent(lastValue.code);
      }
    }
    const currentBoundaryTypeIndex = hierarchyType.boundaryHierarchy.findIndex((h) => h.boundaryType === boundaryType);

    const childBoundaryTypes = hierarchyType.boundaryHierarchy.slice(currentBoundaryTypeIndex + 1, levelIndex);

    setFormData((prevFormData) => {
      const updatedFormData = new Map(prevFormData);
      childBoundaryTypes.forEach((childBoundary) => {
        updatedFormData.set(childBoundary.boundaryType, "");
      });

      formDataRef.current = updatedFormData;

      return updatedFormData;
    });
  };

  const optionsForHierarchy = (boundaryType) => {
    if (!relationshipData || !hierarchyType || !formData) return [];
    const hierarchyLevels = hierarchyType.boundaryHierarchy.map(({ boundaryType }) => boundaryType);
    const boundaryIndex = hierarchyLevels.indexOf(boundaryType);

    if (boundaryIndex === -1) return [];
    let currentOptions = relationshipData;

    for (let i = 0; i < boundaryIndex; i++) {
      console.log("formData--", formData);

      const selectedCode = formData?.get(hierarchyLevels[i])?.code;
      if (!selectedCode) return [];
      const foundOption = currentOptions.find((option) => option?.code === selectedCode);
      if (!foundOption) return [];
      currentOptions = foundOption?.children || [];
    }
    return currentOptions;
  };
  const closeToast = () => {
    setTimeout(() => {
      setShowToast(null);
    }, 5000);
  };

  const isTablePopulated = (formData) => {
    const formArray = Array.from(formDataRef.current);

    if (level) {
      const levelIndex = hierarchyType?.boundaryHierarchy?.indexOf(level);
      if (formArray.length === 0 && levelIndex == 0) return true;
    }

    if (formArray.length === 0) return false;

    for (const [key, value] of formArray) {
      if (!value) {
        return false;
      }
    }
    return true;
  };

  const getLevelArray = () => {
    if (!relationshipData || !hierarchyType || !isTablePopulated()) return [];
    const hierarchyLevels = hierarchyType.boundaryHierarchy.map(({ boundaryType }) => boundaryType);
    const levelIndex = hierarchyLevels.indexOf(level?.boundaryType);

    if (levelIndex === -1) return [];
    let currentOptions = relationshipData;

    for (let i = 0; i < levelIndex; i++) {
      console.log("formData--", formData);
      const selectedCode = formData?.get(hierarchyLevels[i])?.code;
      if (!selectedCode) return [];
      const foundOption = currentOptions.find((option) => option?.code === selectedCode);
      if (!foundOption) return [];
      currentOptions = foundOption?.children || [];
    }
    return currentOptions;
  };

  const displayPopUp = () => {
    setShowPopUp(true);
    console.log("showPopUp", showPopUp);
  };

  console.log("formData", formData, isTablePopulated(formData));
  console.log("level", level);
  console.log("boundaryEntry", boundaryEntry);
  console.log("relationshipData:", relationshipData);
  console.log("formData", formData);
  console.log("isTablePopulated", isTablePopulated());

  const columns = () => {
    const formDataArray = Array.from(formDataRef.current);
    if (formDataArray.length === 0 && (!level || level.boundaryType !== hierarchyType?.boundaryHierarchy?.[0]?.boundaryType)) return [];

    const columnArray = Array.from(formDataRef?.current?.keys()).map((key) => {
      console.log("key", key);
      console.log("formData", formData);
      return {
        Header: key,
        accessor: key,
        Cell: ({ row }) => {
          console.log("formData.get(key)?.code ", formData?.get(key)?.code);
          return GetCell(formDataRef?.current?.get(key)?.code || "");
        },
      };
    });

    console.log("columnArray", columnArray);
    console.log("formData", formData);
    console.log("formDataref", formDataRef.current);

    if (level) {
      columnArray.push({
        Header: level.boundaryType,
        accessor: level.boundaryType,
        Cell: ({ row }) => {
          console.log("row", row);
          // const boundaryTypeOptions = optionsForHierarchy(level?.boundaryType).map(({ code }) => code);
          // console.log("boundaryTypeOptions", boundaryTypeOptions);

          return GetCell(row?.original?.code || "");
          //getLevelArray() ||
        },
      });
    }

    console.log("columnArray-2", columnArray);
    return columnArray;
  };

  console.log("columns", columns());

  let result;
  if (getLevelArray()?.length === 0) {
    result = (
      <Card style={{ marginTop: 20 }}>
        {t("COMMON_TABLE_NO_RECORD_FOUND")
          .split("\\n")
          .map((text, index) => (
            <p key={index} style={{ textAlign: "center" }}>
              {text}
            </p>
          ))}
      </Card>
    );
  } else {
    // const boundaryTypeOptions = optionsForHierarchy(level?.boundaryType).map(({ code }) => code);
    // if (isTablePopulated) console.log("boundaryTypeOptions", getLevelArray());
    let array = [];
    if (isTablePopulated) array = getLevelArray();
    console.log("array", array);
    result = (
      <ApplicationTable
        t={t}
        data={array}
        columns={columns()}
        getCellProps={(cellInfo) => {
          return {
            style: {
              maxWidth: cellInfo.column.Header == t("HR_EMP_ID_LABEL") ? "150px" : "",
              padding: "20px 18px",
              fontSize: "16px",
              minWidth: "150px",
            },
          };
        }}
        // onPageSizeChange={props.onPageSizeChange}
        // currentPage={props.currentPage}
        // onNextPage={props.onNextPage}
        // onPrevPage={props.onPrevPage}
        // pageSizeLimit={props.pageSizeLimit}
        // onSort={props.onSort}
        // disableSort={props.disableSort}
        // sortParams={props.sortParams}
        // totalRecords={props.totalRecords}
      />
    );
  }

  console.log("result", result);

  return (
    <React.Fragment>
      <Header className="works-header-search">{t("MGRAMSEVA_UPLOAD_BOUNDARY")}</Header>
      <Card className="workbench-create-form">
        <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
          <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t("MGRAMSEVA_HIERARCHY_TYPE")} *</CardLabel>
          <Dropdown className="form-field" option={hierarchyTypeData} select={handleHierarchyTypeChange} optionKey={"hierarchyType"} />
        </LabelFieldPair>
        <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
          <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t("MGRAMSEVA_HIERARCHY_LEVEL")} *</CardLabel>
          <Dropdown
            className="form-field"
            option={hierarchyType?.boundaryHierarchy || []}
            select={handleLevelChange}
            selected={level}
            optionKey={"boundaryType"}
          />
        </LabelFieldPair>
      </Card>

      {Array.from(formData).length > 0 && (
        <Card className="workbench-create-form">
          {Array.from(formData).map(([boundaryType, value], index) => (
            <LabelFieldPair key={index} style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
              <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t(`MGRAMSEVA_HIERARCHY_${boundaryType?.toUpperCase()}`)} *</CardLabel>
              <Dropdown
                className="form-field"
                option={optionsForHierarchy(boundaryType)}
                select={(e) => {
                  handleSelect(boundaryType, e); // Call handleSelect to update formData
                }}
                selected={formData?.get(boundaryType)}
                optionKey={"code"}
              />
            </LabelFieldPair>
          ))}
        </Card>
      )}

      {level && isTablePopulated() && (
        <Card className="workbench-create-form">
          <div style={{ display: "flex", justifyContent: "flex-end", marginBottom: "2em" }}>
            <Button
              variation="secondary"
              label={t("ADD_NEW_BOUNDARY")}
              textStyles={{ color: "#c84c0e", width: "unset" }}
              // textStyles={unset}
              className={"hover"}
              onClick={displayPopUp}
            />
          </div>

          <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem" }}>
            {showPopUp && (
              <PopUp
                className={"boundaries-pop-module"}
                type={"default"}
                subheading={t(`MGRAMSEVA_HIERARCHY_${level?.boundaryType?.toUpperCase()}`)}
                onOverlayClick={() => {
                  setShowPopUp(false);
                }}
                onClose={() => {
                  setShowPopUp(false);
                }}
                footerChildren={[
                  <Button
                    type={"button"}
                    size={"large"}
                    variation={"secondary"}
                    label={t("CLOSE")}
                    textStyles={{ color: "#c84c0e", width: "unset" }}
                    onClick={() => {
                      setShowPopUp(false);
                    }}
                  />,
                  <Button
                    type={"button"}
                    size={"large"}
                    variation={"primary"}
                    label={t("CREATE_BOUNDARY")}
                    textStyles={{ width: "unset" }}
                    onClick={() => {
                      submitBoundaryEntry();
                    }}
                  />,
                ]}
                sortFooterChildren={true}
              >
                <div style={{ display: "flex", justifyContent: "space-between" }}>
                  {/* <span>{t(`MGRAMSEVA_HIERARCHY_${level?.boundaryType?.toUpperCase()}`)}</span> */}
                  <TextInput onChange={(e) => setBoundaryEntry(e.target.value)} value={boundaryEntry} />
                </div>
              </PopUp>
            )}
            {/* <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>
              {t(`MGRAMSEVA_HIERARCHY_${level?.boundaryType?.toUpperCase()}`)} *
            </CardLabel>
            <TextInput onChange={(e) => setBoundaryEntry(e.target.value)} value={boundaryEntry} /> */}
          </LabelFieldPair>

          {isTablePopulated() && (
            <div className="result" style={{ marginLeft: "24px", flex: 1 }}>
              {result}
            </div>
          )}
        </Card>
      )}
      {showToast && (
        <Toast error={showToast.isError} label={showToast.label} isDleteBtn={"true"} onClose={() => setShowToast(false)} style={{ bottom: "8%" }} />
      )}
    </React.Fragment>
  );
};

export default CreateBoundaryRelationship;
