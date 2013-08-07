;(function(window, document, $, undefined) {
	"use strict";
	

	/** 
	 * Override ASP form validation
	 *
	 * Adapted from http://caliberwebgroup.blogspot.ch/2009/02/overriding-javascript-in-webresourceaxd.html
	 */

	window.ValidatorUpdateDisplay = function(element) {
		var displayProp = element.isvalid ? 'none' : 'block',
			visibilityProp = element.isvalid ? 'hidden' : 'visible';

		if (typeof element.display === 'string') {
			if (element.display === 'None') {
				return;
			}

			if (element.display === 'Dynamic') {
				element.style.display = displayProp;
				return;
			}
		}

		element.style.visibility = visibilityProp;
	};

})(window, document, jQuery);