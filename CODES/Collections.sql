SELECT
col.CollectionID,
col.Name,
col.Abbreviation,
col.CreatorID,
col.ModifierID,
col.CreationDate,
col.ModificationDate

FROM
polaris.Collections col WITH (NOLOCK)
