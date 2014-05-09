

	

	<cfcomponent displayname="optiontree4">
	
		<cffunction name="getoptiontree4" access="remote" output="false" hint="I generate student loan option tree 4.">
			
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
				<cfset optiontree4 = structnew() />
			
				<cfset subcat4 = false />
				<cfset subcat4canceldeath = false />
				<cfset subcat4cancel911 = false />
				<cfset subcat4canceldisable = false />
				<cfset subcat4cancelcs = false />
				<cfset subcat4cancelunpaid = false />			
				<cfset subcat4cancelatb = false />
				<cfset subcat4cancelcert = false />
				<cfset subcat4psforgive = false />
				<cfset subcat4pslf = "no" />
				<cfset subcat4tlforgive = false />
				<cfset subcat4tlf = "no" />
				<cfset subcat4default = false />
				<cfset subcat4consol = false />
				<cfset subcat4rehab = "no" />				
				<cfset subcat4wg = "no" />
				<cfset subcat4to = "no" />
				<cfset subcat4post = false />
				<cfset subcat4postdefer = "no" />
				<cfset subcat4postforbear = "no" />
				<cfset subcat4bk = false />
				<cfset subcat4oic = false />
				<cfset subcat4repay = false />
				
				
				<!--- // qualify this category --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
						<cfset subcat4 = true />
					</cfif>
				</cfloop>
							
				
				<!--- // Cancellation Options Survey Question 1 thru 7 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat4canceldeath = true />				
				</cfif>
						
				<cfif trim( surveyq2.slqa ) is "yes">
					<cfset subcat4cancel911 = true />				
				</cfif>
				
				<cfif trim( surveyq3.slqa ) is "yes">
					<cfset subcat4canceldisable = true />				
				</cfif>			
				
				<cfif trim( surveyq7.slqa ) is "yes">
					<cfset subcat4cancelcert = true />				
				</cfif>

				<!--- // 12-9-2013 // ad qualifier for closed school/cancellation --->
				<cfif trim( surveyq4.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat4cancelcs = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq5.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat4cancelunpaid = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq6.slqa ) is "no">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat4cancelatb = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // Survery Question 13 --->
				<cfif trim( surveyq13.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif trim( statuscoderefer ) is not "df" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg">
								<cfset subcat4psforgive = true />
								<cfset subcat4pslf = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>		
				
				<!--- // Survery Question 14 --->
				<cfif trim( surveyq14.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif trim( statuscoderefer ) is not "df" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg" and trim( statuscoderefer ) is not "to" and trim( statuscoderefer ) is not "dn">
								<cfif datecompare( closeddate, "10/1/1998", "d" ) eq 1>
									<cfset subcat4tlforgive = true />
									<cfset subcat4tlf = "yes" />							
								</cfif>						
							</cfif>
						</cfif>
					</cfloop>			
				</cfif>			
				
				<!--- // default intervention rehab // 10-24-2013 // check q29 --->				
				<cfif trim( surveyq29.slqa ) is "no" or trim( surveyq29.slqa ) is "N/A">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dg" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfif rehabafter is "N">
									<cfset subcat4default = true />
									<cfset subcat4rehab = "yes">							
								</cfif>											
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // default intervention rehab // 10-24-2013 // check to remove q29 --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
						<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dg" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
							<cfif trim( prevconsol ) is "n">
								<cfset subcat4default = true />
								<cfset subcat4consol = "yes" />							
							</cfif>
						</cfif>
					</cfif>						
				</cfloop>				
				

				<!--- // default intervention wage garnishment q24 --->
				<cfif trim( surveyq24.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat4default = true />
								<cfset subcat4wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention wage garnishment q25 --->
				<cfif trim( surveyq25.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat4default = true />
								<cfset subcat4wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // default intervention tax off set // survey questions 26 --->
				<cfif trim( surveyq26.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat4default = true />
								<cfset subcat4to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				<!--- // default intervention tax off set // survey questions 27 --->
				<cfif trim( surveyq27.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat4default = true />
								<cfset subcat4to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention tax off set // survey questions 28 --->
				<cfif trim( surveyq28.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V" >
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat4default = true />
								<cfset subcat4to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				<!--- // default intervention wage garnishment 
				<cfif trim( surveyq24.slqa ) is "yes" or trim( surveyq25.slqa ) is "yes" >
					<cfset subcat4default = true />
					<cfset subcat4wg = "yes" />				
				</cfif>
				
				<!--- // default intervention tax off set // survey questions 26 thru 28 --->
				<cfif trim( surveyq26.slqa ) is "yes" or trim( surveyq27.slqa ) is "yes" or trim( surveyq28.slqa ) is "yes">
					<cfset subcat4default = true />
					<cfset subcat4to = "yes">					
				</cfif>				
				--->			
				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq20.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datecompare( closeddate, "6/30/1987", "d" ) eq -1 >
								<cfset subcat4post = true />
								<cfset subcat4postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq21.slqa ) is "yes">
					<cfset date1 = "7/1/1987" />
					<cfset date2 = "6/30/1993" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>
								<cfset subcat4post = true />
								<cfset subcat4postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>				 
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq22.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfif datecompare( closeddate, "7/1/1993", "d" ) eq 1 >
								<cfset subcat4post = true />
								<cfset subcat4postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>
				</cfif>			
				
				<!--- // postponement forbearance --->
				<cfif trim( surveyq23.slqa ) is "yes">				
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
							<cfset subcat4post = true />
							<cfset subcat4postforbear = "yes" />
						</cfif>
					</cfloop>
				</cfif>			
				
				<!--- // bankruptcy and offer in compromise --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat4bk = true />							
				</cfif>

				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "E" or trim( loancode ) is "K" or trim( loancode ) is "V">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj" >
							<cfset subcat4oic = true />												
						</cfif>
					</cfif>
				</cfloop>
				
				<!--- // 12-9-2013 // add qualifier for direct consolidation loans --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is not "E" and trim( loancode ) is not "K" and trim( loancode ) is not "V" and trim( loancode ) is not "aa">						
						<cfset subcat4repay = true />					
					</cfif>
				</cfloop>
				
				
				<!--- // add option tree 4 values to our structure --->
				<cfset subcat4 = structinsert( optiontree4, "subcat4", subcat4 ) />
				<cfset subcat4canceldeath = structinsert( optiontree4, "subcat4canceldeath", subcat4canceldeath ) />
				<cfset subcat4cancel911 = structinsert( optiontree4, "subcat4cancel911", subcat4cancel911 ) />
				<cfset subcat4canceldisable = structinsert( optiontree4, "subcat4canceldisable", subcat4canceldisable ) />
				<cfset subcat4cancelcs = structinsert( optiontree4, "subcat4cancelcs", subcat4cancelcs ) />
				<cfset subcat4cancelunpaid = structinsert( optiontree4, "subcat4cancelunpaid", subcat4cancelunpaid ) />
				<cfset subcat4cancelatb = structinsert( optiontree4, "subcat4cancelatb", subcat4cancelatb ) />
				<cfset subcat4cancelcert = structinsert( optiontree4, "subcat4cancelcert", subcat4cancelcert ) />				
				<cfset subcat4psforgive = structinsert( optiontree4, "subcat4psforgive", subcat4psforgive ) />
				<cfset subcat4pslf = structinsert( optiontree4, "subcat4pslf", subcat4pslf ) />
				<cfset subcat4tlforgive = structinsert( optiontree4, "subcat4tlforgive", subcat4tlforgive ) />
				<cfset subcat4tlf = structinsert( optiontree4, "subcat4tlf", subcat4tlf ) />
				<cfset subcat4default = structinsert( optiontree4, "subcat4default", subcat4default ) />
				<cfset subcat4to = structinsert( optiontree4, "subcat4to", subcat4to ) />
				<cfset subcat4rehab = structinsert( optiontree4, "subcat4rehab", subcat4rehab ) />			
				<cfset subcat4consol = structinsert( optiontree4, "subcat4consol", subcat4consol ) />				
				<cfset subcat4wg = structinsert( optiontree4, "subcat4wg", subcat4wg ) />
				<cfset subcat4post = structinsert( optiontree4, "subcat4post", subcat4post ) />				
				<cfset subcat4postdefer = structinsert( optiontree4, "subcat4postdefer", subcat4postdefer ) />
				<cfset subcat4postforbear = structinsert( optiontree4, "subcat4postforbear", subcat4postforbear ) />				
				<cfset subcat4bk = structinsert( optiontree4, "subcat4bk", subcat4bk ) />
				<cfset subcat4oic = structinsert( optiontree4, "subcat4oic", subcat4oic ) />
				<cfset subcat4repay = structinsert( optiontree4, "subcat4repay", subcat4repay ) />
				
			<cfreturn optiontree4 >
		
		</cffunction>	
	
	
	</cfcomponent>