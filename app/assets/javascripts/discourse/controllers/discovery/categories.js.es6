import DiscoveryController from 'discourse/controllers/discovery';

export default DiscoveryController.extend({
  needs: ['modal', 'discovery'],

  withLogo: Em.computed.filterBy('categories', 'logo_url'),
  showPostsColumn: Em.computed.empty('withLogo'),

  actions: {

    refresh() {

      // Don't refresh if we're still loading
      if (this.get('controllers.discovery.loading')) { return; }

      // If we `send('loading')` here, due to returning true it bubbles up to the
      // router and ember throws an error due to missing `handlerInfos`.
      // Lesson learned: Don't call `loading` yourself.
      this.set('controllers.discovery.loading', true);

      const parentCategory = this.get('model.parentCategory');
      const promise = parentCategory ? Discourse.CategoryList.listForParent(parentCategory) :
                                       Discourse.CategoryList.list();

      const self = this;
      promise.then(function(list) {
        self.set('model', list);
        self.send('loadingComplete');
      });
    },

    // Called by the category list controller to show related categories (CSP unit 1 for
    // CSP, ex) and then hide the button that called this
    expand(category_expanding_class) {
      $('.' + category_expanding_class).show();
      $('#' + category_expanding_class).hide();
    }
  },

  canEdit: function() {
    return Discourse.User.currentProp('staff');
  }.property(),

  latestTopicOnly: function() {
    return this.get('categories').find(function(c) { return c.get('featuredTopics.length') > 1; }) === undefined;
  }.property('categories.@each.featuredTopics.length')

});
