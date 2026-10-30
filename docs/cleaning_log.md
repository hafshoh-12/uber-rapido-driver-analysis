# Cleaning Log

Ringkasan semua keputusan pembersihan data. Kode lengkapnya ada di [`02_drivers_cleaning.ipynb`](../02_drivers_cleaning.ipynb), dan temuan masalahnya di [`01_drivers_data_understanding.ipynb`](../01_drivers_data_understanding.ipynb).

**Hasil:** 50.000 baris dan 33 kolom menjadi 48.568 baris dan 46 kolom (`drivers_clean.csv`).

## Aturan umum

- Nilai asli tidak ditimpa: setiap kolom yang diubah menghasilkan kolom baru berakhiran `_clean`.
- Nilai yang mustahil dikosongkan, bukan ditebak.
- Tanda minus yang jelas salah ketik dibalik, dan barisnya ditandai di kolom `*_sign_fixed`.

## Langkah per tahap

| # | Tahap | Keputusan | Dampak |
|---|---|---|---|
| 1 | Duplikat identik | Baris yang sama persis di semua kolom dibuang | 951 baris |
| 2 | Placeholder | `NULL`, `N/A`, `-`, `none`, `unknown` diganti kosong; spasi di awal dan akhir dibuang; sel yang hanya berisi spasi menjadi kosong | semua kolom teks |
| 3 | Placeholder kategori | `na` dan `unknown` (huruf apa pun) diganti kosong pada 11 kolom kategori | 11 kolom |
| 4 | Duplikat setelah standardisasi | Baris dengan delapan kolom kunci sama dianggap kembar; dipertahankan baris dengan nilai kosong paling sedikit | 481 baris |

Kolom kunci duplikat: `driver_id`, `driver_name_clean`, `city`, `platform`, `age_clean`, `vehicle_type`, `trips_clean`, `earn_clean`.

## Keputusan per kolom

| Kolom asli | Kolom hasil | Masalah | Penanganan |
|---|---|---|---|
| `driver_id` | `driver_id`, `id_collision` | ID tidak unik: 2.651 baris berbagi 1.302 ID, hampir semuanya orang berbeda | ID tidak diubah; penanda `id_collision` ditambahkan |
| (baru) | `record_id` | Tidak ada kunci unik | Nomor urut 1 sampai 48.568 |
| `driver_name` | `driver_name_clean` | Spasi ganda dan huruf besar-kecil acak | Spasi dirapikan, huruf judul (`Title Case`) |
| `age` | `age_clean`, `age_sign_fixed` | Teks; akhiran "yrs"; minus; nilai 999 | Angka diambil; minus dibalik dan ditandai; 999 dikosongkan |
| `city` | `city` | 40 penulisan untuk 10 kota; salah ketik (Mumabi, Hydrabad, Bangalroe, Dlhi, Chenna) | Disamakan menjadi 10 kota |
| `platform` | `platform` | Huruf besar-kecil tidak seragam; placeholder | Menjadi Uber, Rapido, Uber & Rapido, Ola |
| `vehicle_type` | `vehicle_type` | Huruf besar-kecil; placeholder | Mini, Sedan, Bike, SUV, Auto |
| `vehicle_condition` | `vehicle_condition` | `avg` dan `average` bercampur | Poor, Average, Good, Excellent |
| `experience_level` | `experience_level` | Placeholder | Fresher, 0-1 yr, 1-3 yrs, 3-5 yrs, 5+ yrs |
| `preferred_shift` | `preferred_shift` | Huruf besar-kecil; placeholder | Day, Night, Both |
| `reason_for_joining` | `reason_for_joining` | Placeholder | Dikosongkan; isi lain tidak diubah |
| `languages_known` | `languages_known` | Beberapa bahasa dalam satu sel; placeholder | Placeholder dikosongkan; isi tidak diubah |
| `document_verification` | `document_verification` | Huruf besar-kecil; placeholder | Pass, Fail, Pending |
| `background_check_status` | `background_check_status` | Huruf besar-kecil; placeholder | Clear, Pending, Flagged |
| `interview_result` | `interview_result` | Huruf besar-kecil; placeholder | Selected, Rejected, On Hold, Waitlist |
| `rejection_reason` | `rejection_reason` | Huruf kecil; placeholder; terisi juga untuk yang tidak ditolak | Huruf kapital di awal; hubungan dengan hasil interview dicatat, tidak diubah |
| `overall_driver_rating` | `rating_clean` | Teks; `unrated`; minus; di atas 5 | Di luar 0 sampai 5 dikosongkan |
| 5 kolom `*_score_10` | `*_score_10_clean` | Minus; di atas 10 | Di luar 0 sampai 10 dikosongkan |
| `total_trips_completed` | `trips_clean`, `trips_sign_fixed` | Minus; penanda 99999 | Minus dibalik dan ditandai; 99999 dikosongkan |
| `trip_completion_rate_%` | `trip_completion_rate_clean` | Minus; di atas 100 | Di luar 0 sampai 100 dikosongkan |
| `cancellation_rate_%` | `cancellation_rate_clean` | Minus; di atas 100 | Di luar 0 sampai 100 dikosongkan |
| `total_complaints` | `total_complaints_clean` | Penanda 99999 | Dikosongkan |
| `total_compliments` | `total_compliments_clean` | Penanda 99999 | Dikosongkan |
| `avg_daily_earnings_INR` | `earn_clean`, `earn_sign_fixed` | Format campuran (`Rs.`, `₹`, `/-`); minus; penanda 9999999 | Angka diambil; minus dibalik dan ditandai; 9999999 dikosongkan |
| `is_currently_active` | `is_active_clean` | Ya/tidak ditulis dengan banyak cara | Boolean |
| `peak_hour_availability` | `is_peak_available` | Ya/tidak ditulis dengan banyak cara | Boolean |
| `interview_date` | `interview_date_clean`, `int_month_only` | Tujuh format tanggal; ada yang hanya bulan dan tahun | Diseragamkan; tanggal bulan-saja ditandai |
| `onboarding_date` | `onboarding_date_clean`, `onb_month_only` | Sama seperti di atas | Sama seperti di atas |
| `phone`, `email` | tidak dibawa | Data pribadi, tidak dibutuhkan analisis | Dibuang dari data bersih |

