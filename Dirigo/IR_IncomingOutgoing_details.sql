-- Description: Retrieves historical INN-Reach circulation
-- transactions for incoming borrowing and outgoing lending.
-- Identifies initial checkouts and renewals separately.
-- Includes historical patron code and patron type.
-- Used for monthly and annual circulation reporting.

SELECT
    th.OrganizationID,
    th.TransactionID,
    th.TransactionDate,

    CASE
        WHEN checkoutType.numValue = 53
            THEN 'Outgoing Lending'
        WHEN material.numValue IN (25, 26)
            THEN 'Incoming Borrowing'
    END AS ILLDirection,

    CASE
        WHEN EXISTS (
            SELECT 1
            FROM PolarisTransactions.Polaris.TransactionDetails r
            WHERE r.TransactionID = th.TransactionID
                AND r.TransactionSubTypeID = 124
                AND r.numValue = 1
        )
            THEN 'Renewal'
        ELSE 'Checkout'
    END AS CirculationType,

    item.numValue AS ItemRecordID,
    patron.numValue AS PatronID,

    patronCode.numValue AS PatronCodeID,
    pc.Description AS PatronType,

    material.numValue AS MaterialTypeID,
    mt.Description AS MaterialTypeName,

    checkoutType.numValue AS CheckoutTypeID

FROM PolarisTransactions.Polaris.TransactionHeaders th

LEFT JOIN PolarisTransactions.Polaris.TransactionDetails material
    ON material.TransactionID = th.TransactionID
    AND material.TransactionSubTypeID = 4

LEFT JOIN Polaris.Polaris.MaterialTypes mt
    ON mt.MaterialTypeID = material.numValue

LEFT JOIN PolarisTransactions.Polaris.TransactionDetails checkoutType
    ON checkoutType.TransactionID = th.TransactionID
    AND checkoutType.TransactionSubTypeID = 145

LEFT JOIN PolarisTransactions.Polaris.TransactionDetails item
    ON item.TransactionID = th.TransactionID
    AND item.TransactionSubTypeID = 38

LEFT JOIN PolarisTransactions.Polaris.TransactionDetails patron
    ON patron.TransactionID = th.TransactionID
    AND patron.TransactionSubTypeID = 6

LEFT JOIN PolarisTransactions.Polaris.TransactionDetails patronCode
    ON patronCode.TransactionID = th.TransactionID
    AND patronCode.TransactionSubTypeID = 7

LEFT JOIN Polaris.Polaris.PatronCodes pc
    ON pc.PatronCodeID = patronCode.numValue

WHERE
    th.TransactionTypeID = 6001

    AND th.OrganizationID = 3

    AND th.TransactionDate >= '{{START_DATE}}'
    AND th.TransactionDate < '{{END_DATE}}'

    AND (
        checkoutType.numValue = 53
        OR material.numValue IN (25, 26)
    )

ORDER BY
    th.TransactionDate,
    th.TransactionID;
