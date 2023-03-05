<?php

namespace App\Http\Controllers;

use App\Service\TaskService;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    private TaskService $taskService;

    public function __construct(TaskService $taskService)
    {
        $this->taskService = $taskService;
    }

    public function index(Request $request)
    {
        $user = $request->user;
        $tasks = $this->taskService->getUsersTaskIndex($user);
        return response()->json($tasks, 200);
    }
}
