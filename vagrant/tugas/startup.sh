#!/usr/bin/env bash

git clone git@github.com/fathoniadi/pelatihan-laravel.git
sudo chown -R www-data:www-data pelatihan-laravel/storage pelatihan-laravel/bootstrap/cache
sudo chmod -R 775 pelatihan-laravel/storage pelatihan-laravel/bootstrap/cache
vagrant up
xdg-open localhost:8080/hello
