


		<cfcomponent displayname="optiontree5">
		
			<cffunction name="getoptiontree5" access="remote" output="false" hint="I generate student loan option tree 5.">
			
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">				
					
					<!--- Get Answer to the Survey Q1 --->
					<cfquery datasource="#application.dsn#" name="surveyq1">
						select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
						  from slanswer
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and slqid = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />				
					</cfquery>						
					
					<!--- Get Answer to the Survey Q3 --->
					<cfquery datasource="#application.dsn#" name="surveyq3">
						select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
						  from slanswer
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and slqid = <cfqueryparam value="3" cfsqltype="cf_sql_integer" />				
					</cfquery>

					<!--- Get Answer to the Survey Q13 --->
					<cfquery datasource="#application.dsn#" name="surveyq13">
						select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
						  from slanswer
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and slqid = <cfqueryparam value="13" cfsqltype="cf_sql_integer" />				
					</cfquery>
					
					<!--- Get Answer to the Survey Q30 --->
					<cfquery datasource="#application.dsn#" name="surveyq30">
						select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
						  from slanswer
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and slqid = <cfqueryparam value="30" cfsqltype="cf_sql_integer" />				
					</cfquery>
					
					<!--- Get Answer to the Survey Q31 --->
					<cfquery datasource="#application.dsn#" name="surveyq31">
						select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
						  from slanswer
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and slqid = <cfqueryparam value="31" cfsqltype="cf_sql_integer" />				
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
					<cfset optiontree5 = structnew() />					
						
					<cfset subcat5 = false />
					<cfset subcat5canceldeath = false />
					<cfset subcat5canceldisable = false />
					<cfset subcat5psforgive = false />
					<cfset subcat5pslf = "no" />
					<cfset subcat5default = false />
					<cfset subcat5rehab = "no" />
					<cfset subcat5consol = "no" />
					<cfset subcat5post = false />
					<cfset subcat5postdefer = "no" />
					<cfset subcat5forbear = false />
					<cfset subcat5bk = false />
					<cfset subcat5oic = false />
					<cfset subcat5repay = false />
					
					
					<!--- // qualify this category --->
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
							<cfset subcat5 = true />
						</cfif>
					</cfloop>					
					
					<!--- // Cancellation Options Survey Question 1 thru 7 --->
					<cfif trim( surveyq1.slqa ) is "yes">
						<cfset subcat5canceldeath = true />					
					</cfif>					
					
					<cfif trim( surveyq3.slqa ) is "yes">
						<cfset subcat5canceldisable = true />					
					</cfif>				

					<!--- // Survery Question 13 --->
					<cfif trim( surveyq13.slqa ) is "yes">
						<cfloop query="worksheets">
							<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
								<cfif trim( statuscoderefer ) is not "df" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg">
									<cfset subcat5psforgive = true />
									<cfset subcat5pslf = "yes" />							
								</cfif>
							</cfif>
						</cfloop>					
					</cfif>		
					
					<!--- // default intervention rehab --->				
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
							<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to">
								<cfif rehabafter is "N">
									<cfset subcat5default = true />
									<cfset subcat5rehab = "yes">								
								</cfif>
							</cfif>
						</cfif>
					</cfloop>					

					<!--- // default intervention - consolidation ---> 
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
							<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to">
								<cfif trim( prevconsol ) is "n" and worksheets.recordcount gt 1>
									<cfset subcat5default = true />
									<cfset subcat5consol = "yes" />
								</cfif>
							</cfif>
						</cfif>
					</cfloop>					
					
					<!--- // postponement deferment --->
					<cfif trim( surveyq31.slqa ) is "yes">
						<cfloop query="worksheets">
							<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
								<cfset subcat5post = true />
								<cfset subcat5postdefer = "yes" />
							</cfif>
						</cfloop>
					</cfif>					
					
					<!--- // forbearance based on 20% of disposable income --->
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
					
					<cfif totals.totalmonthlypayment GT ( budgetincome.totalincome * .20 )>
						<cfset subcat5forbear = true />
					</cfif>					
					
					<!--- // bankruptcy and offer in compromise --->
					<cfif trim( surveyq30.slqa ) is "no">
						<cfset subcat5bk = true />					
					</cfif>
					
					<!--- // offer in compromise --->
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "Q" or trim( loancode ) is "R" or trim( loancode ) is "Y" or trim( loancode ) is "Z">
							<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj" >
								<cfset subcat5oic = true />												
							</cfif>
						</cfif>
					</cfloop>
					
					<!--- // 12-9-2013 // add option for subcat5 - repayment --->
					<cfloop query="worksheets">
						<cfif trim( loancode ) is not "Q" and trim( loancode ) is not "R" and trim( loancode ) is not "Y" and trim( loancode ) is not "Z" and trim( loancode ) is not "aa">
							<cfset subcat5repay = true />					
						</cfif>
					</cfloop>		
					
					
					<!--- // add option tree 5 values to our structure --->
					<cfset subcat5 = structinsert( optiontree5, "subcat5", subcat5 ) />					 
					<cfset subcat5canceldeath = structinsert( optiontree5, "subcat5canceldeath", subcat5canceldeath ) />					
					<cfset subcat5canceldisable = structinsert( optiontree5, "subcat5canceldisable", subcat5canceldisable ) />				
					<cfset subcat5psforgive = structinsert( optiontree5, "subcat5psforgive", subcat5psforgive ) />
					<cfset subcat5pslf = structinsert( optiontree5, "subcat5pslf", subcat5pslf ) />					
					<cfset subcat5default = structinsert( optiontree5, "subcat5default", subcat5default ) />
					<cfset subcat5rehab = structinsert( optiontree5, "subcat5rehab", subcat5rehab ) />
					<cfset subcat5consol = structinsert( optiontree5, "subcat5consol", subcat5consol ) />
					<cfset subcat5post = structinsert( optiontree5, "subcat5post", subcat5post ) />
					<cfset subcat5postdefer = structinsert( optiontree5, "subcat5postdefer", subcat5postdefer ) />
					<cfset subcat5forbear = structinsert( optiontree5, "subcat5forbear", subcat5forbear ) />
					<cfset subcat5bk = structinsert( optiontree5, "subcat5bk", subcat5bk ) />	
					<cfset subcat5oic = structinsert( optiontree5, "subcat5oic", subcat5oic ) />
					<cfset subcat5repay = structinsert( optiontree5, "subcat5repay", subcat5repay ) />
					
			
				<cfreturn optiontree5>	
					
			</cffunction>
		
		</cfcomponent>