SELECT * FROM drivers;
SELECT COUNT (*) AS n, COUNT (DISTINCT record_id) AS n_unik FROM drivers;
SELECT funnel_stage, COUNT(*) AS n,
		ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM drivers GROUP BY funnel_stage ORDER BY n DESC;	
SELECT COUNT(*) FILTER (WHERE id_collision) AS n_collision FROM drivers;
SELECT COUNT(onboarding_date_clean)           AS n_onb_date,
       MIN(onboarding_date_clean)             AS min_onb,
       MAX(onboarding_date_clean)             AS max_onb,
       ROUND(AVG(earn_clean), 2)              AS avg_earn,
       ROUND(AVG(rating_clean), 2)            AS avg_rating,
       COUNT(*) FILTER (WHERE is_active_clean) AS n_active
FROM drivers;

-- Q1. Hasil seleksi interview
SELECT COALESCE(interview_result, 'Unknown') AS interview_result,
		COUNT(*) AS n,
		ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM drivers
GROUP BY 1
ORDER BY n DESC;

-- Q2. Pass rate seleksi (penyebut: baris yang punya hasil interview)
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE interview_result = 'Selected') / COUNT (interview_result), 1) AS pass_rate_pct,
		COUNT(interview_result) AS n_dengan_hasil
FROM drivers;

-- Q3. Pass rate per kota (ganti city dengan platform or vehicle_type for other segments)
SELECT city,
		COUNT(interview_result) AS n,
		ROUND(100.0 * COUNT(*) FILTER (WHERE interview_result = 'Selected')
				/COUNT(interview_result), 1) AS pass_rate_pct
FROM drivers
GROUP BY city
ORDER BY pass_rate_pct DESC;

-- Q3.(2) Pass rate per platform 
SELECT platform,
		COUNT(interview_result) AS n,
		ROUND(100.0 * COUNT(*) FILTER (WHERE interview_result = 'Selected')
				/COUNT(interview_result), 1) AS pass_rate_pct_1
FROM drivers
GROUP BY platform
ORDER BY pass_rate_pct_1 DESC;

-- Q3.(3) Pass rate per vehicle_type 
SELECT vehicle_type,
		COUNT(interview_result) AS n,
		ROUND(100.0 * COUNT(*) FILTER (WHERE interview_result = 'Selected')
				/COUNT(interview_result), 1) AS pass_rate_pct_2
FROM drivers
GROUP BY vehicle_type
ORDER BY pass_rate_pct_2 DESC;

-- Q4. dari yang selected, berapa persen yang punya tanggal onboarding
SELECT COUNT(*) AS n_selected,
		ROUND(100.0 * COUNT(*) FILTER (WHERE onboarding_date_clean IS NOT NULL) / COUNT(*), 1) AS pct_punya_tanggal_onboarding
FROM drivers
WHERE interview_result = 'Selected';

-- Q5. Produktivitas per platform
SELECT COALESCE(platform, 'Unknown') AS platform,
		COUNT(*) AS n,
		ROUND(AVG(trips_clean), 0) AS avg_trips,
		ROUND(AVG(earn_clean), 0) AS avg_earn
FROM drivers
GROUP BY 1
ORDER BY n DESC;

-- Q6. Kualitas per platform
SELECT COALESCE(platform, 'Unknown') AS platform,
		ROUND(AVG(rating_clean), 2) AS avg_rating,
		ROUND(AVG(cancellation_rate_clean), 1) AS avg_cancel_pct,
		ROUND(AVG(total_complaints_clean), 1) AS avg_complaints
FROM drivers
GROUP BY 1
ORDER BY avg_rating DESC;

-- Q7. Waktu dari interview sampai onboarding
SELECT COUNT(days_to_onboard) AS n,
		ROUND(AVG(days_to_onboard), 1) AS avg_days,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_onboard) AS median_days,
		MIN(days_to_onboard) AS min_days,
		MAX(days_to_onboard) AS max_days
FROM drivers;

--Q8. active rate per kota (status aktif dilaporkan terpisah dari funnel)
SELECT city,
		COUNT(*) AS n,
		ROUND(100.0 * AVG(CASE WHEN is_active_clean THEN 1 ELSE 0 END), 1) AS active_pct
FROM drivers
GROUP BY city
ORDER BY active_pct DESC;