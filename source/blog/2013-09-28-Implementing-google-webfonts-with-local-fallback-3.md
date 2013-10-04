---
title: Implementing Webfonts with local fallback 3
date: 2013-09-28 19:55 CEST
tags: Frontend tools
summary: Third and last part from the series on how to implement Webfonts with local fallback. Once we have the font files ready, and the fonts included in our project with its fallbacks we can start using them.
---


This is the third and last part of a series on **how to implement Webfonts with local fallback**. Please check the previoes articles about [preparing fonts](/blog/2013/08/30/Implementing-google-webfonts-with-local-fallback/) and [including them in the project](/blog/2013/09/14/Implementing-google-webfonts-with-local-fallback-2/) in order to get your project ready before start using them. In this article we will be creating some compass mixins to easily create the *combined method* [already explained](/blog/2013/09/14/Implementing-google-webfonts-with-local-fallback/#understanding-the-method).


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

Now you can easily include your fonts in your styles. In my case here is my basic CSS setup:

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