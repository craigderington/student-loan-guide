


		<cfcomponent displayname="portalinstructions">
	
			<cffunction name="init" access="public" output="false" returntype="portalinstructions" hint="Returns an initialized portal instructions gateway object.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="getportalcats" access="public" output="false" hint="I get the list of portal instruction categories for managing the instructions content.">				
				<cfset var portalcats = "" />				
				<cfquery datasource="#application.dsn#" name="portalcats">
					select distinct(instructcategory)
					  from portalinstructions						   
				  order by instructcategory asc
				</cfquery>
				<cfreturn portalcats>
			</cffunction>
			
			
			<cffunction name="getportalinstructions" access="public" output="false" hint="I get the list of portal instructions for managing the instructions content.">
				<cfargument name="instructcat" required="no" type="any" default="">			
				<cfset var portalinstruct = "" />				
				<cfquery datasource="#application.dsn#" name="portalinstruct">
					select instructid, instructuuid, instructcategory, instructtext, instructorder
					  from portalinstructions
						  
						   <cfif structkeyexists( arguments, "instructcat" )>
							  <cfif arguments.instructcat is not "" and arguments.instructcat is not "">
								where instructcategory = <cfqueryparam value="#trim( arguments.instructcat )#" cfsqltype="cf_sql_varchar" />
							  </cfif>
						   </cfif>
						  
				  order by instructorder asc
				</cfquery>
				<cfreturn portalinstruct>
			</cffunction>
			
			
			<cffunction name="getportalinstructdetail" access="public" output="false" hint="I get the list of portal instructions content detail for managing the client portal instructions.">
				<cfargument name="iid" required="yes" type="uuid" default="#url.iid#">
				<cfset var portalinstructdetail = "" />				
				<cfquery datasource="#application.dsn#" name="portalinstructdetail">
					select instructid, instructuuid, instructcategory, instructtext, instructorder
					  from portalinstructions						   
					 where instructuuid = <cfqueryparam value="#arguments.iid#" cfsqltype="cf_sql_varchar" />		 
				</cfquery>
				<cfreturn portalinstructdetail>
			</cffunction>
			
		</cfcomponent>