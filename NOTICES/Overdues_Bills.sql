DECLARE @StartDate DATETIME = '2026-08-01 00:00:00';
DECLARE @EndDate   DATETIME = '2026-08-09 23:59:59';

SELECT
    nl.NotificationDateTime,
    nl.ReportingOrgID,
	o.Name AS [Reporting Library],

    CASE
        WHEN nl.NotificationTypeID = 1 THEN 'First Overdue'
        WHEN nl.NotificationTypeID = 12 THEN 'Second Overdue'
        WHEN nl.NotificationTypeID = 13 THEN 'Third Overdue'
        WHEN nl.NotificationTypeID IN (11,20) THEN 'Bill'

        WHEN nl.NotificationTypeID = 0
             AND nl.OverduesCount > 0 THEN 'First Overdue'

        WHEN nl.NotificationTypeID = 0
             AND nl.Overdues2ndCount > 0 THEN 'Second Overdue'

        WHEN nl.NotificationTypeID = 0
             AND nl.Overdues3rdCount > 0 THEN 'Third Overdue'

        WHEN nl.NotificationTypeID = 0
             AND nl.BillsCount > 0 THEN 'Bill'
    END AS [Notice Type],

    nl.DeliveryOptionID,
    nl.NotificationStatusID,
	nl.DeliveryString,
	nl.PatronBarcode

FROM PolarisTransactions.Polaris.NotificationLog nl WITH (NOLOCK)

INNER JOIN Polaris.Polaris.Organizations o
    ON o.OrganizationID = nl.ReportingOrgID

WHERE
    nl.NotificationDateTime >= @StartDate
    AND nl.NotificationDateTime <= @EndDate

    AND nl.NotificationStatusID IN (1,2,12,15)

    AND (
        nl.NotificationTypeID IN (1,11,12,13,20)

        OR (
            nl.NotificationTypeID = 0
            AND (
                nl.OverduesCount > 0
                OR nl.Overdues2ndCount > 0
                OR nl.Overdues3rdCount > 0
                OR nl.BillsCount > 0
            )
        )
    )
	AND 
	nl.ReportingOrgID = 3

ORDER BY
    nl.NotificationDateTime;
