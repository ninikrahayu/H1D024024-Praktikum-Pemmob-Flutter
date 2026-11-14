<?php

namespace App\Controllers;

use App\Models\MProduk;

class ProdukController extends RestfulController
{
    // Menambahkan produk
    public function create()
    {
        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->responseHasil(
                400, false, 'Body JSON tidak valid'
            );
        }

        $validation = service('validation');
        $validation->setRules([
            'kode_produk' => 'required',
            'nama_produk' => 'required',
            'harga' => 'required|integer|greater_than_equal_to[0]',
        ]);

        if (!$validation->run($data)) {
            return $this->responseHasil(
                422, false, $validation->getErrors()
            );
        }

        $model = new MProduk();

        $id = $model->insert([
            'kode_produk' => $data['kode_produk'],
            'nama_produk' => $data['nama_produk'],
            'harga' => $data['harga'],
        ]);

        return $this->responseHasil(
            201, true, $model->find($id)
        );
    }

    // Menampilkan semua produk
    public function index()
    {
        $model = new MProduk();

        return $this->responseHasil(
            200, true, $model->findAll()
        );
    }

    // Menampilkan detail produk
    public function show($id = null)
    {
        $model = new MProduk();
        $produk = $model->find($id);

        if (!$produk) {
            return $this->responseHasil(
                404, false, 'Produk tidak ditemukan'
            );
        }

        return $this->responseHasil(
            200, true, $produk
        );
    }

    // Mengubah produk
    public function update($id = null)
    {
        $model = new MProduk();
        $produk = $model->find($id);

        if (!$produk) {
            return $this->responseHasil(
                404, false, 'Produk tidak ditemukan'
            );
        }

        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->responseHasil(
                400, false, 'Body JSON tidak valid'
            );
        }

        $validation = service('validation');
        $validation->setRules([
            'kode_produk' => 'required',
            'nama_produk' => 'required',
            'harga' => 'required|integer|greater_than_equal_to[0]',
        ]);

        if (!$validation->run($data)) {
            return $this->responseHasil(
                422, false, $validation->getErrors()
            );
        }

        $model->update($id, [
            'kode_produk' => $data['kode_produk'],
            'nama_produk' => $data['nama_produk'],
            'harga' => $data['harga'],
        ]);

        return $this->responseHasil(
            200, true, $model->find($id)
        );
    }

    // Menghapus produk
    public function delete($id = null)
    {
        $model = new MProduk();
        $produk = $model->find($id);

        if (!$produk) {
            return $this->responseHasil(
                404, false, 'Produk tidak ditemukan'
            );
        }

        $model->delete($id);

        return $this->responseHasil(
            200, true, true
        );
    }
}
