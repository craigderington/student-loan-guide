


		<cfcomponent displayname="tcasolutiongateway">
	
			<cffunction name="init" access="public" output="false" returntype="solutiongateway" hint="Returns an initialized TCA solution gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
		
		
			<cffunction name="gettcasolutions" access="public" output="false" hint="I get the list of TCA solutions">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
				<cfquery datasource="#application.dsn#" name="tcasolutions">
					select tcasolutionid, tcasolutions.leadid, tcasolutionuuid, tcasolutiondate, 
					       idrconsol, consol, econdefer, forbear, ibr, icr, paye, 
						   pslfconsol, pslf, rehab, tlf, unempdefer, 
						   tcasolutionuserid, tcasolutionnarrative, users.firstname, users.lastname
					  from tcasolutions, users
					 where tcasolutions.tcasolutionuserid = users.userid
					   and tcasolutions.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by tcasolutionid asc
				</cfquery>
				<cfreturn tcasolutions>
			</cffunction>
			
			<cffunction name="gettcasolution" access="public" output="false" hint="I get the current TCA solution by solution ID.">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
				<cfquery datasource="#application.dsn#" name="tcasolution">
					select TOP 1 tcasolutionid, tcasolutions.leadid, tcasolutionuuid, tcasolutiondate, 
					       idrconsol, consol, econdefer, forbear, ibr, icr, paye, 
						   pslfconsol, pslf, rehab, tlf, unempdefer, 
						   tcasolutionuserid, tcasolutionnarrative, 
						   users.firstname, users.lastname
					  from tcasolutions, users
					 where tcasolutions.tcasolutionuserid = users.userid
					   and tcasolutions.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by tcasolutionid desc
				</cfquery>
				<cfreturn tcasolution>
			</cffunction>
		
			<cffunction name="gettcasolutioncount" access="public" output="false" hint="I get the count of TCA solutions.">				
				<cfargument name="companyid" type="numeric" default="#session.companyid#" required="yes">
				<cfquery datasource="#application.dsn#" name="tcasolutioncount">
					select sum(case when idrconsol = 'Y' then 1 else 0 end) as totalidrconsol,
						   sum(case when consol = 'Y' then 1 else 0 end) as totalconsol,
						   sum(case when econdefer = 'Y' then 1 else 0 end) as totalecondefer,
						   sum(case when forbear = 'Y' then 1 else 0 end) as totalforbear,
						   sum(case when ibr = 'Y' then 1 else 0 end) as totalibr,
						   sum(case when icr = 'Y' then 1 else 0 end) as totalicr,
						   sum(case when paye = 'Y' then 1 else 0 end) as totalpaye,
						   sum(case when pslfconsol = 'Y' then 1 else 0 end) as totalpslfconsol,
						   sum(case when pslf = 'Y' then 1 else 0 end) as totalpslf,
						   sum(case when rehab = 'Y' then 1 else 0 end) as totalrehab,
						   sum(case when tlf = 'Y' then 1 else 0 end) as totaltlf,
						   sum(case when unempdefer = 'Y' then 1 else 0 end) as totalunempdefer
					  from tcasolutions, leads
					 where tcasolutions.leadid = leads.leadid                     
                       and leads.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn tcasolutioncount>
			</cffunction>
			
			<cffunction name="gettcasolutiondetail" access="public" output="false" hint="I get the TCA solution detail by solution UUID.">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
				<cfargument name="planid" type="uuid" required="yes">
				<cfquery datasource="#application.dsn#" name="tcasolutiondetail">
					select TOP 1 tcasolutionid, tcasolutions.leadid, tcasolutionuuid, tcasolutiondate, 
					       idrconsol, consol, econdefer, forbear, ibr, icr, paye, 
						   pslfconsol, pslf, rehab, tlf, unempdefer, 
						   tcasolutionuserid, tcasolutionnarrative, 
						   users.firstname, users.lastname
					  from tcasolutions, users
					 where tcasolutions.tcasolutionuserid = users.userid
					   and tcasolutions.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and tcasolutions.tcasolutionuuid = <cfqueryparam value="#arguments.planid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				  order by tcasolutionid desc
				</cfquery>
				<cfreturn tcasolutiondetail>
			</cffunction>
		
		
		</cfcomponent>