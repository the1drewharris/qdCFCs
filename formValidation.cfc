<cfcomponent hint="Form Validation CFC">
	<cfset variables.validation_error = StructNew()>
	<cfset variables.errorFields="">
	<cfset variables.noofexternalerrors=0>
	
	<cffunction name="init" access="public" returntype="formValidation" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="set_value" returntype="string" output="false" hint="I set a form value for a form field or if the form field does not exist then I return an empty string">
		<cfargument name="field" required="true" hint="form field to check">
		<cfsilent>
		<cfset tempStr = "">
		<cfif isDefined('form.#arguments.field#')>
			<cfset session['#arguments.field#'] = Trim(form['#arguments.field#'])>
			<cfset tempStr=session['#arguments.field#']>
		</cfif>
		</cfsilent>
		<cfreturn tempStr>
	</cffunction>
	
	<cffunction name="set_rules" returntype="void" output="false" hint="I set rules for specific form fields that need to be tested. If the field is required, required should be the first item in validationlist">
		<cfargument name="field" required="true" hint="form field to check">
		<cfargument name="humanField" required="true" hint="Name of field for humans (i.e. first_name, you would probably want it to display First Name)">
		<cfargument name="validationList" required="true" hint="List of validation rules to check on, currently the only ones are: required and email">
		<cfset var i = "">
		<cfset var compareTitle = "">
		<cfset var requiredfield=0>
		<cfset variables.validTest = true>
		<cfloop list="#validationList#" index="i">
			<cfset variables.humanField['#arguments.field#'] = arguments.humanField>
			<cfswitch expression="#i#">
				<cfcase value="email">
					<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
						<cfset variables.validTest = isEmail(form['#arguments.field#'])>
						<cfif NOT variables.validTest>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a valid email address.">
						</cfif>
					</cfif>
				</cfcase>
				
				<cfcase value="required">
					<cfset variables.validTest = required(form['#arguments.field#'])>
					<cfif NOT variables.validTest>
						<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is required but was left blank.">
					</cfif>
					<cfset requiredfield=1>
				</cfcase>
				
				<cfcase value="phone">
					<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
						<cfset variables.validTest = isPhone(form['#arguments.field#'])>
						<cfif NOT variables.validTest>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a valid phone number. The valid format is: 555-800-1234 or 800-1234.">
						</cfif>
					</cfif>
				</cfcase>
				
				<cfcase value="date">
					<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
						<cfset variables.validTest = isDate(form['#arguments.field#'])> 
						<cfif NOT variables.validTest>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a real date.">
						<cfelse>
							<cfset variables.validTest = validDate(form['#arguments.field#'])>
							<cfif NOT variables.validTest>
								<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a valid date. The valid format is: mm/dd/yyyy.">
							</cfif>
						</cfif>
					</cfif>
				</cfcase>
				
				<cfcase value="numeric">
					<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
						<cfset variables.validTest = isNumeric(form['#arguments.field#'])> 
						<cfif NOT variables.validTest>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a numeric value.">
						</cfif>
					</cfif>
				</cfcase>
				
				<cfcase value="zip">
					<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
						<cfset variables.validTest = isZip(form['#arguments.field#'])> 
						<cfif NOT variables.validTest>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is not a valid zip code.">
						</cfif>
					</cfif>
				</cfcase>
				
				<cfcase value="password">
					<cfset pw=Trim(form['#arguments.field#'])>
					<cfset length=len(pw)>
					<cfset pwIsNotValid=true>
					<cfif length GTE 6>
						<cfif length LTE 32>
							<cfset a="[a-z]">
							<cfset u="[A-Z]">
							<cfset n="[0-9]">
							<cfset regex="(#a##a#*#u#|#u##u#*#a#)(#a#|#u#)*#n#|(#a##a#*#n#|#n##n#*#a#)(#n#|#a#)*#u#|(#u##u#*#n#|#n##n#*#u#)(#n#|#u#)*#a#">
							<cfset r=REFind(regex,pw)>
							<cfif r GT 0>
								<cfset pwIsNotValid=false>
							</cfif>
						</cfif>
					</cfif>
					<cfif pwIsNotValid>
						<cfset variables.validTest=false>
						<cfset variables.validation_error['#arguments.field#']="#arguments.humanField# must be 6-32 characters. Must have both lowercase and uppercase letters. Must have at least one number.">
					</cfif>
				</cfcase>
				
				<cfdefaultcase>
					<cfset compareField = "">
					<cfif #REFind("^hash_matches\[(.*?)\]",i)#>
						<cfset compareField = REReplace(i,"^hash_matches\[(.*?)\]","\1")>
						<cfif hash(form['#arguments.field#']) IS NOT form['#compareField#']>
							<cfset variables.validTest = false>
							<cfset compareTitle = compareField>
							<cfif isDefined("variables.humanField.#compareField#")>
								<cfset compareTitle = variables.humanField['#compareField#']>
							</cfif>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# does not match the letters in the image.">
						</cfif>
					<cfelseif #REFind("^matches\[(.*?)\]",i)#>
						<cfset compareField = REReplace(i,"^matches\[(.*?)\]","\1")>
						<cfif form['#arguments.field#'] IS NOT form['#compareField#']>
							<cfset variables.validTest = false>
							<cfset compareTitle = compareField>
							<cfif isDefined("variables.humanField.#compareField#")>
								<cfset compareTitle = variables.humanField['#compareField#']>
							</cfif>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# does not match #compareTitle#.">
						</cfif>
					<cfelseif #REFind("^date_compare\[(.*?)\]",i)#>
						<cfset compareList = #REReplace(i,"^date_compare\[(.*?)\]","\1")#>
						<cfset compareField = listGetAt(compareList,1)>
						<cfif listLen(compareList) GTE 2>
							<cfset dayPadding = #listGetAt(compareList,2)#>
						<cfelse>
							<cfset dayPadding = 1>
						</cfif>
						<cfset dateDifference = DateDiff('d',form['#compareField#'],form['#arguments.field#'])>
						<cfif dateDifference LT dayPadding>
							<cfset variables.validTest = false>
							<cfset compareTitle = compareField>
							<cfif isDefined("variables.humanField.#compareField#")>
								<cfset compareTitle = variables.humanField['#compareField#']>
							</cfif>
							<cfif dayPadding NEQ 0>
								<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# must be at least #dayPadding# days after #compareTitle#.">
							<cfelse>
								<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# must be the same day or after #compareTitle#.">
							</cfif>
						</cfif>	
					<cfelseif #REFind("^min_len\[(.*?)\]",i)#>
						<cfif requiredfield EQ 1 OR Trim(form['#arguments.field#']) NEQ "">
							<cfset length = REReplace(i,"^min_len\[(.*?)\]","\1")>
							<cfif trim(len(form['#arguments.field#'])) LT length>
								<cfset variables.validTest = false>
								<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is too short. Must be at least #length# characters long.">
							</cfif>
						</cfif>
					<cfelseif #REFind("^max_len\[(.*?)\]",i)#>
						<cfset length = REReplace(i,"^max_len\[(.*?)\]","\1")>
						<cfif trim(len(form['#arguments.field#'])) GT length>
							<cfset variables.validTest = false>
							<cfset variables.validation_error['#arguments.field#'] = "#arguments.humanField# is too long. Must not be longer than #length# characters.">
						</cfif>
					<cfelseif #REFind("^min_val\[(.*?)]",i)#>
						<cfif requiredfield EQ 1 OR IsNumeric(form['#arguments.field#'])>
							<cfset min_value=REReplace(i,"^min_val\[(.*?)\]","\1")>
							<cfif form['#arguments.field#'] LT min_value>
								<cfset variables.validTest=false>
								<cfset variables.validation_error['#arguments.field#']="#arguments.humanField# should be greater than or equal to #min_value#" >
							</cfif>					
						</cfif>
					<cfelseif #REFind("^max_val\[(.*?)]",i)#>
						<cfif requiredfield EQ 1 OR IsNumeric(form['#arguments.field#'])>
							<cfset max_value=REReplace(i,"^max_val\[(.*?)\]","\1")>
							<cfif form['#arguments.field#'] GT max_value>
								<cfset variables.validTest=false>
								<cfset variables.validation_error['#arguments.field#']="#arguments.humanField# should be less than or equal to #max_value#" >
							</cfif>					
						</cfif>
					<cfelseif #REFind("not\[(.*?)]",i)#>
						<cfif requiredfield EQ 1>
							<cfset notValue=REReplace(i,"^not\[(.*?)\]","\1")>
							<cfif form['#arguments.field#'] EQ notValue>
								<cfset variables.validTest=false>
								<cfset variables.validation_error['#arguments.field#']="#arguments.humanField# can not be #notValue#." >
							</cfif>					
						</cfif>
					</cfif>
					
				</cfdefaultcase>
			</cfswitch>
			<cfif NOT variables.validTest>
				<cfset variables.errorFields=listAppend(variables.errorFields,arguments.field)>
				<cfbreak>
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="match_password" returntype="void" hint="I match password and set error if they do not match">
		<cfargument name="passwordfield" type="string" required="true" hint="Password">
		<cfargument name="retypedfield" type="string" required="true" hint="Retyped Password">
		<cfset p=form['#passwordfield#']>
		<cfset r=form['#retypedfield#']>
		<cfif compare(p,r) NEQ 0>
			<cfset variables.validation_error['retypedfield'] = "Password and Retyped Password do not match">
		</cfif>
	</cffunction>
	
	<cffunction name="isValidForm" returntype="boolean">
		<cfif StructCount(variables.validation_error) GT 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="validate" returntype="any">
		<cfreturn variables.validTest>
	</cffunction>
	
	<cffunction name="validation_errors" returntype="any">
		<cfargument name="tag" required="false" hint="tag to surround the errors with. i.e.: p, div" default="div">
		<cfargument name="class" required="false" hint="class to assign to tag." default="error">
		<cfset var tempStr = ''>
		<cfif StructCount(variables.validation_error) GT 0>
			<cfsavecontent variable="tempStr">
			<cfoutput>
			<#arguments.tag# class="#arguments.class#">
				<ul>
				<cfloop collection = #variables.validation_error# item = "error">
					<li>#variables.validation_error['#error#']#</li>
				</cfloop>
				</ul>
			</#arguments.tag#>
			</cfoutput>
			</cfsavecontent>
		</cfif>
		<cfreturn tempStr>
	</cffunction>
	
	<cffunction name="validation_error" returntype="string" output="false">
		<cfargument name="field" required="true" hint="form field error to return.">
		<cfargument name="tag" required="false" hint="tag to surround error with. i.e.: p, div" default="div">
		<cfargument name="class" required="false" hint="class to assign to tag." default="error">
		<cfif isDefined("variables.validation_error.#arguments.field#")>
			<cfset error = variables.validation_error['#arguments.field#']>
			<cfreturn '<#arguments.tag# class="#arguments.class#">#error#</#arguments.tag#>'>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="getListofErrors" returntype="string">
		<cfset tempStr="">
		<cfif listlen(variables.errorfields) GT 0>
			<cfloop list="#variables.errorfields#" index="field">
				<cfset tempStr=ListAppend(tempStr,variables.validation_error['#field#'])>
			</cfloop>
		</cfif>
		<cfreturn tempStr>
	</cffunction>
	
	<cffunction name="required" returntype="boolean">
		<cfargument name="str" required="true">
		<cfif len(trim(str))>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="addError" returntype="void" output="false" hint="I add error">
		<cfargument name="errordesc" required="true" type="string" hint="description of the error">
		<cfset errorfield="external#variables.noofexternalerrors#">
		<cfset variables.errorFields=listAppend(variables.errorFields,errorfield)>
		<cfset variables.validation_error['#errorfield#']=errordesc>
		<cfset variables.noofexternalerrors=variables.noofexternalerrors+1>
	</cffunction>
	
	<cfscript>
		function isEmail(str) {
			return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",
			arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
			len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
		}
	
		function isPhone(valueIn) {
		    var re = "^(([0-9]{3}[-.]?)|\([0-9]{3}\) ?)?[0-9]{3}[.-]?[0-9]{4}$";
		    return    ReFindNoCase(re, valueIn);
		}
		
		function validDate(valueIn) {
		    var re = "^([0-1]{1}[0-9]{1}/)[0-3]{1}[0-9]{1}/[0-9]{4}$";
		    return    ReFindNoCase(re, valueIn);
		}
		
		function isZip(str) {
		    var re = "^(([0-9]{1}[0-9]{4})([-][0-9]{4})?)$";
		    return    ReFindNoCase(re, str);
		}
		
	</cfscript>
</cfcomponent>