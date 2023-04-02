/*

Cleaning Data in SQL Queries and making it more usable

*/


Select *
From [Portofolio Project/Data Cleaning]..[Housing Information]

-------------------------------------------
--Standardize Data format


Select SaleDateConverted,CONVERT(Date,Saledate)
From [Portofolio Project/Data Cleaning]..[Housing Information]

Update [Housing Information]
Set SaleDate = CONVERT(Date,Saledate)

Alter Table [Housing Information]
Add SaleDateConverted Date;

Update [Housing Information]
Set SaleDateConverted = CONVERT(Date,Saledate)


-------------------------------------------------------------------------

-----Populate Property Address Data

Select *
From [Portofolio Project/Data Cleaning]..[Housing Information]
--where PropertyAddress is Null
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Housing Information] a
Join [Housing Information] b
ON a.ParcelID = b.ParcelID
AnD a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Housing Information] a
Join [Housing Information] b
ON a.ParcelID = b.ParcelID
AnD a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null


---**Shpjegim per vete**--
---Po te ekzekutojme Update tani dhe me pas te ekzekutoj rreshtat e meparshem ku beme modifikimin,do shohim qe do na dalin vetem kolonat pa asnje vlere sepse eshte bere modifikimi dhe nuk kemi me vlera Null neper rreshta.
--Tani po te shkosh te kontrollosh(te besh double check) e ta ekzekutosh dhe nje here komanden e pare:

--Select *
--From [Portofolio Project/Data Cleaning]..[Housing Information]
--where PropertyAddress is Null
--Order by ParcelID

--Do na dalin vetem kolonat pa asnje vlere,sepse nuk ka me vlera Null neper rreshta sic kishim me pare,tani eshte populluar cdo rresht.
--Ndersa po ta besh koment rreshtin ne fjale:
--where PropertyAddress is Null 

--Do shohesh qe te dalin te gjithe rreshtat te populluar.



-----------------------------------------------------------------------------------------------------
---Breaking out Address into Individual Colomns (Address,City,State)

Select PropertyAddress
From [Portofolio Project/Data Cleaning]..[Housing Information]
--where PropertyAddress is Null
--Order by ParcelID


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From [Portofolio Project/Data Cleaning]..[Housing Information]


Alter Table [Housing Information]
Add PropertySplitAddress Nvarchar(255);

Update [Housing Information]
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table [Housing Information]
Add PropertySpliCity Nvarchar(255);

Update [Housing Information]
Set PropertySpliCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select*
From [Portofolio Project/Data Cleaning]..[Housing Information]


----Menyra e 2 per te bere ndarjen e te dhenave te 1 kolone ne 2 kolona te ndryshme(ajo qe sapo beme me lart)
--Menyre shume me e lehte e me praktike


Select OwnerAddress
From [Portofolio Project/Data Cleaning]..[Housing Information]

--Pra ketu kemi adresen,qytetin,shtetin

Select
PARSENAME(Replace(OwnerAddress,',','.'),1)
From [Portofolio Project/Data Cleaning]..[Housing Information]


Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From [Portofolio Project/Data Cleaning]..[Housing Information]


Alter Table [Housing Information]
Add OwnerSplitAddress Nvarchar(255);

Update [Housing Information]
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table [Housing Information]
Add OwnerSplitCity Nvarchar(255);

Update [Housing Information]
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table [Housing Information]
Add OwnerSplitState Nvarchar(255);

Update [Housing Information]
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select*
From [Portofolio Project/Data Cleaning]..[Housing Information]

--------------------------------------------------------------------------
----------------- Change Y and N to Yes and No in 'Sold as Vacant; field


Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From [Portofolio Project/Data Cleaning]..[Housing Information]
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant='Y' THEN 'YES'
     when SoldAsVacant='N' THEN 'NO'
	 Else SoldAsVacant
	 END
From [Portofolio Project/Data Cleaning]..[Housing Information]


Update [Housing Information]
SET SoldAsVacant = Case when SoldAsVacant='Y' THEN 'YES'
     when SoldAsVacant='N' THEN 'NO'
	 Else SoldAsVacant
	 END


-----------------------------------------------------------
 -----------REMOVE DUPLICATE(nuk para perdoret ne vendin e punes,mirepo do e ndjkim me qellim informimi
 ---Perdoren disa menyra:Rank,Order Rank,Row number per te identifikuar dublikimet.Ne do perdorim Row NUMBER,meqe eshte me e lehte.


 With RowNumCTE as (
 Select*,
 ROW_NUMBER() OVER(
 Partition BY ParcelID,
 PropertyAddress,
 SalePrice,
 SaleDate,
 LegalReference
ORDER BY
UniqueID)row_num

 From [Portofolio Project/Data Cleaning]..[Housing Information]
 --Order by ParcelID
 )
Select*
From RowNumCTE
Where row_num >1
--Order by PropertyAddress

------------------------------------------------------------------
--------------------Delete Unused Columns




Select*
From [Portofolio Project/Data Cleaning]..[Housing Information]


Alter Table [Portofolio Project/Data Cleaning]..[Housing Information]
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table [Portofolio Project/Data Cleaning]..[Housing Information]
Drop Column Saledate
