Styleguide
=========

Remarks
-------

* "Generally" is used when a rule is not meant to be absolute.


Formatting
----------

1. General
	* Encoding: UTF-8
	* Indentation: Tabs

2. HTML
	* Attributes wrapped with double quotes
	* Filenames with underscores, no dashes

3. CSS
	* Properties indented
	* One property per line
	* Generally one selector per line
	* Selectors in lowercase and with underscores, no dashes
	* SASS: CamelCase for everything but selectors and placeholders

4. JS
	* Variables and function names in camelCase
	* Constants in UPPER_CASE (e.g. ANIMATION_DURATION)
	* Constructors and class names in PascalCase
	* References to jQuery objects start with $ (e.g. $carouselContainer)
	* Single quotes
	* Comments (because we use YUI compressor):  
		/\*!  
		 \* Not stripped when compressed  
		 \*/  
		/\**  
		 \* Stripped when compressed  
		 \*/

5. Ruby
	* Lowercase and underscores for variables, functions etc.


Guidelines
----------

1. Selectors
	* No use of IDs for styling, classes only
	* Prefixing of classes:
		* Layout: "layout\_", used for general page layout (e.g. "layout\_wrapper")
		* Module: "mod\_", used for independent blocks of markup (e.g. "mod\_teaser"). Generally no namespacing inside modules (e.g. use ".mod\_teaser .title" instead of ".mod\_teaser\_title").
		* Variant: "var\_", used as modifier or above elements (e.g. "var\_onecol") 
		* State: "is\_", used as modifier or above elements (e.g. "is\_inactive") 
	* JS hooks: Use data attributes instead of classes to target elements using JavaScript (e.g. "data-role-init="teaser")
	* No use of overqualified selectors (e.g. "div.mod\_teaser")

2. Units
	* em or % for dimensions, generally no px

3. SASS
	* Use mixins and placeholders for repeating styles
	* Define Colors globally
	* Nest your classes as little as possible

4. JS
	* Use unobtrusive JS

5. Ruby
	* Use Ruby as much as necessary and as little as possible

6. Vendor code
	* Do not include minified code, the build step takes care of minification
	* Duplicate vendor files and add ".hotfix" before file ending when applying any changes
