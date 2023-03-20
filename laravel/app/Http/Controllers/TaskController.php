<?php

namespace App\Http\Controllers;

use App\Http\Requests\TaskUpdateRequest;
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

    public function update(TaskUpdateRequest $request)
    {
        $user = $request->user;
        $tasks = $request->tasks;
        try {
            if (!$this->taskService->validateUpdateRequestTasks($tasks)) {
                throw new \Exception('入力が不正です');
            }
            $this->taskService->updateTasks($user, $tasks);
            return response()->json([], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 400);
        }
    }
}
