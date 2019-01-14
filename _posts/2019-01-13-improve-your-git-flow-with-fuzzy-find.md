---
layout: post
title: Improve your Git flow with Fuzzy Find
date: 2019-01-13 18:03 -0600
---

When I started using git from the command line (the command line in general, to be honest) it always bothered me how rustic the flow felt, even when I was using the really basic commands. I was never too attached to the Git GUI tools, but the only thing I missed from them was the fact that I never had the need to write full-path files to add, remove, unstage, etc. I always preferred using a cursor to select files or branches. It felt simply more efficient.

After migrating to using command-line git, I kept dreaming about a better way to reference paths without having to type those full paths.

Fortunately, it wasn't that bad when you're using [Oh My Zsh' smart autocompletion](https://opensource.com/article/18/9/tips-productivity-zsh).

It allows to hit TAB to autocomplete directories. Example:

<script id="asciicast-RbzKTmzaloz4gHeg5vAgy49fs" src="https://asciinema.org/a/RbzKTmzaloz4gHeg5vAgy49fs.js" async data-rows="8" data-size="small"></script>

We only have to enter the first letter of each directory and Zsh will autocomplete the name for us. Zsh is smart enough to autocomplete only directory names (not files) in the context of the current command (`cd` in this example).

Additionally, we can enter all our one letter hints separated by slashes and hit TAB just once, if we're confident that information is enough to let zsh know what we want to reference:

<script id="asciicast-fB6T8EzC5XOXkc3ZxvdbtLwSz" src="https://asciinema.org/a/fB6T8EzC5XOXkc3ZxvdbtLwSz.js" async data-rows="8" data-size="small"></script>

In the context of `git add`, it works for files, as we would expect:

<script id="asciicast-4LbQTUnJ3VvrfI8CAoj1niWrt" src="https://asciinema.org/a/4LbQTUnJ3VvrfI8CAoj1niWrt.js" async data-rows="8" data-size="small"></script>

This is a huge help for our problem, and most of the times it's enough. But if you require a more reliable way to resolve file paths, and a more interactive experience, we can go a step further.

## Fuzzy Find

[Fuzzy find](https://en.wikipedia.org/wiki/Approximate_string_matching) has become fundamental to IDEs when working and navigating through large codebases with hundred of files. I first met it as a built-in feature of SublimeText and it was without doubt one of the most outstanding features that convinced me to switch.

> "Approximate string matching" (often colloquially referred to as "fuzzy string searching") is the technique of finding strings that match a pattern approximately (rather than exactly).

So we can use some algorightms to have a more accurate solution of our problem.

### fzf

> fzf is a general-purpose command-line fuzzy finder.
> It's an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc.

You can get [fzf](https://github.com/junegunn/fzf) with 🍺:

```bash
brew install fzf
```

Now you can use it to process and filter any kind of list-like output from any other command. When no input is provided, it filters recursively the directories and files from the current directory. The output of the `fzf` command, which is a file with a relative path, can be used as input for another command.

In this example, we use the default behavior and use the output as an argument to the `st` command, which is SublimeText binary, to open the file:

<script id="asciicast-PErXLrF5i7eZEWjULWLUsGnTI" src="https://asciinema.org/a/PErXLrF5i7eZEWjULWLUsGnTI.js" async data-rows="18" data-size="small"></script>

### Working with Git

To make the story short, we can craft some interesting aliases to use fuzzy find in our git commands. Here are some examples:

```bash
alias gfuz='git ls-files -m -o --exclude-standard | fzf --print0 -m -1 | xargs -0 -t -o'
```

The alias above will let us fuzzy find a file from the **list of files not ignored by git that have been modified or are not tracked yet (new files).** In other words, it shows [files ready to be staged](https://explainshell.com/explain?cmd=git-ls-files+-m+-o+--exclude-standard) and from there, we use the selected file [to feed another command](http://manpages.ubuntu.com/manpages/precise/en/man1/xargs.1.html).

See below for examples.

**NOTE**: Some of the following alias/functions use the same names of Oh-my-Zsh git aliases, so, if you're already using them, you may need to unalias them first, right before the new definition. Example:

```bash
unalias gco
# new gco alias/function code...
```

#### Git Diff

Show what changed.

```bash
alias gdf='gfuz git diff'
```

<script id="asciicast-yBYSigdJAN06MhLo0JQOCm2Vr" src="https://asciinema.org/a/yBYSigdJAN06MhLo0JQOCm2Vr.js" async data-rows="8" data-size="small"></script>

From this example, you can notice fuzzy search's result list can be navigated with up/down keys, particularly useful when the list is really short and the results are very similar.

#### Git Checkout

Checkout files.

```bash
gco(){
  if [ $# -eq 0 ]; then
    gfuz git checkout
  else
    git checkout "$@"
  fi
}
```

<script id="asciicast-sfkGfO6KzKUMuCXrRKK8CJcZs" src="https://asciinema.org/a/sfkGfO6KzKUMuCXrRKK8CJcZs.js" async data-rows="18" data-size="small"></script>

This is different.

The reason we're not using an alias here is that I wanted to keep some flexibility to be able to use the original command/alias with arguments. So, as a rule, when a command that expects arguments does not receive any, it'll trigger fuzzy search to get it.

In this other example, we provide a path to `gco` to target all files under that folder, as it would normally work with `git checkout`:

<script id="asciicast-rmPjxwyBoIw7kUpqp24vqQg6o" src="https://asciinema.org/a/rmPjxwyBoIw7kUpqp24vqQg6o.js" async data-rows="28" data-size="small"></script>


#### Git Add

Stage files.

```bash
ga(){
  if [ $# -eq 0 ]; then
    gfuz git add
  else
    git add "$@"
  fi
}
```

Same as the previous, we can pass arguments to trigger the original behavior or omit it and start a fuzzy search.

From this example, we learn that when the list returned by the search has one result, it'll skip showing the list and will automatically select it.

<script id="asciicast-UQfWzzIMjhw9nqIOx1SMe4LXT" src="https://asciinema.org/a/UQfWzzIMjhw9nqIOx1SMe4LXT.js" async data-rows="16" data-size="small"></script>

#### Unstage Files

```bash
grh(){
  if [ $# -eq 0 ]; then
    git diff --name-only --cached | fzf --print0 -m -1 | xargs -0 -t -o git reset HEAD
  else
    git reset HEAD "$@"
  fi
}
```

In this case, we can't rely on `gfuz` since we need the opposite of that list, that is, the list of already staged files. We sort that out by using `git diff --name-only --cached`.

<script id="asciicast-fPwDPfjw0iPTNb6bd3BPcBTR9" src="https://asciinema.org/a/fPwDPfjw0iPTNb6bd3BPcBTR9.js" async data-rows="16" data-size="small"></script>

In case you haven't noticed yet, whenever we use a fuzzy search with another command, we can see the actual full command that was ran.

#### Git Branch

Navigating branches.

```bash
gb(){
  if [ $# -eq 0 ]; then
    git branch | fzf --print0 -m | tr -d '[:space:]*' |xargs -0 -t -o git checkout
  else
    git checkout "$@"
  fi
}
```

Until now, we've been dealing with directories and folders, but that's not the only thing we can play with. We can use some additional bash sorcery to handle the list of branches in our repo. Switching between branches was never that easy!

<script id="asciicast-Y09amuM8GoWoWzy2WDTU7dC8U" src="https://asciinema.org/a/Y09amuM8GoWoWzy2WDTU7dC8U.js" async data-rows="12" data-size="small"></script>

And of course, we can try passing arguments to be handled by `git checkout`.

<script id="asciicast-gpOJG4wmk1d4H7rfX9gY9yw6F" src="https://asciinema.org/a/gpOJG4wmk1d4H7rfX9gY9yw6F.js" async data-rows="12" data-size="small"></script>

## Conclusions

These are some of the commands that I use all the time, everyday, and by integrating them with fuzzy search the result have been a much faster flow when using git.

I hope it helps you too.

Now use your imagination and share some other useful customizations!
