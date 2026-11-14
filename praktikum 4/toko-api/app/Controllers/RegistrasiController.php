<?php

namespace App\Controllers;

use App\Models\MRegistrasi;

class RegistrasiController extends RestfulController
{
    public function registrasi()
    {
        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->responseHasil(
                400,
                false,
                'Body JSON tidak valid'
            );
        }

        $validation = service('validation');

        $validation->setRules([
            'nama' => 'required|min_length[3]',
            'email' => 'required|valid_email|is_unique[member.email]',
            'password' => 'required|min_length[6]',
        ]);

        if (!$validation->run($data)) {
            return $this->responseHasil(
                422,
                false,
                $validation->getErrors()
            );
        }

        $model = new MRegistrasi();

        $model->insert([
            'nama' => $data['nama'],
            'email' => $data['email'],
            'password' => password_hash(
                $data['password'],
                PASSWORD_DEFAULT
            ),
        ]);

        return $this->responseHasil(
            200,
            true,
            'Registrasi Berhasil'
        );
    }
}
