// Define libraries
require.config({
  baseUrl: 'js/',
  paths: {
    jquery: 'libs/jquery-1.7.2.min',
    tempo: 'libs/tempo.min',
    bootstrap: 'libs/bootstrap.min'
  }
});

// Load our app
define('app', [
  'jquery',
  'tempo',
  'bootstrap'
  ], function($) {
    var App = {
      // Here will be stored the server connection
      connection: {},

      /**
       * Namespace for Tempo.js views
       */
      Views: {
        // Room tabs
        rooms_list: Tempo.prepare('rooms-list'),
        // Room content
        rooms_content: Tempo.prepare('rooms-content')
      },

      /**
       * Renders the main ui.
       *
       * @param rooms, an array of objects
       */
      load_ui: function(rooms) {
        this.Views.rooms_list.render(msg.connection.rooms);
        this.Views.rooms_content.render(msg.connection.rooms);
        $('#rooms-list li').eq(1).addClass('active');
        $('#rooms-content div').eq(0).addClass('active');
      },

      /**
       * Starts a websocket connection.
       *
       * @param Int, interval id to be stopped
       * @return Object, a `WebSocket` connection
       */
      start_connection: function(iid){
        var conn;
        var app = App;

        conn = new WebSocket('ws://localhost:20022');

        // Once connected, ask for connection details
        conn.onopen = function() {
          conn.send('!connection')
        };

        // Log errors
        conn.onerror = function(error) {
          console.log(error)
        };

        // Treat messages
        conn.onmessage = function(e) {
          msg = JSON.parse(e.data);
          // If this is the rooms request, load the app
          if( typeof(msg.connection) !== 'undefined' ) {
            app.load_ui(msg.connection.rooms);
          }
        };

        this.connection = conn;
      },
    } // App

    setTimeout(App.start_connection, 1000);
    return window.Methane = App;
  }
);
