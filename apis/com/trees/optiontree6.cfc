

	

	<cfcomponent displayname="optiontree6">
	
		<cffunction name="getoptiontree6" access="remote" output="false" hint="I generate student loan option tree 6.">
			
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
				
				<!--- Get Answer to the Survey Q5 --->
				<cfquery datasource="#application.dsn#" name="surveyq5">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="5" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q 6 --->
				<cfquery datasource="#application.dsn#" name="surveyq6">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="6" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q7 --->
				<cfquery datasource="#application.dsn#" name="surveyq7">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="7" cfsqltype="cf_sql_integer" />				
				</cfquery>

				<!--- Get Answer to the Survey Q13 --->
				<cfquery datasource="#application.dsn#" name="surveyq13">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="13" cfsqltype="cf_sql_integer" />				
				</cfquery>
				
				<!--- Get Answer to the Survey Q14 --->
				<cfquery datasource="#application.dsn#" name="surveyq14">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="14" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q20 --->
				<cfquery datasource="#application.dsn#" name="surveyq20">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="20" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q21 --->
				<cfquery datasource="#application.dsn#" name="surveyq21">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="21" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answers to the Survey Q22 --->
				<cfquery datasource="#application.dsn#" name="surveyq22">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="22" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q23 --->
				<cfquery datasource="#application.dsn#" name="surveyq23">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="23" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q24 --->
				<cfquery datasource="#application.dsn#" name="surveyq24">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="24" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q25 --->
				<cfquery datasource="#application.dsn#" name="surveyq25">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="25" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q26 --->
				<cfquery datasource="#application.dsn#" name="surveyq26">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="26" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q27 --->
				<cfquery datasource="#application.dsn#" name="surveyq27">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="27" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q28 --->
				<cfquery datasource="#application.dsn#" name="surveyq28">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="28" cfsqltype="cf_sql_integer" />			
				</cfquery>
				
				<!--- Get Answer to the Survey Q29 --->
				<cfquery datasource="#application.dsn#" name="surveyq29">
					select slqaid, leadid, slqid, slqa, ruleid, slaother, sloptiondate
					  from slanswer
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and slqid = <cfqueryparam value="29" cfsqltype="cf_sql_integer" />			
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
				<cfset optiontree6 = structnew() />			
					
				<cfset subcat6 = false />
				<cfset subcat6canceldeath = false />
				<cfset subcat6cancel911 = false />
				<cfset subcat6canceldisable = false />
				<cfset subcat6cancelcs = false />
				<cfset subcat6cancelunpaid = false />
				<cfset subcat6cancelatb = false />
				<cfset subcat6cancelcert = false />
				<cfset subcat6psforgive = false />
				<cfset subcat6pslf = "no" />
				<cfset subcat6tlforgive = false />
				<cfset subcat6tlf = "no" />
				<cfset subcat6default = false />
				<cfset subcat6rehab = "no" />
				<cfset subcat6consol = "no" />
				<cfset subcat6default = false />
				<cfset subcat6wg = "no" />
				<cfset subcat6to = "no" />
				<cfset subcat6post = false />
				<cfset subcat6postdefer = "no" />
				<cfset subcat6postforbear = "no" />
				<cfset subcat6bk = false />
				<cfset subcat6oic = false />
				
				
				<!--- // qualify this category --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
						<cfset subcat6 = true />
					</cfif>
				</cfloop>							
				
				<!--- // Cancellation Options Survey Question 1 thru 7 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat6canceldeath = true />				
				</cfif>
						
				<cfif trim( surveyq2.slqa ) is "yes">
					<cfset subcat6cancel911 = true />				
				</cfif>
				
				<cfif trim( surveyq3.slqa ) is "yes">
					<cfset subcat6canceldisable = true />				
				</cfif>
				
				<cfif trim( surveyq7.slqa ) is "yes">
					<cfset subcat6cancelcert = true />				
				</cfif>

				<!--- // 12-9-2013 // add qualifier for closed school/cancellation vs origination date --->
				<cfif trim( surveyq4.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat6cancelcs = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq5.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat6cancelunpaid = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq6.slqa ) is "no">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat6cancelatb = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // Survery Question 13 --->
				<cfif trim( surveyq13.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif trim( statuscoderefer ) is not "df" and statuscoderefer is not "ba" and statuscoderefer is not "dj" and statuscoderefer is not "wg">								
								<cfset subcat6psforgive = true />
								<cfset subcat6pslf = "yes" />												
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>			
				
				<!--- // Survery Question 14 --->
				<cfif trim( surveyq14.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif trim( statuscoderefer ) is not "df" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg" and trim( statuscoderefer ) is not "to" and trim( statuscoderefer ) is not "dn">
								<cfif datecompare( closeddate, "10/1/1998", "d" ) eq 1>
									<cfset subcat6tlforgive = false />
									<cfset subcat6tlf = "no" />							
								</cfif>						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // default intervention rehab // 10-24-2013 check q29 --->				
				<cfif trim( surveyq29.slqa ) is "no" or trim( surveyq29.slqa ) is "N/A">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dg" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfif rehabafter is "N">
									<cfset subcat6default = true />
									<cfset subcat6rehab = "yes">								
								</cfif>									
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // default intervention // 10-24-2013 // remove check on q29 --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
						<cfif trim( loancode ) is not "aa" and ( trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "dj" or trim( statuscoderefer ) is "df" )>
							<cfif trim( prevconsol ) is "n" and worksheets.recordcount gt 1>
								<cfset subcat6default = true />
								<cfset subcat6consol = "yes" />							
							</cfif>						
						</cfif>
					</cfif>
				</cfloop>				
				

				<!--- // default intervention wage garnishment q24 --->
				<cfif trim( surveyq24.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat6default = true />
								<cfset subcat6wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention wage garnishment q25 --->
				<cfif trim( surveyq25.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat6default = true />
								<cfset subcat6wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>				
				
				<!--- // default intervention tax off set // survey questions 26 --->
				<cfif trim( surveyq26.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat6default = true />
								<cfset subcat6to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				<!--- // default intervention tax off set // survey questions 27 --->
				<cfif trim( surveyq27.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat6default = true />
								<cfset subcat6to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention tax off set // survey questions 28 --->
				<cfif trim( surveyq28.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat6default = true />
								<cfset subcat6to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq20.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datecompare( closeddate, "6/30/1987", "d" ) eq -1 >
								<cfset subcat6post = true />
								<cfset subcat6postdefer = "yes" />
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq21.slqa ) is "yes">
					<cfset date1 = "7/1/1987" />
					<cfset date2 = "6/30/1993" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>
								<cfset subcat6post = true />
								<cfset subcat6postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				 
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq22.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfif datecompare( closeddate, "7/1/1993", "d" ) eq 1 >
								<cfset subcat6post = true />
								<cfset subcat6postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // postponement forbearance --->
				<cfif trim( surveyq23.slqa ) is "yes">				
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X">
							<cfset subcat6post = true />
							<cfset subcat6postforbear = "yes" />
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // bankruptcy and offer in compromise --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat6bk = true />			
				</cfif>

				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "T" or trim( loancode ) is "U" or trim( loancode ) is "X" >
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj" >
							<cfset subcat6oic = true />											
						</cfif>
					</cfif>
				</cfloop>
				
				
				
				<!--- // add option tree 1 values to our structure --->
				<cfset subcat6 = structinsert( optiontree6, "subcat6", subcat6 ) />
				<cfset subcat6canceldeath = structinsert( optiontree6, "subcat6canceldeath", subcat6canceldeath ) />
				<cfset subcat6cancel911 = structinsert( optiontree6, "subcat6cancel911", subcat6cancel911 ) />
				<cfset subcat6canceldisable = structinsert( optiontree6, "subcat6canceldisable", subcat6canceldisable ) />
				<cfset subcat6cancelcs = structinsert( optiontree6, "subcat6cancelcs", subcat6cancelcs ) />
				<cfset subcat6cancelunpaid = structinsert( optiontree6, "subcat6cancelunpaid", subcat6cancelunpaid ) />
				<cfset subcat6cancelatb = structinsert( optiontree6, "subcat6cancelatb", subcat6cancelatb ) />
				<cfset subcat6cancelcert = structinsert( optiontree6, "subcat6cancelcert", subcat6cancelcert ) />				
				<cfset subcat6psforgive = structinsert( optiontree6, "subcat6psforgive", subcat6psforgive ) />
				<cfset subcat6pslf = structinsert( optiontree6, "subcat6pslf", subcat6pslf ) />
				<cfset subcat6tlforgive = structinsert( optiontree6, "subcat6tlforgive", subcat6tlforgive ) />
				<cfset subcat6tlf = structinsert( optiontree6, "subcat6tlf", subcat6tlf ) />
				<cfset subcat6default = structinsert( optiontree6, "subcat6default", subcat6default ) />
				<cfset subcat6to = structinsert( optiontree6, "subcat6to", subcat6to ) />
				<cfset subcat6rehab = structinsert( optiontree6, "subcat6rehab", subcat6rehab ) />			
				<cfset subcat6consol = structinsert( optiontree6, "subcat6consol", subcat6consol ) />				
				<cfset subcat6wg = structinsert( optiontree6, "subcat6wg", subcat6wg ) />
				<cfset subcat6post = structinsert( optiontree6, "subcat6post", subcat6post ) />				
				<cfset subcat6postdefer = structinsert( optiontree6, "subcat6postdefer", subcat6postdefer ) />
				<cfset subcat6postforbear = structinsert( optiontree6, "subcat6postforbear", subcat6postforbear ) />				
				<cfset subcat6bk = structinsert( optiontree6, "subcat6bk", subcat6bk ) />
				<cfset subcat6oic = structinsert( optiontree6, "subcat6oic", subcat6oic ) />
				
			<cfreturn optiontree6 >
		
		</cffunction>	
	
	
	</cfcomponent>