SELECT
its.ItemStatusID,
its.Description,
its.Name,
its.BannerText

FROM
Polaris.ItemStatuses its WITH (NOLOCK);
