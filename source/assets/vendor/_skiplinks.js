/*!
 * Fix for webkit issue where content accessed using skiplinks is not focused.
 *
 * @source https://gist.github.com/1900563
 */

(function(a,b,c,d) {
	for (c in a) {
		if ((d=a[c].hash)&&a[c].href==b+d&&a[c].addEventListener) {
			a[c].addEventListener('click',function(e,f,g,h) {
				if (e=(f=document).getElementById(g=this.hash.slice(1))||f.getElementsByName(g)[0]) {
					if (h=!e.getAttribute(f='tabindex')) e.setAttribute(f,-1);
					e.focus();
					if (h) e.removeAttribute(f);
				}
			});
		}
	}
})(document.links,location.href.split('#')[0]);