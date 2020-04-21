ALTER TABLE collab1 DROP COLUMN "label";

ALTER TABLE collab1 ADD COLUMN "label" text DEFAULT '';

UPDATE collab1 SET "label" = "label" || affiliation || ' '
FROM auth_uni INNER JOIN universities ON (uni_id = aff_id)
WHERE uni1 = auth_id AND affiliation = '"CERN"';

UPDATE collab1 SET "label" = "label" || affiliation || ' '
FROM auth_uni INNER JOIN universities ON (uni_id = aff_id)
WHERE uni1 = auth_id AND affiliation = '"Fermilab"';

UPDATE collab1 SET "label" = "label" || affiliation || ' '
FROM auth_uni INNER JOIN universities ON (uni_id = aff_id)
WHERE uni2 = auth_id AND affiliation = '"CERN"';

UPDATE collab1 SET "label" = "label" || affiliation || ' '
FROM auth_uni INNER JOIN universities ON (uni_id = aff_id)
WHERE uni2 = auth_id AND affiliation = '"Fermilab"';