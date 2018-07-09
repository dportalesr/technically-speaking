---
layout: post
title: Ripgrep – The fastest grep alive
date: 2016-11-29 02:00 -0500
---

I’ve been happily using [ag](https://github.com/ggreer/the_silver_searcher) a.k.a. The Silver Searcher for some time now, since searching for strings (and regex patterns) in all project files using SublimeText’s search panel recently became an insufferable pain to work with.

Maybe it was something I did after tweaking some ST’s config files –we all like it custom–, but having to wait at least a minute to get a single recursive search over a couple of files is ridiculous. That’s how I met `ag`, thanks to [@AnyVelnz](https://twitter.com/AnyVelnz). Unlike me, she uses it as a vim integration, but I tried it anyways.

It claims to be the fastest tool in its kind, and it was all fine and dandy until I struggled to do something simple as to make a search excluding files with 2 different extensions. Maybe I missed something in their docs (and by that I mean `ag -h`) but dealing with types didn't seem flexible enough.

Then I found about [ripgrep](https://github.com/BurntSushi/ripgrep) which claimed to be **even faster**. The basic usage instructions showed me what I was looking for:

```bash
# Recursively search current directory for "hidden" in files that DON'T end with scss or css
rg -g '!*.{scss,css}' hidden
```

Ripgrep seem to have all the nice features of ag but with more sensible defaults and seems easier to use, except for the fact that at this time, there’s no way to persist custom configuration. A `.rgrc` has been [already proposed](https://github.com/BurntSushi/ripgrep/issues/196) but the only solution for now is to handle it with [command aliases](https://github.com/BurntSushi/ripgrep/issues/196#issuecomment-256675205).

Fair enough.
