# geo_catatan_app

## Menambahkan pada Pubspec.yaml
<img width="650" height="198" alt="image" src="https://github.com/user-attachments/assets/defaee51-1eb7-4141-8156-6887fa7fdf84" />

## Membuat File catatan_model.dart
<img width="552" height="377" alt="image" src="https://github.com/user-attachments/assets/b2f0c811-d441-4745-9dcf-68f2643c54b9" />

# TugasMandiri
## 1. Kustomisasi Marker : Ubah ikon marker agar berbeda-beda tergantung jenis catatan(misal:Toko,Rumah,Kantor).
### Langkah langkah
- Menambahkan Atribut baru didalam file catatan_model.dart
<img width="642" height="394" alt="image" src="https://github.com/user-attachments/assets/7f5fbc2b-26f6-46c6-8d99-b8079cf947c2" />

- Menambahkan Marker icon
<img width="712" height="257" alt="image" src="https://github.com/user-attachments/assets/0fc18faf-751d-4cae-866f-258385cd6e8b" />

- Tambahkan pilihan kategori
<img width="744" height="690" alt="image" src="https://github.com/user-attachments/assets/01c54b41-c15d-4d1e-8591-60d83b7949c9" />

- Pada setState menambahkan field baru yaitu type
<img width="431" height="269" alt="image" src="https://github.com/user-attachments/assets/9be45f0b-b400-4c7e-ae34-04309857436f" />


## 2. HapusData : Tambahkan fitur untuk menghapus marker yang sudah dibuat.
- Membuat Fungsi baru didalam _MapScreenState
<img width="559" height="622" alt="image" src="https://github.com/user-attachments/assets/d72133f5-74e4-487d-aa9a-f92fb38ef6c2" />

## 3. SimpanData : (Opsional) Gunakan SharedPreferences atau Hive agar data tidak hilang saat aplikasi ditutup
- Tambahkan package di pubspec.yaml dan lakukan flutter pub get
<img width="376" height="209" alt="image" src="https://github.com/user-attachments/assets/42530e61-7fcf-40e0-8218-c459de307e1d" />

- Membuat fungsi untuk menyimpan catatan di dalam sharedpreferences
<img width="636" height="351" alt="image" src="https://github.com/user-attachments/assets/24f229fc-a33f-46a3-b4d0-cbbfdf645d18" />

- Pada setstate ditambahkan savenotes
<img width="592" height="290" alt="image" src="https://github.com/user-attachments/assets/1241ced1-d788-455f-b89b-fe5689361ccd" />

# DOKUMENTASI PRAKTIKUM


