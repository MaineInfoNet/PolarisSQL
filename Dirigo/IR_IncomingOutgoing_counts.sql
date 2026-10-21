-- Description: Summarizes historical INN-Reach circulation
-- transactions for a selected reporting period, combining
-- checkouts and renewals into circulation counts by
-- organization, patron type, and ILL direction.
-- Uses historical patron codes from transaction details.
-- Used for monthly and annual circulation reporting.

WITH INNReachTransactions AS (
    SELECT
        th.OrganizationID,
        th.TransactionID,

        patronCode.numValue AS PatronCodeID,
        pc.Description AS PatronType,

        CASE
            WHEN checkoutType.numValue = 53
                THEN 'Outgoing Lending'
            WHEN material.numValue IN (25, 26)
                THEN 'Incoming Borrowing'
        END AS ILLDirection

    FROM PolarisTransactions.Polaris.TransactionHeaders th

    LEFT JOIN PolarisTransactions.Polaris.TransactionDetails material
        ON material.TransactionID = th.TransactionID
        AND material.TransactionSubTypeID = 4

    LEFT JOIN PolarisTransactions.Polaris.TransactionDetails checkoutType
        ON checkoutType.TransactionID = th.TransactionID
        AND checkoutType.TransactionSubTypeID = 145

    LEFT JOIN PolarisTransactions.Polaris.TransactionDetails patronCode
        ON patronCode.TransactionID = th.TransactionID
        AND patronCode.TransactionSubTypeID = 7

    LEFT JOIN Polaris.Polaris.PatronCodes pc
        ON pc.PatronCodeID = patronCode.numValue

    WHERE
        th.TransactionTypeID = 6001

        AND th.TransactionDate >= '{{START_DATE}}'
		  AND th.TransactionDate < '{{END_DATE}}'

        AND (
            checkoutType.numValue = 53
            OR material.numValue IN (25, 26)
        )
)

SELECT
    t.OrganizationID AS LibraryID,
    t.PatronCodeID,
    t.PatronType AS [Patron Code],

    SUM(
        CASE
            WHEN t.ILLDirection = 'Incoming Borrowing'
            THEN 1 ELSE 0
        END
    ) AS [Incoming Count],

    SUM(
        CASE
            WHEN t.ILLDirection = 'Outgoing Lending'
            THEN 1 ELSE 0
        END
    ) AS [Outgoing Count]

FROM INNReachTransactions t

GROUP BY
    t.OrganizationID,
    t.PatronCodeID,
    t.PatronType

ORDER BY
    t.OrganizationID,
    t.PatronType;
