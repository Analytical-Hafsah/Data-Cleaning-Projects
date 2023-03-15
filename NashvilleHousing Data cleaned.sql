/****** Data Cleaning in SQL queries  ******/


SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing


-- Standardize Date Format


SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProjects.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


-- Populate Property Address data

SELECT PropertyAddress
FROM PortfolioProjects.dbo.NashvilleHousing
ORDER BY ParcelID

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



-- Breaking the PropertyAddress into Individual Columns (Address, City)


SELECT PropertyAddress
FROM PortfolioProjects.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS City
FROM PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertyAddressUpdated NVARCHAR(300);

UPDATE NashvilleHousing
SET PropertyAddressUpdated = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
ADD PropertyCityUpdated NVARCHAR(300);

UPDATE NashvilleHousing
SET PropertyCityUpdated = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




-- Breaking the OwnerAddress into Individual Columns (Address, City, State)


SELECT OwnerAddress
FROM PortfolioProjects.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProjects.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerAddressUpdated NVARCHAR(300);

UPDATE NashvilleHousing
SET OwnerAddressUpdated = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerCityUpdated NVARCHAR(300);

UPDATE NashvilleHousing
SET OwnerCityUpdated = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
ADD OwnerStateUpdated NVARCHAR(300);

UPDATE NashvilleHousing
SET OwnerStateUpdated = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProjects.dbo.NashvilleHousing

)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProjects.dbo.NashvilleHousing

)
DELETE
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns


SELECT *
From PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress





