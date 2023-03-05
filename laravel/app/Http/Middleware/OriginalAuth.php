<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class OriginalAuth
{
    /**
     * Handle an incoming request.
     *
     * @param \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response) $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (!auth('sanctum')->check()) {
            return response()->json(['message' => '不正なトークンです'], 400);
        }
        $request->merge(['user' => auth('sanctum')->user()]);
        return $next($request);
    }
}
