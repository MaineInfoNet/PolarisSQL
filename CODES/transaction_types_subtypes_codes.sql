SELECT
*

FROM PolarisTransactions.Polaris.TransactionRules tr

INNER JOIN PolarisTransactions.Polaris.TransactionTypes tt
    ON tt.TransactionTypeID = tr.TransactionTypeID
    
INNER JOIN PolarisTransactions.Polaris.TransactionSubTypes tst
    ON tst.TransactionSubTypeID = tr.TransactionSubTypeID
    
INNER JOIN PolarisTransactions.Polaris.TransactionSubTypeCodes tsc
    ON tsc.TransactionSubTypeID = tr.TransactionSubTypeID

WHERE
--comment out if you want all or uncomment and enter a specific TransactionTypeID to review
    tr.TransactionTypeID = [insert transactiontype id here]

ORDER BY
    tr.TransactionSubTypeID;
