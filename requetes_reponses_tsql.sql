-- 3. Manipulations

-- 3.1 Interrogations


-- Consignes : Donner la requête vous permettant de répondre à la question et répondez-y.



-- 1. Combien y-a-t-il d'enregistrements dans les tables DimCustomer, DimPromotion et DimCurrency ?

SELECT COUNT(*) FROM DimCustomer
UNION
SELECT COUNT(*) FROM DimPromotion
UNION
SELECT COUNT(*) FROM DimCurrency;

-- OU

SELECT COUNT(*) AS CustomerCount FROM DimCustomer;
SELECT COUNT(*) AS PromotionCount FROM DimPromotion;
SELECT COUNT(*) AS CurrencyCount FROM DimCurrency;

-- Il y a 18485 enregistrmenets dans la table DimCustomer, 16 enregistrements dans la table DimPromotion et 105 enregistrements dans la table DimCurrency.


/******************************************************************************************************************************************************************/


-- 2. Lister par ville, par sexe et par ordre alphabétique les clients habitant aux Etats Unis.

SELECT FirstName, LastName FROM DimCustomer
INNER JOIN DimGeography
ON DimCustomer.GeographyKey = DimGeography.GeographyKey
WHERE FrenchCountryRegionName = 'États-Unis'
ORDER BY City, Gender, FirstName;



/******************************************************************************************************************************************************************/

-- 3. Combien y en a-t-il ? (faire une requête)

SELECT COUNT(*) AS CustomerInUnitedStates FROM DimCustomer
INNER JOIN DimGeography
ON DimCustomer.GeographyKey = DimGeography.GeographyKey
WHERE FrenchCountryRegionName = 'États-Unis';

-- Il y a 7820 clients habitant aux Etats-Unis.


/******************************************************************************************************************************************************************/


-- 4. Quelle catégorie de produit a été la plus vendue en quantité sur Internet ?

SELECT TOP 1 DimProductCategory.FrenchProductCategoryName, SUM(OrderQuantity) AS QuantitySales FROM DimProductCategory
INNER JOIN FactSurveyResponse
ON DimProductCategory.ProductCategoryKey = FactSurveyResponse.ProductCategoryKey
INNER JOIN FactInternetSales
ON FactSurveyResponse.CustomerKey = FactInternetSales.CustomerKey
GROUP BY DimProductCategory.FrenchProductCategoryName
ORDER BY SUM(OrderQuantity) DESC;

-- La catégorie de produit qui a été le plus vendue en quantité sur Internet est la catégorie des accessoires avec une quantité vendue de 5960 unités.

/******************************************************************************************************************************************************************/


-- 5. Donner l’adresse complète de Shannon C Carlson.

SELECT FirstName, MiddleName, LastName, AddressLine1, City, StateProvinceName, EnglishCountryRegionName, PostalCode FROM DimCustomer
INNER JOIN DimGeography
ON DimCustomer.GeographyKey = DimGeography.GeographyKey
WHERE FirstName = 'Shannon' AND MiddleName = 'C' AND LastName = 'Carlson';

-- Shannon C Carlson habite au 3839 Northgate Road, dans la ville de Hervey Bay dans la région du Queensland en Australie, code postal 4655.


/******************************************************************************************************************************************************************/


-- 6. Quel employé a effectué le plus de commandes, combien ?

SELECT TOP 1 FirstName, MiddleName, LastName, COUNT(SalesOrderNumber) AS MostOrder FROM DimEmployee
INNER JOIN FactResellerSales
ON DimEmployee.EmployeeKey = FactResellerSales.EmployeeKey
GROUP BY FirstName, MiddleName, LastName
ORDER BY COUNT(SalesOrderNumber) DESC;

-- L'employé qui a effectué le plus de commandes est Jillian Carson avec un total de 7825 commandes.

/******************************************************************************************************************************************************************/


-- 7. Quelle employée a effectué le plus grand chiffre d’affaire, combien ?

SELECT TOP 1 FirstName, MiddleName, LastName, SUM(SalesAmount) AS MostCA, CurrencyName FROM DimEmployee
INNER JOIN FactResellerSales
ON DimEmployee.EmployeeKey = FactResellerSales.EmployeeKey
INNER JOIN DimCurrency
ON FactResellerSales.CurrencyKey = DimCurrency.CurrencyKey
GROUP BY FirstName, MiddleName, LastName, CurrencyName
ORDER BY SUM(SalesAmount) DESC;

-- L'employée qui a effectué le plus grand chiffre d'affaire est Linda C. Mitchell avec un chiffre d'affaire de 10367007,4286 Dollars américain.

/******************************************************************************************************************************************************************/


-- 8. Quel département a été le plus impacté par les arrêts maladies ?

SELECT TOP 1 DepartmentName, SUM(DimEmployee.SickLeaveHours) AS SickLeavesHours FROM DimEmployee
GROUP BY DepartmentName
ORDER BY SUM(DimEmployee.SickLeaveHours) DESC;

