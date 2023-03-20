<?php

namespace App\Service;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserService
{
    private User $user;

    public function __construct(User $user)
    {
        $this->user = $user;
    }

    /**
     * 与えられたメールアドレスとパスワードからログイン処理(パスワードチェックとトークン作成)
     *
     * @param string $email
     * @param string $password
     * @return string
     */
    public function login(string $email, string $password): string
    {
        $user = $this->user->where('email', $email)->first();
        if (!$user || !Hash::check($password, $user->password)) {
            throw \Exception('パスワードが一致しません');
        }
        return $user->createToken('device')->plainTextToken;
    }

    /**
     * 与えられたメールアドレスとパスワードから新規登録処理を行い、トークンを返す
     *
     * @param string $email
     * @param string $password
     * @return string
     */
    public function register(string $email, string $password): string
    {
        $user = new User();
        $user->email = $email;
        $user->password = bcrypt($password);
        $user->save();
        return $user->createToken('device')->plainTextToken;
    }

    public function logout(): void
    {
        Auth::guard('sanctum')->user()->tokens()->delete();
    }
}
