import React, { useState, useRef, useEffect } from "react";
import {
  FormComposerV2,
  TextInput,
  Button,
  Card,
  CardLabel,
  CardSubHeader,
  LabelFieldPair,
  Header,
  Dropdown,
  InputCard,
  ActionBar,
  SubmitBar,
} from "@egovernments/digit-ui-react-components";
import { Toast } from "@egovernments/digit-ui-react-components";

import { useTranslation } from "react-i18next";
import { useHistory } from "react-router-dom/cjs/react-router-dom.min";
import { Controller } from "react-hook-form";

const CreateBoundaryRelationship = () => {
  const { t } = useTranslation();
  const [showToast, setShowToast] = useState(null);
  const [hierarchyType, setHierarchyType] = useState(null);
  const [level, setLevel] = useState(null);
  const [parent, setParent] = useState(null);
  const [boundaryEntry, setBoundaryEntry] = useState("");
  const stateId = Digit.ULBService.getStateId();

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
  }, [hierarchyType, level]);

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
    }
  }, [hierarchyType, level]);

  const { data: hierarchyTypeData } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryHierarchySearch);
  const relation_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryRelationshipCreate);
  const entity_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryEntityCreate);
  const { data: relationshipData, error, isLoading } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryRelationshipSearch);

  const handleHierarchyTypeChange = (selectedValue) => {
    setHierarchyType(selectedValue);
    setLevel(null);
    setParent(null);
    setFormData({});
  };

  const handleLevelChange = (selectedValue) => {
    setLevel(selectedValue);
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
            setShowToast({ label, isWarning: true });
            closeToast();
          },
          onSuccess: () => {
            setShowToast({ label: `${t("WBH_BOUNDARY_UPSERT_SUCCESS")}` });
            closeToast();
            setHierarchyType(null);
            setTimeout(() => {
              history.push(`/${window?.contextPath}/employee`);
            }, 2000);
          },
        }
      );
    } catch {}
  };

  const submitBoundaryEntry = async () => {
    try {
      if (!hierarchyType || !level || !boundaryEntry) {
        setShowToast({ label: `${t("MGRAMSEVA_FILLOUT_IS_MANDATORY")}`, isWarning: true });
        closeToast();
        return;
      }

      if (hierarchyType && level && hierarchyType?.boundaryHierarchy?.[0] !== level && !parent) {
        setShowToast({ label: `${t("MGRAMSEVA_FILLOUT_IS_MANDATORY")}`, isWarning: true });
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
            setShowToast({ label, isWarning: true });
            closeToast();
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
      const selectedCode = formData.get(hierarchyLevels[i])?.code;
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

        {Array.from(formData).map(([boundaryType, value], index) => (
          <LabelFieldPair key={index} style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
            <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t(`MGRAMSEVA_HIERARCHY_${boundaryType?.toUpperCase()}`)} *</CardLabel>
            <Dropdown
              className="form-field"
              option={optionsForHierarchy(boundaryType)}
              select={(e) => {
                handleSelect(boundaryType, e); // Call handleSelect to update formData
              }}
              selected={formData.get(boundaryType)}
              optionKey={"code"}
            />
          </LabelFieldPair>
        ))}

        {level && (
          <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem" }}>
            <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>
              {t(`MGRAMSEVA_HIERARCHY_${level?.boundaryType?.toUpperCase()}`)} *
            </CardLabel>
            <TextInput onChange={(e) => setBoundaryEntry(e.target.value)} value={boundaryEntry} />
          </LabelFieldPair>
        )}
      </Card>

      <ActionBar>
        <SubmitBar
          label={t("MGRAMSEVA_BOUNDARY_UPLOAD")}
          onSubmit={submitBoundaryEntry}
          //  disabled={files.length === 0}
        />
      </ActionBar>
      {showToast && (
        <Toast
          warning={showToast.isWarning}
          label={showToast.label}
          isDleteBtn={"true"}
          onClose={() => setShowToast(false)}
          style={{ bottom: "8%" }}
        />
      )}
    </React.Fragment>
  );
};

export default CreateBoundaryRelationship;
