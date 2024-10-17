export const addBoundaryHierarchyConfig = [
  {
    body: [
      {
        label: "WBH_HIERARCHY_NAME",
        type: "text",
        isMandatory: true,
        disable: false,
        populators: {
          name: "hierarchyType",
          customStyle: { alignItems: "baseline" },
          required: true,
        },
      },
      {
        isMandatory: true,
        key: "levelcards",
        type: "component",
        component: "LevelCards",
        withoutLabel: true,
        disable: false,
        populators: {
          name: "levelcards",
          required: true,
        },
      },
    ],
  },
];
