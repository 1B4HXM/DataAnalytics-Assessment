WITH txn_data AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100.0 AS total_value
    FROM savings_savingsaccount
    GROUP BY owner_id
),
clv_data AS (
    SELECT
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
        t.total_transactions,
        (t.total_value * 0.001 / t.total_transactions) AS avg_profit_per_txn,
        ROUND(
            (t.total_transactions / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0))
            * 12
            * (t.total_value * 0.001 / t.total_transactions),
            2
        ) AS estimated_clv
    FROM users_customuser u
    JOIN txn_data t ON u.id = t.owner_id
)
SELECT * FROM clv_data
ORDER BY estimated_clv DESC;
