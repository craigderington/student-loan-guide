

	<cfcomponent displayname="optiontree3">
	
		<cffunction name="getoptiontree3" access="remote" output="false" hint="I generate student loan option tree 3.">
			
			<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
			
				<!--- Get Answer to the Survey Q1 --->
				<cfquery datasource="#application.dsn#" name="surveyq1">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />				
				</cfquery>

				<!--- Get Answer to the Survey Q2 --->
				<cfquery datasource="#application.dsn#" name="surveyq2">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="2" cfsqltype="cf_sql_integer" />				
				</cfquery>			
				
				<!--- Get Answer to the Survey Q3 --->
				<cfquery datasource="#application.dsn#" name="surveyq3">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="3" cfsqltype="cf_sql_integer" />				
				</cfquery>

				<!--- Get Answer to the Survey Q4 --->
				<cfquery datasource="#application.dsn#" name="surveyq4">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="4" cfsqltype="cf_sql_integer" />				
				</cfquery>			
				
				<!--- Get Answer to the Survey Q15 --->
				<cfquery datasource="#application.dsn#" name="surveyq15">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="15" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q16 --->
				<cfquery datasource="#application.dsn#" name="surveyq16">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="16" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q17 --->
				<cfquery datasource="#application.dsn#" name="surveyq17">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="17" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q18 --->
				<cfquery datasource="#application.dsn#" name="surveyq18">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="18" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q19 --->
				<cfquery datasource="#application.dsn#" name="surveyq19">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="19" cfsqltype="cf_sql_integer" />			
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
				
				
				<!--- create our structure to hold our values --->
				<cfset optiontree3 = structnew() />				
				<cfset subcat3 = false />
				<cfset subcat3canceldeath = false />
				<cfset subcat3cancel911 = false />
				<cfset subcat3canceldisable = false />
				<cfset subcat3cancelcs = false />
				<cfset subcat3consol = "no" />
				<cfset subcat3rehab = "no" />
				<cfset subcat3ocforgive = false />
				<cfset subcat3post = false />
				<cfset subcat3postdefer = "no" />
				<cfset subcat3post = false />
				<cfset subcat3bk = false />
				<cfset subcat3oic = false />
				<cfset subcat3repay = false />
				
				<!--- // qualify this category --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
						<cfset subcat3 = true />
					</cfif>
				</cfloop>							
				
				<!--- // cancellation options survey questions 1 thru 4 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat3canceldeath = true />				
				</cfif>
						
				<cfif trim( surveyq2.slqa ) is "yes">
					<cfset subcat3cancel911 = true />				
				</cfif>
				
				<cfif trim( surveyq3.slqa ) is "yes">
					<cfset subcat3canceldisable = true />				
				</cfif>				
				
				<cfif trim( surveyq4.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq -1>
								<cfset subcat3cancelcs = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>			
				
				<!--- // default intervention rehab --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" >
							<cfif rehabafter is "N">
								<cfset subcat3rehab = "yes" />
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
				
				<!--- // default intervention consolidation --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to">
							<cfif trim( prevconsol ) is "n" and worksheets.recordcount gt 1> 
								<cfset subcat3consol = "yes" />
							</cfif>
						</cfif>
					</cfif>
				</cfloop>

				
				
				<!-- // occupational forgiveness --->
				<cfif trim( surveyq15.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfset subcat3ocforgive = true />
						</cfif>
					</cfloop>
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq16.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfif datecompare( closeddate, "10/1/1980", "d" ) eq -1 >
								<cfset subcat3post = true />
								<cfset subcat3postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq17.slqa ) is "yes">
					<cfset date1 = "10/1/1980" />
					<cfset date2 = "6/30/1987" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>
								<cfset subcat3post = true />
								<cfset subcat3postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq18.slqa ) is "yes">
					<cfset date1 = "7/1/1987" />
					<cfset date2 = "6/30/1993" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>				
								<cfset subcat3post = true />
								<cfset subcat3postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq19.slqa ) is "yes">				
					<cfloop query="worksheets">	
						<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
							<cfif datecompare( closeddate, "7/1/1993", "d" ) eq 1 >
								<cfset subcat3post = true />
								<cfset subcat3postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>				
				
				<!--- forbearance based on 20% of disposable --->
				<cfquery datasource="#application.dsn#" name="budgetincome">
					 select primarytotalincome as totalincome
					   from budget b
					  where b.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				</cfquery>	
				
				<cfquery datasource="#application.dsn#" name="totals">
					select sum(currentpayment) as totalmonthlypayment
					  from slworksheet
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<cfset subcat3forbear = false />
				<cfif totals.totalmonthlypayment GT ( budgetincome.totalincome * .20 )>
					<cfset subcat3forbear = true />
				</cfif>			
				
				<!--- // bankruptcy --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat3bk = true />								
				</cfif>
				
				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "F" or trim( loancode ) is "M" or trim( loancode ) is "N" or trim( loancode ) is "AE">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj">
							<cfset subcat3oic = true />												
						</cfif>
					</cfif>
				</cfloop>

				<!--- // 12-9-2013 // add qualifier for consolidated repayment for perkins loans --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is not "F" and trim( loancode ) is not "M" and trim( loancode ) is not "N" and trim( loancode ) is not "AE" and trim( loancode ) is not "aa">
						<cfset subcat3repay = true />
					</cfif>
				</cfloop>
				
				
				<!--- // add option tree 3 values to our structure --->
				<cfset subcat3 = structinsert( optiontree3, "subcat3", subcat3 ) />
				<cfset subcat3canceldeath = structinsert( optiontree3, "subcat3canceldeath", subcat3canceldeath ) />
				<cfset subcat3cancel911 = structinsert( optiontree3, "subcat3cancel911", subcat3cancel911 ) />
				<cfset subcat3canceldisable = structinsert( optiontree3, "subcat3canceldisable", subcat3canceldisable ) />
				<cfset subcat3cancelcs = structinsert( optiontree3, "subcat3cancelcs", subcat3cancelcs ) />
				<cfset subcat3ocforgive = structinsert( optiontree3, "subcat3ocforgive", subcat3ocforgive ) />
				<cfset subcat3rehab = structinsert( optiontree3, "subcat3rehab", subcat3rehab ) />			
				<cfset subcat3consol = structinsert( optiontree3, "subcat3consol", subcat3consol ) />
				<cfset subcat3post = structinsert( optiontree3, "subcat3post", subcat3post ) />
				<cfset subcat3postdefer = structinsert( optiontree3, "subcat3postdefer", subcat3postdefer ) />			
				<cfset subcat3forbear = structinsert( optiontree3, "subcat3forbear", subcat3forbear ) />				
				<cfset subcat3bk = structinsert( optiontree3, "subcat3bk", subcat3bk ) />
				<cfset subcat3oic = structinsert( optiontree3, "subcat3oic", subcat3oic ) />
				<cfset subcat3repay = structinsert( optiontree3, "subcat3repay", subcat3repay ) />
				
			<cfreturn optiontree3 >
		
		</cffunction>	
	
	
	</cfcomponent>