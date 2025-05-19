SELECT
    id AS plan_id,
    owner_id,
    'Savings' AS type,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(transaction_date)) AS inactivity_days
FROM
    savings_savingsaccount
GROUP BY
    id, owner_id
HAVING
    MAX(transaction_date) < CURRENT_DATE - INTERVAL 365 DAY

UNION

SELECT
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    MAX(withdrawal_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(withdrawal_date)) AS inactivity_days
FROM
    plans_plan
WHERE
    is_a_fund = 1
GROUP BY
    id, owner_id
HAVING
    MAX(withdrawal_date) < CURRENT_DATE - INTERVAL 365 DAY;
