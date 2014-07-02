		
		
		<cfcomponent displayname="studentloancalculator">
		
			<cffunction name="init" access="public" output="false" returntype="studentloancalculator" hint="Returns an initialized student loan calculator function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>

			<!--- check to see if the client has agreed to electronic debit authorization --->
			<cffunction name="getEDA" output="false" returntype="any" access="remote">
				<cfargument name="leadid" type="any" required="yes" default="#session.leadid#" >		
				
				<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="checkeda">
						select leadid, eda
						  from slsummary
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				  
					</cfquery>
					
					<cfif trim( checkeda.eda ) is "yes">
						<cfset eda = true />
					<cfelse>
						<cfset eda = false />
					</cfif>
					
					<cfreturn eda >				
			
			</cffunction>

			<!--- Does client qualify for IBR or ICR --->
			<cffunction name="qualifyClient" output="false" returntype="any" access="remote">
				<cfargument name="agi" type="any" required="yes">
				<cfargument name="famsize" type="any" required="yes">
				<cfargument name="region" type="any" required="yes">
				
				<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="povlookup">
						SELECT PovertyAmount
						  FROM PovertyGuide
						 WHERE Region = <cfqueryparam value="#arguments.region#" cfsqltype="cf_sql_varchar" />
						   AND HouseholdPersons = <cfqueryparam value="#arguments.famsize#" cfsqltype="cf_sql_numeric" /> 			
					</cfquery>
					
					<cfset qualifyThisClient = FALSE />
						
					<cfif arguments.agi LT (1.5 * povlookup.povertyamount)>
						<cfset qualifyThisClient = TRUE />
					<cfelse>
						<cfset qualifyThisClient = FALSE />
					</cfif>
					
					<cfreturn qualifyThisClient >
			
			
			</cffunction>
			

			<!--- Calculate the Income Based Repayment Formula --->
			<cffunction name="calcIBR" output="false" returntype="any" access="remote">
			
				<!--- Define arguments --->				
				<cfargument name="agi" type="any" required="yes">
				<cfargument name="region" type="any" required="yes">
				<cfargument name="famsize" type="any" required="yes">
				<cfargument name="leadid" default="#session.leadid#" required="yes" type="numeric">
					
					<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="povlookup">
						SELECT PovertyAmount
						  FROM PovertyGuide
						 WHERE Region = <cfqueryparam value="#arguments.region#" cfsqltype="cf_sql_varchar" />
						   AND HouseholdPersons = <cfqueryparam value="#arguments.famsize#" cfsqltype="cf_sql_numeric" />			
					</cfquery>

					<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="debtlookup">
						SELECT spousedebt, mfj, filingstatus
						  FROM slsummary
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />		
					</cfquery>
					
					<cfif debtlookup.spousedebt is "">
						<cfset totalspousedebt = 0.00 />
					<cfelse>
						<cfset totalspousedebt = debtlookup.spousedebt />
					</cfif>
			
			
					<cfset clientagi = arguments.agi />
					<cfset povamount = 1.5 * povlookup.povertyamount />
					
					<cfif clientagi GT povamount>				
						<cfset percentDisposeIncome =  clientagi - povamount />
					<cfelse>
						<cfset percentDisposeIncome = 0.00 />			
					</cfif>	
					
					<!--- // *** CLD 9-30-2013 *** --->
					<!--- // add the loan totals to the IBR calc to determine eligibility --->
					<!--- // get the Weighted Interest Rate for All SL Loans --->
					<cfquery datasource="#application.dsn#" name="ibrloans">
						SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
							   AVG(intrate) as irate
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
					</cfquery>
					
					<!--- // get the weighted interest rate --->
					<cfquery datasource="#application.dsn#" name="wInt">
						SELECT leadid,
							   SUM(loanBalance * (intrate/100)) AS weightInt
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					  GROUP BY leadid
					</cfquery>
					
					<!--- Calculate the weighted interest rate or use the interest rate for a single loan --->
					<cfif ibrloans.totalLoans GT 1>
						<cfset wIntRate = wInt.weightInt/ibrloans.totalLoanAmount * 100.00 />
						<cfset intRate = wIntRate/100.00 />
					<cfelse>		
						<cfset intRate = ibrloans.irate/100.00 />
					</cfif>
					
					<cfif intRate GT 0.08250 >
						<cfset intRate = 0.08250 />			
					</cfif>			
					
					<cfif this.getEDA() is true >
						<cfset intRate = intRate - 0.0025 />
					</cfif>
					
					
					<!--- Determine if the monthly payment is less than the threshold --->					
					<cfif percentDisposeIncome LTE 5.00>
						<cfset monthlyPaymentIBR = 0.00 />
						<cfset monthlyPayAsYouEarn = 0.00 />
						<cfset mstd = 0.00 />
					<cfelseif percentDisposeIncome GT 5.00 AND percentDisposeIncome LTE 10.00>
						<cfset monthlyPaymentIBR = 10.00 />
						<cfset monthlyPayAsYouEarn = 0.00 />
						<cfset mstd = 0.00 />
					<cfelseif percentDisposeIncome GT 10.00>				
						<cfset monthlyPaymentIBR = (0.15 * percentDisposeIncome) / 12 />				
						<cfset monthlyPayAsYouEarn = (.10 * percentDisposeIncome) / 12 />
						<cfset mstd = ibrloans.totalLoanAmount * (intRate/12) / (1-(1+intRate/12)^(-120)) />
					</cfif>
					
					<cfif trim( debtlookup.mfj ) is "YES">
						<cfif totalspousedebt gt 0.00>
							<cfset monthlyPaymentIBR = ( monthlyPaymentIBR * totalspousedebt ) / ( ibrloans.totalLoanAmount + totalspousedebt ) />
						</cfif>
					</cfif>
						
					
					<!--- // create our structure --->
					<cfset mIBR = StructNew() />
					<cfset mIBRPayAmt = StructInsert( mIBR, "mIBRPayAmt", monthlyPaymentIBR ) />
					<cfset mIBRPAYE = StructInsert( mIBR, "mIBRPAYE", monthlyPayAsYouEarn ) />
					<cfset mIBRStd = StructInsert( mIBR, "mIBRStd", mstd ) />
					
					<cfreturn mIBR >
			
			
			</cffunction>
			
			
			<!--- Calculate the Income Based Repayment Formula --->
			<cffunction name="calcICR" output="false" returntype="any" access="remote">
			
				<!--- Define arguments --->
				<cfargument name="agi" type="any" required="yes">
				<cfargument name="region" type="any" required="yes">
				<cfargument name="maritalstatus" type="any" required="yes">
				<cfargument name="famsize" type="any" required="yes">	
				<cfargument name="incomefactor" type="any" required="no">
				<cfargument name="leadid" type="numeric" required="yes">		
					
					<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="povlookup">
						SELECT PovertyAmount
						  FROM PovertyGuide
						 WHERE Region = <cfqueryparam value="#arguments.region#" cfsqltype="cf_sql_varchar" />
						   AND HouseholdPersons = <cfqueryparam value="#arguments.famsize#" cfsqltype="cf_sql_numeric" /> 			
					</cfquery>
					
					<!--- Look up the client AGI and compare to the Poverty Guide table --->
					<cfquery datasource="#application.dsn#" name="iclookup">
						SELECT TOP 1 IncomeAmount, Factor
						  FROM IncomeFactor
						 WHERE MaritalStatus = <cfqueryparam value="#arguments.maritalstatus#" cfsqltype="cf_sql_varchar" />
						   AND IncomeAmount !< <cfqueryparam value="#arguments.agi#" cfsqltype="cf_sql_numeric" /> 			
					</cfquery>
					
					<!--- Get the Weighted Interest Rate for All SL Loans --->
					<cfquery datasource="#application.dsn#" name="studentloans">
						SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
							   AVG(intrate) as irate
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />	
					</cfquery>

					<cfif studentloans.irate LT 3.50 >
						<cfset studentloans.irate = 3.50 />
					<cfelse>
						<cfset studentloans.irate = studentloans.irate />
					</cfif>
					
					<!--- Get the constant multiplier and interest rate  --->
					<cfquery datasource="#application.dsn#" name="conm">
						SELECT TOP 1 conintrate, annualmultiplier
						  FROM constantmultiplier
						 WHERE conintrate <= <cfqueryparam value="#studentloans.irate#" cfsqltype="cf_sql_numeric" />
					  ORDER BY annualmultiplier DESC 
					</cfquery>
					
					<cfif conm.annualmultiplier IS "" >
						<cfset conmultip = .131545 />
					<cfelse>
						<cfset conmultip = conm.annualmultiplier />
					</cfif>
			
					<!--- Set the value for the monthly payment --->
					<cfset proposedPayment1 = ((( agi - povlookup.povertyAmount ) * .20 )) / 12 />
					<cfset proposedPayment2A = (studentloans.totalloanamount * conmultip) />
					<cfset proposedPayment2B = (((proposedPayment2A * iclookup.factor) / 100) / 12 )  />		
					
					<!--- Compare the 2 formulas and get the lowest amount --->
					<cfif proposedPayment1 LT proposedPayment2B >
						<cfset monthlyPaymentICR = proposedPayment1 />
					<cfelseif proposedPayment2B LT proposedPayment1>
						<cfset monthlyPaymentICR = proposedPayment2B />
					</cfif>
					
					<cfif monthlyPaymentICR LTE 5.00 >
						<cfset monthlyPaymentICR = 5.00 />			
					</cfif>
			
					<cfreturn monthlyPaymentICR >
			
			
			</cffunction>


			<!--- Calculate the ISR Repayment Formula --->
			<cffunction name="calcISR" access="remote" output="false" returntype="any">
			
				<!--- Define arguments --->
				<cfargument name="agi" type="any" required="yes">
				<cfargument name="loanterm" type="any" required="yes">
				<cfargument name="totalLoanAmount" type="any" required="no">
				<cfargument name="irate" type="any" required="no">
				<cfargument name="leadid" type="numeric" required="yes">
				
					<!--- Get the client student loan totals --->
					<cfquery datasource="#application.dsn#" name="loanTotals">
						SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
							   AVG(intrate) as irate
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
					</cfquery>
			
					<cfset DTI = loanTotals.totalLoanAmount / (arguments.agi/12) />
					<cfset ifactor = DTI * .66666 />
					<cfset isrpayment = (ifactor * arguments.agi) / arguments.loanterm />
					
				<cfreturn isrPayment >
			
			</cffunction>
			
			
			<!--- Calculate the Standard Repayment Formula --->
			<cffunction name="calcSTD" access="remote" output="false" returntype="any">
			
				<!--- Define arguments --->
				<cfargument name="loanterm" type="any" required="yes">
				<cfargument name="irate" type="any" required="no">
				<cfargument name="intRate" type="any" required="no">
				<cfargument name="totalloanamount" type="any" required="no">
				<cfargument name="payment" type="any" required="no">
				<cfargument name="leadid" type="numeric" required="yes">
				
					<!--- Get the client student loan totals --->
					<cfquery datasource="#application.dsn#" name="loanTotals">
						SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
							   AVG(intrate) as irate
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_numeric" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
					</cfquery>
					
					<cfquery datasource="#application.dsn#" name="wInt">
						SELECT leadid,
							   SUM(loanBalance * (intrate/100)) AS weightInt
						  FROM slworksheet
						 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
					           AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					  GROUP BY leadid
					</cfquery>
					
					<!--- Calculate the weighted interest rate or use the interest rate for a single loan --->
					<cfif loanTotals.totalLoans GT 1>
						<cfset wIntRate = wInt.weightInt/loanTotals.totalLoanAmount * 100.00 />
						<cfset intRate = wIntRate/100.00 />
					<cfelse>		
						<cfset intRate = loantotals.irate/100.00 />
					</cfif>
					
					<cfif intRate GT 0.08250 >
						<cfset intRate = 0.08250 />			
					</cfif>			
					
					<cfif this.getEDA() is true >
						<cfset intRate = intRate - 0.0025 />
					</cfif>		
			
					<!--- ********************  Set the monthly payment according to the formula  *********************** --->			
					<!--- **********   Payment = Principal * (Interest Rate/12) / (1-(1+Interest Rate/12)^(-60)) ******** --->			
					<cfset monthlyPaymentStd = loanTotals.totalLoanAmount * (intRate/12) / (1-(1+intRate/12)^(-loanterm)) />
					
			
				<cfreturn monthlyPaymentStd >
				
			</cffunction>
				
			<!--- Calculate the Extended Repayment Formula --->
			<cffunction name="calcExt" access="remote" output="false" returntype="any">
				
					<!--- Define arguments --->
					<cfargument name="loanterm" type="any" required="yes">
					<cfargument name="irate" type="any" required="no">
					<cfargument name="intRate" type="any" required="no">
					<cfargument name="totalloanamount" type="any" required="no">
					<cfargument name="payment" type="any" required="no">
					<cfargument name="leadid" type="numeric" required="yes">
					
						<!--- Get the client student loan totals --->
						<cfquery datasource="#application.dsn#" name="loanTotals">
							SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
								   AVG(intrate) as irate
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
						           AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
						</cfquery>
						
						<cfquery datasource="#application.dsn#" name="wInt">
							SELECT leadid,
								   SUM(loanBalance * (intrate/100)) AS weightInt
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
							   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						  GROUP BY leadid
						</cfquery>
						
						<!--- If the loan balance is over 30000, set the loan terms to 300 months --->				
						<cfif loanTotals.totalLoanAmount GT 30000>
							<cfset loanTerm = 300 />
						<cfelse>
							<cfset loanterm = loanterm />
						</cfif>
						
						<!--- Calculate the weighted interest rate or use the interest rate for a single loan --->
						<cfif loanTotals.totalLoans GT 1>
							<cfset wIntRate = wInt.weightInt/loanTotals.totalLoanAmount * 100.00 />
							<cfset intRate = wIntRate/100.00 />
						<cfelse>		
							<cfset intRate = loantotals.irate/100.00 />
						</cfif>
						
						<cfif intRate GT 0.08250 >
							<cfset intRate = 0.08250 />			
						</cfif>

						<cfif this.getEDA() is true >
							<cfset intRate = intRate - 0.0025 />
						</cfif>
				
						<!--- ****************** Set the monthly payment according to the Extended formula  *************** --->
						<!--- ** (Total Loan Amount * (Interest Rate/12) ) / (1 – ((Interest Rate/12) + 1))^(- loan term)** --->
						<!--- ********************************************************************************************* --->
						
						<cfset monthlyPaymentExt = loanTotals.totalLoanAmount * (intRate/12) / (1-((intRate/12) + 1)^(-loanterm)) />
						
						<cfset mExtPay = structnew() />
						<cfset mExtTerm = structinsert( mExtPay, "mExtTerm", loanterm ) />
						<cfset mExtPayAmt = structinsert( mExtPay, "mExtPayAmt", monthlyPaymentExt ) />
						
				
				<cfreturn mExtPay >
				
			</cffunction>
			
			
			<!--- Calculate the Graduated Repayment Formula --->
			<cffunction name="calcGrad" access="remote" output="false" returntype="any">
				
					<!--- Define arguments --->
					<cfargument name="loanterm" type="any" required="yes">
					<cfargument name="irate" type="any" required="no">
					<cfargument name="intRate" type="any" required="no">
					<cfargument name="totalloanamount" type="any" required="no">
					<cfargument name="payment" type="any" required="no">
					<cfargument name="leadid" type="numeric" required="yes">
					
						<!--- Get the client student loan totals --->
						<cfquery datasource="#application.dsn#" name="loanTotals">
							SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
								   AVG(intrate) as irate
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
							   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
						</cfquery>
						
						<cfquery datasource="#application.dsn#" name="wInt">
							SELECT leadid,
								   SUM(loanBalance * (intrate/100)) AS weightInt
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
							   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						  GROUP BY leadid
						</cfquery>
						
						<!--- Calculate the weighted interest rate or use the interest rate for a single loan --->
						<cfif loanTotals.totalLoans GT 1>
							<cfset wIntRate = wInt.weightInt/loanTotals.totalLoanAmount * 100.00 />
							<cfset intRate = wIntRate/100.00 />
						<cfelse>		
							<cfset intRate = loantotals.irate/100.00 />
						</cfif>
						
						<cfif intRate GT 0.08250 >
							<cfset intRate = 0.08250 />			
						</cfif>

						<cfif this.getEDA() is true >
							<cfset intRate = intRate - 0.0025 />
						</cfif>
						
										
						<!--- // Set the monthly payment according to the Graduated Repayment formula  // --->				
						<cfset monthlyPaymentStd = loanTotals.totalLoanAmount * (intRate/12) / (1-(1+intRate/12)^(-loanterm)) />
						<cfset gradInitialPayAmt = max((monthlyPaymentStd / 2), (loanTotals.totalLoanAmount * (intRate/12))) />
						<cfset gradInitialPayAmt = max(5, gradInitialPayAmt) />
						
						<!---
						<cfset monthGrad = StructInsert(strGrad, "monthGrad", monthlyPaymentStd) />
						<cfset grad1 = StructInsert(strGrad, "grad1", gradInitialPayAmt) />
						<cfset grad2 = StructInsert(strGrad, "grad2", gradInitialPayAmt2) />
						<cfset intRate = StructInsert(strGrad, "intRate", intRate) />
						--->
						
						<!--- This is best done on the page that lists the payment schedule for graduated repayment option 
						<cfset loopTerm = 300 />
						<cfloop from="1" to="#loopTerm#" index="i" step="24">
							<cfset increaseAmt = (gradInitialPayAmt[i] * .042) /> <!--- based on 30 years --->
							<cfset gradPaymentAmt = gradInitialPayAmt[i] + increaseAmt />
						</cfloop>				
						--->
				<cfreturn gradInitialPayAmt>
				
			</cffunction>
			
			
			<!--- Calculate the Extended Repayment Formula --->
			<cffunction name="calcExtGrad" access="remote" output="false" returntype="any">
				
					<!--- Define arguments --->
					<cfargument name="loanterm" type="any" required="yes">
					<cfargument name="irate" type="any" required="no">
					<cfargument name="intRate" type="any" required="no">
					<cfargument name="totalloanamount" type="any" required="no">
					<cfargument name="payment" type="any" required="no">
					<cfargument name="leadid" type="numeric" required="yes">
					
						<!--- Get the client student loan totals --->
						<cfquery datasource="#application.dsn#" name="loanTotals">
							SELECT SUM(loanBalance) as totalLoanAmount, COUNT(*) as totalLoans,
								   AVG(intrate) as irate
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_numeric" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
							   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />		
						</cfquery>
						
						<!--- Query needed to get the average interest rate --->
						<cfquery datasource="#application.dsn#" name="wInt">
							SELECT leadid,
								   SUM(loanBalance * (intrate/100)) AS weightInt
							  FROM slworksheet
							 WHERE leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							   AND incconsol = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND loancodeid <> <cfqueryparam value="35" cfsqltype="cf_sql_integer" />
							   AND completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						  GROUP BY leadid
						</cfquery>
						
						<!--- If the loan balance is over 30000, set the loan terms to 300 months --->
						<cfif loanTotals.totalLoanAmount GT 30000>
							<cfset loanTerm = 300 />
						<cfelse>
							<cfset loanterm = loanterm />
						</cfif>
						
						<!--- Calculate the weighted interest rate or use the interest rate for a single loan --->
						<cfif loanTotals.totalLoans GT 1>
							<cfset wIntRate = wInt.weightInt/loanTotals.totalLoanAmount * 100.00 />
							<cfset intRate = wIntRate/100.00 />
						<cfelse>		
							<cfset intRate = loantotals.irate/100.00 />
						</cfif>
						
						<cfif intRate GT 0.08250 >
							<cfset intRate = 0.08250 />			
						</cfif>

						<cfif this.getEDA() is true >
							<cfset intRate = intRate - 0.0025 />
						</cfif>
						
						<!--- // Set the monthly payment according to the Extended Graduated Repayment formula // --->						
						<cfset monthlyPaymentStd = loanTotals.totalLoanAmount * (intRate/12) / (1-((intRate/12) + 1)^(-loanterm)) />
						<cfset gradExtInitialPayAmt = max((monthlyPaymentStd / 2), (loanTotals.totalLoanAmount * (intRate/12))) />
						<cfset gradExtInitialPayAmt = max(5, gradExtInitialPayAmt) />
						
						
						<cfset strExtGrad = StructNew() />
						<cfset gradExtInitialPayAmt = StructInsert(strExtGrad, "gradExtInitialPayAmt", gradExtInitialPayAmt) />
						<cfset newloanterm = StructInsert(strExtGrad, "newloanterm", loanterm) />
						
						
						<!--- This is best done on the page that lists the payment schedule for extended graduated repayment option 
						<cfset loopTerm = 300 />
						<cfloop from="1" to="#loopTerm#" index="i" step="24">
							<cfset increaseAmt = (gradExtinitialPayAmt[i] * .0498) /> <!--- .0498 = 25 years for extended graduated --->
							<cfset gradExtPaymentAmt = gradExtInitialPayAmt[i] + increaseAmt />
						</cfloop>
						--->
						
				<cfreturn strExtGrad >
				
			</cffunction>
			
			
			

			<!--- Round up to nearest 1/4 percent --->
			<cffunction name="roundUpToNearestQuarter" output="false" returntype="numeric">
				<cfargument name="number" type="numeric" required="true" />

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
