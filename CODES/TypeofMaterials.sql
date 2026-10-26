SELECT
tom.MARCTypeOfMaterialID,
tom.Description,
tom.Precedence,
tom.SearchCode

FROM
polaris.MARCTypeOfMaterial  tom WITH(NOLOCK);
