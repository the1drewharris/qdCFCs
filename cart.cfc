<cfcomponent hint="cart - functions">
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">

	<cffunction name="createtables">
	<cfargument name="ds" required="true" type="string" hint="datasource for the building of these tables">
		<cfquery name="dropandcreate" datasource="#ds#">
			DROP TABLE CART2ITEM;
			DROP TABLE CARTOWNER;
			DROP TABLE CART;
			
			CREATE TABLE CART
			(
				CARTID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
				CREATEDBY BIGINT NOT NULL,
				REPID BIGINT,
				ACTIVE BIT NOT NULL DEFAULT 1
			)
			ALTER TABLE CART ADD FOREIGN KEY CART(CREATEDBYID) REFERENCES NAME(NAMEID);
			ALTER TABLE CART ADD FOREIGN KEY CART(REPID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE CART2ITEM
			(
				CARTID BIGINT NOT NULL,
				ITEMID BIGINT NOT NULL
			)
			ALTER TABLE CART2ITEM ADD FOREIGN KEY CART2ITEM(CARTID) REFERENCES CART(CARTID);
			ALTER TABLE CART2ITEM ADD FOREIGN KEY CART2ITEM(ITEMID) REFERENCES CART(ITEMID);
		</cfquery>
	</cffunction>
	
	<cffunction name="getCartidByCreatedbyid" returntype="String" access="public" hint="I get the cartid for the createdbyid passed to me"> 
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="createdbyid" type="string" required="true" hint="id of the person who created the cart">
		<cfquery name="getMyCart" datasource="#cartdsn#" maxrows="1">
			SELECT CARTID
			FROM CART
			WHERE CREATEDBYID=<cfqueryparam value="#createdbyid#">
			AND ACTIVE=1
		</cfquery>
		<cfset myCartid=getMyCart.cartid>
		<cfreturn myCartid>
	</cffunction>
	
	<cffunction name="getCart" returntype="any" access="public" hint="I get all of the cart data for the cartid passed to me">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">	
		<cfargument name="cartid" type="String" required="true" hint="The id of the cart you want to get">	
		<cfquery name="viewcart" datasource="#cartdsn#">
				SELECT
					CART.CARTID,
					CART.TRANSACTIONID,
					ITEM.PRODUCTID,
					ITEM.QUANTITY,
					ITEM.CREATEDTIME,
					PRODUCT.PRODUCTNAME,
					PRODUCT.PRICE,
					PRODUCT.SALEPRICE,
					PRODUCT.SALESTARTDAY,
					PRODUCT.SALEENDDAY,
					PRODUCT.SHORTDESCRIPTION,
					PRODUCT.IMAGEID,
					PRODUCT.KEYWORDS,
					PRODUCT.DESCRIPTION,
					PRODUCT.QUANTITYONHAND,
					PRODUCT.PRODUCTTYPE,
					PRODUCT.PARENTPRODUCTID
				FROM PRODUCT, ITEM, CART
				WHERE ITEM.CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
				AND ITEM.PRODUCTID=PRODUCT.PRODUCTID 
				AND ITEM.CARTID=CART.CARTID
				AND CART.ACTIVE=1
			</cfquery>
			<cfset carttotal = 0>
			<cfxml variable="mycart">
			<mycart>
				<cfoutput><cartid>#viewcart.cartid#</cartid>
				<transactionid>#viewcart.transactionid#</transactionid></cfoutput>
				<cfoutput query="viewcart">
					<item 
						productname="#productname#"
						productid="#productid#" 
						quantity="#quantity#"
						shortdescription="#shortdescription#"
						imageid="#imageid#"
						keywords="#keywords#"
						quantityonhand="#quantityonhand#"
						producttype="#producttype#"
						parentproductid="#PARENTPRODUCTID#"
					<cfif SALESTARTDAY LTE #timedate# and SALEENDDAY GTE #timedate# and SALEPRICE NEQ "" AND SALEPRICE NEQ 0>
						<cfset itemprice=saleprice>
						price="#saleprice#" saleendday="#saleendday#">
					<cfelse>
						<cfset itemprice=price>
						price="#price#">
					</cfif>
					#description#
					</item>
					<cfset carttotal = carttotal + itemprice*quantity>
				</cfoutput>
				<cfoutput><carttotal>#carttotal#</carttotal></cfoutput>
			</mycart>
			</cfxml>
		<cfreturn mycart>
	</cffunction>
	
	<cffunction name="createcart" returntype="String" access="public" hint="Creates a new cart and returns an id of the cart"> 
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="createdbyid" type="string" required="true" hint="id of the person who created the cart">
		<cfargument name="repid" type="string" required="false" hint="id of the representative who is selling the items">
		<cfquery name="createcart" datasource="#cartdsn#">
			INSERT INTO CART
			(
				CREATEDBYID
				<cfif isdefined('repid')>
				,REPID
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#createdbyid#" cfsqltype="cf_sql_bigint">
				<cfif isdefined('repid')>
				,<cfqueryparam value="#repid#">
				</cfif>
			)
			SELECT @@IDENTITY AS CARTID
		</cfquery>
		<cfreturn createcart.CARTID>
	</cffunction>
	
	<cffunction name="additem" returntype="void" access="public" hint="Adds and item to the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="productid" type="String" required="true" hint="Id of the product typing to buy">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfargument name="quantity" type="string" required="false" default=1 hint="Quantity of the item trying to buy">
		
		<cfquery name="checkproduct" datasource="#cartdsn#">
			SELECT 
				PRODUCTID
			FROM
				PRODUCT
			WHERE PRODUCTID=<cfqueryparam value="#productid#">
		</cfquery>
		
		<cfif checkproduct.recordcount gt 0>
			<cfquery name="checkitem" datasource="#cartdsn#">
				SELECT 
					QUANTITY
				FROM ITEM
				WHERE
				CARTID='#cartid#' 
				AND PRODUCTID=<cfqueryparam value="#productid#">	
			</cfquery>
			
			<cfif checkitem.recordcount eq 0>
			<cfquery name="additemtocart" datasource="#cartdsn#">
				INSERT INTO ITEM
				(
					PRODUCTID,
					CARTID,
					QUANTITY,
					CREATEDTIME
					
				)
				VALUES
				(
					<cfqueryparam value="#productid#">,
					<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#quantity#" cfsqltype="cf_sql_bigint">,
					<cfqueryparam value="#timedate#">
				)
			</cfquery>
			<cfelse>
			<cfset quantity=checkitem.QUANTITY + quantity>
				<cfquery datasource="#cartdsn#" name="updateQty">
					UPDATE ITEM
					SET 
						QUANTITY=<cfqueryparam value="#quantity#" cfsqltype="cf_sql_bigint">
					WHERE
					CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
					AND PRODUCTID=<cfqueryparam value="#productid#" cfsqltype="cf_sql_bigint">
				</cfquery>
			</cfif>
		</cfif>
		
	</cffunction>
	
	<cffunction name="updatequantity" returntype="void" access="public" hints="I update the quantities">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="productid" type="String" required="true" hint="Id of the product typing to buy">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfargument name="quantity" type="string" required="false" default=1 hint="Quantity of the item trying to buy">
			<cfquery datasource="#arguments.cartdsn#" name="updateQty">
				UPDATE ITEM
				SET 
					QUANTITY=<cfqueryparam value="#arguments.quantity#" cfsqltype="cf_sql_bigint">
				WHERE
				CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_bigint">
				AND PRODUCTID=<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_bigint">
			</cfquery>
	</cffunction>
	
	<cffunction name="removeitem" returntype="void" access="public" hints="Removes an item from the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart from where item is to be removed">
		<cfargument name="productid" type="string" required="true" hint="ID of the product to be removed from cart"> 
		<cfargument name="quantity" type="string" required="false" default=1 hint="Quantity of the number of items to be removed">
		
		
		<cfquery name="checkitem" datasource="#cartdsn#">
			SELECT 
				QUANTITY
			FROM ITEM
			WHERE
			CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint"> 
			AND PRODUCTID=<cfqueryparam value="#productid#">	
		</cfquery>
		
		<cfif checkitem.QUANTITY gt quantity>
			<cfset quantity=checkitem.QUANTITY-quantity>
			<cfquery name="updatequantity" datasource="#cartdsn#">
				UPDATE ITEM
				SET
					QUANTITY=<cfqueryparam value="#quantity#" cfsqltype="cf_sql_bigint">
				WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint"> 
				AND PRODUCTID=<cfqueryparam value="#productid#">
			</cfquery>
			
		<cfelseif quantity gte checkitem.QUANTITY>
		<cfquery name="removeitem" datasource="#cartdsn#">
			DELETE FROM ITEM
			WHERE
			CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint"> 
			AND PRODUCTID=<cfqueryparam value="#productid#">
		</cfquery>
		</cfif>
		
		
	</cffunction>
	
	<cffunction name="deletecart" returntype="void" access="public" hints="Deletes the whole cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart trying to delete">
		<cfquery name="deletecart" datasource="#cartdsn#">
			UPDATE CART 
			SET 
			ACTIVE=0
			WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="iscartactive" returntype="binary" access="public" hint="Finds out it the cart is currently active">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart which is to be checked">
		<cfquery name="isactive" datasource="#cartdsn#">
			SELECT
				ACTIVE
			FROM 
				CART
			WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfreturn isactive.ACTIVE>
	</cffunction>	
</cfcomponent>