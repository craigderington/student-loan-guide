


	<!--- // 7-26-2013 // settings gateway component --->
	<cfcomponent displayname="settingsgateway">	
		
		<cffunction name="init" access="public" output="false" returntype="settingsgateway" hint="Returns an initialized settings gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
		
		
		<cffunction name="getcompdetails" access="public" output="false" returntype="query" hint="I get the company specific settings and details.">
			<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
			<cfset var compdetails = "" />
			<cfquery datasource="#application.dsn#" name="compdetails">
				select companyid, companyname, dba, address1, address2, city, state, zip, phone, fax, email, regcode, 
				       active, complogo, advisory, implement, comptype, achprovider, achdatafile, achprovideruniqueid,
					   luckyorangecode, escrowservice, trustaccountbankname, trustaccountnumber, numlicenses,
					   trustaccountrouting, achdaystohold, enrollagreepath, implagreepath, esignagreepath1, esignagreepath2
				  from company
				 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfreturn compdetails >
		</cffunction>	
		
		
		<cffunction name="getjobs" output="false" returntype="query" access="remote" hint="I get the list of job conditions from the database.">			
			<cfset var jobs1 = "" />
			<cfquery datasource="#application.dsn#" name="jobs1">
				select conditionid, conditionuuid, condition, active, perkins8087, perkinspre80, perkins8793, perkinsafter93
				  from conditions
			  order by condition asc
			</cfquery>			
			<cfreturn jobs1 >		
		</cffunction>
		
		<cffunction name="getjobdetail" output="false" returntype="query" access="remote" hint="I get the job condition detail from the database.">			
			<cfargument name="jobid" required="yes" default="#url.jobid#" type="uuid">			
			<cfset var jobdetail = "" />
			<cfquery datasource="#application.dsn#" name="jobdetail">
				select conditionid, conditionuuid, condition, active, perkins8087, perkinspre80, perkins8793, perkinsafter93
				  from conditions
			     where conditionuuid = <cfqueryparam value="#arguments.jobid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
			</cfquery>			
			<cfreturn jobdetail >		
		</cffunction>
		
		
		<cffunction name="getmtasks" output="false" returntype="query" access="remote" hint="I get the list of master tasks from the database.">			
			<cfargument name="companyid" default="444" type="numeric">			
			<cfset var mtasklist = "" />
			<cfquery datasource="#application.dsn#" name="mtasklist">
				select mtaskid, mtaskuuid, companyid, mtasktype, mtaskname, mtaskdescr, mtaskactive
				  from mtask
				 where companyid = <cfqueryparam value="444" cfsqltype="cf_sql_integer" />
			  order by mtasktype, mtaskorder asc
			</cfquery>			
			<cfreturn mtasklist >		
		</cffunction>
		
		<cffunction name="getnsfreasons" output="false" returntype="query" access="remote" hint="I get the list nsf reasons for each company.">			
			<cfargument name="companyid" default="444" type="numeric">			
			<cfset var nsfreasonlist = "" />
			<cfquery datasource="#application.dsn#" name="nsfreasonlist">
				select nsfreasonid, companyid, nsfreasoncode, nsfreasondescr
				  from nsfreasons
				 where companyid = <cfqueryparam value="444" cfsqltype="cf_sql_integer" />
			  order by nsfreasondescr asc
			</cfquery>			
			<cfreturn nsfreasonlist >		
		</cffunction>
		
		<cffunction name="getnsfreason" output="false" returntype="query" access="remote" hint="I get the nsf reason for the automated email.">			
			<cfargument name="nsfreasonid" default="0" type="numeric" required="yes">			
			<cfset var nsfreasondetail = "" />
			<cfquery datasource="#application.dsn#" name="nsfreasondetail">
				select nsfreasonid, nsfreasoncode, nsfreasondescr
				  from nsfreasons
				 where nsfreasonid = <cfqueryparam value="#arguments.nsfreasonid#" cfsqltype="cf_sql_integer" />			  
			</cfquery>			
			<cfreturn nsfreasondetail >		
		</cffunction>
		
		
		
	
	
	</cfcomponent>