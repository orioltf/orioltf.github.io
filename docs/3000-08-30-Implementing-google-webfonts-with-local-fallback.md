---
title: Implementing Webfonts with local fallback
date: 3000-08-30 19:20 CEST
tags: Frontend tools
summary: Google web fonts, or any other service, are great to add web fonts to your site. Nevertheless, you may want to have either the security to be independent from Google in case that their servers ever were down, or you to be able to develop your site in a completely off-line modus. Or even both at the same time.
published: false
---

In this article I propose a methodology to **implement web fonts**, in this case from [Google Web fonts service](http://www.google.com/fonts/), **with local fallback**. Benefits from this methodology:

* You can use the CDN from Google and therefor reduce the loading time of your site in case the user has already cached the font.
* You can be quiet in case that Google ever removes the service or in the improbable case it would ever be down.
* You can reliably develop in off-line modus.


## 0. Understanding the method

The method proposed here uses a couple of techniques to ensure that the fonts can be used first from the external server and then from the local server if the first option fails:

1. Google fonts will be loaded via JS to be able to track whether the fonts were loaded or not.
2. Google fonts uses the **style-linking** to serve the font styles. So we will use **name-matching** method to serve our font styles. Both together are the **combined method**, which you can find perfectly explained in SmashingMagazine:

> Franz, Laura. "Setting Weights And Styles With The @font-face Declaration". SmashingMagazine. February 14th, 2013. August 30th, 2013. [http://coding.smashingmagazine.com/2013/02/14/setting-weights-and-styles-at-font-face-declaration/]()


## 1. Choosing Fonts

First of all, of course, you should choose one or more fonts and font styles. Since we are using both style-linking and name linking we can take advantage from the benefits from both techniques, but we'll also have to manage drawbacks from both techniques.

**Drawback**: Using style-linking, which is the technique used by Google on the font-styles they serve means that the number of fonts (font names) and styles (light, bold, italic and combinations) is limited due to... wait for it... Microsoft Internet Explorer! 

/* TODO: Add resources!! Smashingmag */

For this article I'll use the fonts used in this page (note that from each family Google offers more derivatives):

1. Source Sans Pro:
	1. Light 300
	1. Light 300 italic
	1. Semi-Bold 600
	1. Semi-bold 600 italic
1. Roboto Slab
	1. Light 300


## 2. Getting the fonts ready

The first step, after choosing your font family and its derivatives, is to **get all the font formats for each browser**. Google is doing this for you behind the scenes and serves only the appropriate file format to each browser via server-side detection.

To do so click on the arrow icon on the upper right corner to download the fonts in True Type Format (*.ttf):

/* TODO: Add image google-fonts-download-arrow.png */
![img alt text](/blog/path-to/img.png)

Pay attention: when you download the chosen fonts you'll get the whole family for each font, while you'll probably want only some of them. On our example I just want the 5 described above, out of the 16 downloaded.

Then **head over to [FontSquirrel](http://www.fontsquirrel.com/tools/webfont-generator) to transform your ttf font files** to the rest of the formats:

1. Upload only the ttf files that respond to the chosen fonts (max. 3 uploads at the same time)
2. Choose the "Expert" option to optimize the fonts
3. Formats: TrueType, WOFF, EOT Compressed, SVG
4. Truetype Hinting: Keep existing
5. CSS: make sure "Style linking" is not active
6. Check the Agreement
7. Click on "Download your kit"

You'll see at the top of the table the conversion progress for each font you uploaded before getting a zip file with all the necessary files.

/* TODO: Add image fontsquirrel-fonts-downloaded.png */

Now unzip the downloaded file and **place the font files** (only the *.ttf, *.eot, *.woff and *.svg files) **in a folder from your project**, in my case I placed them in "/assets/vendor/googleFonts/", keeping there a separate folder for each font family. 

**Place also the "stylesheet.css" file in a folder from your project**. This file contains the @font-face declarations and will be used when the fallback is activated. Remember to update the path to the fonts in this file. This path is relative to this file, not to the HTML document. In my case I placed it in "/assets/vendor/googleFonts/_fonts.css" (I've renamed it), so the URL to each font will have to contain only the folder name: `src: url('robotoSlab/robotoslab-light-webfont.eot?#iefix') format('embedded-opentype'),`. 

Lastly, in order to properly apply the **combined method** we need to update the @font-face declarations, by giving to each declaration its appropriate font-weight and font-style. For instance:

~~~css
@font-face {
	font-family: 'source_sans_proSBdIt';
	src: url('sourceSansPro/sourcesanspro-semibolditalic-webfont.eot');
	src: url('sourceSansPro/sourcesanspro-semibolditalic-webfont.eot?#iefix') format('embedded-opentype'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.woff') format('woff'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.ttf') format('truetype'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.svg#source_sans_proSBdIt') format('svg');
	font-weight: normal;
	font-style: normal;
}
~~~

should become:

~~~css
@font-face {
	font-family: 'source_sans_proSBdIt';
	src: url('sourceSansPro/sourcesanspro-semibolditalic-webfont.eot');
	src: url('sourceSansPro/sourcesanspro-semibolditalic-webfont.eot?#iefix') format('embedded-opentype'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.woff') format('woff'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.ttf') format('truetype'),
		 url('sourceSansPro/sourcesanspro-semibolditalic-webfont.svg#source_sans_proSBdIt') format('svg');
	font-weight: 600;
	font-style: italic;
}
~~~



## 3. Including the fonts for normal browsers

In the screen from Google choose the tab "javascript" to copy the necessary code to include the fonts via javascript. This is, of course, not the easiest option, but it offers more refined options for us to track whether the fonts can or not be loaded. Those users without JS won't get the fonts, but those users are either advanced users who try this just for fun or for testing, or users with old machines which anyway do not support them. So we really make no worries about them.

/* TODO: Add image google-fonts-js-tab.png */

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


## 6. Setup the cascading styles

When configuring font styles the first thing will be to declare a default font-family group of fonts. This declaration should include those system font families that will act as fallback in the improvable case that everything else would fail.

So the first piece of CSS could be:

~~~css
body {
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 100%;
	line-height: 1.5;
}
~~~


Then, we will create some compass mixins to declare the font definitions. I post here the compass solution because this is my work-flow, though you could probably do the same in less, and for sure you can achieve the same in plain CSS.

These mixins will help us setting any CSS declaration bound to the font classes set in the HTML element by the Web Font Loader. So if the classes are set or not, our web can react accordingly.  To clearly get which are these classes, inspect your page with the previous steps already implemented. In the HTML node of your inspector you 'll see a good amount of CSS classes. Get the ones related to web fonts, which will have a "wf-" prefix. In my case:

* wf-sourcesanspro-n3-active
* wf-sourcesanspro-n6-active
* wf-sourcesanspro-i3-active
* wf-sourcesanspro-i6-active
* wf-robotoslab-n3-active
* wf-active

If you cut any Internet connection and reload the page, you'll see that all these classes are gone, and there's just one in replacement:

* wf-local

Therefor, each font-family will get its own mixin, bound to its own class. And since we are using the **combined method** to match font-family name with font files (Style-linking and name-matching), we'll have to give also font-weight and font-style.

Then in the mixin we'll set a font-family attribute with an appropriate list of fallback fonts, in this sequence:

1. The **font-family name** specified in the @font-face definition **from the local css file**.
2. The **font-family name** specified in the @font-face definition from the css file **from Google** (when there is connection). You can get it with your inspector. Notice that the font-family names there, are the same regardless of what Web font file is being accessed, and the font-weight and font-style are used to match the proper file. This is called **style linking**.
3. The **rest of** the fallback **font-families defined before**.

~~~scss
@mixin ssp-light($fontSize: false) {
	.wf-sourcesanspro-n3-active &, .wf-local & {
		font-family: "source_sans_prolight", "Source Sans Pro", "Helvetica Neue", Helvetica, Arial, sans-serif;
		font-weight: 300;
		font-style: normal;
		@if $fontSize {font-size: $fontSize;}
	}
}
~~~



## 7. Include the fonts in your styles

Now you can easily include your fonts in your styles. In my case here is my basic setup:

~~~SCSS
body {@include ssp-light;}
strong, b {@include ssp-bold;}
em, i {@include ssp-light-italic;}
strong > em, em > strong,
strong > i, i > strong,
b > em, em > b,
b > i, i > b {@include ssp-bold-italic;}
#{headings()} {@include roboto-slab-light;}
~~~