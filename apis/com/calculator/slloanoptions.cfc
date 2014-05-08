		
		
		<cfcomponent displayname="clientloanoptions">
		
			<cffunction name="init" access="public" output="false" returntype="clientloanoptions" hint="Returns an initialized client loan options function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>

			<!--- Calculate the ISR Repayment Formula --->
			<cffunction name="getclientloaninfo" access="remote" output="false">				
				<cfargument name="leadid" required="yes" type="numeric">				
					
					<!--- Get the client student loan totals --->
					<cfquery datasource="#application.dsn#" name="loanTotals">
						SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
							   AVG(intrate) as irate
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />		
					</cfquery>
					
					<cfquery datasource="#application.dsn#" name="checkeda">
						select leadid, eda, spousedebt
						  FROM slsummary
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				   		
					</cfquery>
					
					<cfquery datasource="#application.dsn#" name="wInt">
						SELECT leadid,
							   SUM(loanBalance * (intrate/100)) AS weightInt
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
					  GROUP BY leadid
					</cfquery>
					
					<cfset wIntRate = NumberFormat(( wInt.weightInt/loanTotals.totalLoanAmount ) * 100.00, "9.999") />
					
					<cfif wIntRate GT 8.25>
						<cfset wIntRate = 8.25 />
					</cfif>
					
					<cfif trim( checkeda.eda ) is "yes">
						<cfset wIntRate = wIntRate - 0.25 />
					</cfif>
					
					<cfif checkeda.spousedebt gt 0>
						<cfset spousedebt = checkeda.spousedebt />
						<cfset totaldebtparty = loantotals.totalloanamount + spousedebt />
					<cfelse>
						<cfset totaldebtparty = loantotals.totalloanamount />
					</cfif>
					
					<cfset cloaninfo = StructNew()>	
					<cfset totalLoanAmount = StructInsert( cLoanInfo, "totalLoanAmount", loanTotals.totalLoanAmount ) />
					<cfset totalLoans = StructInsert( cLoanInfo, "totalLoans", loanTotals.totalLoans ) />
					<cfset irate = StructInsert( cLoanInfo, "irate", loanTotals.irate ) />
					<cfset weightRate = StructInsert( cLoanInfo, "weightRate", wIntRate ) />
					<cfset totalloandebt = structinsert( cLoanInfo, "totalloandebt", totaldebtparty ) />
			
				<cfreturn cloaninfo >
			
			</cffunction>


			<!--- Round up to nearest 1/8 percent --->
			<cffunction name="roundUpToNearestQuarter" output="FALSE" returntype="numeric">
				<cfargument name="number" type="numeric" required="TRUE" />

				  <cfscript>
					  var remainder = arguments.number - Int( arguments.number );
					
					  if( remainder <= .25 ){
						remainder = .25;
					  }else if( remainder <= .5 ){
						remainder = .5;
					  }else if( remainder <= .75 ){
						remainder = .75;
					  }else{
						remainder = 1;
					  }
				
					  return Int( arguments.number ) + remainder;
				  </cfscript>
			</cffunction>

		</cfcomponent>