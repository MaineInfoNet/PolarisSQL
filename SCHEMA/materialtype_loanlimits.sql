SELECT
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE
FROM
    Polaris.INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME IN (
        'ViewMaterialLoanLimits',
        'MaterialLoanLimits',
        'LoanLimits',
        'LoanLimitMatrices'
    )
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;
