# Soal
1. Buat 3 VM, 2 Ubuntu 16.04 sebagai worker, 1 Debian 9 sebagai DB server
2. Pada vm Debian install Mysql dan setup agar koneksi DB bisa diremote dan memiliki user: username: regal password: bolaubi
3. Pada worker: 2.1. Install Nginx 2.2. Install PHP 7.2 2.3. Install composer 2.4. Install Git dan pastikan worker dapat menjalankan Laravel 5.6
4. Clone https://github.com/udinIMM/Hackathon pada setiap worker dan setup database pada .env mengarah ke DB server.
5. Setup root directory nginx ke folder Laravel hasil clone repo diatas

## Penyelesaian
### 1
Buat VM [worker1](../ansible/tugas/vms/workers/worker1/Vagrantfile), [worker2](../ansible/tugas/vms/workers/worker2/Vagrantfile), dan [db](../ansible/tugas/vms/db/Vagrantfile).

Buat file ```host```, lalu ketikkan perintah berikut (untuk grouping host)
```
[db]
10.11.1.2 ansible_user=vagrant

[workers]
10.11.1.3 ansible_user=vagrant
10.11.1.4 ansible_user=vagrant
```

Jalankan perintah
```
ansible -i ./hosts -m ping all -k
```

Jika status yang dihasilkan "SUCCESS" pada semua VM, maka berhasil.

---
### 2


---
### 3
Lihat pada worker1 10.11.1.3
![result3](tugas/assets/result3.png)

Lihat pada worker2 10.11.1.4
![result4](tugas/assets/result4.png)
