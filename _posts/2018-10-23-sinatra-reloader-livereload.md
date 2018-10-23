---
layout: post
title: Sinatra Reloader + LiveReload
date: 2018-10-23 01:18 -0500
excerpt: Development flow in Sinatra is slow out-of-the-box. Sinatra Reloader surely is fast, but we can go faster.
---
<img class="post-frontimage" src="/assets/img/reloading.jpg" alt="RELOADING!">

[Sinatra::Contrib](http://sinatrarb.com/contrib/) is a project that basically extends the core capabilities of Sinatra without adding significant overhead. It provides useful and often asked functionality in the form of extensions.

We'll talk about one of them that will help you to speed up your workflow: Sinatra Reloader.

When your Sinatra application starts to grow, or even just because you like to place everything in a more organized way, you will probably find yourself creating files to put some code outside the main application file. Helper methods are a good example of this.

If you don't really need that many helpers and, in fact, you can keep them inside a `helpers` block in your main file, like this:

```ruby
helpers do
  def my_helper
    ...
  end

  def another_helper
    ...
  end
end
```

In the other hand, if you want to use the `helpers` method by referencing a module, like:

```ruby
require_relative 'app/my_helpers'

helpers MyHelpers
# or the more verbose
helpers do
  include MyHelpers
end
```

then, by requiring your files you'll eventually find a limitation: Changes to `app/my_helpers.rb` file won't be picked up unless you restart your local server.

This is a case for THE RELOADER.

## Sinatra Reloader

Its [official page](http://sinatrarb.com/contrib/reloader) reads as follows:

> Extension to reload modified files. Useful during development, since it will automatically require files defining routes, filters, error handlers and inline templates, with every incoming request, but only if they have been updated.

Or in other words, required files will be loaded on the next request after they've been modified without having to restart your server.

### Usage

The extension provides a `also_reload` method that let us specify the files that we want to be reloaded at every request/refresh of the browser.

But the documentation omits a very important detail: `also_reload` accepts "globbing" (as if you were using [Dir.glob](https://ruby-doc.org/core-2.2.3/Dir.html#method-c-glob)) and also, can be called any number of times.

```ruby
also_reload 'app/some/file.rb'
also_reload 'lib/**/*.rb'
also_reload 'app/{helpers,models}/*.rb'
also_reload '*.rb'
```

**WARNING**: you should avoid using `also_reload` on files that make use of that same method, otherwise, each reload of such files will stack up for every request and cause a lot of unnecessary reloads.

## Reloader + LiveReload

And now you must be thinking "Ok, all this is cool but I was expecting that Sinatra-reload would be somewhat related to that LiveReload does, aka, trigger browser refreshing". LiveReloading is a completely different thing but it's easy to go there.

You'll need to add 2 gems to your Gemfile: [rack-livereload](https://github.com/onesupercoder/rack-livereload) and [guard-livereload](https://github.com/guard/guard-livereload). You can check the code needed [in this gist](https://gist.github.com/dportalesr/de535477362963dcdfc7cc402b9a1665).

There, you can see the basic rules for a Guardfile:

```ruby
# A page refresh will be triggered
# when these files are modified:
watch(%r{^app\.rb}) # app.rb
watch(%r{views/.+\.(erb|haml|slim)$}) # file under views/ with erb, haml or slim extension
watch(%r{public/.+\.(css|js|html)}) # css, js or html file in public/
```

You will also notice in that gist the `Guardfile` I'm currently using which is already configured to support [sinatra-asset-pipeline](https://github.com/kalasjocke/sinatra-asset-pipeline). With such settings, CSS, HTML and JS assets inside the `assets` (source) or `public` (compiled) folder will be watched and the browser will refresh automagically when a change in them is detected. It works specially well for the CSS since it'll "inject" the changes into the browser, and not even a page refresh is needed!

Changes to other assets –namely, images– will be detected and reported to Guard but not default action will be taken, as far as I know. Mysteries of life.

Finally, an additional rule to refresh the browser is present:

```ruby
watch(%r{app\/(helpers|models)\/(.+)\.rb$}) # files inside app/helpers & app/models subfolders
```

Adapt these to your application structure and enjoy!
