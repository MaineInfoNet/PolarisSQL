SELECT
sl.ShelfLocationID,
sl.Description,
sl.OrganizationID,
o.Name,
o.DisplayName,
sl.Description

FROM
polaris.ShelfLocations sl WITH (NOLOCK)

INNER JOIN
Organizations o WITH (NOLOCK)
	 ON o.OrganizationID = sl.OrganizationID
