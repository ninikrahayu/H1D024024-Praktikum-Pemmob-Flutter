<?php

namespace App\Controllers;

use App\Models\MLogin;
use App\Models\MMember;

class LoginController extends RestfulController
{
    public function login()
    {
        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->responseHasil(
                400,
                false,
                'Body JSON tidak valid'
            );
        }

        $email = $data['email'] ?? '';
        $password = $data['password'] ?? '';

        if (empty($email) || empty($password)) {
            return $this->responseHasil(
                400,
                false,
                'Email dan password wajib diisi'
            );
        }

        $model = new MMember();

        $member = $model
            ->where('email', $email)
            ->first();

        if (!$member ||
            !password_verify($password, $member['password'])) {
            return $this->responseHasil(
                401,
                false,
                'Email atau password salah'
            );
        }

        $authKey = bin2hex(random_bytes(32));

        $login = new MLogin();

        $login->insert([
            'member_id' => $member['id'],
            'auth_key' => $authKey,
        ]);

        return $this->responseHasil(
            200,
            true,
            [
                'token' => $authKey,
                'user' => [
                    'id' => (int) $member['id'],
                    'email' => $member['email'],
                ],
            ]
        );
    }
}
