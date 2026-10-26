SELECT
psc.StatisticalClassID,
psc.Description,
o.OrganizationID, 
o.Name,
o.DisplayName

FROM
polaris.PatronStatClassCodes psc WITH(NOLOCK)

INNER JOIN
Organizations o WITH(NOLOCK)
    ON o.OrganizationID = psc.OrganizationID
