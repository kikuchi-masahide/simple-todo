<?php

namespace App\Service;

use App\Models\Task;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use function Psy\debug;

class TaskService
{
    private Task $task;

    public function __construct(Task $task)
    {
        $this->task = $task;
    }

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

    /**
     * /updateのリクエストで受け取るタスクの配列が適正か確認
     *
     * @param array $tasks
     * @return bool 正しいタスクの配列になっているか
     */
    public function validateUpdateRequestTasks(array $tasks): bool
    {
        $map = array_reduce($tasks, function ($m, $task) {
            $m[$task["id"]] = $task;
            return $m;
        });
        $top = array_reduce($tasks, function ($m, $task) {
            $m[$task["id"]] = null;
            return $m;
        });
        foreach ($map as $task) {
            $id = $task["id"];
            if ($top[$id] != null) {
                continue;
            }
            $paths = [];
            $cur = $id;
            while (true) {
                if (!array_key_exists('parent_id', $map[$cur])) {
                    $top[$cur] = $cur;
                    foreach ($paths as $path) {
                        $top[$path] = $cur;
                    }
                    break;
                } else {
                    $parent_id = $map[$cur]['parent_id'];
                    if ($parent_id == $cur) {
                        return false;
                    }
                    if ($top[$parent_id] != null) {
                        $top[$cur] = $top[$parent_id];
                        foreach ($paths as $path) {
                            $top[$path] = $top[$cur];
                        }
                        break;
                    } else if ($parent_id == $id) {
                        return false;
                    } else {
                        array_push($paths, $cur);
                        $cur = $parent_id;
                    }
                }
            }
        }
        return true;
    }

    /**
     * Updateリクエストに従いDB更新
     *
     * @param User $user
     * @param array $tasks
     * @return void
     */
    public function updateTasks(User $user, array $tasks): void
    {
        try {
            DB::beginTransaction();
            $user->tasks()->delete();
            $timestamp = Carbon::now();
            $insert = array_map(function ($task) use ($user, $timestamp) {
                return [
                    'id' => $task['id'],
                    'user_id' => $user->id,
                    'title' => $task['title'],
                    'limit' => $task['limit'] ?? null,
                    'parent_id' => $task['parent_id'] ?? null,
                    'created_at' => $timestamp,
                    'updated_at' => $timestamp,
                ];
            }, $tasks);
            $this->task->insert($insert);
            DB::commit();
        } catch (Exception $e) {
            DB::rollback();
            throw new \Exception('データベース保存に失敗しました');
        }
    }
}
