
window.deprecationWorkflow = window.deprecationWorkflow || {};
window.deprecationWorkflow.config = {
  workflow: [
    { handler: "silence", matchMessage: "Using \"_lookupFactory\" is deprecated. Please use container.factoryFor instead." }

 ]
};

