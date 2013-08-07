/**
 * TODO Description of plugin
 * @author TODO RoW, Unic AG
 * @license All rights reserved Unic AG
 */

;(function(window, document, $, Unic, undefined) {
	'use strict';

	var $document = $(document);

	var pluginName = 'example',
		events = {
			eventname: pluginName +'_eventname'
		},
		defaults = {
		};

	// Globally accessible data like event names
	Unic.modules[pluginName] = {
		events: events
	};


	/**
	 * Create an instance of the module
	 * @param {object} element The DOM element to bind the module
	 * @param {object} options Options overwriting the defaults
	 * @constructor
	 */
	var Plugin = function(element, options) {
		// Call super constructor
		this.helper = Unic.modules.PluginHelper;
		this.helper(pluginName, defaults, element, options);
	};

	/**
	 * Initialize module, bind events
	 */
	Plugin.prototype.init = function() {
		// Example: Bind event to element
		this.$element.on('click.' + pluginName, '[data-'+ pluginName +'~="link"]', $.proxy(function(event) {
			event.preventDefault();

			var param = 'someParam';

			this.someMethod(param);
		}, this));

		// Example: Bind event to document (triggered from outside)
		// $document.on(Unic.modules.othermodule.events.eventname, $.proxy(function(event, data) {
		// 	this.someMethod(data.param);
		// }, this));

		console.log('init() called in source/assets/modules/'+ pluginName +'/'+ pluginName +'.js');
	};

	/**
	 * Do stuff
	 * @param {string} param Something
	 */
	Plugin.prototype.someMethod = function(param) {
		// Example: Trigger event on element
		this.$element.trigger(events.eventname, {
			param: param
		});

		// Example: Trigger event on document
		$document.trigger(events.eventname, {
			param: param
		});

		console.log('someMethod() called in source/assets/modules/'+ pluginName +'/'+ pluginName +'.js');
	};


	// Make the plugin available through jQuery (and the global project namespace)
	Unic.modules.PluginHelper.register(Plugin, pluginName);

	// Bind the module to particular events and elements
	$document.on('ready ajax_loaded', function() {
		$.fn[pluginName].apply($('[data-'+ pluginName +'~="init"]'), [{
			// Options
		}]);
	});

})(window, document, jQuery, Unic);