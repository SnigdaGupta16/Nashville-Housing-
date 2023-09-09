use nashville_housing;
CREATE TABLE housing (
    UniqueID VARCHAR(100),
    ParcelID VARCHAR(100),
    LandUse VARCHAR(100),
    PropertyAddress VARCHAR(100),
    SaleDate VARCHAR(100),
    SalePrice VARCHAR(100),
    LegalReference VARCHAR(100),
    SoldAsVacant VARCHAR(100),
    OwnerName VARCHAR(100),
    OwnerAddress VARCHAR(100),
    Acreage VARCHAR(100),
    TaxDistrict VARCHAR(100),
    LandValue VARCHAR(100),
    BuildingValue VARCHAR(100),
    TotalValue VARCHAR(100),
    YearBuilt VARCHAR(100),
    Bedrooms VARCHAR(100),
    FullBath VARCHAR(100),
    HalfBath VARCHAR(100)
);
describe housing;
SELECT 
    *
FROM
    housing;
truncate table housing;
load data infile 'Nashville Housing Data for Data Cleaning- edited.csv' into table housing fields terminated by ',' ENCLOSED BY '"' ignore 1 lines;
SELECT 
    COUNT(*)
FROM
    housing;
DELETE FROM housing 
WHERE
    uniqueid = '';

-- convert data type to date
alter table housing modify column SaleDate date;

-- populate propertty address data
SELECT 
    *
FROM
    housing
-- WHERE 
   --  propertyaddress = ''
ORDER BY parcelid;

SELECT 
    a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
FROM
    housing a
        JOIN
    housing b ON a.parcelid = b.parcelid
        AND a.uniqueid <> b.uniqueid;
   --  WHERE
     -- a.propertyaddress = 'no address';
-- WHERE
   -- a.propertyaddress = '';
    
UPDATE housing a
        JOIN
    housing b ON a.parcelid = b.parcelid
        AND a.uniqueid <> b.uniqueid 
SET 
    a.propertyaddress = b.propertyaddress
WHERE
    a.propertyaddress = '';
    
-- breaking out address into individual columns
SELECT 
    propertyaddress
FROM
    housing;
SELECT 
    SUBSTRING_INDEX(propertyaddress, ',', 1) AS 'Address',
    SUBSTRING_INDEX(propertyaddress, ',', - 1) AS 'Address'
FROM
    housing;
    
alter table housing add column (property_split_address varchar(50), property_split_city varchar(50));
UPDATE housing 
SET 
    property_split_address = SUBSTRING_INDEX(propertyaddress, ',', 1);
UPDATE housing 
SET 
    property_split_city = SUBSTRING_INDEX(propertyaddress, ',', - 1);
    
SELECT 
    SUBSTRING_INDEX(owneraddress, ',', 1) AS 'Address',
    SUBSTRING_INDEX(owneraddress, ',', 2) AS 'Address',
    SUBSTRING_INDEX(owneraddress, ',', - 1) AS 'Address'
FROM
    housing;

alter table housing add column (owner_split_address varchar(50), owner_split_address2 varchar(50), owner_split_city varchar(50), owner_split_state varchar(50));
UPDATE housing 
SET 
    owner_split_address = SUBSTRING_INDEX(owneraddress, ',', 1);
UPDATE housing 
SET 
    owner_split_address2 = SUBSTRING_INDEX(owneraddress, ',', 2);
UPDATE housing 
SET 
    owner_split_city = SUBSTRING_INDEX(owner_split_address2, ',', - 1);
UPDATE housing 
SET 
    owner_split_state = SUBSTRING_INDEX(owneraddress, ',', - 1);
    
-- change Y & N to Yes and No in the column "sold as vacant"
SELECT DISTINCT
    (soldasvacant), COUNT(soldasvacant)
FROM
    housing
GROUP BY soldasvacant
ORDER BY 2;
SELECT 
    soldasvacant,
    CASE
        WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
    END AS 'Yes/No'
FROM
    housing;
    
UPDATE housing 
SET 
    soldasvacant = CASE
        WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
    END;

-- delete duplicate data    
-- delete unused data
alter table housing drop column taxdistrict;



