



			<!--- // looping over an array --->
			<cfparam name="slworksheetarray" default="">
			<cfparam name="worksheetID" default="">
			
			<cfset worksheetid = #form.debtid# />
			
			<cfset slworksheetarray = listtoarray( debtid ) />
			
			<cfloop from="1" to="#arraylen( slworksheetarray )#" step="1" index="i">
				
				<cfquery datasource="#application.dsn#" name="solutionworksheets">
					insert into solution
					
									(
					
									leadid,
									solutiondate,
									solutionoptiontree,
									solutionoption,
									solutionworksheetid,
									solutionnotes,
									solutionselectedby
									)
								
								values
								
									(
								
									<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
									<cfqueryparam value="#treenum#" cfsqltype="cf_sql_numeric" />,
									<cfqueryparam value="#selectedoption#" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="#slworksheetarray[i]#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="none entered" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
								
									);
				</cfquery>
			
			</cfloop>
			
			
			