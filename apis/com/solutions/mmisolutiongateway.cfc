


		<cfcomponent displayname="mmisolutiongateway">
	
			<cffunction name="init" access="public" output="false" returntype="mmisolutiongateway" hint="Returns an initialized MMI solution gateway function.">		
				<!--- // return this reference. --->
				<cfreturn this />
			</cffunction>	
		
			<cffunction name="getmmisolutions" access="public" output="false" hint="I get the list of MMI solutions">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
				<cfquery datasource="#application.dsn#" name="mmisolutions">
					select mmisolutionid, mmisolutions.leadid, mmisolutionuuid, mmisolutiondate, mmisolutionuserid, 
						   mmisolutionnarrative, mmisolutioncompleted,						   
						   users.firstname, users.lastname
   				      from mmisolutions, users
					 where mmisolutions.mmisolutionuserid = users.userid
					   and mmisolutions.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by mmisolutionid asc
				</cfquery>
				<cfreturn mmisolutions>
			</cffunction>		
			
			<cffunction name="getmmisolution" access="public" output="false" hint="I get the MMI solution info by solution UUID.">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
				<cfargument name="planid" type="uuid" required="yes">
				<cfquery datasource="#application.dsn#" name="mmisolution">
					select mmisolutionid, mmisolutions.leadid, mmisolutionuuid, mmisolutiondate, mmisolutionuserid, 
					       mmisolutionnarrative, mmisolutioncompleted,						   
						   users.firstname, users.lastname
					  from mmisolutions, users
					 where mmisolutions.mmisolutionuserid = users.userid
					   and mmisolutions.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and mmisolutions.mmisolutionuuid = <cfqueryparam value="#arguments.planid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				<cfreturn mmisolution>
			</cffunction>
			
			<cffunction name="getmmisolutiondetail" access="public" output="false" hint="I get the MMI solution detail by solution ID.">
				<cfargument name="mmisolutionid" type="numeric" required="yes">				
				<cfquery datasource="#application.dsn#" name="mmisolutiondetail">
					select mmisolutiondetailid, mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat					   
					  from mmisolutiondetail
					 where mmisolutionid = <cfqueryparam value="#arguments.mmisolutionid#" cfsqltype="cf_sql_integer" />
					 order by mmisolutiondetailid asc
				</cfquery>
				<cfreturn mmisolutiondetail>
			</cffunction>
			
		</cfcomponent>