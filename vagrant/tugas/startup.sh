#!/usr/bin/env bash

sudo chown -R www-data:www-data pelatihan-laravel/storage pelatihan-laravel/bootstrap/cache
sudo chmod -R 775 pelatihan-laravel/storage pelatihan-laravel/bootstrap/cache
vagrant up
xdg-open localhost:8080/hello