-- Le département le plus impacté par les arrêts maladies est le secteur de la production avec un total de 7929 heures.

/******************************************************************************************************************************************************************/


-- 9. Jill Williams a un contentieux pour harcèlement dans son service. Nommez l’ensemble de ses collègues et supérieurs hiérarchiques directs ainsi que leur fonction au sein de la compagnie.

DECLARE @ParentEmployeeKeyJillWilliams INT; 
SET @ParentEmployeeKeyJillWilliams = (SELECT ParentEmployeeKey FROM DimEmployee WHERE FirstName = 'Jill' AND LastName = 'Williams');

SELECT FirstName, LastName, Title, ParentEmployeeKey FROM DimEmployee WHERE ParentEmployeeKey = @ParentEmployeeKeyJillWilliams OR EmployeeKey = @ParentEmployeeKeyJillWilliams;

-- Les collègues de travail de Jill Williams sont :
    -- Kevin Brown au poste de Marketing Assistant,
    -- Sariya Harnpadoungsataya au poste de Marketing Specialist,
    -- Mary	Gibson au poste de Marketing Specialist,
    -- Terry Eminhizer au poste de Marketing Specialist,
    -- Wanida Benshoof au poste de Marketing Assistant,
    -- John Wood au poste de Marketing Specialist,
    -- Mary Dempsey	au poste de Marketing Assistant.

-- Son supérieur hiérarchique direct est David Bradley au poste de Marketing Manager.

/******************************************************************************************************************************************************************/


-- 10. Quelle(s) sous catégorie(s) de produits n’a pas été vendue ?

SELECT FrenchProductName, DimProductSubcategory.ProductSubcategoryKey, FrenchProductSubcategoryName FROM DimProductSubcategory
INNER JOIN DimProduct
ON DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
INNER JOIN FactResellerSales
ON DimProduct.ProductKey = FactResellerSales.ProductKey
WHERE DimProduct.ProductKey = FactResellerSales.ProductKey 
GROUP BY FrenchProductName, DimProductSubcategory.ProductSubcategoryKey, FrenchProductSubcategoryName
ORDER BY ProductSubcategoryKey;

-- Les sous catégories de produits qui n'ont pas été vendu sont les range-vélos, les garde-boues, les éclairages et les sacoches.

 SELECT FactInternetSales.ProductKey AS 'ProductKey Internet', DimProductSubcategory.ProductSubcategoryKey AS 'SS cat Internet', DimProduct.ProductKey AS 'ProductKey Product', DimProduct.ProductSubcategoryKey AS 'SS cat Product' FROM FactInternetSales 
  RIGHT JOIN DimProduct
  ON FactInternetSales.ProductKey = DimProduct.ProductKey
  INNER JOIN DimProductSubcategory
  ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
  
  GROUP BY FactInternetSales.ProductKey, DimProductSubcategory.ProductSubcategoryKey, DimProduct.ProductKey, DimProduct.ProductSubcategoryKey
  ORDER BY 'SS cat Internet' ASC, 'SS cat Product' ASC

/******************************************************************************************************************************************************************/


-- 11. Pour l’année 2011, quelle zone de vente a été la plus productive en nombre de commandes ? Même question en chiffre d’affaire ? (NB : une zone de vente suppose un achat en magasin)



/******************************************************************************************************************************************************************/



-- 12. Sélectionner les clients qui n'ont pas encore passé commande et trier par ordre alphabétique ascendant.

SELECT FirstName, LastName FROM FactInternetSales
RIGHT JOIN DimCustomer
ON FactInternetSales.CustomerKey = DimCustomer.CustomerKey
WHERE FactInternetSales.CustomerKey IS NULL
ORDER BY FirstName ASC, LastName ASC;

/******************************************************************************************************************************************************************/


-- 13. Donner la liste de toutes les ventes de VTT depuis le début. On souhaite voir apparaître les noms et prénoms des clients, la date de commande et le numéro de commande sous les nomenclatures respectives de Nom, Prénom, Date Cde, Num Cde. Les ventes magasin seront nommées Magasin.

SELECT LastName AS 'Nom', FirstName AS 'Prénom', FactResellerSales.OrderDate AS 'Date Cde Magasin', vAssocSeqOrders.OrderNumber AS 'Num Cde', FactResellerSales.OrderQuantity AS 'Magasin' FROM DimCustomer
INNER JOIN vAssocSeqOrders
ON DimCustomer.CustomerKey = vAssocSeqOrders.CustomerKey
INNER JOIN FactInternetSales
ON vAssocSeqOrders.CustomerKey = FactInternetSales.CustomerKey
INNER JOIN DimDate
ON FactInternetSales.OrderDateKey = DimDate.DateKey
INNER JOIN FactResellerSales
ON DimDate.DateKey = FactResellerSales.OrderDateKey
INNER JOIN DimProduct
ON FactInternetSales.ProductKey = DimProduct.ProductKey
INNER JOIN DimProductSubcategory
ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
WHERE DimProductSubcategory.FrenchProductSubcategoryName = 'VTT'
GROUP BY LastName, FirstName, FactResellerSales.OrderDate, vAssocSeqOrders.OrderNumber, FactResellerSales.OrderQuantity

