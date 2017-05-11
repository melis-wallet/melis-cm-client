`import LeafModalComponent from 'ember-leaf-core/components/leaf-modal'`
`import BackButtonSupport from '../mixins/backbutton-support'`

ModalComponent = LeafModalComponent.extend(BackButtonSupport,

  onBack: (-> @close(false, 'back'))
)

`export default ModalComponent`
