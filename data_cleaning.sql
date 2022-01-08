-- select All Data in Excel File To underStand Data
select *
from portifolio.dbo.Nashvile

-- conver column date into date formate
select SaleDate, CONVERT(date,SaleDate) as formatDates
from portifolio.dbo.Nashvile

--update salesValue with new formate but still have the same value so i use alter to add new column
update portifolio.dbo.Nashvile 
set SaleDate=CONVERT(date,SaleDate)

--Add New Column to store new formate
Alter table portifolio.dbo.Nashvile 
add SalesDateConverted date


--update the column SalesDateConverted and select * then u saw the new column in last 
update portifolio.dbo.Nashvile 
set SalesDateConverted=CONVERT(date,SaleDate)

-- -----------------------------------------------------------------------------------------------------

-- Select PropertyAddress
select PropertyAddress
from portifolio.dbo.Nashvile
where PropertyAddress is not null


-- that show me if there is two have the same id then that must have the same address
select *
from portifolio.dbo.Nashvile
--where PropertyAddress is not  null
order by ParcelID

--join with the same table
--no equal <>
--select all property address have values null and select the same parcelId have already value 

select a.ParcelID ,a.PropertyAddress ,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from portifolio.dbo.Nashvile a
join portifolio.dbo.Nashvile b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- update using isnull 
-- is first check is null or no if is null then replace with the value in b.propertyAddress else still the same value 
-- the same query can used in update quert without using word select as in example
update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from portifolio.dbo.Nashvile a
join portifolio.dbo.Nashvile b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



--Breaking address into individual columns (address , city , state)

select PropertyAddress , SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as AddressNum 
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Addresscity
from portifolio.dbo.Nashvile

Alter Table portifolio.dbo.Nashvile 
add propertySplitAddress nvarchar(255)

update portifolio.dbo.Nashvile 
set propertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table portifolio.dbo.Nashvile 
add propertySplitCity nvarchar(255)

update portifolio.dbo.Nashvile 
set propertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))



-- paresName Function Example to Understand It 

select 
parseName(replace(OwnerAddress,',','.'),3),
parseName(replace(OwnerAddress,',','.'),2),
parseName(replace(OwnerAddress,',','.'),1)
from portifolio.dbo.Nashvile

--add column ownerSplitAddress
Alter Table portifolio.dbo.Nashvile 
add ownerSplitAddress nvarchar(255)

--update new column with value
update portifolio.dbo.Nashvile 
set ownerSplitAddress=parseName(replace(OwnerAddress,',','.'),3)

--add column ownerSplitCity

Alter Table portifolio.dbo.Nashvile 
add ownerSplitCity nvarchar(255)

--update new column with value

update portifolio.dbo.Nashvile 
set ownerSplitCity=parseName(replace(OwnerAddress,',','.'),2)

--add column ownerSplitSate

Alter Table portifolio.dbo.Nashvile 
add ownerSplitSate nvarchar(255)

--update new column with value

update portifolio.dbo.Nashvile 
set ownerSplitSate=parseName(replace(OwnerAddress,',','.'),1)


select *
from portifolio.dbo.Nashvile
where ownerSplitSate is not null



-- change Y and N in sold as vacant field


select Distinct(SoldAsVacant) ,count(SoldAsVacant)
from portifolio.dbo.Nashvile
group by SoldAsVacant
order by count(SoldAsVacant)


--my way of making CASE-------------------------------
select SoldAsVacant,
case SoldAsVacant 
when 'Y' then 'Yes'
when 'N' then 'No'
when 'Yes' then 'Yes'
when 'No' then 'No'
else 'unknow'
end
from portifolio.dbo.Nashvile

update portifolio.dbo.Nashvile
set SoldAsVacant=case SoldAsVacant 
when 'Y' then 'Yes'
when 'N' then 'No'
when 'Yes' then 'Yes'
when 'No' then 'No'
else 'unknow'
end

-- Alex Way Of used CASE---------------------------

select SoldAsVacant,
case  
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end
from portifolio.dbo.Nashvile

update portifolio.dbo.Nashvile
set SoldAsVacant=case  
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end



--CTE  to show All the duplicate record where row_num>1
with RowNumCte AS (
select  * , ROW_NUMBER() over (PARTITION by ParcelID ,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) as row_num
from portifolio.dbo.Nashvile
)
select * 
from RowNumCte
where row_num>1



--CTE  to show All the delete record where row_num>1
with RowNumCte AS (
select  * , ROW_NUMBER() over (PARTITION by ParcelID ,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID) as row_num
from portifolio.dbo.Nashvile
)
delete 
from RowNumCte
where row_num>1


-- Drop Some Column Using Alter 

Alter Table portifolio.dbo.Nashvile
Drop Column PropertyAddress,TaxDistrict,OwnerAddress,BuildingValue,SaleDate