/******************************************************************************************************************************************************************/


-- 14. Combien y-a-t-il de villes différentes dans la table DimGeography?

SELECT COUNT(DISTINCT City) FROM DimGeography;

-- Il y a 563 villes différentes dans la table DimGeography.

/******************************************************************************************************************************************************************/

-- 15. Les casques sport ne se vendent pas bien. On souhaite modifier la promotion en cours. Passer celle-ci de 15% à 30%.

UPDATE DimPromotion
  SET DiscountPct = 0.30
  WHERE FrenchPromotionName = 'Remise sur les casques sport - 2003';

/******************************************************************************************************************************************************************/


/*16. Ecrire un déclencheur permettant d’ajouter une promotion lorsqu’on ajoute un nouvel article. La promotion se fait comme suit :
- Nom de la promotion : Nouveau produit
- Réduction : 15%
- Type de promotion : Client
- Commence à partir de maintenant pour 5 ans
- La promotion se déclenche à partir de 5 articles commandés */

CREATE TRIGGER TR_ADD_PROMO_AFTER_INSERT_PRODUCT
ON DimProduct
AFTER INSERT
AS
BEGIN 
DECLARE @NextPromotionKey INT;
SET @NextPromotionKey = (Select TOP 1 PromotionKey FROM DimPromotion ORDER BY PromotionKey DESC);
INSERT INTO DimPromotion (PromotionKey, FrenchPromotionName, DiscountPct, FrenchPromotionType, StartDate, EndDate, MinQty)
VALUES
(@NextPromotionKey+1, 'Nouveau Produit', 0.15, 'Client', GETDATE(), GETDATE()+1825, 5)
END;

/******************************************************************************************************************************************************************/


-- 17. Tester le déclencheur en ajoutant un article cohérent via une procédure de test.

CREATE PROCEDURE NewProduct 
		@ProductKey INT,
		@ProductAlternateKey NVARCHAR(25),
		@EnglishProductName NVARCHAR(50), 
		@SpanishProductName NVARCHAR(50), 
		@FrenchProductName NVARCHAR(50),
		@FinishedGoodFlag BIT,
		@Color NVARCHAR(15)
AS
BEGIN
	INSERT INTO DimProduct (ProductKey, ProductAlternateKey, EnglishProductName, SpanishProductName, FrenchProductName, FinishedGoodsFlag, Color)
	VALUES
	(@ProductKey, @ProductAlternateKey, @EnglishProductName, @SpanishProductName, @FrenchProductName, @FinishedGoodFlag, @Color)
END

-- Test :

BEGIN TRANSACTION;

EXEC NewProduct @ProductKey = 608, @ProductAlternateKey = 'SO-R809-XL', @EnglishProductName = 'XL-Socks', @SpanishProductName = 'XL-Medias', @FrenchProductName = 'Chaussettes Taille XL', @FinishedGoodFlag = 1, @Color = 'Red';

SELECT * FROM DimPromotion;
SELECT * FROM DimProduct WHERE ProductAlternateKey = 'SO-R809-XL';

COMMIT;


/******************************************************************************************************************************************************************/


-- 18. Reprendre la question 4 et donner la catégorie la plus vendue par la société, toutes ventes confondues avec la somme perçue.

SELECT TOP 1 DimProductCategory.FrenchProductCategoryName, (SUM(FactInternetSales.OrderQuantity) + SUM(FactResellerSales.OrderQuantity)) AS TotalQuantitySales, (SUM(FactInternetSales.SalesAmount) + SUM(FactResellerSales.SalesAmount)) AS TotalSalesAmount FROM DimProductCategory
INNER JOIN FactSurveyResponse
ON DimProductCategory.ProductCategoryKey = FactSurveyResponse.ProductCategoryKey
INNER JOIN FactInternetSales
ON FactSurveyResponse.CustomerKey = FactInternetSales.CustomerKey
INNER JOIN FactResellerSales
ON FactInternetSales.ProductKey = FactResellerSales.ProductKey
GROUP BY DimProductCategory.FrenchProductCategoryName
ORDER BY TotalQuantitySales DESC, TotalSalesAmount DESC;

-- La catégorie la plus vendue par le société est la catégorie des accesoires avec un total de ventes de 6 833 380 unités pour une somme totale de 1 560 087 969,5039 (toutes devises confondues).

/******************************************************************************************************************************************************************/



-- 19. On veut optimiser la recherche des produits sur les nomenclatures anglaises. Ecrivez la requête permettant cette optimisation.

CREATE INDEX idx_english_product
ON DimProduct (EnglishProductName);

/******************************************************************************************************************************************************************/



-- 20. Bonus : Donnez les noms des clients étant mariés avec un employé de la compagnie



/******************************************************************************************************************************************************************/