import ReactiveObjectState from '../lifecycle/reactive-object-state';

export default class LayerState extends ReactiveObjectState {
  constructor({attributeManager, layer}) {
    super(layer);
    this.attributeManager = attributeManager;
    this.model = null;
    this.needsRedraw = true;
    this.subLayers = null; // reference to sublayers rendered in a previous cycle
  }

  get layer() {
    return this.object;
  }

  set layer(layer) {
    this.object = layer;
  }
}
