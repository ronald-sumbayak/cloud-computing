#!/usr/bin/env bash

git clone git@github.com/fathoniadi/pelatihan-laravel.git
cp pelatihan-laravel/.env.example pelatihan-laravel/.env
vagrant up
xdg-open localhost:8080/hello
