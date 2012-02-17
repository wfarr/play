//= require_directory ./frameworks
//= require_directory ./plugins

//= require views
//= require templates
//= require helpers

//= require realtime
//= require router
//= require behaviors
//= require upload

play = exports ? this

# Route the app
new play.Router(window.location.pathname).go()