WITH txn_counts AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(maturity_start_date), MAX(maturity_end_date)) + 1 AS months_active
    FROM savings_savingsaccount
    GROUP BY owner_id
),
txn_rates AS (
    SELECT 
        owner_id,
        total_transactions,
        months_active,
        total_transactions * 1.0 / months_active AS avg_txn_per_month
    FROM txn_counts
),
categorized AS (
    SELECT 
        owner_id,
        avg_txn_per_month,
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM txn_rates
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;
