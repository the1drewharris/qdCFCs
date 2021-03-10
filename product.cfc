<cfcomponent hint="I have all the functions for product management system">
	<cfobject component="timeDateConversion" name="mytime">
	
	<cffunction name="dropTables" access="" hint="drop table script">
		DROP TABLE COUPOUNUSED;
		DROP TABLE COUPOUN;
		DROP TABLE THENTABLE;
		DROP TABLE IFTABLE;
		DROP TABLE DAMAGED;
		DROP TABLE RETURNEDPRODUCT;
		DROP TABLE SALESRECORD;
		DROP TABLE TRANSACTIONS;
		DROP TABLE PRICE;
		DROP TABLE PRODUCTGROUP;
		DROP TABLE PRODUCTLOG;
		DROP TABLE ITEMIMAGES;
		DROP TABLE PRODUCT;
		DROP TABLE PRICENAMES;
		DROP TABLE PRODUCTCATEGORY;
		DROP TABLE IDPOOL;
	</cffunction>
	
	<cffunction name="createProductTables" access="public" hint="I create product management tables">
		<cfargument name="productdsn" type="string" required="true" hint="datasource">
		<cfquery name="createtables" datasource="#productdsn#">
			CREATE TABLE IDPOOL
			(
				ID BIGINT IDENTITY(0,1) NOT NULL PRIMARY KEY,
				IDFOR VARCHAR(64) NOT NULL,
				ITEMNAME VARCHAR(256) NOT NULL,
				SUBSCRIABLE BIT NOT NULL DEFAULT 0,
				STOPSELLING BIT NOT NULL DEFAULT 0
			);
			INSERT INTO IDPOOL(IDFOR, ITEMNAME,SUBSCRIABLE) VALUES ('All videos', 'All videos', 1);
			INSERT INTO IDPOOL(IDFOR, ITEMNAME,SUBSCRIABLE) VALUES ('All Podcast', 'All Podcasts', 1);
			
			CREATE TABLE PRODUCTCATEGORY
			(
				CATEGORYID INT IDENTITY(1,1) PRIMARY KEY,
				CATEGORY VARCHAR(128) NOT NULL UNIQUE
			);
			
			CREATE TABLE PRICENAMES
			(
				PRICENAMEID INT IDENTITY(1,1) PRIMARY KEY,
				PRICENAME VARCHAR(32) UNIQUE NOT NULL
			);
			INSERT INTO PRICENAMES (PRICENAME) VALUES('Retail');
			INSERT INTO PRICENAMES (PRICENAME) VALUES('Reseller');
			
			CREATE TABLE PRODUCT
			(
				ID BIGINT NOT NULL PRIMARY KEY, 
				CATEGORYID INT NOT NULL,
				QUANTITY INT NOT NULL,
				DESCRIPTION NTEXT,
				ATTRIBUTES NTEXT
			)
			ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_PRODUCTCAT FOREIGN KEY(CATEGORYID) REFERENCES PRODUCTCATEGORY(CATEGORYID);
			
			CREATE TABLE ITEMIMAGES
			(
				ID BIGINT NOT NULL,
				IMAGEID BIGINT NOT NULL
			)
			ALTER TABLE ITEMIMAGES ADD PRIMARY KEY(ID, IMAGEID);
			ALTER TABLE ITEMIMAGES ADD CONSTRAINT ITEMIMAGES_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			
			<!--- ALTER TABLE ITEMIMAGES ADD CONSTRAINT ITEMIMAGES_IMAGE FOREIGN KEY(IMAGEID) REFERENCES IMAGE(IMAGEID); --->
			
			CREATE TABLE PRODUCTLOG
			(
				ID BIGINT NOT NULL,
				QUANTITY INTEGER NOT NULL,
				NAMEID BIGINT NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL
			);
			ALTER TABLE PRODUCTLOG ADD CONSTRAINT PRODUCTLOG_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
			ALTER TABLE PRODUCTLOG ADD CONSTRAINT PRODUCTLOG_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
		
			CREATE TABLE PRODUCTGROUP
			(
				ID BIGINT NOT NULL,
				PRODUCTID BIGINT NOT NULL
			);
			ALTER TABLE PRODUCTGROUP ADD PRIMARY KEY(ID, PRODUCTID);
			ALTER TABLE PRODUCTGROUP ADD CONSTRAINT PRODUCTGROUP_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE PRODUCTGROUP ADD CONSTRAINT PRODUCTGROUP_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT(ID);
			
			CREATE TABLE PRICE
			(
				ID BIGINT NOT NULL,
				PRICENAMEID INT NOT NULL,
				PRICE FLOAT NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL,
				ACTIVE BIT DEFAULT 1
			);
			ALTER TABLE PRICE ADD CONSTRAINT PRICE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE PRICE ADD CONSTRAINT PRICE_PRCENAMES FOREIGN KEY(PRICENAMEID) REFERENCES PRICENAMES(PRICENAMEID);
			
			
			CREATE TABLE TRANSACTIONS
			(
				TRANSACTIONID BIGINT PRIMARY KEY,
				BUYERID BIGINT NOT NULL,
				NAMEID BIGINT NOT NULL,
				TRANSACTIONTOTAL FLOAT NOT NULL,
				DATETIME VARCHAR(16) NOT NULL
			)
			ALTER TABLE TRANSACTIONS ADD CONSTRAINT TRANSACTIONS_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			ALTER TABLE TRANSACTIONS ADD CONSTRAINT TRANSACTIONS_BUYERNAME FOREIGN KEY(BUYERID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE SALESRECORD
			(
				ID BIGINT NOT NULL,
				TRANSACTIONID BIGINT NOT NULL,
				UNITPRICE FLOAT NOT NULL,
				QUANTITY INT NOT NULL,
				DISCOUNTPERCENT FLOAT DEFAULT 0,
				DISCOUNT FLOAT DEFAULT 0,
				OTHERCHARGES FLOAT DEFAULT 0,
				TOTAL FLOAT NOT NULL,
				REMARKS VARCHAR(256) NOT NULL DEFAULT 'Sold'
			)
			ALTER TABLE SALESRECORD ADD CONSTRAINT PK_SALESRECORD PRIMARY KEY(ID, TRANSACTIONID);
			ALTER TABLE SALESRECORD ADD CONSTRAINT SALESRECORD_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE SALESRECORD ADD CONSTRAINT SALESRECORD_TRANSACTIONS FOREIGN KEY(TRANSACTIONID) REFERENCES TRANSACTIONS(TRANSACTIONID);
			
			CREATE TABLE RETURNEDPRODUCT
			(
				TRANSACTIONID BIGINT NOT NULL,
				ID BIGINT NOT NULL,
				REFUNDPERCENT FLOAT NOT NULL,
				REFUNDAMOUNT  FLOAT NOT NULL,
				REASONOFRETURN NTEXT NOT NULL,
				NAMEID BIGINT NOT NULL,
				DATETIME FLOAT NOT NULL
			)
			ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_TRANSACTION FOREIGN KEY(TRANSACTIONID) REFERENCES TRANSACTIONS(TRANSACTIONID);
			ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
			ALTER TABLE RETURNEDPRODUCT ADD CONSTRAINT RETURNEDPRODUCT_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE DAMAGED
			(
				ID BIGINT NOT NULL,
				DESCRIPTION NTEXT NOT NULL,
				NAMEID BIGINT NOT NULL,
				DATETIME VARCHAR(16) NOT NULL
			)
			ALTER TABLE DAMAGED ADD CONSTRAINT DAMAGED_PRODUCT FOREIGN KEY(ID) REFERENCES PRODUCT(ID);
			ALTER TABLE DAMAGED ADD CONSTRAINT DAMAGED_NAME FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE IFTABLE
			(
				RULEID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
				CATEGORYID INT,
				VIDEOCATEGORYID INT,
				ID BIGINT,
				QUANTITY INTEGER,
				TOTALPRICE FLOAT DEFAULT 0,
				STARTDATE VARCHAR(16),
				ENDDATE VARCHAR(16)
			)
			ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_PRODUCTCATEGORY FOREIGN KEY(CATEGORYID) REFERENCES PRODUCTCATEGORY(CATEGORYID);
			ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
			ALTER TABLE IFTABLE ADD CONSTRAINT IFTABLE_VIDEOCATEGORY FOREIGN KEY(VIDEOCATEGORYID) REFERENCES VIDEOCATEGORY(VIDEOCATEGORYID);
					
			CREATE TABLE THENTABLE
			(
				RULEID BIGINT NOT NULL,
				CATEGORYID INT,
				VIDEOCATEGORYID INT,
				ID BIGINT,
				QUANTITY INTEGER,
				DISCOUNTPERCENT FLOAT NOT NULL DEFAULT 0,
				DISCOUNT FLOAT NOT NULL DEFAULT 0 
			)
			ALTER TABLE THENTABLE ADD CONSTRAINT THENTABLE_IFTABLE FOREIGN KEY(RULEID) REFERENCES IFTABLE(RULEID);
			ALTER TABLE THENTABLE ADD CONSTRAINT THENTABLE_IDPOOL FOREIGN KEY(ID) REFERENCES IDPOOL(ID);
		
			CREATE TABLE COUPOUN
			(
				COUPOUN VARCHAR(16) NOT NULL,
				RULEID BIGINT NOT NULL,
				CREATEDON VARCHAR(16) NOT NULL,
				NOOFTIMESALLOWED INT NOT NULL DEFAULT 1
			)
			ALTER TABLE COUPOUN ADD CONSTRAINT PK_COUPOUN PRIMARY KEY(COUPOUN);
			ALTER TABLE COUPOUN ADD CONSTRAINT FK_COUPOUN_IFTABLE FOREIGN KEY(RULEID) REFERENCES IFTABLE(RULEID);
		
			CREATE TABLE COUPOUNUSED
			(
				COUPOUN VARCHAR(16) NOT NULL,
				TIMEDATE VARCHAR(16) NOT NULL,
				NAMEID BIGINT NOT NULL
			)
			ALTER TABLE COUPOUNUSED ADD CONSTRAINT FK_COUPOUNUSED_COUPOUN FOREIGN KEY(COUPOUN) REFERENCES COUPOUN(COUPOUN);
			ALTER TABLE COUPOUNUSED ADD CONSTRAINT FK_COUPOUNUSED_NAMEID FOREIGN KEY(NAMEID) REFERENCES NAME(NAMEID);
		</cfquery>
	</cffunction>

	<cffunction name="addcategory" access="public" returntype="void" hint="I add product category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="category" required="true" type="String" hint="Category a product may belong to">
		<cfquery name="addproductcategory" datasource="#productdsn#">
			INSERT INTO PRODUCTCATEGORY
			(
				CATEGORY
			)
			VALUES
			(
				<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="addpricename" access="public" hint="I add pricenames. Price name can be retail price, reseller price etc">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="pricename" required="true" type="String" hint="price name like retail price, reseller price etc">
		<cfquery name="addprice" datasource="#productdsn#">
			INSERT INTO PRICENAMES
			(
				PRICENAME
			)
			VALUES
			(
				<cfqueryparam value="#pricename#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="createID" access="public" returntype="numeric" hint="I create a new id for any product or service">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="idfor" type="String" required="true" hint="The item for which the id is required">
		<cfargument name="itemname" type="String" required="true" hint="Name of the item">
		<cfargument name="subscriable" type="String" required="false" default="0" hint="pass 1 if the item is subscriable">
		<cfargument name="stopselling" type="String" required="false" default="0" hint="pass 1 not to start selling this item">
		<cfquery name="getid" datasource="#productdsn#">
			INSERT INTO IDPOOL
			(
				IDFOR,
				ITEMNAME,
				STOPSELLING,
				SUBSCRIABLE
			)
			VALUES
			(
				<cfqueryparam value="#idfor#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#stopselling#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#subscriable#" cfsqltype="cf_sql_varchar">
			)
			SELECT @@IDENTITY AS ID
		</cfquery>
		<cfreturn getid.ID>
	</cffunction> 	

	<cffunction name="updateName" access="public" returntype="void" output="false" hint="I update name of the sample media">
		<cfargument name="ds" required="true" type="string" hint="Update">
		<cfargument name="id" required="true" type="string" hint="id">
		<cfargument name="name" required="true" type="string" hint="updated itemname">
		<cfset var update=0>
		<cfquery name="update" datasource="#arguments.ds#">
			UPDATE IDPOOL SET
			ITEMNAME=<cfqueryparam value="#arguments.name#">
			WHERE ID=<cfqueryparam value="#arguments.id#">
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="additems" access="public" returntype="void" hint="Created to add items from already existing table">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="id of the item">
		<cfargument name="idfor" type="String" required="true" hint="The item for which the id is required">
		<cfargument name="itemname" type="String" required="true" hint="Name of the item">
		<cfargument name="subscriable" type="String" required="false" hint="pass any value if the item is subscriable">
		<cfset var items=0>
		<cfquery name="items" datasource="#productdsn#">
			 SET IDENTITY_INSERT dbo.IDPOOL ON
			 INSERT INTO IDPOOL
			 (
			 	ID,
				IDFOR,
				ITEMNAME
				<cfif isdefined('subscriable')>
				,SUBSCRIABLE
				</cfif>
			 ) 
			 VALUES
			 (
			 	<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
			 	<cfqueryparam value="#idfor#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">
				<cfif isDefined('subscriable')>
				,1
				</cfif>
			 )
			 SET IDENTITY_INSERT dbo.IDPOOL ON
		</cfquery>
		
	</cffunction>
	
	<cffunction name="addproduct" access="public" returntype="void" hint="I add product to database">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="id of the product">
		<cfargument name="quantity" required="true" type="String" hint="quantity of the product">
		<cfargument name="categoryid" required="true" type="String" hint="category of the product">
		<cfargument name="description" required="false" type="String" default="no description" hint="description of the product">
		<cfargument name="attributes" required="false" type="String" default="" hint="list of attributes of the product">
		
		<cfquery name="addproduct" datasource="#productdsn#">
			INSERT INTO PRODUCT
			(
				ID,
				CATEGORYID,
				QUANTITY,
				DESCRIPTION,
				ATTRIBUTES
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#categoryid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#attributes#" cfsqltype="cf_sql_longvarchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addexistingproduct" access="public" hint="Add certain quantity of known product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="name of a product">
		<cfargument name="quantity" required="true" type="String" hint="quantity of the product">
	
		<cfquery name="getquantity" datasource="#productdsn#">
			SELECT QUANTITY FROM PRODUCT WHERE ID=<cfqueryparam value="#id#">
		</cfquery>
		<cfset quantity=quantity + getquantity.quantity>
		
		<cfquery name="addquantity" datasource="#productdsn#">
			UPDATE PRODUCT 
			SET QUANTITY = <cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar"> 
			WHERE ID=<CFQUERYPARAM VALUE="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="logproductadd" access="public" returntype="void" hint="I log product added">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="id of the product">
		<cfargument name="quantity" required="true" type="String" hint="Quantity of the the product being added">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the person adding log entry">
		
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		
		<cfquery name="logproduct" datasource="#productdsn#">
			INSERT INTO PRODUCTLOG
			(
				ID,
				QUANTITY,
				NAMEID,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="groupProduct" access="public" returntype="String" hint="I group product so that they can be treated as a single product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="groupid" required="true"  type="String" hint="id of the grouped product">
		<cfargument name="productid" required="true" type="String" hint="id of the product">
		<cfquery name="group" datasource="#productdsn#">
			INSERT INTO PRODUCTGROUP
			(
				ID,
				PRODUCTID
			)
			VALUES
			(
				<cfqueryparam value="#groupid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#productid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="mediaToProduct" access="public"  returntype="void" hint="I add video to product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="productfamilyid of the product">
		<cfargument name="vid" required="true" type="String" hint="vid of the video">
		
		<cfquery name="mediatoproduct" datasource="#productdsn#">
			INSERT INTO MEDIATOPRODUCT
			(
				ID,
				VID
			)
			VALUES
			(
				<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="setprice" access="public" returntype="void" hint="I set price of a product or susbscription">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="true" type="String" hint="subscriptionplanid">
		<cfargument name="pricenameid" required="true" type="String" hint="priceid of the price">
		<cfargument name="price" required="true" type="String" hint="price">
		<cfset timedate=mytime.createTimeDate()>
		<cfquery name="deactivateprice" datasource="#productdsn#">
			UPDATE PRICE
			SET ACTIVE=0
			WHERE ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">	
			AND PRICENAMEID=<cfqueryparam value="#arguments.pricenameid#" cfsqltype="cf_sql_varchar">	
		</cfquery>
		<cfquery name="setprice" datasource="#arguments.productdsn#">
			INSERT INTO PRICE
			(
				ID,
				PRICENAMEID,
				PRICE,
				TIMEDATE
			)
			VALUES
			(
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.pricenameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.price#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="createtransaction" access="public" returntype="void" hint="I create transaction">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="transactionid" required="true" type="String" hint="transactionid">
		<cfargument name="buyerid" required="true" type="String" hint="nameid of the buyer">
		<cfargument name="transactiontotal" required="true" type="String" hint="nameid of the buyer">
		<cfargument name="nameid" required="false" default="1" type="String" hint="nameid of the employee">
		
		<cfset timedate=mytime.createTimeDate()>
		
		<cfquery name="addtransaction" datasource="#productdsn#">
			INSERT INTO TRANSACTIONS
			(	
				TRANSACTIONID,
				BUYERID,
				NAMEID,
				TRANSACTIONTOTAL,
				DATETIME
			)
			VALUES
			(
				<cfqueryparam value="#transactionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#buyerid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#transactiontotal#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	<cffunction name="addsales" access="public" returntype="void" hint="I add sales record">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="productid">
		<cfargument name="transactionid" required="true" type="String" hint="transactionid">
		<cfargument name="unitprice" required="true" type="String" hint="Price of the product">
		<cfargument name="quantity" required="false" default="1" type="String" hint="quantity of the product">
		<cfargument name="discountpercent" required="false" default ="0" type="String" hint="Discount Percentage">
		<cfargument name="discount" required="false" default ="0" type="String" hint="Discount">
		<cfargument name="othercharges" required="false" default ="0" type="String" hint="other charges">
		<cfargument name="remarks" required="false" type="String" default="Sold" hint="Comments or about the sale made. remarks can be like Gift">
		<cfset var Sales=0>
		<cfset total=unitprice*quantity + discount>
		<cfquery name="Sales" datasource="#productdsn#">
			INSERT INTO SALESRECORD
			(
				ID,
				TRANSACTIONID,
				UNITPRICE,
				QUANTITY,
				DISCOUNTPERCENT,
				DISCOUNT,
				OTHERCHARGES,
				TOTAL,
				REMARKS
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#transactionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#unitprice#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#discountpercent#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#discount#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#othercharges#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#total#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#remarks#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="addDamaged" access="public" returntype="void" hint="I set a product as damaged">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="productid">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the employee">
		<cfargument name="description" required="false" type="String" default="no description" hint="short description of how the product is damaged">
		
		<cfset timedate=mytime.createTimeDate()>
		<cfquery name="adddamaged" datasource="#productdsn#">
			INSERT INTO DAMAGED
			(
				ID,
				DESCRIPTION,
				NAMEID,
				DATETIME
			)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>	
	</cffunction>
	
	<cffunction name="returnproduct" access="public" returntype="void" hint="I record products which are sold and returned">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="transactionid" required="true" type="String" hint="transactionid">
		<cfargument name="id" required="true" type="String" hint="id">
		<cfargument name="refundpercent" required="true" type="String" hint="refundpercent">
		<cfargument name="refundamount" required="true" type="String" hint="refundamount">
		<cfargument name="reasonofreturn" required="true" type="String" hint="reasonofreturn">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the person accepting return">
		
		<cfset timedate=mytime.createTimeDate()>
		
		<cfquery name="returnproduct" datasource="#productdsn#">
			INSERT INTO RETURNEDPRODUCT
			(
				TRANSACTIONID
				ID,
				REFUNDPERCENT,
				REFUNDAMOUNT,
				REASONOFRETURN,
				NAMEID,
				DATETIME
			)
			VALUES
			(
				<cfqueryparam value="#transactionid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#refundpercent#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#refundamount#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#reasonofreturn#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery> 
	</cffunction>

	<!--- Get Begins Here --->
	<cffunction name="getCategory" access="public" returntype="Query" hint="I get all the Categories">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="categoryid" required="false" type="string" default="0" hint="id of the category">
		<cfquery name="getcategory" datasource="#productdsn#">
			SELECT CATEGORYID, CATEGORY FROM PRODUCTCATEGORY
			<cfif arguments.categoryid NEQ 0>
			WHERE CATEGORYID=<cfqueryparam value="#arguments.categoryid#">
			</cfif>
		</cfquery>
		<cfreturn getcategory>
	</cffunction>
	
	<cffunction name="getPricenames" access="public" returntype="Query" hint="Get all prices">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfquery name="prices" datasource="#productdsn#">
			SELECT PRICENAMEID, PRICENAME FROM PRICENAMES
		</cfquery>
		<cfreturn prices>
	</cffunction>
	
	<cffunction name="getPrices" access="public" returntype="Query" hint="Get prices">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfargument name="pricename" required="false" type="string" hint="the name of the price you need" default="0">
		<cfset var prices=0>
		<cfquery name="prices" datasource="#productdsn#">
			SELECT PRICENAMES.PRICENAME, PRICE.PRICE
			FROM PRICE, PRICENAMES
			WHERE PRICENAMES.PRICENAMEID=PRICE.PRICENAMEID
			AND PRICE.ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			<cfif arguments.pricename neq 0>AND PRICENAME = '#arguments.pricename#'</cfif>
			AND ACTIVE=1
			ORDER BY PRICENAME
		</cfquery>
		<cfreturn prices>
	</cffunction>
	
	<cffunction name="getIdFromItemName" access="public" returntype="String" hint="Get id from itemname">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="itemname" required="false" type="String" hint="name of the product/item">
		<cfquery name="getid" datasource="#productdsn#">
			SELECT ID FROM IDPOOL WHERE ITEMNAME=<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getid.recordcount EQ 0> <cfreturn 0>
		<cfelse> <cfreturn getid.ID>
		</cfif>
	</cffunction>
	
	<cffunction name="getItemNameFromId" access="public" returntype="String" hint="Get itemname from id">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product/item">
		<cfquery name="getid" datasource="#productdsn#">
			SELECT ITEMNAME FROM IDPOOL WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getid.ITEMNAME>
	</cffunction>
	
	<cffunction name="getProduct" access="public" returntype="Query" hint="Get Products. Return fiels: ID, PRODUCTNAME,CATEGORY,QUANTITY,DESCRIPTION,ATTRIBUTES">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfargument name="itemname" required="false" type="string" hint="Name of the product">
		<cfquery name="product" datasource="#productdsn#">
			SELECT
				PRODUCT.ID,
				IDPOOL.ITEMNAME,
				IDPOOL.IDFOR,
				IDPOOL.SUBSCRIABLE,
				IDPOOL.STOPSELLING,
				PRODUCT.CATEGORYID,
				PRODUCT.QUANTITY,
				PRODUCT.DESCRIPTION,
				PRODUCT.ATTRIBUTES,
				PRODUCTCATEGORY.CATEGORY
			FROM PRODUCT, IDPOOL, PRODUCTCATEGORY
			WHERE IDPOOL.ID=PRODUCT.ID
			AND PRODUCT.CATEGORYID=PRODUCTCATEGORY.CATEGORYID
			<cfif isDefined('id')>
			AND PRODUCT.ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('itemname')>
			AND IDPOOL.ITEMNAME = <cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn product>
	</cffunction>
	
	<cffunction name="getItems" access="public" returntype="Query" hint="I get items from the Idpool">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="neededitems" required="false" type="String" hint="kind of items">
		<cfset var Items=0>
		<cfquery name="Items" datasource="#productdsn#">
			SELECT ID, IDFOR, ITEMNAME, SUBSCRIABLE, STOPSELLING FROM IDPOOL
			WHERE ID!=1
			<cfif isDefined('neededitems')>
			AND IDFOR=<cfqueryparam value="#neededitems#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		<cfreturn Items>
	</cffunction>

	<cffunction name="getSubscriable" access="public" returntype="Query" hint="I get subscriable items">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfset var subscriable=0>
		<cfquery name="subscriable" datasource="#productdsn#">
			SELECT ID, IDFOR, ITEMNAME FROM IDPOOL
			WHERE SUBSCRIABLE=1
		</cfquery>
		<cfreturn subscriable>
	</cffunction>
	
	<cffunction name="getNonSubscriable" access="public" returntype="Query" hint="I get subscriable items">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfset var nonsubscriable=0>
		<cfquery name="nonsubscriable" datasource="#productdsn#">
			SELECT ID, IDFOR, ITEMNAME FROM IDPOOL
			WHERE SUBSCRIABLE=0
		</cfquery>
		<cfreturn nonsubscriable>
	</cffunction>
		
	<cffunction name="getProductLog" access="public" returntype="Query" hint="Get Products. Return fields: ID, PRODUCTNAME, QUANTITY, NAMEID, FIRSTNAME, LASTNAME, COMPANY">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfargument name="itemname" required="false" type="string" hint="Name of the product">
		<cfargument name="category" required="false" type="String" hint="category of the product">
		<cfargument name="description" required="false" type="String" hint="description of the product">
		<cfargument name="attributes" required="false" type="String" hint="attribute of the product">
		<cfargument name="nameid" required="false" type="String" hint="nameid of the employee adding the product">
		<cfargument name="beingdate" required="false" type="String" hint="begin date">
		<cfargument name="enddate" required="false" type="String" hint="end date">
		 
		<cfquery name="productlog" datasource="#productdsn#">
			SELECT
				PRODUCTLOG.ID,
				IDPOOL.ITEMNAME,
				PRODUCTLOG.QUANTITY,
				PRODUCTLOG.TIMEDATE,
				PRODUCTCATEGORY.CATEGORY,
				PRODUCT.DESCRIPTION,
				PRODUCT.ATTRIBUTES,
				NAME.NAMEID,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				NAME.COMPANY
			FROM PRODUCT, PRODUCTLOG, NAME, IDPOOL, PRODUCTCATEGORY
			WHERE PRODUCT.ID=PRODUCTLOG.ID
			AND NAME.NAMEID=PRODUCTLOG.NAMEID
			AND PRODUCTLOG.ID=IDPOOL.ID
			AND PRODUCT.CATEGORYID=PRODUCTCATEGORY.CATEGORYID
			<cfif isDefined('nameid')>
			AND NAME.NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('id')>
			AND PRODUCTLOG.ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('productname')>
			AND PRODUCT.PRODUCTNAME LIKE <cfqueryparam value="%#productname#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('category')>
			AND PRODUCT.CATEGORY=<cfqueryparam value="%#category#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('productname')>
			AND PRODUCT.DESCRIPTION LIKE <cfqueryparam value="%#description#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('attributes')>
			AND PRODUCT.ATTRIBUTES LIKE<cfqueryparam value="%#attributes#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('begindate')>
			AND PRODUCTLOG.TIMEDATE >= <cfqueryparam value="#begindate#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('enddate')>
			AND PRODUCTLOG.TIMEDATE <=<cfqueryparam value="#enddate#" cfsqltype="cf_sql_varchar">
			</cfif>
			ORDER BY TIMEDATE DESC
		</cfquery>
		<cfreturn productlog>
	</cffunction>

	<cffunction name="getmypurchase" access="public" returntype="Query" hint="I get purchase made by a person">
		<cfargument name="productdsn" Required="true" type="String" hint="data source">
		<cfargument name="nameid" required="true" type="String" hint="name id of the person who made the purchase">
		<cfset var mypurchase=0>
		<cfquery name="mypurchase" datasource="#productdsn#">
			SELECT 
				SALESRECORD.ID, 
				IDPOOL.ITEMNAME, 
				SALESRECORD.TRANSACTIONID, 
				TRANSACTIONS.TRANSACTIONTOTAL, 
				SALESRECORD.UNITPRICE
			FROM IDPOOL, TRANSACTIONS, SALESRECORD
			WHERE IDPOOL.ID=SALESRECORD.ID
			AND TRANSACTIONS.TRANSACTIONID=SALESRECORD.TRANSACTIONID
			AND TRANSACTIONS.BUYERID = <cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn mypurchase>
	</cffunction>
	
	<cffunction name="getitemsnotincart" access="public" returntype="Query" hint="I get items not in the given cart">
		<cfargument  name="productdsn" type="string" required="true" hint="The datasource">
		<cfargument name="cartid" type="String" required="true" hint="Id of the cart">
		<cfset var products=0>
		<cfquery name="products" datasource="#productdsn#">
			SELECT
				IDPOOL.ID,
				IDPOOL.ITEMNAME,
				IDPOOL.IDFOR
			FROM IDPOOL
			WHERE 1=1
			AND (IDFOR='Product' OR IDFOR='Subscriptionplan')
			AND IDPOOL.STOPSELLING<>1
			AND IDPOOL.ID NOT IN(SELECT ID FROM CART2ITEM WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		<cfreturn products>
	</cffunction>
	<!--- <cffunction name="getProductGroup" access="public" returntype="Query" hint="Get all the products belonging to the group. Return Fields: PRODUCTID,ITEMNAME,CATEGORY,DESCRIPTION,ATTRIBUTES">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfargument name="itemname" required="false" type="String" hint="name of the item">
		<cfset var productsingroup=0>
		<cfif not isDefined('id')>
			<cfinvoke method="getIdFromItemname" returnvariable="id" productdsn="#productdsn#" itemname="#itemname#">
		</cfif>
		<cfquery name="productsingroup" datasource="#productdsn#">
			SELECT
				PRODUCTGROUP.PRODUCTID,
				IDPOOL.ITEMNAME,
				IDPOOL.SUBSCRIABLE,
				IDPOOL.STOPSELLING,
				PRODUCT.CATEGORYID,
				PRODUCT.DESCRIPTION,
				PRODUCT.ATTRIBUTES,
				PRODUCTCATEGORY.CATEGORY
			FROM PRODUCTGROUP, IDPOOL, PRODUCT, PRODUCTCATEGORY
			WHERE PRODUCTGROUP.ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			AND PRODUCTGROUP.PRODUCTID=PRODUCT.ID
			AND PRODUCTCATEGORY.CATEGORYID=PRODUCT.CATEGORYID
		</cfquery>
		<cfreturn productsingroup>
	</cffunction>	 --->

	<cffunction name="getReturnedProduct" access="public" returntype="Query" hint="Get Returned Product. Return Fields: PRODUCTID,ITEMNAME,CATEGORY,DESCRIPTION,ATTRIBUTES">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfargument name="itemname" required="false" type="String" hint="">
		<cfquery name="returnedproduct" datasource="#productdsn#">
			SELECT
				RETURNEDPRODUCT.TRANSACTIONID,
				RETURNEDPRODUCT.ID,
				RETURNEDPODUCT.RETURNEDPERCENT,
				RETURNEDPODUCT.RETURNEDAMOUNT,
				RETURNEDPODUCT.NAMEID,
				RETURNEDPODUCT.DATETIME,
				NAME.FIRSTNAME,
				NAME.LASTNAME,
				IDPOOL.ITEMNAME,
				PRODUCT.CATEGORY,
				PRODUCT.DESCRIPTION,
				PRODUCT.ATTRIBUTES
			FROM RETURNEDPRODUCT, PRODUCT, IDPOOL, NAME
			WHERE IDPOOL.ID=PRODUCT.ID
			<cfif isDefined('id')>
			AND RETURNEDPRODUCT.ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('productname')>
			AND IDPOOL.ITEMNAME=<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('category')>
			AND PRODUCT.CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('description')>
			AND PRODUCT.DESCRIPTION LIKE <cfqueryparam value="%#description#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('attributes')>
			AND PRODUCT.ATTRIBUTES LIKE <cfqueryparam value="%#attributes#%" cfsqltype="cf_sql_varchar">
			</cfif> 
		</cfquery>
		<cfreturn returnedproduct>
	</cffunction>

	<cffunction name="getGroupIDfromname" access="public" returntype="String" hint="Get groupid from name">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="groupname" required="false" type="String" hint="name of the group">
		<cfset var getgroupid=0>
		<cfset var groupid=0>
		<cfquery name="getgroupid" datasource="#productdsn#">
			SELECT ID FROM IDPOOL 
			WHERE IDFOR='grouped items' 
			AND ITEMNAME=<cfqueryparam value="#groupname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getgroupid.recordcount GT 0>
			<cfset groupid=getgroupid.ID>
		</cfif>
		<cfreturn groupid>
	</cffunction>
	
	<cffunction name="addProductGroup" access="public" output="false" returntype="void" hint="Add Product Group">
		<cfargument name="productdsn" required="true" type="string" hint="Database name">
		<cfargument name="itemname" required="true" type="string" hint="Name of the product group">
		<cfargument name="subscriable" required="false" type="string" default="0" hint="1 if the item is subscriable">
		<cfargument name="stopselling" required="false" type="string" default="0" hint="1 if the item should not be sold">
		<cfset var add=0>
		<cfquery name="add" datasource="#arguments.productdsn#">
			INSERT INTO IDPOOL
			(
				IDFOR,
				ITEMNAME,
				SUBSCRIABLE,
				STOPSELLING
			)
			VALUES
			(
				<cfqueryparam value="grouped items">,
				<cfqueryparam value="#arguments.itemname#">,
				<cfqueryparam value="#arguments.subscriable#">,
				<cfqueryparam value="#arguments.stopselling#">
			)
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getGroupMembers" access="public" returntype="Query" hint="Get groupmembers from groupname">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="groupid" required="false" type="String" hint="id of the group">
		<cfset var groupmembers=0>
		<cfquery name="groupmembers" datasource="#productdsn#">
			SELECT 	
				IDPOOL.ID, 
				IDPOOL.IDFOR, 
				IDPOOL.ITEMNAME, 
				IDPOOL.SUBSCRIABLE, 
				IDPOOL.STOPSELLING,
				PRODUCT.CATEGORYID,
				(SELECT CATEGORY FROM PRODUCTCATEGORY WHERE CATEGORYID=PRODUCT.CATEGORYID) AS CATEGORY,
				PRODUCT.DESCRIPTION,
				PRODUCT.ATTRIBUTES
			FROM IDPOOL,PRODUCT
			WHERE IDPOOL.ID IN(SELECT PRODUCTID FROM PRODUCTGROUP WHERE ID=<cfqueryparam value="#groupid#" cfsqltype="cf_sql_varchar">) 
			AND PRODUCT.ID=IDPOOL.ID
		</cfquery>
		<cfreturn groupmembers>
	</cffunction>
	
	<cffunction name="getItemsNotInGroup" access="public" returntype="query" output="false" hint="I get items not in a group">
		<cfargument name="productdsn" required="true" type="string" hint="database name">
		<cfargument name="groupid" required="true" type="string" hint="I am the id of the group">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.productdsn#">
			SELECT 
				ID,
				ITEMNAME
			FROM IDPOOL
			WHERE IDFOR=<cfqueryparam value="product">
			AND ID NOT IN(SELECT ID FROM PRODUCTGROUP WHERE ID=<cfqueryparam value="#arguments.groupid#">)	
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="removeItemFromGroup" access="public" returntype="void" output="false" hint="I remove item from group">
		<cfargument name="productdsn" required="true" type="string" hint="database name">
		<cfargument name="groupid" required="true" type="string" hint="Id of the group">
		<cfargument name="productid" required="true" type="string" hint="id of the product">
		<cfset var remove=0>
		<cfquery name="remove" datasource="#arguments.productdsn#">
			DELETE FROM PRODUCTGROUP
			WHERE ID=<cfqueryparam value="#arguments.groupid#">
			AND PRODUCTID=<cfqueryparam value="#arguments.productid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getProductsandGroups" access="public" returntype="Query" hint="Get product and productgroups">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfset var productsandGroups=0>
		<cfquery name="productsandGroups" datasource="#productdsn#">
			SELECT ID,IDFOR,ITEMNAME,SUBSCRIABLE,STOPSELLING FROM IDPOOL
			WHERE IDFOR='Product'
			OR IDFOR='grouped items'
		</cfquery>
		<cfreturn productsandGroups>
	</cffunction>
	
	<cffunction name="getProductGroups" access="public" returntype="query" hint="get grouped item">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="string" default="0" hint="id of the product group">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.productdsn#">
			SELECT ID,IDFOR,ITEMNAME,SUBSCRIABLE,STOPSELLING FROM IDPOOL
			WHERE IDFOR=<cfqueryparam value='grouped items'>
			<cfif arguments.id NEQ 0>
				AND ID = <cfqueryparam value="#arguments.id#">
			</cfif>
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="getquantity" access="public" returntype="Numeric" hint="I get the quantity of the product">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfset var productquantity=0>
		<cfquery name="productquantity" datasource="#productdsn#">
			SELECT QUANTITY FROM PRODUCT WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif productquantity.recordcount GT 0>
			<cfreturn productquantity.quantity>
		<cfelse>
			<cfreturn 1>
		</cfif>
	</cffunction>

	<cffunction name="getCoupouns" access="public" returntype="Query" hint="I get coupouns. Return fields: COUPOUN, RULEID, CREATEDON, NOOFTIMESALLOWED, STARTDATE, EXPIRESON">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="noofcoupouns" required="false"  default="0" type="String" hint="No of coupouns required">
		<cfset var coupouns=0>
		<cfquery name="coupouns" datasource="#arguments.productdsn#">
			SELECT 
			<cfif noofcoupouns NEQ 0>
			TOP #noofcoupouns#
			</cfif>
				COUPOUN.COUPOUN,
				COUPOUN.RULEID,
				COUPOUN.CREATEDON,
				COUPOUN.NOOFTIMESALLOWED,
				IFTABLE.STARTDATE,
				IFTABLE.ENDDATE AS EXPIRESON,
				(SELECT COUNT(COUPOUN) FROM COUPOUNUSED WHERE COUPOUN=COUPOUN.COUPOUN) AS NOOFTIMESUSED
			FROM COUPOUN, IFTABLE
			WHERE COUPOUN.RULEID=IFTABLE.RULEID
			ORDER BY CREATEDON DESC
		</cfquery>
		<cfreturn coupouns>
	</cffunction>
	
	<!--- <cffunction name="getSales" access="public" returntype="Query" hint="I get sales">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="startdate" required="false" type="String" hint="start date">
		<cfargument name="enddate" required="false" type="String" hint="end date">
		<cfargument name="buyerid" required="false" type="String" hint="nameid of the buyer">
		<cfargument name="sellerid" required="false" type="String" hint="nameid id of the attending employee">
		<cfargument name="category" required="false" type="String" hint="Category of the product sold">
		<cfset var sales=0>
		<cfquery name="sales">
		
		</cfquery>
		<cfreturn sales>
	</cffunction> --->
	
	<!--- Edit Begins Here --->
	<cffunction name="updateidpoolinfo" access="public" returntype="void" hint="i update idpool info">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" type="String" required="true" hint="id of the item">
		<cfargument name="itemname" type="String" required="true" hint="Name of the item">
		<cfargument name="idfor" type="String" required="false" default="-1" hint="The item for which the id is required">
		<cfargument name="stopselling" type="String" required="false"  default="-1" hint="pass 1 not to start selling this item and 0 if it is not">
		<cfset var updateidpool=0>
		<cfquery name="updateidpool" datasource="#arguments.productdsn#">
			UPDATE IDPOOL
			SET ITEMNAME=<cfqueryparam value="#arguments.itemname#" cfsqltype="cf_sql_varchar">
			<cfif arguments.idfor NEQ "-1">
			,IDFOR=<cfqueryparam value="#arguments.idfor#" cfsqltype="cf_sql_varchar">		
			</cfif>
			<cfif arguments.stopselling NEQ "-1">
			,STOPSELLING=<cfqueryparam value="#arguments.stopselling#" cfsqltype="cf_sql_varchar">		
			</cfif>
			WHERE ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="editCategory" access="public" returntype="void" hint="I update category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="categoryid" required="true" type="String" hint="category that needs to be updated">
		<cfargument name="newcategory" required="true" type="String" hint="new category">
		
		<cfquery name="editcategory" datasource="#productdsn#">
			UPDATE PRODUCTCATEGORY SET CATEGORY=<cfqueryparam value="#newcategory#" cfsqltype="cf_sql_varchar">
			WHERE CATEGORYID=<cfqueryparam value="#categoryid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getPriceName" access="public" returntype="string" hint="Price name">
		<cfargument name="productdsn" required="true" type="String" hint="database name">
		<cfargument name="pricenameid" required="true" type="String" hint="id of price name">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.productdsn#">
			SELECT PRICENAME FROM PRICENAMES 
			WHERE PRICENAMEID=<cfqueryparam value="#arguments.pricenameid#">
		</cfquery>
		<cfif get.recordcount EQ 0>
			<cfreturn ''>
		<cfelse>
			<cfreturn get.PRICENAME>
		</cfif>
	</cffunction>
	
	<cffunction name="editPriceName" access="public" returntype="void" hint="I update Price name">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="pricenameid" required="true" type="String" hint="pricenameid of the price name that needs to be updated">
		<cfargument name="newpricename" required="true" type="String" hint="new price name">
		<cfquery name="editpricename" datasource="#productdsn#">
			UPDATE PRICENAMES SET PRICENAME=<cfqueryparam value="#newpricename#" cfsqltype="cf_sql_varchar">
			WHERE PRICENAMEID=<cfqueryparam value="#pricenameid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="editproduct" access="public" returntype="void" hint="I edit product information">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="id of the product">
		<cfargument name="itemname" required="true" type="String" hint="name of the product">
		<cfargument name="categoryid" required="true" type="String" hint="category of the product">
		<cfargument name="description" required="true" type="String" hint="description of the product">
		<cfargument name="attributes" required="true" type="String"  hint="list of attributes of the product">
		<cfargument name="subscriable" required="true" type="String" hint="1 if the item is subscriable and O otherwise">
		<cfargument name="stopselling" required="true" type="String" hint="1 to stop selling this item and O otherwise">
		<cfquery name="updateproductname" datasource="#productdsn#">
			UPDATE IDPOOL 
			SET 
				ITEMNAME=<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">,
				SUBSCRIABLE=<cfqueryparam value="#subscriable#" cfsqltype="cf_sql_varchar">,
				STOPSELLING=<cfqueryparam value="#stopselling#" cfsqltype="cf_sql_varchar">
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="updateproduct" datasource="#productdsn#">
			UPDATE PRODUCT
			SET
			<cfif isDefined('categoryid')>
				CATEGORYID=<cfqueryparam value="#categoryid#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('description')>
				,DESCRIPTION=<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif isDefined('attributes')>
				,ATTRIBUTES=<cfqueryparam value="#attributes#" cfsqltype="cf_sql_varchar">
			</cfif>
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="checkCategory" access="public" output="false" returntype="boolean" hint="I check if category exists or not">
		<cfargument name="productdsn" required="true" type="string" hint="Database name">
		<cfargument name="category" required="true" type="string" hint="I am the category">
		<cfargument name="categoryid" required="false" default="0" type="string" hint="I am the id of the category">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.productdsn#">
			SELECT COUNT(*) C FROM PRODUCTCATEGORY
			WHERE CATEGORY = <cfqueryparam value="#arguments.category#">
			<cfif arguments.categoryid NEQ 0>
			AND CATEGORYID <> <cfqueryparam value="#arguments.categoryid#"> 
			</cfif>
		</cfquery>
		<cfif get.C GT 0>
			<cfreturn TRUE>
		<cfelse>
			<cfreturn FALSE>
		</cfif>
	</cffunction>
	
	<cffunction name="decreasequantity" access="public" returntype="void" hint="I decrease quantity after sales">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="id" required="true" type="String" hint="id of the product">
		<cfargument name="quantity" required="true" type="String" hint="quantity to decrease">
		<cfset var getquantity=0>
		<cfset var setquantity=0>
		
		<cfquery name="getquantity" datasource="#productdsn#">
			SELECT QUANTITY FROM PRODUCT WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset quantity=getquantity.quantity - quantity>
		
		<cfquery name="setquantity" datasource="#productdsn#">
			UPDATE PRODUCT SET QUANTITY=<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="stopselling" access="public" returntype="void" hint="I mark product to stop its sale">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfset var stopsale=0>
		<cfquery name="stosale" datasource="#productdsn#">
			UPDATE IDPOOL SET STOPSELLING =1 WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="startselling" access="public" returntype="void" hint="I mark product to make it available for sale">
		<cfargument name="productdsn" required="true" type="String" hint="Database name">
		<cfargument name="id" required="false" type="String" hint="id of the product">
		<cfset var startsale=0>
		<cfquery name="startsale" datasource="#productdsn#">
			UPDATE IDPOOL SET STOPSELLING=0 WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<!---Remove Begins Here--->
	<cffunction name="removecategory" access="public" returntype="void" hint="I remove category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="category" required="true" type="String" hint="category">
		<cfset var remove=0> 
		<cfquery name="remove" datasource="#productdsn#">
			DELETE FROM PRODUCTCATEGORY WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="removePrice" access="public" returntype="void" hint="I remove price name">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="pricename" required="true" type="String" hint="pricename">
		<cfset var remove=0> 
		<cfquery name="remove" datasource="#productdsn#">
			DELETE FROM PRICENAMES WHERE PRICENAME=<cfqueryparam value="#pricename#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<!--- Other functions --->
	<cffunction name="checkItemname" access="public" returntype="Numeric" hint="I check if the item alread exists">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="itemname" required="true" type="String" hint="name of the product">
		<cfargument name="id" required="false" type="string" default="0" hint="id of the item">
		<cfquery name="checkitem" datasource="#productdsn#">
			SELECT ID FROM IDPOOL 
			WHERE ITEMNAME=<cfqueryparam value="#itemname#" cfsqltype="cf_sql_varchar">
			<cfif arguments.id NEQ 0>
				AND ID <> <cfqueryparam value="#arguments.id#">
			</cfif>
		</cfquery>
		<cfif checkitem.recordcount GT 0>
		<cfreturn 1>
		<cfelse> <cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="createRule" access="public" returntype="String" hint="Create a new discount rule">
		<cfargument name="productdsn" required="true" type="String" hint="productdsn">
		<cfargument name="startdate" required="true" type="String" hint="date starting which the coupoun can be used">
		<cfargument name="enddate" required="true" type="String" hint="date when coupoun expires">
		<cfargument name="categoryid" required="false" default="0" type="String" hint="categoryid of a product. Needs to be passed if the rule should used only for product/subscription of this category">
		<cfargument name="videocategoryid" required="false" default="0" type="String" hint="videocategoryid of a plan subscribed. Needs to be passed if the rule should used only subscription of this video category">
		<cfargument name="id" required="false" default="-1" type="String" hint="id of the product/subscription. Needs to be passed if the rule should be used only for the product/subscription">
		<cfargument name="quantity" required="false" type="String" default="0" hint="Quantity of product/subscription required for the rule to trigger. Default is 0 which means any quantity">
		<cfargument name="totalprice" required="false" type="String" default="0" hint="Total price of the purchase that will trigger the rule">
		<cfargument name="discountcategoryid" required="false" type="String" default="0" hint="Categoryid on which discount should be applied">
		<cfargument name="discountvideocategoryid" required="false" default="0" type="String" hint="videocategoryid of a plan on which discount should be applied">
		<cfargument name="discountid" required="false" type="String" default="-1" hint="id of the product/subscription on which discount should be applied">
		<cfargument name="discountquantity" required="false" type="String" default="0" hint="quantity of product on which quantity should be applied">
		<cfargument name="discountpercent" required="false" type="String" default="0" hint="discount in percentage that should be applied. Either discountpercent or discount is required">
		<cfargument name="discount" required="false" type="String" default="0" hint="Amount that should be discounted. Either discountpercent or discount is required">
		<cfset var rule=0>
		<cfset var ruleaction=0>
		<cfquery name="rule" datasource="#arguments.productdsn#">
			INSERT INTO IFTABLE
			(
				STARTDATE,
				ENDDATE,
				TOTALPRICE,
				QUANTITY
				<cfif arguments.id NEQ -1>
				,ID
				</cfif>
				<cfif arguments.categoryid NEQ 0>
				,CATEGORYID
				</cfif>
				 <cfif arguments.videocategoryid NEQ 0>
				,VIDEOCATEGORYID
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.totalprice#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.quantity#" cfsqltype="cf_sql_varchar">
				<cfif arguments.id NEQ -1>
				,<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.categoryid NEQ 0>
				,<cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.videocategoryid NEQ 0>
				,<cfqueryparam value="#arguments.videocategoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
			SELECT @@IDENTITY AS RULEID
		</cfquery>
		
		<cfquery name="ruleaction" datasource="#arguments.productdsn#">
			INSERT INTO THENTABLE
			(
				RULEID
				<cfif arguments.discountcategoryid NEQ 0>
				,CATEGORYID
				</cfif>
				 <cfif arguments.discountvideocategoryid NEQ 0>
				,VIDEOCATEGORYID
				</cfif>
				<cfif arguments.discountid NEQ -1>
				,ID
				</cfif>
				<cfif arguments.discountquantity NEQ 0>
				,QUANTITY
				</cfif>
				<cfif arguments.discountpercent NEQ 0>
				,DISCOUNTPERCENT
				</cfif>
				<cfif arguments.discount NEQ 0>
				,DISCOUNT
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#rule.ruleid#" cfsqltype="cf_sql_varchar">
				<cfif discountcategoryid NEQ 0>
				,<cfqueryparam value="#arguments.discountcategoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif arguments.discountvideocategoryid NEQ 0>
				,<cfqueryparam value="#arguments.discountvideocategoryid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif discountid NEQ -1>
				,<cfqueryparam value="#arguments.discountid#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif discountquantity NEQ 0>
				,<cfqueryparam value="#arguments.discountquantity#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif discountpercent NEQ 0>
				,<cfqueryparam value="#arguments.discountpercent#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif discount NEQ 0>
				,<cfqueryparam value="#arguments.discount#" cfsqltype="cf_sql_varchar">
				</cfif>
			)
		</cfquery>
		<cfreturn rule.ruleid>
	</cffunction>
	<!--- coupoun part --->
	
	<cffunction name="registerCoupoun" access="public" returntype="String" hint="I register coupoun to the database">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="ruleid" required="true" type="String" hint="ruleid that will handle this coupoun">
		<cfargument name="nooftimesallowed" type="String" required="false" default="1" hint="no of times the coupoun is allowed to be used">
		<cfset var register=0>
		<cfset var getcoupouns=0>
		<cfset myVar=false>
		
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		
		<cfloop condition="myVar EQ false">	
			<cfinvoke method="createCoupoun" returnvariable="variables.coupoun">
			<cfquery name="getcoupouns" datasource="#arguments.productdsn#">
				SELECT COUPOUN FROM COUPOUN 
				WHERE COUPOUN=<cfqueryparam value="#variables.coupoun#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif getcoupouns.recordcount LTE 0><cfset myVar=true></cfif>
		</cfloop>
		<cfquery name="register" datasource="#arguments.productdsn#">
			INSERT INTO COUPOUN
			(
				COUPOUN,
				RULEID,
				CREATEDON,
				NOOFTIMESALLOWED
			)
			VALUES
			(
				<cfqueryparam value="#variables.coupoun#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.ruleid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nooftimesallowed#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		<cfreturn variables.coupoun>
	</cffunction>
	
	<cffunction name="registerCoupounUsage" access="public" returntype="void" hint="I register coupounUsage">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="coupoun" required="true" type="String" hint="coupoun code used">
		<cfargument name="nameid" required="true" type="String" hint="nameid of the person using the coupoun">
		<cfset var registerusage=0>
		
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		
		<cfquery name="registerusage" datasource="#productdsn#">
			INSERT INTO COUPOUNUSED
			(
				COUPOUN,
				TIMEDATE,
				NAMEID
			)
			VALUES
			(
				<cfqueryparam value="#arguments.coupoun#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.nameid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="checkCoupoun" access="public" returntype="String" hint="I return RULEID if the coupoun is valid, 0 if the coupoun is used for allowed number of times and -1 if the coupoun is invalid and -2 if the coupoun has expired">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="coupoun" required="true" type="String" hint="coupoun code used">
		<cfset var checkvalidity=0>
		<cfset var checkusage=0>
		<cfset var checkexpiracy=0>
		<cfinvoke component="#mytime#" method="createTimeDate" returnvariable="timedate">
		<cfquery name="checkvalidity" datasource="#arguments.productdsn#">
			SELECT RULEID, NOOFTIMESALLOWED FROM COUPOUN 
			WHERE COUPOUN = <cfqueryparam value="#arguments.coupoun#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif checkvalidity.recordcount LTE 0><cfreturn "-1"></cfif>
		
		<cfquery name="checkusage" datasource="#arguments.productdsn#">
			SELECT COUNT(COUPOUN) AS NOOFTIMESUSED FROM COUPOUNUSED
			WHERE COUPOUN = <cfqueryparam value="#arguments.coupoun#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfif checkusage.NOOFTIMESUSED GTE checkvalidity.NOOFTIMESALLOWED><cfreturn "0"></cfif>
		
		<cfquery name="checkexpiracy" datasource="#arguments.productdsn#">
			SELECT STARTDATE, ENDDATE FROM IFTABLE 
			WHERE RULEID=<cfqueryparam value="#checkvalidity.ruleid#" cfsqltype="cf_sql_varchar">
			AND STARTDATE<=<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			AND ENDDATE>=<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif checkexpiracy.recordcount LTE 0><cfreturn -2></cfif>
		
		<cfreturn checkvalidity.RULEID>
	</cffunction>
	
	<cffunction name="getDiscount" access="public" returntype="any" output="true" hint="I get discount amount">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="ruleid" required="true" type="String" hint="id of the rule which specifies discount"> 
		<cfargument name="coupoun" required="true" type="String" hint="Coupoun code">
		<cfargument name="cart" required="false" type="any" hint="cart used to calculate discount">
		<cfset var getif=0>
		<cfset var getthen=0>
		<cfset variables.totaldiscount=0>
		<cfset thecart=XmlParse(arguments.cart)>
		<cfif thecart.mycart.carttotal[1].xmltext LTE "0"><cfreturn 0></cfif>
		<cfset variables.noofitems = thecart.mycart.noofitems[1].XmlText>
		<cfset variables.cartid = thecart.mycart.cartid[1].XmlText>
		<cfobject component="newcart" name="objcart">
		<cfobject component="subscription" name="objsubscription">

		<cfquery name="getif" datasource="#arguments.productdsn#">
			SELECT 
			CATEGORYID, 
			ID, 
			QUANTITY, 
			TOTALPRICE 
			FROM IFTABLE
			WHERE RULEID=<cfqueryparam value="#arguments.ruleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="getthen" datasource="#arguments.productdsn#">
			SELECT 
			CATEGORYID, 
			VIDEOCATEGORYID, 
			ID, 
			QUANTITY, 
			DISCOUNTPERCENT, 
			DISCOUNT 
			FROM THENTABLE 
			WHERE RULEID=<cfqueryparam value="#arguments.ruleid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset variables.ID=0>
		<cfif getthen.ID NEQ "">
			<cfinvoke component="#objcart#" method="checkitemincart" cartdsn="#productdsn#" cartid="#variables.cartid#" id="#getthen.ID#" returnvariable="variables.quantity">
			<cfif variables.quantity NEQ 0>
				<cfset variables.ID=getthen.ID>
			</cfif>
		</cfif> 
		<cfset thecart.mycart.coupouncode.XmlText=arguments.coupoun>
		<!--- discount on totalprice no condition--->
		<cfif Trim(getif.categoryid) EQ "" AND Trim(getif.ID) EQ "" AND Trim(getif.Quantity) EQ "" AND getif.Totalprice LTE 0 AND Trim(getthen.ID) EQ "" AND Trim(getthen.CATEGORYID) EQ "" AND Trim(getthen.VIDEOCATEGORYID) EQ "">	
			<cfif Trim(getthen.discountpercent) NEQ 0>
				<cfset variables.discount=thecart.mycart.grosstotal[1].xmltext*getthen.discountpercent/100>
			<cfelse>
				<cfset variables.discount=getthen.DISCOUNT>
			</cfif>
			<cfset variables.totaldiscount=variables.totaldiscount + variables.discount>
			<cfset thecart.mycart.totaldiscount.XmlText=variables.totaldiscount>
			<cfset thecart.mycart.carttotal.XmlText=thecart.mycart.totaldiscount.XmlText-variables.discount>
			<cfif thecart.mycart.carttotal.XmlText LT 0>
				<cfset thecart.mycart.carttotal.XmlText=0>
			</cfif>
			<!--- discount on total price when total greater than certain value --->
		<cfelseif (Trim(getthen.ID) EQ "") AND (Trim(getthen.CATEGORYID) EQ "") AND (Trim(getthen.VIDEOCATEGORYID) EQ "") AND (XmlParse(arguments.cart).mycart.carttotal[1].XmlText GT getif.Totalprice)>
			<cfif Trim(getthen.discountpercent) NEQ 0>
				<cfset variables.discount=thecart.mycart.grosstotal[1].xmltext*getthen.discountpercent/100>
			<cfelse>
				<cfset variables.discount=getthen.DISCOUNT>
			</cfif>
			<cfset variables.totaldiscount=variables.totaldiscount + variables.discount>
		
			<cfset thecart.mycart.totaldiscount.XmlText=variables.totaldiscount>
			<cfset thecart.mycart.carttotal.XmlText=thecart.mycart.grosstotal.XmlText-variables.discount>
			<cfif thecart.mycart.carttotal.XmlText LT 0>
				<cfset thecart.mycart.carttotal.XmlText=0>
			</cfif>
			<!--- discount on certain item --->
		<cfelseif (variables.ID NEQ 0) AND (Trim(getif.ID) EQ "") AND (Trim(getif.categoryid) EQ "")  AND (Trim(getif.Quantity) EQ "0") AND (Trim(getif.Totalprice) EQ "0")  AND (Trim(getthen.CATEGORYID) EQ "") AND (Trim(getthen.VIDEOCATEGORYID) EQ "")>
			<cfset itemfound=false>
			<cfloop from="1" to="#variables.noofitems#" index="i">
				<cfif variables.ID EQ thecart.mycart.item[i].XmlAttributes.id>
					<cfset itemfound=true>
					<cfset theitem=i>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif itemfound EQ true>
				<cfif Trim(getthen.discountpercent) NEQ "">
					<cfset variables.discount=thecart.mycart.item[theitem].XmlAttributes.price*getthen.discountpercent/100>
				<cfelse>
					<cfset variables.discount=getthen.discount>
				</cfif>
				<cfset variables.totaldiscount=variables.totaldiscount + variables.discount*variables.quantity>
				<cfset thecart.mycart.totaldiscount.XmlText=variables.totaldiscount>
				<cfset thecart.mycart.carttotal.XmlText=thecart.mycart.grosstotal.XmlText-variables.discount>
				<cfif thecart.mycart.carttotal.XmlText LT 0>
					<cfset thecart.mycart.carttotal.XmlText=0>
				</cfif>
			</cfif>
			
			<!--- discount on certain videocategory --->
		<cfelseif Trim(getthen.videocategoryid) NEQ "">
			<cfset args=StructNew()>
			<cfset args.subscriptiondsn=arguments.productdsn>
			<cfset args.videocategoryid=getthen.videocategoryid>
			<cfloop from="1" to="#variables.noofitems#" index="i">
				<cfset args.id=thecart.mycart.item[i].XmlAttributes.id>
				<cfinvoke component="#objsubscription#" method="checkVideoCategoryOfPlan" argumentcollection="#args#" returnvariable="variables.result">
				<cfif variables.result EQ 1>
					<cfset variables.quantity=thecart.mycart.item[i].XmlAttributes.quantity>
					<cfif Trim(getthen.discountpercent) NEQ "">
						<cfset variables.discount=thecart.mycart.item[i].XmlAttributes.price*getthen.discountpercent/100>
					<cfelse>
						<cfset variables.discount=getthen.discount>
					</cfif>
					<cfset thecart.mycart.item[i].XmlAttributes.discount=variables.discount>
					<cfset variables.totaldiscount=variables.totaldiscount + variables.discount*variables.quantity>
				</cfif>
			</cfloop>
			<cfset thecart.mycart.totaldiscount.XmlText=variables.totaldiscount>
			<cfset thecart.mycart.carttotal.XmlText=thecart.mycart.grosstotal.XmlText-variables.totaldiscount>
			<cfif thecart.mycart.carttotal.XmlText LT 0>
				<cfset thecart.mycart.carttotal.XmlText=0>
			</cfif>
		</cfif>
		<cfif thecart.mycart.grosstotal.xmltext LT thecart.mycart.totaldiscount.XmlText>
			<cfset thecart.mycart.totaldiscount.XmlText=thecart.mycart.grosstotal.xmltext>
		</cfif>
		<cfreturn thecart>
	</cffunction>
	
	<cffunction name="createCoupoun" access="private" returntype="String" hint="I create coupoun">
		<cfset coupoun="">
		<!--- CREATE A RANDOM 16 LETTER STRING WHICH IS NOT IN COUPOUN TABLE --->
		<cfloop index="i" from="1" to="16" step="1">
			<cfset a = randrange(48,90)>
			<cfif (#a# gt 57 and #a# lt 65)>
		        <cfset coupoun = coupoun & "E">
		    <cfelse>
		        <cfset coupoun=coupoun & chr(a)>
		    </cfif>
		</cfloop>
		<cfreturn coupoun>
	</cffunction>
	
	<cffunction name="getCoupounUsage" access="public" returntype="Query" hint="I get coupoun usage. Return fields: COUPOUN, TIMEDATE, NAMEID, FIRSTNAME, LASTNAME">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="coupoun" required="true" type="String" hint="coupoun code used">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.productdsn#">
			SELECT 
				COUPOUNUSED.COUPOUN,
				COUPOUNUSED.TIMEDATE,
				COUPOUNUSED.NAMEID, 
				NAME.FIRSTNAME,
				NAME.LASTNAME
			FROM COUPOUNUSED, NAME
			WHERE COUPOUNUSED.NAMEID=NAME.NAMEID
			AND COUPOUNUSED.COUPOUN=<cfqueryparam value="#arguments.coupoun#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn get>
	</cffunction>
<!---
	<cffunction name="" access="public" returntype="" hint="">
	
	</cffunction> 		
	<cffunction name="addstatus" access="public" returntype="void" hint="I add product category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="status" required="true" type="String" hint="Category a product may belong to">
		<cfquery name="addproductstatus" datasource="#productdsn#">
			INSERT INTO PRODUCTSTATUS
			(
				STATUS
			)
			VALUES
			(
				<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addproductattribute" access="public" returntype="numeric" hint="I add attributes to product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productid" required="true" type="String" hint="productid">
		<cfargument name="attributename" required="true" type="String" hint="product attribute">
		<cfargument name="attributevalue" required="true" type="String" hint="value of the attribute">
		<cfargument name="additionalprice" required="false" default="0" type="String" hint="additional price for product with the attribute">
		<cfquery name="addproductattribute" datasource="#productdsn#">
			INSERT INTO PRODUCTATTRIBUTES
			(
				PRODUCTID,
				ATTRIBUTENAME,
				ATTRIBUTEVALUE,
				ADDITIONALPRICE
			)
			VALUES
			(
				<cfqueryparam value="#productid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#attributename#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#attributevalue#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#additionalprice#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	
	
	

	<cffunction name="addattributevaluelist" access="public" returntype="numeric" hint="I add attribute value list for an attribute">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="attributename" required="true" type="String" hint="name of the attribute">
		<cfargument name="valuelist" required="true" type="String" hint="list of attributes values for an attribute">
		<cfquery name="addattributevaluelist" datasource="#productdsn#">
			INSERT INTO ATTRIBUTEVALUELIST
			(
				ATTRIBUTENAME,
				ATTRIBUTEVALUELIST NVARCHAR
			)
			VALUES
			(
				<cfqueryparam value="#attributename#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#attributevaluelist#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>

	
	
	<cffunction name="assignnewproductid" access="public" returntype="void" hint="I map old productid with new productid">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productid" required="true" type="String" hint="productid">
		<cfargument name="newproductid" required="true" type="String" hint="newproductid">
		<cfquery name="newproductid" datasource="#productdsn#">
			INSERT INTO NEWPRODUCTID
			(
				NEWPRODUCTID,
				OLDPRODUCTID,
				DATETIME
			)
			VALUES
			(
				<cfqueryparam value="#newproductid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#productid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	
	<cffunction name="getVideos" access="public"  returntype="Query" hint="I add video to product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="productfamilyid of the product">
		<cfquery name="getVideos" datasource="#productdsn#">
			SELECT 
			VIDEO_TO_PRODUCT.VID,
			VIDEOLIB.TITLE,
			VIDEOLIB.CAPTION,
			VIDEOLIB.STATUS,
			VIDEOLIB.KEYWORDS,
			VIDEOLIB.IMAGEPATH
			FROM VIDEO_TO_PRODUCT, VIDEOLIB
			WHERE PRODUCTFAMILYID=<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
			AND VIDEO_TO_PRODUCT.VID=VIDEOLIB.VID
		</cfquery>
		<cfreturn getVideos>
	</cffunction>
	
	<cffunction name="getStatus" access="public" returntype="Query" hint="I get all the status">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfquery name="getstatus" datasource="#productdsn#">
			SELECT STATUS FROM PRODUCTSTATUS
		</cfquery>
		<cfreturn getStatus>
	</cffunction>
	
	
	
	<cffunction name="getallproducts" access="public" returntype="Query" hint="I get product information">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfquery name="getproducts" datasource="#productdsn#">
			SELECT
				PRODUCTFAMILY.PRODUCTFAMILYID,
				PRODUCTFAMILY.PRODUCTNAME,
				PRODUCTFAMILY.CATEGORY,
				PRODUCTFAMILY.DESCRIPTION,
				(SELECT COUNT(PRODUCTFAMILYID) FROM PRODUCT WHERE PRODUCTFAMILYID=PRODUCTFAMILY.PRODUCTFAMILYID AND STATUS='good') as ITEMSINSTOCK,
				(SELECT TOP 1 PRICE FROM PRODUCTPRICE WHERE PRODUCTFAMILYID=PRODUCTFAMILY.PRODUCTFAMILYID ORDER BY TIMEDATE DESC) as PRICE
			FROM PRODUCTFAMILY
			WHERE PRODUCTFAMILY.PRODUCTFAMILYID IN (SELECT DISTINCT PRODUCTFAMILYID FROM PRODUCT WHERE STATUS='good')
		</cfquery>
		<cfreturn getproducts>
	</cffunction>
	
	<cffunction name="getproduct" access="public" returntype="Query" hint="I get product information">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="product family id">
		<cfquery name="getproducts" datasource="#productdsn#">
			SELECT
				PRODUCTFAMILY.PRODUCTFAMILYID,
				PRODUCTFAMILY.PRODUCTNAME,
				PRODUCTFAMILY.CATEGORY,
				PRODUCTFAMILY.DESCRIPTION,
				PRODUCTFAMILY.ATTRIBUTELIST,
				(SELECT TOP 1 PRICE FROM PRODUCTPRICE WHERE PRODUCTFAMILYID=PRODUCTFAMILY.PRODUCTFAMILYID ORDER BY TIMEDATE DESC) as PRICE
			FROM PRODUCTFAMILY
			WHERE PRODUCTFAMILY.PRODUCTFAMILYID = <cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getproducts>
	</cffunction>

	<cffunction name="getproductsfromfamily" access="public" returntype="Query" hint="I get all products in a family">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="product family id">
		<cfquery name="getproductfamily" datasource="#productdsn#">
			SELECT 
				PRODUCTID,
				STATUS
			FROM PRODUCT
			WHERE PRODUCTFAMILYID=<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
			AND STATUS <> 'SOLD'
		</cfquery>
		<cfreturn getproductfamily>
	</cffunction>
	
	<cffunction name="getproductid" access="public" returntype="numeric" hint="I get productfamilyid from product name">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productname" required="true" type="String" hint="product name">
		<cfquery name="getproductid" datasource="#productdsn#">
			SELECT PRODUCTID FROM PRODUCT
			WHERE PRODUCTNAME=<cfqueryparam value="#productname#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif getproductid.recordcount GT 0>
			<cfreturn getproductid.id>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getmaxproductid" access="public" returntype="numeric" hint="I get maximum product id">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfquery name="getmax" datasource="#productdsn#">
			SELECT TOP 1 PRODUCTID FROM PRODUCT ORDER BY PRODUCTID DESC
		</cfquery>
		<cfreturn getmax.PRODUCTID>
	</cffunction>
	<cffunction name="getAttributeList" access="public" returntype="String" hint="I get list of attributes for a product family">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="productfamilyid of the product">
		<cfquery name="getattributes" datasource="#productdsn#">
			SELECT ATTRIBUTELIST FROM PRODUCTFAMILY
			WHERE PRODUCTFAMILYID=<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif (getattributes.recordcount NEQ 0) and getattributes.attributelist NEQ  "">
			<cfreturn getattributes.ATTRIBUTELIST>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

	<cffunction name="getproductfamilyidfromproductid" access="public" returntype="numeric" hint="I get maximum productid">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productid" required="true" type="String" hint="productid">
		<cfquery name="getproductfamilyid" datasource="#productdsn#">
			SELECT PRODUCTFAMILYID FROM PRODUCT 
			WHERE PRODUCTID=<cfqueryparam value="#productid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn getproductfamilyid.productfamilyid>
	</cffunction>

	<cffunction name="editStatus" access="public" returntype="String" hint="I update status">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="status" required="true" type="String" hint="Status">
		<cfargument name="newstatus" required="true" type="String" hint="new Status">
		<cftry>
			<cfquery name="editstatus" datasource="#productdsn#">
				UPDATE PRODUCTSTATUS SET STATUS=<cfqueryparam value="#newstatus#" cfsqltype="cf_sql_varchar">
				WHERE STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfcatch type="any">
				<cfreturn "Error">
			</cfcatch>
		</cftry>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="editCategory" access="public" returntype="String" hint="I update category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="category" required="true" type="String" hint="category that needs to be updated">
		<cfargument name="newcategory" required="true" type="String" hint="new category">
		<cftry>
			<cfquery name="editcategory" datasource="#productdsn#">
				UPDATE PRODUCTCATEGORY SET CATEGORY=<cfqueryparam value="#newcategory#" cfsqltype="cf_sql_varchar">
				WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfcatch type="any">
				<cfreturn "Error">
			</cfcatch>
		</cftry>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="editproduct" access="public" returntype="String" hint="I edit product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="productfamilyid">
		<cfargument name="productname" required="true" type="String" hint="name of the product">
		<cfargument name="category" required="true" type="String" hint="category of the product">
		<cfargument name="description" required="false"  default="" type="String" hint="description of the product"> 
		<cfargument name="attributelist" required="false"  default="" type="String" hint="attributes of the product">
		<cfquery name="editproduct" datasource="#productdsn#">
			UPDATE PRODUCTFAMILY
			SET 
				PRODUCTNAME=<cfqueryparam value="#productname#" cfsqltype="cf_sql_varchar">,
				CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">,
				DESCRIPTION=<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
				ATTRIBUTELIST=<cfqueryparam value="#attributelist#" cfsqltype="cf_sql_varchar">
			WHERE PRODUCTFAMILYID=<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
		</cfquery> 
	</cffunction>
	
	<cffunction name="editproductstatus" access="public" returntype="void" hint="I update status of a product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productid" required="true" type="String" hint="Id of a product">
		<cfargument name="status" required="True" type="String" hint="new status of the product">
		<cfquery name="setproductstatus" datasource="#productdsn#">
			UPDATE PRODUCT
			SET STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
			WHERE PRODUCTID=<cfqueryparam value="#productid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="removeStatus" access="public" returntype="String" hint="I remove status">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="status" required="true" type="String" hint="Status">
		<cftry>
		<cfquery name="removestatus" datasource="#productdsn#">
			DELETE FROM PRODUCTSTATUS WHERE STATUS=<cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfcatch type="any">
			<cfreturn "Error">
		</cfcatch>
		</cftry>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="removecategory" access="public" returntype="String" hint="I remove category">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="category" required="true" type="String" hint="category">
		<cftry>
		<cfquery name="removecategory" datasource="#productdsn#">
			DELETE FROM PRODUCTCATEGORY WHERE CATEGORY=<cfqueryparam value="#category#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfcatch type="any">
			<cfreturn "Error">
		</cfcatch>
		</cftry>
		<cfreturn "Success">
	</cffunction>

	<cffunction name="removeVideo" access="public"  returntype="void" hint="I add video to product">
		<cfargument name="productdsn" required="true" type="String" hint="datasource">
		<cfargument name="productfamilyid" required="true" type="String" hint="productfamilyid of the product">
		<cfargument name="vid" required="true" type="String" hint="vid of the video">
		
		<cfquery name="videotoproduct" datasource="#productdsn#">
			DELETE FROM VIDEO_TO_PRODUCT
			WHERE PRODUCTFAMILYID=<cfqueryparam value="#productfamilyid#" cfsqltype="cf_sql_varchar">
			AND VID=<cfqueryparam value="#vid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

 --->
</cfcomponent>