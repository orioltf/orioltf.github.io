---
title: Configure Chrome to work on browser
date: 2013-07-19 07:18 CEST
tags: Frontend tools
summary: Step-by-step guide to configure Google Chrome to edit local files so it is not needed to leave DevTools.
---

This is a step-by-step guide to configure Chrome to work on browser. This enables editing and saving local files and thanks to this, it is not needed to leave DevTools in your workflow.

1. Open chrome://flags in a new tab in Chrome
1. Activate "Enable Developer Tools experiments"
1. Open the dev tools
1. Go to the dev tools settings (press "?" in keyboard)
1. Go to tab "Experiments"
1. Enable option "File system folders in Sources Panel"
1. Enable option "CSS Regions Support"
1. Enable option "Support for Sass" (if you use sass command directly, not for MM)
1. Restart dev tools (or even Chrome sometimes)
1. Go again to the dev tools settings (press "?" in keyboard)
1. You'll have a new tab called "Workspace"
1. Add a file system (path to your static page folder)
1. Accept the message (yellow bar) giving Chrome access to the Filesystem
1. Restart dev tools (or even Chrome sometimes)
1. In "sources tab" the page is now represented by a folder icon, not by a greyed-world icon.
1. Choose one of the resources in this folder to change it and see live the changes in the page. (You can try CMD+o to open a file in the sublime cmd+p way)
1. CMD+s to save it to disc.

References
* http://remysharp.com/2013/07/18/my-workflow-v3-full-coding-stack/