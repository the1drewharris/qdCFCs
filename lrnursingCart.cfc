<cfcomponent hint="cart - functions">
	<cfset timedate = "#DateFormat(Now(),'yyyymmdd')##timeformat(now(),'HHmmss')##Right(GetTickCount(), 2)#">

	<cffunction name="droptables">
		<cfquery name="drop" datasource="#cartdsn#">
			DROP TABLE CART2ITEM;
			DROP TABLE CARTOWNER;
			DROP TABLE CART;
		</cfquery>
	</cffunction>
	
	<cffunction name="createtables">
		<cfquery name="create" datasource="#cartdsn#">
			CREATE TABLE CART
			(
				CARTID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
				REPID BIGINT,
				CREATEDON VARCHAR(16) NOT NULL,
				ACTIVE BIT NOT NULL DEFAULT 1
			)
			ALTER TABLE CART ADD FOREIGN KEY (REPID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE CARTOWNER
			(
				CARTID BIGINT NOT NULL PRIMARY KEY,
				NAMEID BIGINT NOT NULL
			)
			ALTER TABLE CARTOWNER ADD FOREIGN KEY (CARTID) REFERENCES CART(CARTID);
			ALTER TABLE CARTOWNER ADD FOREIGN KEY (NAMEID) REFERENCES NAME(NAMEID);
			
			CREATE TABLE CART2ITEM
			(
				CARTID BIGINT NOT NULL,
				ID BIGINT NOT NULL,
				QUANTITY BIGINT NOT NULL
			)
			ALTER TABLE CART2ITEM ADD PRIMARY KEY (CARTID, ID);
			ALTER TABLE CART2ITEM ADD FOREIGN KEY (CARTID) REFERENCES CART(CARTID);
			ALTER TABLE CART2ITEM ADD FOREIGN KEY (ID) REFERENCES IDPOOL(ID);
		</cfquery>
	</cffunction>

	<cffunction name="getallcarts" access="public" returntype="query" output="false" hint="I get all the active carts">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfset var allcarts=0>
		<cfquery name="allcarts" datasource="#cartdsn#">
		 	SELECT 
		 		CART.CARTID, 
		 		CARTOWNER.NAMEID, 
		 		NAME.FIRSTNAME, 
		 		NAME.LASTNAME, 
		 		CART.CREATEDON, 
		 		CART.REPID
		 	FROM CART, CARTOWNER, NAME
		 	WHERE CART.ACTIVE=1
		 	AND CARTOWNER.NAMEID=NAME.NAMEID
		 	AND CARTOWNER.CARTID=CART.CARTID
		 	ORDER BY CART.CARTID DESC
		</cfquery>
		<cfreturn allcarts>
	</cffunction>
	
	<cffunction name="getCartByCreatedbyid" returntype="any" access="public" output="false" hint="I get the cartid for the createdbyid passed to me"> 
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="nameid" type="string" required="true" hint="id of the person who created the cart">
		<cfset var getMyCart=0>
		<cfquery name="getMyCart" datasource="#cartdsn#" maxrows="1">
			SELECT TOP 1 CARTOWNER.CARTID
			FROM CARTOWNER, CART
			WHERE CARTOWNER.NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			AND CARTOWNER.CARTID=CART.CARTID
			AND CART.ACTIVE=1
			ORDER BY CARTOWNER.CARTID DESC
		</cfquery>
		<cfif getMyCart.recordcount GT 0>
			<cfinvoke method="getCart" cartdsn="#cartdsn#" cartid="#getMyCart.cartid#" returnvariable="myxml">
			<cfreturn myxml>
		</cfif>
		<cfreturn "Error">
	</cffunction>
	
	<cffunction name="getCart" returntype="any" access="public" output="false" hint="I get all of the cart data for the cartid passed to me">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">	
		<cfargument name="cartid" type="String" required="true" hint="The id of the cart you want to get">	
		<cfargument name="pricename" type="String" false default="Retail" hint="Price name to be applied">
		<cfset var viewcart=0>
		<cfquery name="viewcart" datasource="#cartdsn#">
			SELECT
				CART2ITEM.ID,
				CART2ITEM.QUANTITY,
				CART.CREATEDON,
				IDPOOL.ITEMNAME,	
				IDPOOL.IDFOR,
				(SELECT PRICE FROM PRICE, PRICENAMES
				WHERE PRICENAMES.PRICENAME=<cfqueryparam value="#pricename#" cfsqltype="cf_sql_varchar">
				AND PRICENAMES.PRICENAMEID=PRICE.PRICENAMEID
				AND PRICE.ID=CART2ITEM.ID
				AND PRICE.ACTIVE=1) AS UNITPRICE
			FROM IDPOOL, CART2ITEM, CART
			WHERE CART.CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
			AND CART2ITEM.CARTID=CART.CARTID
			AND CART2ITEM.ID=IDPOOL.ID
			AND CART.ACTIVE=1
			</cfquery>
			<cfset carttotal = 0>
			<cfxml variable="mycart">
			<mycart>
				<cfoutput><cartid>#cartid#</cartid></cfoutput>
				<cfoutput><Noofitems>#viewcart.recordcount#</Noofitems></cfoutput>
				<cfoutput query="viewcart">
					<item 
						itemname="#XmlFormat(itemname)#"
						id="#id#" 
						quantity="#quantity#"
						itemtype="#idfor#"
						price="#unitprice#"
						discount="0"
						amount="#unitprice*quantity#">
					</item>
					<cfset carttotal = carttotal + unitprice*quantity>
				</cfoutput>
				<cfoutput>
					<noofitems>#viewcart.recordcount#</noofitems>
					<grosstotal>#carttotal#</grosstotal>
					<coupouncode>0</coupouncode>
					<totaldiscount>0</totaldiscount>
					<carttotal>#carttotal#</carttotal>
				</cfoutput>
			</mycart>
			</cfxml>
		<cfreturn mycart>
	</cffunction>
	
	<cffunction name="createcart" returntype="String" access="public" output="false" hint="Creates a new cart and returns an id of the cart"> 
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="repid" type="string" required="false" hint="id of the representative who is selling the items">
		<cfset var create=0>
		<cfquery name="create" datasource="#cartdsn#">
			INSERT INTO CART
			(
				CREATEDON
				<cfif isdefined('repid')>
				,repid
				</cfif>
			)
			VALUES
			(
				<cfqueryparam value="#timedate#" cfsqltype="cf_sql_varchar">
				<cfif isdefined('repid')>
				,<cfqueryparam value="#repid#">
				</cfif>
			)
			SELECT @@IDENTITY AS CARTID
		</cfquery>
		<cfreturn create.CARTID>
	</cffunction>
	
	<cffunction name="setcartowner" returntype="void" access="public" output="false" hint="I assign cart to a owner">
		<cfargument  name="cartdsn" type="String" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="String" required="true" hint="The id of the cart you want to get">
		<cfargument name="nameid" type="string" required="true" hint="id of the person who created the cart">
		<cfquery name="cartowner" datasource="#cartdsn#">
			INSERT INTO CARTOWNER
			(
				CARTID,
				NAMEID
			)
			VALUES
			(
				<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#nameid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="addproduct" returntype="String" access="public" hint="Adds product item to the cart" output="false">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="id" type="String" required="true" hint="Id of the product">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfargument name="quantity" type="string" required="false" default=1 hint="Quantity of the item trying to buy">
		
		<cfset var stock=0>
		<cfset var check=0>
		<cfset var total=0>
		
		<!--- get the quantity in stock --->
		<cfquery name="stock" datasource="#cartdsn#">
			SELECT QUANTITY FROM PRODUCT
			WHERE ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- return error if quantity is 0 --->
		<!--- <cfif stock.quantity EQ 0 OR stock.quantity EQ ""> <cfreturn "Error"> </cfif> --->
		
		<!--- get the quantity of the item if the item is already in the cart --->
		<cfquery name="check" datasource="#cartdsn#">
			SELECT QUANTITY FROM CART2ITEM
			WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">
			AND ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- set the value of total --->
		<cfif check.quantity GT 0>
			<cfset total=check.quantity + arguments.quantity> 
		<cfelse> 
			<cfset total=arguments.quantity> 
		</cfif>
		
		<!--- <cfif total GT stock.quantity><cfreturn "Error"></cfif> ---> <!--- return error if total is GT items in stock --->
		
		<!--- If no error --->
		<cfif check.recordcount GT 0> <!--- increase number if item is already in the cart--->
			<cfquery name="add" datasource="#cartdsn#">
				UPDATE CART2ITEM SET QUANTITY=<cfqueryparam value="#total#" cfsqltype="cf_sql_varchar">
				WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">
				AND ID=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse> <!--- add new entry --->
			<cfquery name="add" datasource="#cartdsn#">
				INSERT INTO CART2ITEM
				(
					CARTID,
					ID,
					QUANTITY
				)
				VALUES
				(
					<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.quantity#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfif>	
		<cfreturn "Success">	
	</cffunction>
	
	<cffunction name="addproductgroup" returntype="String" access="public" hint="Adds product group to the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="id" type="String" required="true" hint="Id of the product">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfset var addgroup=0>
		
		<cfset var check=0>
		<cfset var total=0>
		
		<!--- get the quantity of the group if the item is already in the cart --->
		<cfquery name="check" datasource="#cartdsn#">
			SELECT QUANTITY FROM CART2ITEM
			WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
			AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- set the value of total --->
		<cfif check.quantity GT 0>
			<cfset total=check.quantity + 1> 
		<cfelse> 
			<cfset total=1> 
		</cfif>
		
		<cfif check.recordcount GT 0> <!--- increase number if item is already in the cart--->
			<cfquery name="add" datasource="#cartdsn#">
				UPDATE CART2ITEM SET QUANTITY=<cfqueryparam value="#total#" cfsqltype="cf_sql_varchar">
				WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
				AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse> <!--- add new entry --->
			<cfquery name="add" datasource="#cartdsn#">
				INSERT INTO CART2ITEM
				(
					CARTID,
					ID,
					QUANTITY
				)
				VALUES
				(
					<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					1
				)
			</cfquery>
		</cfif>	
		<cfreturn "Success">	
	</cffunction>
	
	<cffunction name="addsubscription" returntype="String" access="public" hint="Adds subscription item to the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart">
		<cfargument name="id" type="string" required="true" hint="ID of the product">
		<cfset var check=0>
		<cfset var checkitem=0>
		<cfquery name="checkitem" datasource="#cartdsn#">
			SELECT IDFOR FROM IDPOOL WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif checkitem.idfor NEQ "Subscriptionplan"><cfreturn "Error"></cfif>
		<cfquery name="check" datasource="#cartdsn#">
			SELECT ID FROM CART2ITEM 
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			AND CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif check.recordcount GT 0> <cfreturn "Error">
		<cfelse>
			<cfquery name="add" datasource="#cartdsn#">
				INSERT INTO CART2ITEM
				(
					CARTID,
					ID,
					QUANTITY
				)
				VALUES
				(
					<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					1
				)
			</cfquery>
		</cfif>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="removeitem" returntype="string" access="public" output="false" hints="Removes an item from the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart from where item is to be removed">
		<cfargument name="id" type="string" required="true" hint="ID of the product to be removed from cart"> 
		<cfargument name="quantity" type="string" required="false" default=1 hint="Quantity of the number of items to be removed">
		
		<cfset var check=0>
		<cfset var x=0>
		<cfquery name="check" datasource="#cartdsn#">
			SELECT QUANTITY FROM CART2ITEM WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_bigint">
			AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_bigint">
		</cfquery>
		<cfif check.recordcount GT 0> 
			<cfoutput>#check.quantity#</cfoutput>
			<cfset quantity=check.quantity-quantity>
			<cfoutput>#quantity#</cfoutput>
			<cfif quantity LT 0><cfreturn "Error">
			<cfelseif quantity EQ 0>
				<cfquery name="remove" datasource="#cartdsn#">
					DELETE FROM CART2ITEM WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
					AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
				</cfquery> 
			<cfelse>
				<cfquery name="remove" datasource="#cartdsn#">
					UPDATE CART2ITEM SET QUANTITY=<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">
					WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
					AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
				</cfquery> 
			</cfif>
		<cfelse><cfreturn "Error">
		</cfif>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="deletecart" returntype="void" access="public" hints="Deletes the whole cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="ID of the cart trying to delete">
		<cfquery name="deletecart" datasource="#arguments.cartdsn#">
			UPDATE CART 
			SET 
			ACTIVE=0
			WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_bigint">
		</cfquery>
	</cffunction>
	
	<cffunction name="deletemycart" returntype="void" access="public" hints="Deletes the whole cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="nameid" type="string" required="true" hint="ID of the cart trying to delete">
		<cfquery name="deletecart" datasource="#cartdsn#">
			UPDATE CART 
			SET 
			ACTIVE=0
			WHERE CARTID IN (SELECT CARTID FROM CARTOWNER WHERE NAMEID=<cfqueryparam value="#nameid#" cfsqltype="cf_sql_bigint">)
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

	<cffunction name="updatequantity" returntype="String" access="public" hint="set the quanity of the product in the cart to certain value">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="id" type="String" required="true" hint="Id of the product">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfargument name="quantity" type="string" required="true" hint="Quantity of the item trying to buy">
		
		<cfset var setquantity=0>
		<cfset var stock=0>
		
		<cfquery name="stock" datasource="#cartdsn#">
			SELECT QUANTITY FROM PRODUCT
			WHERE ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif stock.quantity GT quantity>
			<cfquery name="setquantity" datasource="#cartdsn#">
				UPDATE CART2ITEM
				SET QUANTITY=<cfqueryparam value="#quantity#" cfsqltype="cf_sql_varchar">
				WHERE CARTID=<cfqueryparam value="#cartid#" cfsqltype="cf_sql_varchar">
				AND ID=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelse> <cfreturn "Error">
		</cfif>
		<cfreturn "Success">
	</cffunction>
	
	<cffunction name="checkitemincart" returntype="String" access="public" hint="I return quantity if the item is in the cart and 0 otherwise">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="id" type="String" required="true" hint="Id of the product">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfset var checkcart=0>
		<cfquery name="checkcart" datasource="#cartdsn#">
			SELECT QUANTITY FROM CART2ITEM 
			WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">
			and id=<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif checkcart.recordcount EQ 0><cfreturn "0">
		<cfelse><cfreturn checkcart.quantity></cfif>
	</cffunction>

	<cffunction name="clearcart" access="public" returntype="String" hint="I delete all the items from the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfquery name="clear" datasource="#arguments.cartdsn#">
			DELETE FROM CART2ITEM
			WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="getcartowner" access="public" returntype="String" hint="I get owner(NAMEID) of the cart.I return 0 if nobody owns the cart">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">
		<cfargument name="cartid" type="string" required="true" hint="Id of the cart">
		<cfset var get=0>
		<cfquery name="get" datasource="#arguments.cartdsn#">
			SELECT NAMEID 
			FROM CARTOWNER 
			WHERE CARTID=<cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif get.recordcount GT 0>
			<cfreturn get.NAMEID>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>

	<cffunction name="consolidatecart" access="public" returntype="String" hint="I consolidate cart and return a new cartid">
		<cfargument  name="cartdsn" type="string" required="true" hint="The datasource for the cart">	
		<cfargument name="cart1" type="String" required="true" hint="first cart">
		<cfargument name="cart2" type="String" required="true" hint="second cart">
		<cfargument name="nameid" type="String" required="false" default="0" hint="person who owns the cart">
		<cfset var cartitems=0>
		<cfinvoke method="createcart" cartdsn="#arguments.cartdsn#" returnvariable="cartid">
		<cfquery name="cartitems" datasource="#arguments.cartdsn#">
			SELECT
				CART2ITEM.ID,
				CART2ITEM.QUANTITY,	
				IDPOOL.IDFOR
			FROM IDPOOL, CART2ITEM
			WHERE CART2ITEM.CARTID IN(<cfqueryparam value="#cart1#">,<cfqueryparam value="#cart2#">)
			AND CART2ITEM.ID=IDPOOL.ID
		</cfquery>
		<cfloop query="cartitems">
			<cfif idfor EQ "product">
				<cfinvoke method="addproduct" cartdsn="#arguments.cartdsn#" cartid="#cartid#" id="#id#" quantity="#quantity#">
			<cfelse>
				<cfinvoke method="addsubscription" cartdsn="#arguments.cartdsn#" cartid="#cartid#" id="#id#">
			</cfif>
		</cfloop>
		<cfif arguments.nameid NEQ "0">
			<cfinvoke method="deletemycart" cartdsn="#arguments.cartdsn#" nameid="#arguments.nameid#">
			<cfinvoke method="setcartowner" cartdsn="#arguments.cartdsn#" cartid="#cartid#" nameid="#arguments.nameid#">
		</cfif>
		<cfreturn cartid>
	</cffunction>
</cfcomponent>