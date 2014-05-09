

	<cfcomponent displayname="implementstepgateway">
	
		<cffunction name="init" access="public" output="false" returntype="implementstepgateway" hint="Returns an initialized master implementation step gateway function.">		
			<!--- // return this reference. --->
			<cfreturn this />
		</cffunction>
		
		<cffunction name="getcats" access="public" output="false" hint="I get the list of master implementation steps.">
			<cfset var impstepcat = "" />
			<cfquery datasource="#application.dsn#" name="impstepcat">
					select distinct(ms.msimpstepcat)				       
					  from masterstepsimpl ms
				  order by ms.msimpstepcat
			</cfquery>
			<cfreturn impstepcat>
		</cffunction>
		
		<cffunction name="getsteps" access="public" output="false" hint="I get the list of master implementation steps.">
			<cfargument name="stepcat" type="any" required="yes" default="#session.stepcat#">
			<cfset var mimplementsteps = "" />
			<cfquery datasource="#application.dsn#" name="mimplementsteps">
					select ms.msimpstepid, ms.msimpcat, ms.msimptype, ms.msimpstepcat, ms.msimpstepstat, ms.msimpstepnum,
						   ms.msimpsteptask, ms.msimpstepreasonnumber, ms.msimpstepreason
					  from masterstepsimpl ms
					 where ms.msimpstepcat = <cfqueryparam value="#arguments.stepcat#" cfsqltype="cf_sql_varchar" />
					   and ms.msimpstepstat = <cfqueryparam value="C" cfsqltype="cf_sql_char" />
						<cfif structkeyexists( session, "stepcat" )>
							<cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset">
								order by ms.msimpstepreasonnumber, ms.msimpstepreason asc
							<cfelse>
								order by ms.msimpcat, ms.msimptype, ms.msimpstepnum asc
							</cfif>
						</cfif>
			</cfquery>
			<cfreturn mimplementsteps>
		</cffunction>
		
		<cffunction name="getstep" access="public" output="false" hint="I get the list of master implementation steps.">
			<cfargument name="stepid" type="numeric" required="yes" default="#url.stepid#">
			<cfset var stepdetail = "" />
			<cfquery datasource="#application.dsn#" name="stepdetail">
					select ms.msimpstepid, ms.msimpcat, ms.msimptype, ms.msimpstepcat, ms.msimpstepstat, ms.msimpstepnum,
						   ms.msimpsteptask, ms.msimpstepreasonnumber, ms.msimpstepreason
					  from masterstepsimpl ms
					 where ms.msimpstepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />				  
			</cfquery>
			<cfreturn stepdetail>
		</cffunction>
		
		
		
	
	</cfcomponent>