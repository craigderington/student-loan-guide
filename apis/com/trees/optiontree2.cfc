
		

	<cfcomponent displayname="optiontree2">
	
		<cffunction name="getoptiontree2" access="remote" output="false" hint="I generate student loan option tree 2.">
			
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
				<cfset optiontree2 = structnew() />
			
					
				<cfset subcat2 = false />
				<cfset subcat2canceldeath = false />
				<cfset subcat2cancel911 = false />
				<cfset subcat2canceldisable = false />
				<cfset subcat2cancelcs = false />
				<cfset subcat2cancelunpaid = false />
				<cfset subcat2cancelatb = false />
				<cfset subcat2cancelcert = false />
				<cfset subcat2psforgive = false />
				<cfset subcat2pslf = "no" />
				<cfset subcat2tlforgive = false />
				<cfset subcat2tlf = "no" />
				<cfset subcat2default = false />
				<cfset subcat2rehab = "no" />				
				<cfset subcat2consol = "no" />
				<cfset subcat2wg = "no" />
				<cfset subcat2to = "no" />
				<cfset subcat2post = false />
				<cfset subcat2postdefer = "no" />
				<cfset subcat2postforbear = "no" />
				<cfset subcat2bk = false />
				<cfset subcat2oic = false />
				
				
				<!--- // qualify this category --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "P" or trim( loancode ) is "S" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
						<cfset subcat2 = true />
					</cfif>
				</cfloop>
							
				
				<!--- // Cancellation Options Survey Question 1 thru 7 --->
				<cfif trim( surveyq1.slqa ) is "yes">
					<cfset subcat2canceldeath = true />
				</cfif>
						
				<cfif trim( surveyq2.slqa ) is "yes">
					<cfset subcat2cancel911 = true />				
				</cfif>
				
				<cfif trim( surveyq3.slqa ) is "yes">
					<cfset subcat2canceldisable = true />				
				</cfif>			
				
				<cfif trim( surveyq7.slqa ) is "yes">
					<cfset subcat2cancelcert = true />				
				</cfif>

				
				<!--- // 12-9-2013 // add qualifier for originationdate/closed school --->
				<cfif trim( surveyq4.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat2cancelcs = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq5.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat2cancelunpaid = true />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfif trim( surveyq6.slqa ) is "no">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datecompare( closeddate, "1/1/1986", "d" ) eq 1>
								<cfset subcat2cancelatb = true />	
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				
				
				<!--- // Survery Question 13 --->
				<cfif trim( surveyq13.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is not "df" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg">								
								<cfset subcat2psforgive = true />
								<cfset subcat2pslf = "yes" />								
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>			
				
				<!--- // Survery Question 14 --->
				<cfif trim( surveyq14.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is not "DF" and trim( statuscoderefer ) is not "ba" and trim( statuscoderefer ) is not "dj" and trim( statuscoderefer ) is not "wg" and trim( statuscoderefer ) is not "to" and trim( statuscoderefer ) is not "dn">
								<cfif datecompare( closeddate, "10/1/1998", "d" ) eq 1>
									<cfset subcat2tlforgive = true />
									<cfset subcat2tlf = "yes" />							
								</cfif>						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // default intervention rehab --->				
				<cfif trim( surveyq29.slqa ) is "no" or trim( surveyq29.slqa ) is "N/A" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dg" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfif trim( rehabafter ) is "N">
									<cfset subcat2default = true />
									<cfset subcat2rehab = "yes">
								</cfif>											
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				
				<!--- // 10-24-2013 // change to remove check on q29 --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
						<cfif trim( loancode ) is not "aa" and ( trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "dj" or trim( statuscoderefer ) is "df" )>
							<cfif trim( prevconsol ) is "n">
								<cfset subcat2default = true />
								<cfset subcat2consol = "yes" />								
							</cfif>							
						</cfif>						
					</cfif>
				</cfloop>				
				
				
				<!--- // default intervention wage garnishment q24 --->
				<cfif trim( surveyq24.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat2default = true />
								<cfset subcat2wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention wage garnishment q25 --->
				<cfif trim( surveyq25.slqa ) is "yes" >
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat2default = true />
								<cfset subcat2wg = "yes" />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // default intervention tax off set // survey questions 26 --->
				<cfif trim( surveyq26.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat2default = true />
								<cfset subcat2to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				<!--- // default intervention tax off set // survey questions 27 --->
				<cfif trim( surveyq27.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat2default = true />
								<cfset subcat2to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- // default intervention tax off set // survey questions 28 --->
				<cfif trim( surveyq28.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "dn">
								<cfset subcat2default = true />
								<cfset subcat2to = "yes">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>		
				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq20.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datecompare( closeddate, "6/30/1987", "d" ) eq -1 >
								<cfset subcat2post = true />
								<cfset subcat2postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>					
				</cfif>				
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq21.slqa ) is "yes">
					<cfset date1 = "7/1/1987" />
					<cfset date2 = "6/30/1993" />				
					<cfloop query="worksheets">			
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datediff( "d", closeddate, date1 ) GTE 0 and datediff( "d", closeddate, date2 ) GTE 0>
								<cfset subcat2post = true />
								<cfset subcat2postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				 
				
				<!--- // postponement deferment --->
				<cfif trim( surveyq22.slqa ) is "yes">
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfif datecompare( closeddate, "7/1/1993", "d" ) eq 1 >
								<cfset subcat2post = true />
								<cfset subcat2postdefer = "yes" />						
							</cfif>
						</cfif>
					</cfloop>				
				</cfif>				
				
				<!--- // postponement forbearance --->
				<cfif trim( surveyq23.slqa ) is "yes">				
					<cfloop query="worksheets">
						<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
							<cfset subcat2post = true />
							<cfset subcat2postforbear = "yes" />
						</cfif>
					</cfloop>
				</cfif>					
				
				<!--- // bankruptcy and offer in compromise --->
				<cfif trim( surveyq30.slqa ) is "no">
					<cfset subcat2bk = true />			
				</cfif>

				<!--- // offer in compromise --->
				<cfloop query="worksheets">
					<cfif trim( loancode ) is "A" or trim( loancode ) is "B" or trim( loancode ) is "C" or trim( loancode ) is "G" or trim( loancode ) is "H" or trim( loancode ) is "O" or trim( loancode ) is "S" or trim( loancode ) is "P" or trim( loancode ) is "S" or trim( loancode ) is "J" or trim( loancode ) is "AB" or trim( loancode ) is "AF">
						<cfif trim( statuscoderefer ) is "dn" or trim( statuscoderefer ) is "to" or trim( statuscoderefer ) is "wg" or trim( statuscoderefer ) is "df" or trim( statuscoderefer ) is "dj" >
							<cfset subcat2oic = true />												
						</cfif>
					</cfif>
				</cfloop>
				
				
				
				<!--- // add option tree 2 values to our structure --->
				<cfset subcat2 = structinsert( optiontree2, "subcat2", subcat2 ) />				
				<cfset subcat2canceldeath = structinsert( optiontree2, "subcat2canceldeath", subcat2canceldeath ) />
				<cfset subcat2cancel911 = structinsert( optiontree2, "subcat2cancel911", subcat2cancel911 ) />
				<cfset subcat2canceldisable = structinsert( optiontree2, "subcat2canceldisable", subcat2canceldisable ) />
				<cfset subcat2cancelcs = structinsert( optiontree2, "subcat2cancelcs", subcat2cancelcs ) />
				<cfset subcat2cancelunpaid = structinsert( optiontree2, "subcat2cancelunpaid", subcat2cancelunpaid ) />
				<cfset subcat2cancelatb = structinsert( optiontree2, "subcat2cancelatb", subcat2cancelatb ) />
				<cfset subcat2cancelcert = structinsert( optiontree2, "subcat2cancelcert", subcat2cancelcert ) />				
				<cfset subcat2psforgive = structinsert( optiontree2, "subcat2psforgive", subcat2psforgive ) />
				<cfset subcat2pslf = structinsert( optiontree2, "subcat2pslf", subcat2pslf ) />				
				<cfset subcat2tlforgive = structinsert( optiontree2, "subcat2tlforgive", subcat2tlforgive ) />
				<cfset subcat2tlf = structinsert( optiontree2, "subcat2tlf", subcat2tlf ) />
				<cfset subcat2default = structinsert( optiontree2, "subcat2default", subcat2default ) />				
				<cfset subcat2to = structinsert( optiontree2, "subcat2to", subcat2to ) />				
				<cfset subcat2rehab = structinsert( optiontree2, "subcat2rehab", subcat2rehab ) />			
				<cfset subcat2consol = structinsert( optiontree2, "subcat2consol", subcat2consol ) />				
				<cfset subcat2wg = structinsert( optiontree2, "subcat2wg", subcat2wg ) />
				<cfset subcat2post = structinsert( optiontree2, "subcat2post", subcat2post ) />
				<cfset subcat2postdefer = structinsert( optiontree2, "subcat2postdefer", subcat2postdefer ) />
				<cfset subcat2postforbear = structinsert( optiontree2, "subcat2postforbear", subcat2postforbear ) />
				<cfset subcat2bk = structinsert( optiontree2, "subcat2bk", subcat2bk ) />
				<cfset subcat2oic = structinsert( optiontree2, "subcat2oic", subcat2oic ) />
				
			<cfreturn optiontree2 >
		
		</cffunction>	
	
	
	</cfcomponent>