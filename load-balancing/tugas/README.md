#### 1. Kasus

### How to Use
#### Startup
```sh
./load_balancing start [balancing_method]
```
> Balancing method can be between **round_robin**, **ip_hash**, or **least_conn**.

Example:
```sh
./load_balancing start round_robin
./load_balancing start ip_hash
./load_balancing start least_conn
```

#### Change Balancing Method
To change current balancing method, run:
```sh
./load_balancing method [balancing_method]
```
> Balancing method can be between **round_robin**, **ip_hash**, or **least_conn**.
Then reload the balancer server.

Example
```sh
./load_balancing method round_robin
./load_balancing method ip_hash
./load_balancing method least_conn
```

#### Destroy
To destroy currently active balancer and workers:
```sh
./load_balancing destroy
```

---

#### 2. Analisa apa perbedaan antara ketiga algoritma tersebut.

- Round Robin :
Membagi beban kerja secara berurutan dari satu server ke server lainnya. Konsep dasar dari algoritma ini adalah time sharing, yaitu membagikan beban kerja sesuai dengan antrian.
Misal ada 3 server yaitu A, B, C. Maka beban kerja akan dibagikan pada server A, lalu server B, selanjutnya server C, kembali lagi ke server A, dan begitu seterusnya sampai beban kerja habis dibagikan.

- Least Connection :
Membagi beban kerja berdasarkan banyaknya koneksi yang sedang dilayani oleh sebuah server yang aktif. Algoritma penjadwalan ini termasuk dalam penjadwalan dinamik, dimana memerlukan perhitungan koneksi yang aktif untuk masing-masing real server. Algoritma ini baik digunakan untuk jaringan internet yang memerlukan throughput maksimal. Metode penjadwalan ini juga baik digunakan untuk melancarkan pendistribusian ketika request yang datang banyak.
Misal, ada 2 server yaitu A dan B. Koneksi aktif pada server A berjumlah 2 koneksi, sedangkan koneksi aktif pada server B berjumlah 1 koneksi, maka beban kerja akan diberikan kepada server B karena koneksi aktif server B lebih sedikit dibanding dengan server A.

- IP Hash :
Menggunakan IP source dan destination dari klien dan server untuk men-generate hash key menjadi kode unik. Kode ini digunakan untuk mengalokasikan klien ke server tertentu. Metode ini dapat memastikan bahwa klien akan terhubung dengan server yang sama yang sebelumnya sudah terhubung. Metode ini sangat berguna untuk klien yang harus terhubung ke session yang masih aktif setelah terjadi diskoneksi atau rekoneksi.
