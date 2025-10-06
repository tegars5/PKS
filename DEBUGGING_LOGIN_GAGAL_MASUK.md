# Debugging Login Gagal Masuk ke Dashboard

## Masalah:
Setelah memasukkan email dan password dengan benar, aplikasi tidak bisa masuk ke halaman home, baik itu untuk role pemasok maupun kurir.

## Langkah Debugging:

### 1. Restart Aplikasi
```bash
flutter run
```

### 2. Coba Login dan Periksa Log Debug
1. Buka aplikasi
2. Masukkan email dan password yang sudah terdaftar
3. Klik tombol "Masuk"
4. Periksa log debug di terminal

### 3. Analisis Log Debug

#### Log Login Page:
Cari pesan "=== LOGIN PAGE DEBUG START ===" dan "=== LOGIN PAGE DEBUG END ==="
```
=== LOGIN PAGE DEBUG START ===
Email: test@example.com
Password length: 8
=== LOGIN PAGE STATE DEBUG START ===
State type: AuthLoading
State: Not AuthLoading
State: Authenticated
User ID: 12345678-1234-1234-1234-123456789012
User role: supplier
Navigating to home page...
=== LOGIN PAGE STATE DEBUG END ===
```

#### Log Auth Repository:
Cari pesan "=== LOGIN DEBUG START ===" dan "=== LOGIN DEBUG END ==="
```
=== LOGIN DEBUG START ===
Attempting login for email: test@example.com
Login response received
User exists: true
User ID: 12345678-1234-1234-1234-123456789012
User email: test@example.com
User metadata: {full_name: Test User, role: supplier}
User email confirmed: 2023-01-01T00:00:00.000Z
AuthUser created successfully
User role: supplier
=== LOGIN DEBUG END ===
```

#### Log Home Page:
Cari pesan "=== HOME PAGE DEBUG START ===" dan "=== HOME PAGE DEBUG END ==="
```
=== HOME PAGE DEBUG START ===
Home Page State: Authenticated
Home Page: User is authenticated
User ID: 12345678-1234-1234-1234-123456789012
User role: supplier
=== HOME PAGE DEBUG END ===
```

### 4. Masalah Umum dan Solusi

#### Masalah 1: Login Berhasil Tapi Tidak Masuk Home Page
**Gejala:** Log menunjukkan login berhasil, tapi tidak ada navigasi ke home page
**Penyebabab:** Navigasi di login_page.dart tidak berfungsi
**Solusi:** Pastikan baris 97-99 di login_page.dart sudah benar:
```dart
if (state is Authenticated) {
  // Navigate to home page
  context.goNamed('home');
} else if (state is AuthError) {
```

#### Masalah 2: Home Page Muncul Tapi Loading Terus
**Gejala:** Home page muncul tapi hanya menampilkan loading
**Penyebabab:** BlocBuilder di home_page.dart tidak mendapatkan state Authenticated
**Solusi:** Periksa apakah AuthBloc tersedia di context

#### Masalah 3: Role User Tidak Sesuai
**Gejala:** Login berhasil tapi role user tidak sesuai (seharusnya supplier tapi jadi buyer)
**Penyebabab:** User metadata tidak tersimpan dengan benar
**Solusi:** 
1. Periksa tabel profiles di Supabase
2. Pastikan kolom role memiliki nilai yang benar
3. Jalankan kembali script SQL `fix_registration.sql`

#### Masalah 4: Bottom Navigation Tidak Berfungsi
**Gejala:** Home page muncul tapi bottom navigation tidak bisa diklik
**Penyebabab:** Navigation di home_page.dart tidak berfungsi
**Solusi:** Pastikan baris 76-84 di home_page.dart sudah benar:
```dart
onTap: (index) {
  setState(() {
    _currentIndex = index;
  });
},
```

### 5. Verifikasi di Supabase Dashboard
1. Pergi ke menu **Authentication** → **Users**
2. Cari user yang sedang diuji
3. Periksa kolom "raw_user_meta_data" untuk memastikan role tersimpan dengan benar
4. Pergi ke menu **Table Editor** → **profiles**
5. Cari profile user yang sama
6. Periksa kolom "role" untuk memastikan nilainya benar

### 6. Coba dengan User Berbeda
1. Buat user baru dengan role yang berbeda
2. Coba login dengan user baru tersebut
3. Periksa apakah masalah terjadi pada semua role atau hanya pada role tertentu

### 7. Clear Cache dan Restart
```bash
flutter clean
flutter pub get
flutter run
```

## Logging yang Ditambahkan:
Saya sudah menambahkan logging detail di:
- `auth_repository_impl.dart` - Untuk debugging proses login di backend
- `login_page.dart` - Untuk debugging state dan navigasi di UI
- `home_page.dart` - Untuk debugging rendering home page

## Kontak Jika Masih Ada Masalah:
Jika setelah mengikuti langkah-langkah di atas masalah masih terjadi:
1. Screenshot log debug dari terminal
2. Informasikan role user yang sedang diuji
3. Jelaskan langkah mana yang gagal (login, navigasi, render home page)
4. Kirim informasi ke tim pengembang