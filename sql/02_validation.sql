-- 02_validation.sql
-- Validasi: data di PostgreSQL harus sama dengan hasil di Python

-- 1. jumlah baris dan keunikan record_id (48568 dan 48568)
SELECT COUNT(*) AS n, COUNT(DISTINCT record_id) AS n_unik FROM drivers;

-- 2. sebaran funnel_stage (13650, 12882, 12696, 6379, 2961)
SELECT funnel_stage, COUNT(*) AS n,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM drivers
GROUP BY funnel_stage
ORDER BY n DESC;

-- 3. ID bertabrakan (2651)
SELECT COUNT(*) FILTER (WHERE id_collision) AS n_collision FROM drivers;

-- 4. kolom tanggal, desimal, dan boolean (18425, 2021-01-01, 2024-06-14, 1445.07, 3.75, 24332)
SELECT COUNT(onboarding_date_clean)            AS n_onb_date,
       MIN(onboarding_date_clean)              AS min_onb,
       MAX(onboarding_date_clean)              AS max_onb,
       ROUND(AVG(earn_clean), 2)               AS avg_earn,
       ROUND(AVG(rating_clean), 2)             AS avg_rating,
       COUNT(*) FILTER (WHERE is_active_clean) AS n_active
FROM drivers;
