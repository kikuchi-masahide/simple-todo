<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserLoginRequest;
use App\Http\Requests\UserRegisterRequest;
use App\Service\UserService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    private UserService $userService;

    public function __construct(UserService $userService)
    {
        $this->userService = $userService;
    }

    public function UserRegister(UserRegisterRequest $request): JsonResponse
    {
        $token = $this->userService->register($request->email, $request->password);
        return response()->json(["token" => $token], 200);
    }

    public function UserLogin(UserLoginRequest $request): JsonResponse
    {
        try {
            $token = $this->userService->login($request->email, $request->password);
            return response()->json(["token" => $token], 200);
        } catch (\Exception $e) {
            return response()->json(["message" => $e->getMessage()], 400);
        }
    }

    public function UserLogout(): JsonResponse
    {
        $this->userService->logout();
        return response()->json();
    }

}
