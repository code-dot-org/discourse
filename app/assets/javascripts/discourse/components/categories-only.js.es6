export default Ember.Component.extend({
  tagName: '',
  actions: {
    // Called by the category list controller to show related categories (CSP unit 1 for
    // CSP, ex) and then hide the button that called this
    expand(category_expanding_class) {
      $('.' + category_expanding_class).show();
      $('#' + category_expanding_class).hide();
    }
  }
});
