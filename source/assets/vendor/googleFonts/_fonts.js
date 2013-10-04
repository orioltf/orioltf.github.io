
var t;
WebFontConfig = {
	google: {
		families: [
			'Source+Sans+Pro:300,600,300italic,600italic:latin',
			'Roboto+Slab:300:latin'
		]
	},
	active: function() {
		if (window.jQuery) {
			jQuery(document).trigger('wfActive');
		} else {
			t = setTimeout(function() {
				if(window.jQuery) {
					clearTimeout(t);
					jQuery(document).trigger('wfActive');
				}
			},500);
		}
	}
};


(function() {
	var wf, s, t;
	wf = document.createElement('script');
	wf.src = ('https:' == document.location.protocol ? 'https' : 'http') + '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
	wf.type = 'text/javascript';
	wf.async = 'true';
	s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(wf, s);

	wf.onerror = function() {
		wf = document.createElement('link');
		wf.href = '/assets/vendor/googleFonts/fonts.css';
		wf.type = 'text/css';
		wf.rel = 'stylesheet';
		wf.media = 'all';
		s = document.getElementsByTagName('link')[0];
		s.parentNode.insertBefore(wf, s);
		document.getElementsByTagName('html')[0].className += ' wf-local';
		if(window.jQuery) {
			clearTimeout(t);
			jQuery(document).trigger('wfActive');
		} else {
			t = setTimeout(function() {
				if(window.jQuery) {
					clearTimeout(t);
					jQuery(document).trigger('wfActive');
				}
			},500);
		}
	};
})();

