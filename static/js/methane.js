// Define libraries
require.config({
  baseUrl: 'js/',
  paths: {
    jquery: 'libs/jquery-1.7.2.min',
    ember: 'libs/ember-0.9.6.min',
    bootstrap: 'libs/bootstrap.min',
    less: 'libs/less-1.3.0.min',
    spin: 'libs/jquery.spin'
  }
});

// Load our app
define('app', [
  'jquery',
  'ember',
  'bootstrap',
  'spin',
  'less',
  ], function($) {
    var App = Ember.Application.create({
      VERSION: '0.0.1',
      Views: Ember.Namespace.create(),
      Models: Ember.Namespace.create(),
      Controllers: Ember.Namespace.create(),
      init: function() {
        this._super();
      }
    });
    return window.Methane = App;
  }
);
