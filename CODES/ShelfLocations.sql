SELECT
sl.OrganizationID,
o.Name,
sl.ShelfLocationID,
sl.Description
	
FROM
polaris.ShelfLocations sl WITH (NOLOCK)

INNER JOIN
Organizations o WITH (NOLOCK)
	 ON o.OrganizationID = sl.OrganizationID
