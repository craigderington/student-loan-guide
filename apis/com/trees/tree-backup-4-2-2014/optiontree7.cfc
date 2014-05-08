	
	
	<cfcomponent displayname="optiontree7">
	
		<cffunction name="getoptiontree7" access="remote" output="false" hint="I get the option tree 7.">
		
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">
			
				<!--- Get Answer to the Survey Q1 --->
				<cfquery datasource="#application.dsn#" name="surveyq1">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q7 --->
				<cfquery datasource="#application.dsn#" name="surveyq7">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="7" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q8 --->
				<cfquery datasource="#application.dsn#" name="surveyq8">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="8" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q9 --->
				<cfquery datasource="#application.dsn#" name="surveyq9">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="9" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q10 --->
				<cfquery datasource="#application.dsn#" name="surveyq10">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="10" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q11 --->
				<cfquery datasource="#application.dsn#" name="surveyq11">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="11" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q12 --->
				<cfquery datasource="#application.dsn#" name="surveyq12">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="12" cfsqltype="cf_sql_integer" />				
				</cfquery>		
				
				<!--- Get Answer to the Survey Q30 --->
				<cfquery datasource="#application.dsn#" name="surveyq30">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="30" cfsqltype="cf_sql_integer" />				
				</cfquery>

				<!--- // get our debt worksheet data --->
				<cfquery datasource="#application.dsn#" name="worksheets">
					select lc.loancode, slw.closeddate, slw.prevconsol, slw.rehabafter, slw.active, 
					       rc.repaycode, sc.statuscode, sc.statuscoderefer
					  from slworksheet slw, loancodes lc, repaycodes rc, statuscodes sc
					 where slw.loancodeid = lc.loancodeid
					   and slw.repaycodeid = rc.repaycodeid
					   and slw.statuscodeid = sc.statuscodeid
					   and slw.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by lc.loancode asc
				</cfquery>
				
				
				<cfset optiontree7 = structnew() />
				
				<cfset subcat7 = false />
				<cfset subcat7canceldeath = false />
				<cfset subcat7legalage = false />
				<cfset subcat7ftcrule = false />
				<cfset subcat7mixeduse = false />
				<cfset subcat7idtheft = false />
				<cfset subcat7default = false />
				<cfset subcat7defaultstat = "no">
				<cfset subcat7hardship = false />
				<cfset subcat7mod = false />
				<cfset subcat7validate = false />
				<cfset subcat7ext = false />
				<cfset subcat7bk = false />
				<cfset subcat7oic = false />
				
				
				<!--- // qualify this category --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "AA">
						<cfset subcat7 = true />
					</cfif>
				</cfloop>
				
				<!--- // Cancellation Options Survey Question 1 thru 7 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat7canceldeath = true />				
				</cfif>				
				
				<cfif trim( surveyq8.slqa ) is "no">
					<cfset subcat7legalage = true />				
				</cfif>
				
				<cfif trim( surveyq9.slqa ) is "no">
					<cfset subcat7ftcrule = true />				
				</cfif>
				
				<cfif trim( surveyq10.slqa ) is "yes">
					<cfset subcat7mixeduse = true />				
				</cfif>
				
				<cfif trim( surveyq7.slqa ) is "yes">
					<cfset subcat7idtheft = true />				
				</cfif>
				
				<cfloop query="worksheets">	
					<cfif trim( loancode ) is "aa" and ( trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" )>
						<cfif trim( surveyq11.slqa ) is "yes">
							<cfset subcat7default = true />
							<cfset subcat7defaultstat = "yes">				
						</cfif>
					</cfif>
				</cfloop>
				
				<cfif trim( surveyq12.slqa ) is "yes">
					<cfset subcat7hardship = true />				
				</cfif>
				
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "aa" and trim( repaycode ) is "s">
						<cfset subcat7mod = true />					
					</cfif>
				</cfloop>
				
				<cfloop query="worksheets">					
					<cfif trim( loancode ) is "aa" and ( trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" )>
						<cfset subcat7validate = true />
					</cfif>
				</cfloop>				
				
				<cfif subcat7hardship is false and subcat7mod is false>
					<cfset subcat7ext = true />				
				</cfif>				
				
				<!--- // bankruptcy --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat7bk = true />			
				</cfif>
				
				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "AA">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj">
							<cfset subcat7oic = true />												
						</cfif>
					</cfif>
				</cfloop>
				
				
				<!--- // place all of our option tree 7 variable values in our structure --->
				<cfset subcat7 = structinsert( optiontree7, "subcat7", subcat7 ) />				
				<cfset subcat7canceldeath = structinsert( optiontree7, "subcat7canceldeath", subcat7canceldeath ) />				
				<cfset subcat7legalage = structinsert( optiontree7, "subcat7legalage", subcat7legalage ) />				
				<cfset subcat7ftcrule = structinsert( optiontree7, "subcat7ftcrule", subcat7ftcrule ) />				
				<cfset subcat7mixeduse = structinsert( optiontree7, "subcat7mixeduse", subcat7mixeduse ) />				
				<cfset subcat7idtheft = structinsert( optiontree7, "subcat7idtheft", subcat7idtheft ) />
				<cfset subcat7default = structinsert( optiontree7, "subcat7default", subcat7default ) />				
				<cfset subcat7defaultstat = structinsert( optiontree7, "subcat7defaultstat", subcat7defaultstat ) />				
				<cfset subcat7hardship = structinsert( optiontree7, "subcat7hardship", subcat7hardship ) />				
				<cfset subcat7mod = structinsert( optiontree7, "subcat7mod", subcat7mod ) />				
				<cfset subcat7ext = structinsert( optiontree7, "subcat7ext", subcat7ext ) />				
				<cfset subcat7bk = structinsert( optiontree7, "subcat7bk", subcat7bk ) />
				<cfset subcat7oic = structinsert( optiontree7, "subcat7oic", subcat7oic ) />
				<cfset subcat7validate = structinsert( optiontree7, "subcat7validate", subcat7validate ) />
				
			<cfreturn optiontree7>
		
		</cffunction>
	
	
	</cfcomponent>