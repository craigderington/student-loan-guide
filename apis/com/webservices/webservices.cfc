





				<cfcomponent displayname="webservices">
				
					<cffunction name="init" access="public" output="false" returntype="webservices" hint="Returns an initialized webservices object.">		
						<!--- // return This reference. --->
						<cfreturn this />
					</cffunction>				
			
					<cffunction name="getwebservices" access="remote" output="false" hint="I get the list of webservices for the selected company.">
						<cfargument name="companyid" required="yes" type="numeric" default="#session.companyid#">
						<cfset var webservices = "" />
						<cfquery datasource="#application.dsn#" name="webservices">
							select webserviceid, webserviceuuid, companyid, webserviceprovidername, webservicerequesttype, webserviceposturl, 
								   webserviceloginuserid, webserviceloginpassword, webserviceclientid, webserviceframeid, 
								   webserviceapiencryptkey, webservicesessionid, webservicerequestid, webservicelastlogindatetime, 
								   webserviceisactive, webservicedatecreated
							  from webservice
							 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							order by webserviceid asc
						</cfquery>	
						<cfreturn webservices >
					</cffunction>
					
					<cffunction name="getwebservice" access="remote" output="false" hint="I get the webservice by ID for the selected company.">
						<cfargument name="wsid" required="yes" type="uuid" default="#url.wsid#">
						<cfset var webservicedetail = "" />
						<cfquery datasource="#application.dsn#" name="webservicedetail">
							select webserviceid, webserviceuuid, companyid, webserviceprovidername, webservicerequesttype, webserviceposturl, 
								   webserviceloginuserid, webserviceloginpassword, webserviceclientid, webserviceframeid, 
								   webserviceapiencryptkey, webservicesessionid, webservicerequestid, webservicelastlogindatetime, 
								   webserviceisactive, webservicedatecreated
							  from webservice
							 where webserviceuuid = <cfqueryparam value="#arguments.wsid#" cfsqltype="cf_sql_varchar" maxlength="35" />				
						</cfquery>
						<cfreturn webservicedetail >
					</cffunction>		
				
				</cfcomponent>