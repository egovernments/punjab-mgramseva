import { Loader, Header, Dropdown, LabelFieldPair, CardLabel, LinkLabel, SubmitBar } from "@egovernments/digit-ui-react-components";
import React, { useState,useMemo,useEffect } from "react";
import { useTranslation } from "react-i18next";
import { Controller, useForm, useWatch } from "react-hook-form";

function buildTree(data, hierarchy) {
  const tree = { options: [] };

  data.forEach((item) => {
    // Ignore items without zoneCode
    if (!item.zoneCode) return;

    let currentLevel = tree;

    hierarchy.forEach(({level}, index) => {
      const value = item[level];

      if (!currentLevel[value]) {
        // Clone the item and delete the options property from it
        const clonedItem = { ...item };
        delete clonedItem.options;

        // Initialize the current level with the cloned item
        currentLevel[value] = { ...clonedItem, options: [] };

        // Push the cloned item to the options array without the options property
        currentLevel.options.push({ ...clonedItem });
      }

      if (index === hierarchy.length - 1) {
        currentLevel[value].codes = currentLevel[value].codes || [];
        currentLevel[value].codes.push(item.code);
      }

      currentLevel = currentLevel[value];
    });
  });

  return tree;
}

const SearchUserForm = () => {
  const { t } = useTranslation();
  const [hierarchy, setHierarchy] = useState([
    { "level": "zoneCode", "value": 1,"optionsKey":"zoneName" },
    { "level": "circleCode", "value": 2,"optionsKey":"circleName" },
    { "level": "divisionCode", "value": 3,"optionsKey":"divisionName" },
    { "level": "subDivisionCode", "value": 4,"optionsKey":"subDivisionName" },
    { "level": "sectionCode", "value": 5,"optionsKey":"sectionName" },
    // { "level": "schemeCode", "value": 6,"optionsKey":"schemeName" },
    { "level": "code", "value": 7,"optionsKey":"name" }
]
);
  
  const [tree, setTree] = useState(null);
  const [zones,setZones] = useState([])
  const [circles,setCircles] = useState([])
  const [divisions,setDivisions] = useState([])
  const [subDivisions,setSubDivisions] = useState([])
  const [sections,setSections] = useState([])
  const [schemes,setSchemes] = useState([])
  const [codes,setCodes] = useState([])
  
  console.log("tree", tree);
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
        ],
      },
    },
    config: {
      cacheTime: Infinity,
      select: (data) => {
        const result = data?.MdmsRes?.tenant?.tenants
        const resultInTree = buildTree(result, hierarchy);
        setTree(resultInTree);
        return result;
      },
    },
  };

  const { isLoading, data, revalidate, isFetching, error } = Digit.Hooks.useCustomAPIHook(requestCriteria);

  const {
    register,
    handleSubmit,
    setValue,
    getValues,
    reset,
    watch,
    trigger,
    control,
    formState,
    errors,
    setError,
    clearErrors,
    unregister,
  } = useForm({
    defaultValues: {},
  });

  const formData = watch();
  console.log("formData from watch",formData);

  const clearSearch = () => {
    reset({});

    // dispatch({
    //   type: uiConfig?.type === "filter"?"clearFilterForm" :"clearSearchForm",
    //   state: { ...uiConfig?.defaultValues }
    //   //need to pass form with empty strings
    // })
    //here reset tableForm as well
    // dispatch({
    //   type: "tableForm",
    //   state: { limit:10,offset:0 }
    //   //need to pass form with empty strings
    // })
  };

  const onSubmit = (data) => {
    console.log("formData", data);
  };

  // const optionsForHierarchy = (hierarchy) =>{
  //   // this gets called whenever formData changes
  //   // Here we need to add logic to return options for one dropdown and return [] for all the childs
  //   //zoneCode -> circleCode -> divisionCode -> subDivisionCode -> sectionCode -> schemeCode -> code
  //   // console.log(hierarchy);
  //   const data = getValues("zoneCode")
  //   return tree.options
  //   debugger
  //   if(data){
  //     return tree?.[data?.zoneCode]?.options
  //   }
    
  //   return null
  // }

  const optionsForHierarchy = (level, value) => {
    if (!tree) return [];
    
    const levels = hierarchy.map(({level}) => level)
    const levelIndex = levels.indexOf(level);

    //zoneCode(1st level(highest parent))
    if (levelIndex === -1 || levelIndex=== 0) return tree.options;
    
    let currentLevel = tree;
    for (let i = 0; i < levelIndex; i++) {
      const code = formData[levels[i]]?.[levels[i]];
      if (!code || !currentLevel[code]) return [];
      currentLevel = currentLevel[code];
    }
    return currentLevel.options || [];
  };

  const renderFields = useMemo(() => { return hierarchy.map(({level,optionsKey,...rest},idx) => (
    <LabelFieldPair>
      <CardLabel style={{ marginBottom: "0.4rem" }}>{t(Digit.Utils.locale.getTransformedLocale(`HR_SU_${level}`))}</CardLabel>
      <Controller
        render={(props) => (
          <Dropdown
            style={{ display: "flex", justifyContent: "space-between" }}
            option={optionsForHierarchy(level)}
            key={level}
            optionKey={optionsKey}
            value={props.value}
            select={(e) => {
              props.onChange(e)
              //clear all child levels
              const childLevels = hierarchy.slice(hierarchy.findIndex(h => h.level === level) + 1);
              childLevels.forEach(child => setValue(child.level, ""));
            }}
            selected={props.value}
            defaultValue={props.value}
            t={t}
            optionCardStyles={{
              top: "2.3rem",
              overflow: "auto",
              maxHeight: "200px",
            }}
          />
        )}
        rules={{}}
        defaultValue={""}
        name={level}
        control={control}
      />
    </LabelFieldPair>
  ))}, [formData])

  if (isLoading || !setTree) {
    return <Loader />;
  }

  return (
    <div className={"search-wrapper"}>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div>
          <p className="search-instruction-header">{t("HR_SU_HINT")}</p>
          <div className={`search-field-wrapper search `}>
            {renderFields}
            <div className={`search-button-wrapper search `} style={{}}>
              <LinkLabel style={{ marginBottom: 0, whiteSpace: "nowrap" }} onClick={()=>{
                clearSearch()
              }}>
                {t("CLEAR_SEARCH")}
              </LinkLabel>
              <SubmitBar label={t("SEARCH")} submit="submit" disabled={false} />
            </div>
          </div>
        </div>
      </form>
    </div>
  );
};

export default SearchUserForm;
