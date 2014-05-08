


			<cfcomponent displayname="doccat">		
				<cffunction name="init" access="public" output="false" returntype="doccat" hint="Returns an initialized document category function.">		
					<!--- // return This reference. --->
					<cfreturn this />
				</cffunction>				
				<cffunction name="getdoccats" access="public" output="false" hint="I get the list of document categories.">
					<cfset var doccats = "" />
					<cfquery datasource="#application.dsn#" name="doccats">
						select doccatid, doccat
						  from doccategory
						 where doccatid <> <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
						order by doccat asc
					</cfquery>
					<cfreturn doccats>
				</cffunction>
				<cffunction name="getdoccatdetail" access="public" output="false" hint="I get the document category detail.">
					<cfargument name="catid" type="numeric" required="yes" default="#url.catid#">
					<cfset var doccatdetail = "" />
					<cfquery datasource="#application.dsn#" name="doccatdetail">
						select doccatid, doccat
						  from doccategory
						 where doccatid = <cfqueryparam value="#arguments.catid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn doccatdetail>
				</cffunction>
			</cfcomponent>