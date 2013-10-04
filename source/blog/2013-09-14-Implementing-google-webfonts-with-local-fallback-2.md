---
title: Implementing Webfonts with local fallback 2
date: 2013-09-14 19:20 CEST
tags: Frontend tools
summary: Second part from the series on how to implement Webfonts with local fallback. Once we have the font files ready we must follow some steps in order to include the fonts from the server (Google in this case) and then provide a fallback system.
---


This is the second part of a series on **how to implement Webfonts with local fallback**. Please check the [previous article](/blog/2013/08/30/Implementing-google-webfonts-with-local-fallback/) in order to get your fonts ready. In this article we will be including the webfonts from the server, and the we will add 2 fallbacks: one for normal browsers, and another one for legacy browsers (namely, oldIEs).


## 3. Including the fonts for normal browsers

In the screen from Google choose the tab "javascript" to copy the necessary code to include the fonts via javascript. This is, of course, not the easiest option, but it offers more refined options for us to track whether the fonts can or not be loaded. Those users without JS won't get the fonts, but those users are either advanced users who try this just for fun or for testing, or users with old machines which anyway do not support them. So we really make no worries about them.

![Google offers 3 options to include fonts, displayed in tabs. We choose the javascript tab.](/assets/media/blog/google-fonts-js-tab.png)

So **copy the JS code from Google and paste it at the top of the JS file** that you'll load at the end of your html file. You could also load it at the head of your HTML in order to avoid flickering when fonts are loaded. But in my experience, if you load more than 1 or 2 font file it flickers anyway because the browser is faster at rendering the rest of the HTML document than the fonts.

Here a copy from the code for the fonts listed above:

~~~javascript

WebFontConfig = {
	google: { families: [ 
		'Source+Sans+Pro:300,600,300italic,600italic:latin', 
		'Roboto+Slab:300:latin' 
	] }
};
(function() {
	var wf = document.createElement('script');
	wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
		'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
	wf.type = 'text/javascript';
	wf.async = 'true';
	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(wf, s);
})();
~~~

This piece of code is the *Web Font Loader*. This script was co-developed by Typekit and Google, and it can load fonts from several services as well as self-hosted fonts. [Source code in Github](https://github.com/typekit/webfontloader). **The Web Font Loader provides several events we can use.  It also provides some CSS class names** that will be placed in the HTML element. We'll be using both things.

There are some drawbacks when fonts are loading: the load is asynchronous, which means that your JS may have already executed either partly or completely. Let's say for instance that you have a plug-in called sameHeight() that calculates heights for some boxes: since the height of an element depends of its content and this one depends on the font family, you'll need to re-calculate the height once the web fonts become **active**.

To get around this, we'll be using the **active event** from the *Web Font Loader*. We can set a callback function that will be executed as soon as the fonts are rendered: then the **active event** is fired. And in that function we can trigger a custom event in jQuery (called "wfActive" in the code below) that can be used, for instance, in our plug-in `sameHeight()`{:.language-javascript} in order to force the re-calculation. Or wherever we may need once the fonts become active.

~~~javascript

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
	var wf = document.createElement('script');
	wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
		'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
	wf.type = 'text/javascript';
	wf.async = 'true';
	var s = document.getElementsByTagName('script')[0];
	s.parentNode.insertBefore(wf, s);
})();
~~~

You can then use your custom event:

~~~javascript

$(document).on('wfActive', function() {
	// Your code
});
~~~
As you can see, I check if the jQuery object is already there. If not I just give it another try, after half a second to trigger the jQuery event. I think that half a second is time enough for a Browser to render the page and execute jQuery. If not... well I should either re-think the web I'm working on, or rethink this parameter ;)


## 4. Setting a fallback for offline development

As you may have notice, there is a second part in the code from google: the self executing function
from the half below `(function() { ... })();`{:.language-javascript}. It asynchronously loads the Web Font Loader library, while the first half from the code was the configuration.

This parts sets a new `<script />`{:.language-html} element. And most of the modern browsers implement an **`error`** event that is fired when the script is not loaded. So we can use this to:

1. Create a new <link /> element to load a CSS file from our server with the @font-face definitions.
1. Sets a custom class "wf-local" in the HTML element, just in case we would like to react in CSS or JS.
1. Triggers the "wfActive" event in case jQuery is there.

~~~javascript

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
	wf.src = ('https:' == document.location.protocol ? 'https' : 'http') + 
		'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
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
~~~


## 5. onerror fallback for legacy browsers

OldIEs and a couple of pretty old Firefox version have either poor or no implementation of the `onerror`{:.language-javascript} method ([http://www.quirksmode.org/dom/events/error.html]()), so we need to provide another solution for those browsers. Since most of the Firefox user base is pretty up to date with their browser, I'll wrap my JS code in a conditional comment.

This time the code will be placed at the very end of our document, and since we cannot test if the browser properly implements the `onerror`{:.language-javascript} method, we're going to test if the `WebFont`{:.language-javascript} object is available. This object is set by the Web Font Loader library, which should have been downloaded by the Web Font Loader, that added the script `'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'`.

The target of the JS is the same than before:

1. Create a new <link /> element to load the CSS file wif @font-face definitions to our fonts.
2. Set a custom class "wf-local" in the HTML element.
3. Trigger the "wfActive" event in case jQuery is there.

~~~javascript
<!--[if lt IE 9]>
	<script>
		if (!window.WebFont){
			var wf, s;
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
		}
	</script>
<![endif]-->
~~~

