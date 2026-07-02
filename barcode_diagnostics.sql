SELECT TOP 1
   br.BrowseTitle AS Title,
   br.BrowseAuthor AS Author,
   cir.Barcode,
   ist.Description AS Status,
   CASE
      WHEN cir.LoanableOutsideSystem = 1
         THEN 'Contributed'
      ELSE 'Not Contributed'
   END AS Contributed,
   ir.ItemRecordID,
   br.BibliographicRecordID AS BibRecordID,
   m.Description AS MaterialType,
   sl.Description AS Location,
   c.Name AS Collection,
   ird.CallNumber,
   'System',
   'Permalink'

FROM Polaris.CircItemRecords cir

INNER JOIN Polaris.ItemRecords ir
   ON cir.ItemRecordID = ir.ItemRecordID

INNER JOIN Polaris.ItemRecords ird
   ON cir.ItemRecordID = ird.ItemRecordID
   
INNER JOIN Polaris.BibliographicRecords br
   ON cir.AssociatedBibRecordID = br.BibliographicRecordID

LEFT JOIN Polaris.MaterialTypes m
   ON cir.MaterialTypeID = m.MaterialTypeID

LEFT JOIN Polaris.Collections c
   ON cir.AssignedCollectionID = c.CollectionID

LEFT JOIN Polaris.ShelfLocations sl
   ON cir.ShelfLocationID = sl.ShelfLocationID

LEFT JOIN Polaris.ItemStatuses ist
   ON cir.ItemStatusID = ist.ItemStatusID

WHERE cir.Barcode = '31220013067803'
        