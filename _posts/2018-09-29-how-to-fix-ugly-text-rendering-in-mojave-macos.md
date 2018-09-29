---
layout: post
title: How to fix ugly text rendering in Mojave MacOS
date: 2018-09-29 00:15 -0500
---

Apple's new operating system, Mojave, has deprecated an old technique for smoothing text rendering, leaving non-retina screens at the mercy of ugly crispy font renderings.

Fortunately, "deprecated" doesn't mean we can't bring it back. Here are 3 things you can do to fix it.

1. I'm pretty sure you've already covered this one, but for completeness, go to _System Preferences_ > _General_ and make sure you have _Use font smoothing when available_ checked. If that's not the issue, continue reading.


2. Open the _terminal_ app and copy/paste the following command as is:
```bash
defaults write -g CGFontRenderingFontSmoothingDisabled -bool false
```
After that, press _Enter_. You won't get any confirmation message. Close the terminal window and try logging out from your user session and log back in, to see the changes applied.


3. If your eyes are still feeling uncomfortable about the look of those fonts in your screen, you may try again the terminal approach, but this time using a different command:
  ```bash
  defaults -currentHost write -globalDomain AppleFontSmoothing -int 2
  ```
  This last command accepts a range of values that can fine-tunning how bold your fonts will look. Change the number after `-int` to a `3` to use the boldest rendering. A value of `1` will use the most subtle font smoothing whereas a value of `0` will disable it completely. Don't forget you'll need to restart your session before seeing any changes.

Hopefully, you will have overcome another case of programmed obsolescence. Congrats!
