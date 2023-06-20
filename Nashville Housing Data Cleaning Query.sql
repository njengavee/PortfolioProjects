SELECT *
FROM [Portfolio Projects].[dbo].[Nashvillehousing]

--Standadize data format

select SaleDateConverted, CONVERT(Date, SaleDate)
From [Portfolio Projects].[dbo].[Nashvillehousing]

Update Nashvillehousing
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address data

SELECT *
FROM [Portfolio Projects].[dbo].[Nashvillehousing]
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Projects].[dbo].[Nashvillehousing] a
JOIN [Portfolio Projects].[dbo].[Nashvillehousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Projects].[dbo].[Nashvillehousing] a
JOIN [Portfolio Projects].[dbo].[Nashvillehousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


-- Breaking out PropertyAddress into individual Columns(Address, city, State) using SUBSTRING

SELECT PropertyAddress
FROM [Portfolio Projects].[dbo].[Nashvillehousing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address 

FROM [Portfolio Projects].[dbo].[Nashvillehousing]


ALTER TABLE Nashvillehousing
Add PropertysplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashvillehousing
Add PropertysplitCity Nvarchar(255);

Update Nashvillehousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



--Breaking out OwnerAddress into individual Columns(Address, city, State) using PARSENAME

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From [Portfolio Projects].[dbo].[Nashvillehousing]

ALTER TABLE Nashvillehousing
Add OwnersplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashvillehousing
Add OwnersplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashvillehousing
Add OwnersplitState Nvarchar(255);

Update Nashvillehousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From [Portfolio Projects].[dbo].[Nashvillehousing]

--Change Y and N to yes and No in 'Sold as Vacant' field

Select distinct(SoldAsVacant), Count(SoldAsVacant) AS soldasvacant
From [Portfolio Projects].[dbo].[Nashvillehousing]
GROUP BY SoldAsVacant
ORDER BY 2

Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
From [Portfolio Projects].[dbo].[Nashvillehousing]


Update Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END

--Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
From [Portfolio Projects].[dbo].[Nashvillehousing]
)

Select *
From RowNumCTE
Where row_num > 1


--Delete Unused columns

Select *
From [Portfolio Projects].[dbo].[Nashvillehousing]

ALTER TABLE [Portfolio Projects].[dbo].[Nashvillehousing]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate