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

const CreateBoundaryRelationship = () => {
  const { t } = useTranslation();
  const [showToast, setShowToast] = useState(null);
  const [hierarchyType, setHierarchyType] = useState(null);
  const [level, setLevel] = useState(null);
  const [parent, setParent] = useState(null);
  const [boundaryEntry, setBoundaryEntry] = useState("");
  const stateId = Digit.ULBService.getStateId();

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
    //   config: {
    //     enabled: true,
    //   },
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

      console.log("reqss", reqCriteriaBoundaryRelationshipSearch);
    }
  }, [hierarchyType, level]);

  const { data: hierarchyTypeData } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryHierarchySearch);
  const relation_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryRelationshipCreate);
  const entity_mutation = Digit.Hooks.useCustomAPIMutationHook(reqCriteriaBoundaryEntityCreate);
  const { data: relationshipData, error, isLoading } = Digit.Hooks.useCustomAPIHook(reqCriteriaBoundaryRelationshipSearch);

  console.log("hierarchyData", hierarchyTypeData);
  console.log("hierarchyType", hierarchyType);
  console.log("level", level);
  console.log("boundaryEntry", boundaryEntry);
  console.log("parent", parent);
  console.log("relationshipdata", relationshipData);

  const handleHierarchyTypeChange = (selectedValue) => {
    setHierarchyType(selectedValue);
    setLevel(null);
    setParent(null);
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
        {level && (
          <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem" }}>
            <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>
              {t(`MGRAMSEVA_HIERARCHY_${level?.boundaryType?.toUpperCase()}`)} *
            </CardLabel>
            <TextInput onChange={(e) => setBoundaryEntry(e.target.value)} value={boundaryEntry} />
          </LabelFieldPair>
        )}

        {hierarchyType && level && hierarchyType?.boundaryHierarchy?.[0] !== level && (
          <LabelFieldPair style={{ alignItems: "flex-start", paddingLeft: "1rem", marginBottom: "1.5rem" }}>
            <CardLabel style={{ marginBottom: "0.4rem", fontWeight: "700" }}>{t(`MGRAMSEVA_HIERARCHY_PARENT`)} *</CardLabel>
            <Dropdown
              className="form-field"
              selected={parent}
              //   option={hierarchyOptions} selected={selected} select={(value) => select(value, key)} optionKey={optionKey}
            />
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
