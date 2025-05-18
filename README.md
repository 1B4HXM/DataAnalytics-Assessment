
# DataAnalytics-Assessment

## Question 1: Identifying High-Value Customers with Multiple Products

### Objective

To identify customers who hold both a funded savings account (`amount > 0`) and a funded investment plan (`is_a_fund = 1` and `amount > 0`). This analysis supports cross-selling initiatives by targeting customers engaged with multiple product lines.

### Methodology

* **Data Sources:**

  * `users_customuser`: Customer information.
  * `savings_savingsaccount`: Records of savings account transactions.
  * `plans_plan`: Investment plan details.

* **Approach:**

  * Join customer data to savings accounts and investment plans via `owner_id`.
  * Filter for savings accounts with confirmed positive amounts and investment plans flagged as funds with positive amounts.
  * Aggregate data by customer, counting distinct savings and investment products.
  * Calculate total deposits from savings accounts (converted to the base currency by dividing by 100).
  * Sort customers by total deposits to prioritize top clients.
  * Limit the results to the top 1000 customers.

### Output Fields

| Field              | Description                                         |
| ------------------ | --------------------------------------------------- |
| `owner_id`         | Unique identifier for the customer                  |
| `name`             | Full name of the customer                           |
| `savings_count`    | Number of funded savings accounts                   |
| `investment_count` | Number of funded investment plans                   |
| `total_deposits`   | Total confirmed savings deposits (in base currency) |

### Challenges & Solutions

* Filters were repositioned to the WHERE clause for clearer logic and MySQL compatibility.

### Summary

The query effectively isolates customers with both active savings and investment products, enabling targeted marketing and cross-selling strategies.



## Question 2: Transaction Frequency Analysis

### Objective

Segment customers based on their transaction frequency within savings accounts to enable tailored marketing and engagement strategies. The segments include:

* **High Frequency:** 10 or more transactions per month
* **Medium Frequency:** Between 3 and 9 transactions per month
* **Low Frequency:** 2 or fewer transactions per month

### Methodology

* **Data Source:**

  * `savings_savingsaccount`: Savings transaction records.

* **Approach:**

  * Estimate the active duration of accounts per customer using the difference between earliest `maturity_start_date` and latest `maturity_end_date`.
  * Count total transactions per customer.
  * Calculate average monthly transactions by dividing total transactions by the active duration in months.
  * Categorize customers based on predefined transaction frequency thresholds.
  * Aggregate results by category to report customer counts and average transaction rates.

### Output Fields

| Field                        | Description                                      |
| ---------------------------- | ------------------------------------------------ |
| `frequency_category`         | Customer segment based on transaction frequency  |
| `customer_count`             | Number of customers in each segment              |
| `avg_transactions_per_month` | Average transactions per customer in the segment |

### Challenges & Solutions

* PostgreSQL-specific date functions (`DATE_PART`) were replaced with `TIMESTAMPDIFF` for MySQL compatibility.
* Absence of explicit transaction timestamps was addressed by using account maturity dates as proxies.

### Summary

This segmentation provides actionable insights into customer activity levels, supporting targeted retention and engagement initiatives.



## Question 3: Account Inactivity Alert

### Objective

Identify all active savings and investment accounts that have not recorded any transactions for more than 365 days. This helps the operations team flag accounts that may require follow-up or reactivation efforts.

---

###  Approach

1. **Tables Involved**:

   * `savings_savingsaccount`: Contains savings account transactions including `transaction_date`.
   * `plans_plan`: Contains investment plans with `withdrawal_date` for transactions.

2. **Key Logic**:

   * For savings accounts, the latest `transaction_date` is considered as the last activity date.
   * For investment accounts marked as funds (`is_a_fund = 1`), the latest `withdrawal_date` is considered.
   * Calculate inactivity by comparing the last transaction date to the current date.
   * Filter accounts where inactivity exceeds 365 days.
   * Combine results from both savings and investment accounts using a `UNION` query.

3. **Grouping and Filtering**:

   * Group by account `id` and `owner_id` to get the latest transaction date per account.
   * Use `HAVING` clause to only select accounts with inactivity longer than 365 days.

---

###  Output Fields

| Field                   | Description                                          |
| ----------------------- | ---------------------------------------------------- |
| `plan_id`               | Unique identifier for the savings or investment plan |
| `owner_id`              | Customer or account owner ID                         |
| `type`                  | Account type: either "Savings" or "Investment"       |
| `last_transaction_date` | Date of the most recent transaction                  |
| `inactivity_days`       | Number of days since the last transaction            |

---

### Challenges

* Column names for transaction dates differed between savings (`transaction_date`) and investment (`withdrawal_date`) tables.
* Ensuring compatibility and correct date handling across both tables was crucial.
* Initial attempts to filter on non-existent columns were corrected by verifying table schemas.

###  Summary

This query effectively identifies inactive savings and investment accounts by leveraging the latest transaction dates. It equips the operations team with actionable insights to engage dormant accounts, improving retention and reducing churn.

Absolutely! Here’s the professional README section for **Question 4** following the same pattern and tone:

---

## Question 4: Customer Lifetime Value (CLV) Estimation

### Objective

Estimate the Customer Lifetime Value (CLV) based on customers’ transaction activity in their savings accounts. The analysis helps quantify the long-term value of each customer to inform marketing and retention strategies.

---

###  Approach

1. **Tables Involved**:

   * `users_customuser`: Contains customer demographic and registration details.
   * `savings_savingsaccount`: Contains transaction records with confirmed amounts.

2. **Key Logic**:

   * Aggregate total number of transactions and total confirmed transaction value per customer.
   * Calculate customer tenure in months using the difference between the current date and the customer’s registration date (`date_joined`).
   * Compute average profit per transaction by scaling the total transaction value.
   * Estimate annual CLV by multiplying the average monthly transaction frequency and average profit per transaction, then annualizing it.

3. **Calculation Details**:

   * Tenure is measured in months using date difference functions compatible with MySQL.
   * Average profit per transaction is calculated as `(total_value * 0.001) / total_transactions` assuming scaling factors.
   * Annual CLV is projected by multiplying monthly transaction rates by profit and scaling by 12 months.


###  Output Fields

| Field                | Description                                |
| -------------------- | ------------------------------------------ |
| `customer_id`        | Unique identifier for the customer         |
| `name`               | Customer's full name                       |
| `tenure_months`      | Number of months since the customer joined |
| `total_transactions` | Total number of transactions performed     |
| `avg_profit_per_txn` | Average profit earned per transaction      |
| `estimated_clv`      | Projected annual Customer Lifetime Value   |

###  Challenges

* Initial use of PostgreSQL-specific date functions (`DATE_PART`) led to errors in MySQL.
* Adapted calculations to use `TIMESTAMPDIFF()` for better cross-database compatibility.
* Assumed scaling factor of 0.001 in profit calculations to align with business context.

### Final Query Summary

The final solution accurately estimates the Customer Lifetime Value using transactional data and customer tenure. This empowers the business to prioritize high-value customers and tailor marketing efforts for maximum ROI.


### Presented by Ibrahim Ayuba
