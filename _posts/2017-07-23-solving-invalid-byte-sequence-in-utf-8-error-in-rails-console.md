---
layout: post
excerpt: 'Quickest solution: Locate and delete the `.irb-history` file.'
title: Solving "Invalid byte sequence in UTF-8" error in Rails console
date: 2017-07-23 09:00 -0500
---

## Problem

When launching the Rails console, an `invalid byte sequence in UTF-8` error prevented it from starting, with no apparent changes to my project code. The last line in the backtrace was something like:

```
[...]/lib/ruby/gems/2.4.0/bundler/gems/rb-readline-fd882edcd145/lib/rbreadline.rb:6135:in `delete`: invalid byte sequence in UTF-8 (ArgumentError)
```

## Solution

Quickest solution: Locate and delete the `.irb-history` file.

```bash
rm -f ~/.irb-history
```

The home directory is the usual location of that file. In windows, the file is actually named  `.irb_history`, probably located at your home directory too: `C:\Users\your_username\`

If you're using the `pry` gem, the history will be actually saved in a file called `.pry_history` (looks like there's no convention for using dash or underscore in config file names).

Actually, this is more like a workaround, since the [real solution is still waiting to be merged](https://github.com/ConnorAtherton/rb-readline/pull/140)  at `rb-readline` gem repo (at the moment of writing this).

## Explanation

Taking a closer look to the backtrace we can notice some calls to IRB's `load_history` method.

```bash
...
from C:/ruby24/lib/ruby/2.4.0/irb/ext/save-history.rb:75:in `load_history`
...
```

That made me think of encoding issues in the history registry, the file [IRB](https://en.wikipedia.org/wiki/Interactive_Ruby_Shell) console uses to keep a record of all commands entered previously. After a quick search about the whereabouts of this file, I opened the file looking for strange characters, but then I decided it was faster to just empty the file. Deleting the file is an option, since the file is generated automatically after entering any thing in the console.

But, where did that dirty character came from? Well, in my case, I think it happened due copy-pasting code from the internet (whoever is without sin, cast the first stone).
