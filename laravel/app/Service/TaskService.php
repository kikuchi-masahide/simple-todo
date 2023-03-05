<?php

namespace App\Service;

use App\Models\User;

class TaskService
{
    public function getUsersTaskIndex(User $user)
    {
        return $user->tasks->map(function ($task) {
            $data = [
                "id" => $task->id,
                "title" => $task->title,
            ];
            if ($task->limit != null) {
                $data["limit"] = $task->limit;
            }
            if ($task->parent_id != null) {
                $data["parent_id"] = $task->parent_id;
            }
            return $data;
        });
    }
}
