---
layout: post
title: 'Laravel: Creating the database using Artisan commands'
date: 2018-09-30 00:23 -0500
---
Laravel is a PHP framework that was created as a fierce contestant in the world of modern web development frameworks. It's actually based on [Symfony](https://symfony.com/) and it was conceived as a solution to integrate a lot of features and amenities that were long envied from other environments and tools, like Ruby on Rails.

**Database migrations** was one of them, and while they were already available in Symfony, they were not part of the core functionalities but as an external library (the appropriate term is _bundle_).

In Laravel, they're available out-of-the-box, and while they're still far from having a [smart and powerful way to create them](https://guides.rubyonrails.org/active_record_migrations.html#model-generators), they still give you the control to do anything through the [DB](https://laravel.com/docs/5.7/database#running-queries) facade (raw SQL queries 🤫).

## The Problem

However, I was confused and surprised after going through the docs and not being able to find anything about **how to create the database using an [artisan](https://laravel.com/docs/5.7/artisan) command**, just like you can do it with `rails db:create` command in Ruby on Rails. After looking for an answer and finding a few people asking for the same thing and having their questions misunderstood, it was clear for me that the concept of automating the database creation was not familiar to the Laravel community.

## The Solution

Fortunately, I eventually found a solution simple enough to craft something that felt familiar.

First, create a new Artisan command

```shell
php artisan make:command dbcreate
```

That'll create a file at `app/Console/Commands/dbcreate.php`. Go there and replace the contents with the following:

```php
<?php
namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class dbcreate extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:create {name?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a new MySQL database based on the database config file or the provided name';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $schemaName = $this->argument('name') ?: config("database.connections.mysql.database");
        $charset = config("database.connections.mysql.charset",'utf8mb4');
        $collation = config("database.connections.mysql.collation",'utf8mb4_unicode_ci');

        config(["database.connections.mysql.database" => null]);

        $query = "CREATE DATABASE IF NOT EXISTS $schemaName CHARACTER SET $charset COLLATE $collation;";

        DB::statement($query);

        config(["database.connections.mysql.database" => $schemaName]);

    }
}
```

Now, you'll be able to use an Artisan command to create your database in a very Rail-ish way:

```shell
php artisan db:create
```

This can be improved to give some feedback about the database created, because it won't output a thing when it finishes successfully.

You could also follow the same steps, and change a couple little things to create another command to _drop_ the database, but I'd encourage you to add some safe way to run it (you don't want to accidentaly run it in production, do you?). I'll update this article when I have some time to figure that out.
