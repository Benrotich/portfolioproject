/*
Cleaning data in sql queries
*/

select *
from Portfolioproject1.dbo.Nationalhousing

---standardize date format

select SaleDateconverted,CONVERT(Date,SaleDate)
from Portfolioproject1.dbo.Nationalhousing

update Nationalhousing
set SaleDate = CONVERT(Date,SaleDate)

alter table Nationalhousing
add saleDateconverted Date;

update Nationalhousing
set SaleDateconverted = CONVERT(Date,SaleDate)


---populate property address data

select *
from Portfolioproject1.dbo.Nationalhousing
  --where PropertyAddress is null
  order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject1.dbo.Nationalhousing a
 join Portfolioproject1.dbo.Nationalhousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from Portfolioproject1.dbo.Nationalhousing a
 join Portfolioproject1.dbo.Nationalhousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null


--breaking out Address into individual columns(Address,city,state)

select PropertyAddress
from Portfolioproject1.dbo.Nationalhousing

select
 substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
  substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from Portfolioproject1.dbo.Nationalhousing




alter table Nationalhousing
add PropertysplitAddress nvarchar(255);

update Nationalhousing
set PropertysplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 

alter table Nationalhousing
add  Propertysplitcity nvarchar(255);

update Nationalhousing
set Propertysplitcity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

select *
from Portfolioproject1.dbo.Nationalhousing


select OwnerAddress
from Portfolioproject1.dbo.Nationalhousing

select
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from Portfolioproject1.dbo.Nationalhousing

alter table Nationalhousing
add  OwnertysplitAddress nvarchar(255);

update Nationalhousing
set OwnersplitAddress = PARSENAME(replace(OwnerAddress, ',','.') , 3)

alter table Nationalhousing
add   Ownersplitcity nvarchar(255);

update Nationalhousing
set Ownersplitcity = PARSENAME(replace(OwnerAddress, ',','.'),2)

alter table Nationalhousing
add  Ownersplitstate nvarchar(255);

update Nationalhousing
set Ownersplitstate = PARSENAME(replace(OwnerAddress, ',','.'),1)


select *
from Portfolioproject1.dbo.Nationalhousing


--change Y and N to Yes and No "Sold as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from Portfolioproject1.dbo.Nationalhousing
 group by SoldAsVacant
 order by 2
 

 select SoldAsVacant,
 case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
from Portfolioproject1.dbo.Nationalhousing

update Nationalhousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end


--remove duplicates

with RowNumCTE as (
select *,
    ROW_NUMBER() over (partition by ParcelID,
	                               PropertyAddress,
								   SalePrice,
								   SaleDate,
								   LegalReference
								   order by 
								   UniqueID)
								   row_num

from Portfolioproject1.dbo.Nationalhousing
)
select *
from RowNumCTE
where row_num > 1
order by  PropertyAddress


--Delete unused columns

select *
from Portfolioproject1.dbo.Nationalhousing

alter table Portfolioproject1.dbo.Nationalhousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate







