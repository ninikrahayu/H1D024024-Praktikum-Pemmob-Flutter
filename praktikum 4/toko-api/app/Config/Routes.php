<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */

$routes->get('/', 'Home::index');

// Registrasi dan Login
$routes->post('registrasi', 'RegistrasiController::registrasi');
$routes->post('login', 'LoginController::login');

// CRUD Produk
$routes->group('produk', function ($routes) {
    $routes->post('/', 'ProdukController::create');
    $routes->get('/', 'ProdukController::index');
    $routes->get('(:num)', 'ProdukController::show/$1');
    $routes->put('(:num)', 'ProdukController::update/$1');
    $routes->delete('(:num)', 'ProdukController::delete/$1');
});
