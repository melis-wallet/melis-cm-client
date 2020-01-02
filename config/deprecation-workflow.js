window.deprecationWorkflow = window.deprecationWorkflow || {};
window.deprecationWorkflow.config = {
  workflow: [
    { handler: "silence", matchId: "ember-env.old-extend-prototypes" },
    { handler: "silence", matchId: "computed-property.property" },
    { handler: "silence", matchId: "ember-views.curly-components.jquery-element" },
    { handler: "silence", matchId: "computed-property.override" },
    { handler: "silence", matchId: "ember-component.send-action" },

  ]
};