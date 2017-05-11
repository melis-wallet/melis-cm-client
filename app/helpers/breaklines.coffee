`import Ember from 'ember'`


Breaklines =  Ember.Helper.helper((params) ->
  text = params[0]
  text = Ember.Handlebars.Utils.escapeExpression(text)
  text = text.replace(/(\r\n|\n|\r)/gm, '<br>')
  return new Ember.String.htmlSafe(text)
)

`export default Breaklines`