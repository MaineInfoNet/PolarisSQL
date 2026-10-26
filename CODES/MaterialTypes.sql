SELECT
mat.MaterialTypeID,
mat.Description,
mat.MinimumAge

FROM
polaris.MaterialTypes mat WITH (NOLOCK)
;
