


	
	
		<cfcomponent displayname="emailtemplategateway">
		
			<cffunction name="init" access="public" output="false" returntype="emailtemplategateway" hint="I create an initialized instance of the email template gateway object.">				
				<cfreturn this >			
			</cffunction>
			
			<cffunction name="getemailtemplates" access="public" output="false" hint="I get the list of email templates by category">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfset var emailtemplatelist = "" />
				<cfquery datasource="#application.dsn#" name="emailtemplatelist">
					select emailtemplates.templateid, emailtemplates.companyid, emailtemplates.templatecategory, 
					       emailtemplates.templatecreatedate, emailtemplates.templatepath, emailtemplates.lastupdated, 
						   emailtemplates.lastupdatedby, users.firstname, users.lastname
					  from emailtemplates, users
					 where emailtemplates.lastupdatedby = users.userid
					   and emailtemplates.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />					   
				</cfquery>			
				<cfreturn emailtemplatelist>
			</cffunction>
			
			<cffunction name="getemailtemplatebycat" access="public" output="false" hint="I get the list of email templates by category">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="cat" type="any" required="yes" default="client-login">
				<cfset var emailtemplate = "" />
				<cfquery datasource="#application.dsn#" name="emailtemplate">
					select emailtemplates.templateid, emailtemplates.companyid, emailtemplates.templatecategory, 
					       emailtemplates.templatecreatedate, emailtemplates.templatepath, emailtemplates.lastupdated, 
						   emailtemplates.lastupdatedby, users.firstname, users.lastname
					  from emailtemplates, users
					 where emailtemplates.lastupdatedby = users.userid
					   and emailtemplates.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and emailtemplates.templatecategory = <cfqueryparam value="#arguments.cat#" cfsqltype="cf_sql_varchar" />
				</cfquery>			
				<cfreturn emailtemplate>
			</cffunction>
		
		
		</cfcomponent>