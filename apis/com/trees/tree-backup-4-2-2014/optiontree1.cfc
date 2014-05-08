

	<cfcomponent displayname="optiontree1">
	
		<cffunction name="getoptiontree1" access="remote" output="false" hint="I generate student loan option tree 1.">
			
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
					select lc.loancode, slw.closeddate, slw.prevconsol, slw.rehabafter, slw.active, rc.repaycode, 
					       sc.statuscode, sc.statuscoderefer
					  from slworksheet slw, loancodes lc, repaycodes rc, statuscodes sc
					 where slw.loancodeid = lc.loancodeid
					   and slw.repaycodeid = rc.repaycodeid
					   and slw.statuscodeid = sc.statuscodeid
					   and slw.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by lc.loancode asc
				</cfquery>
				
				
				<!--- create our structure to hold our values --->
				<cfset optiontree1 = structnew() />
			
					
				<cfset subcat1 = false />
				
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "D" or trim( loancode ) is "L" or trim( loancode ) is "I" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
						<cfset subcat1 = true />
					</cfif>
				</cfloop>
				
				<!--- // default out variables to false --->			
				<cfset subcat1canceldeath = false />
				<cfset subcat1cancel911 = false />
				<cfset subcat1canceldisable = false />
				<cfset subcat1cancelcs = false />
				<cfset subcat1cancelunpaid = false />
				<cfset subcat1cancelatb = false />
				<cfset subcat1cancelcert = false />
				<cfset subcat1psforgive = false />
				<cfset subcat1pslf = "no" />
				<cfset subcat1tlforgive = false />
				<cfset subcat1tlf = "no" />
				<cfset subcat1default = false />
				<cfset subcat1wg = "no" />
				<cfset subcat1to = "no" />
				<cfset subcat1rehab = "no" />
				<cfset subcat1consol = "no" />
				<cfset subcat1post = false />
				<cfset subcat1postdefer = "no" />
				<cfset subcat1postforbear = "no" />
				<cfset subcat1bk = false />
				<cfset subcat1oic = false />			
				
				
				
				<!--- // Cancellation Options Survey Question 1 thru 7 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat1canceldeath = true />				
				</cfif>
						
				<cfif trim( surveyq2.slqa ) is "yes">
					<cfset subcat1cancel911 = true />			
				</cfif>
				
				<cfif trim( surveyq3.slqa ) is "yes">
					<cfset subcat1canceldisable = true />				
				</cfif>
				
				<cfif trim( surveyq7.slqa ) is "yes">
					<cfset subcat1cancelcert = true />					
				</cfif>

				<!--- // 12-9-2013 // add origination/closed school date to qualifier --->
				<cfif trim( surveyq4.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">					
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>							
								<cfset subcat1cancelcs = true />
							</cfif>
						</cfif>
					</cfloop>					
				</cfif>
				
				<cfif trim( surveyq5.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">					
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat1cancelunpaid = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq6.slqa ) is "no">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">					
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat1cancelatb = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // Survery Question 13 --->
				<cfif trim( surveyq13.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is not "df" and statuscoderefer is not "ba" and statuscoderefer is not "dj" and statuscoderefer is not "wg">
								<cfset subcat1psforgive = true />
								<cfset subcat1pslf = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>			
				
				<!--- // Survery Question 14 --->
				<cfif trim( surveyq14.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is not "DF" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg" and trim( statuscoderefer ) is not "to" and trim( statuscoderefer ) is not "dn">
								<cfif datecompare( closeddate, "10/1/1998", "d" ) eq 1>
									<cfset subcat1tlforgive = true />
									<cfset subcat1tlf = "yes" />							
								</cfif>
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // default intervention rehab // 10-24-2013 // change to check q29 --->				
				<cfif trim( surveyq29.slqa ) is "no" or trim( surveyq29.slqa ) is "N/A" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dg" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfif rehabafter is "N">
									<cfset subcat1default = true />
									<cfset subcat1rehab = "yes">							
								</cfif>												
							</cfif>						
						</cfif>
					</cfloop>		
				</cfif>
				
				<!--- // default consolidation // 10-24-13 // change to not check q29 --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "dj" or trim( statuscoderefer ) is "df">
							<cfif trim( prevconsol ) is "n">
								<cfset subcat1default = true />
								<cfset subcat1consol = "yes" />								
							</cfif>							
						</cfif>						
					</cfif>
				</cfloop>				
					
				
				
				<!--- // default intervention wage garnishment q24 --->
				<cfif trim( surveyq24.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat1default = true />
								<cfset subcat1wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention wage garnishment q25 --->
				<cfif trim( surveyq25.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat1default = true />
								<cfset subcat1wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // default intervention tax off set // survey questions 26 --->
				<cfif trim( surveyq26.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat1default = true />
								<cfset subcat1to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				<!--- // default intervention tax off set // survey questions 27 --->
				<cfif trim( surveyq27.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat1default = true />
								<cfset subcat1to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention tax off set // survey questions 28 --->
				<cfif trim( surveyq28.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat1default = true />
								<cfset subcat1to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq20.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif datecompare( closeddate, "6/30/1987", "d" ) eq -1 >
								<cfset subcat1post = true />
								<cfset subcat1postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>
				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq21.slqa ) is "yes">
					<cfset date1 = "7/1/1987" />
					<cfset date2 = "6/30/1993" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>
								<cfset subcat1post = true />
								<cfset subcat1postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				 
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq22.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfif datecompare( closeddate, "7/1/1993", "d" ) eq 1 >
								<cfset subcat1post = true />
								<cfset subcat1postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // postponement forbearance --->
				<cfif trim( surveyq23.slqa ) is "yes">				
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "D" or trim( loancode ) is "I" or trim( loancode ) is "L" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
							<cfset subcat1post = true />
							<cfset subcat1postforbear = "yes" />
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // bankruptcy and offer in compromise --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat1bk = true />						
				</cfif>

				
				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "D" or trim( loancode ) is "L" or trim( loancode ) is "I" or trim( loancode ) is "AC" or trim( loancode ) is "AD">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj" >
							<cfset subcat1oic = true />												
						</cfif>
					</cfif>
				</cfloop>				
				
				
				
				
				<!--- // add option tree 1 values to our structure --->
				<cfset subcat1 = structinsert( optiontree1, "subcat1", subcat1 ) />
				<cfset subcat1canceldeath = structinsert( optiontree1, "subcat1canceldeath", subcat1canceldeath ) />
				<cfset subcat1cancel911 = structinsert( optiontree1, "subcat1cancel911", subcat1cancel911 ) />
				<cfset subcat1canceldisable = structinsert( optiontree1, "subcat1canceldisable", subcat1canceldisable ) />
				<cfset subcat1cancelcs = structinsert( optiontree1, "subcat1cancelcs", subcat1cancelcs ) />
				<cfset subcat1cancelunpaid = structinsert( optiontree1, "subcat1cancelunpaid", subcat1cancelunpaid ) />
				<cfset subcat1cancelatb = structinsert( optiontree1, "subcat1cancelatb", subcat1cancelatb ) />
				<cfset subcat1cancelcert = structinsert( optiontree1, "subcat1cancelcert", subcat1cancelcert ) />
				<cfset subcat1psforgive = structinsert( optiontree1, "subcat1psforgive", subcat1psforgive ) />
				<cfset subcat1pslf = structinsert( optiontree1, "subcat1pslf", subcat1pslf ) />
				<cfset subcat1tlforgive = structinsert( optiontree1, "subcat1tlforgive", subcat1tlforgive ) />
				<cfset subcat1tlf = structinsert( optiontree1, "subcat1tlf", subcat1tlf ) />
				<cfset subcat1default = structinsert( optiontree1, "subcat1default", subcat1default ) />
				<cfset subcat1to = structinsert( optiontree1, "subcat1to", subcat1to ) />
				<cfset subcat1rehab = structinsert( optiontree1, "subcat1rehab", subcat1rehab ) />			
				<cfset subcat1consol = structinsert( optiontree1, "subcat1consol", subcat1consol ) />
				<cfset subcat1wg = structinsert( optiontree1, "subcat1wg", subcat1wg ) />
				<cfset subcat1post = structinsert( optiontree1, "subcat1post", subcat1post ) />
				<cfset subcat1postdefer = structinsert( optiontree1, "subcat1postdefer", subcat1postdefer ) />
				<cfset subcat1postforbear = structinsert( optiontree1, "subcat1postforbear", subcat1postforbear ) />
				<cfset subcat1bk = structinsert( optiontree1, "subcat1bk", subcat1bk ) />
				<cfset subcat1oic = structinsert( optiontree1, "subcat1oic", subcat1oic ) />
			
			<cfreturn optiontree1 >
		
		</cffunction>	
	
	
	</cfcomponent>