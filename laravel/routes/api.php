<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/login', [App\Http\Controllers\UserController::class, "UserLogin"]);
Route::post('/register', [App\Http\Controllers\UserController::class, "UserRegister"]);

Route::middleware(App\Http\Middleware\OriginalAuth::class)->group(function () {
    Route::get('/index', [App\Http\Controllers\TaskController::class, 'index']);
    Route::post('/update', [App\Http\Controllers\TaskController::class, 'update']);
    Route::post('/logout', [App\Http\Controllers\UserController::class, 'UserLogout']);
});
