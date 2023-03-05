<?php

namespace App\Providers;

use App\Service\TaskService;
use App\Service\UserService;
use Illuminate\Support\ServiceProvider;

class UserServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->bind('UserService', UserService::class);
        $this->app->bind('TaskService', TaskService::class);
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