## Kolom turunan (15)

| Kolom | Isi |
|---|---|
| `record_id` | Nomor urut unik per baris |
| `id_collision` | `True` bila `driver_id` dipakai lebih dari satu baris |
| `age_sign_fixed`, `trips_sign_fixed`, `earn_sign_fixed` | `True` bila nilai aslinya bertanda minus dan sudah dibalik |
| `int_month_only`, `onb_month_only` | `True` bila tanggal aslinya hanya berisi bulan dan tahun |
| `days_to_onboard` | Selisih hari dari interview ke onboarding; hanya untuk baris dengan kedua tanggal lengkap (12.163 baris, rentang 1 sampai 60 hari) |
| `age_group` | 20-29, 30-39, 40-49, 50-55 |
| `earnings_category` | Low (di bawah 1.000), Medium (1.000 sampai di bawah 2.000), High (2.000 ke atas) |
| `trip_volume_category` | Low (di bawah 2.000), Medium (2.000 sampai di bawah 5.000), High (5.000 ke atas) |
| `rating_tier` | Low (di bawah 3,5), Medium (3,5 sampai di bawah 4,5), High (4,5 ke atas) |
| `onboarding_speed` | Fast (1-15 hari), Normal (16-45), Slow (46-60) |
| `is_multi_platform` | `True` bila platform Uber & Rapido |
| `funnel_stage` | Rejected, Selected - Onboarded, Selected - No onboarding date, Pending (On Hold/Waitlist), Unknown |

## Tipe data

Kolom bilangan bulat (`age_clean`, `trips_clean`, `total_complaints_clean`, `total_compliments_clean`, `days_to_onboard`) memakai `Int64` supaya nilai kosong didukung dan CSV tidak menulis `.0`. Sebelas kolom kategori memakai `category`. Daftar lengkap perubahan tipe ada di [`tipe_data_berubah.csv`](tipe_data_berubah.csv).

## Yang sengaja tidak dilakukan

- Outlier (metode IQR) hanya dilaporkan di [`outlier_check.csv`](outlier_check.csv), tidak dibuang, karena data ini sintetis dan sebarannya hampir seragam.
- Duplikat dengan salah ketik pada nama tidak ditelusuri.
- Tanggal bulan-saja tidak ditebak harinya; tidak dipakai untuk menghitung lama onboarding.
- Platform Ola dipertahankan sebagai kategori tersendiri walau di luar cakupan Uber dan Rapido.

## Validasi

Hasil pengecekan aturan validitas pada data mentah ada di [`validity_check.csv`](validity_check.csv). Pada data bersih, semua nilai berada di dalam rentang yang masuk akal karena nilai di luar rentang sudah dikosongkan.
