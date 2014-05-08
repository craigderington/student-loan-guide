


		<!--- // get our data access objects --->
		<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
		
		<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>			
		
		<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
		
		<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
			
		<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutions" returnvariable="solutionlist">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
		
		<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>

		<!--- // get our budget, income and assets and liabilities data access objects --->
		<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>				
		
		
		
		
		
		
		<!--- // get our solution cart data access objects --->
		<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutionsforpresentation" returnvariable="solutionpresent">
			<cfinvokeargument name="leadid" value="#session.leadid#">
			<cfinvokeargument name="solcomp" value="0">
		</cfinvoke>
		
		<cfparam name="today" default="">
		<cfparam name="thisworksheet" default="">
		<cfset today = #CreateODBCDateTime( Now() )# />
		
		<!--- // mark student loan debt worksheets completed --->
		<cfset thisworksheet = valuelist( solutionpresent.solutionworksheetid ) />
		<cfquery datasource="#application.dsn#" name="updateworksheets">
			update slworksheet
			   set completed = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			 where worksheetid IN( <cfqueryparam value="#thisworksheet#" cfsqltype="cf_sql_integer" list="yes" /> )
		</cfquery>
		
		<!--- // update and mark solutions completed --->
		<cfquery datasource="#application.dsn#" name="marksolutioncompleted">
			update solution
			   set solutioncompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
			       solutioncompdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />				   
		     where leadid = <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />
			   and solutioncompleted = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
			   and solutioncompdate is null
		</cfquery>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		<style>			
			h1 {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 18px;}
			h2 {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 16px;}
			h3 {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 14px;}
			h4 {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;}
			h5 {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 10px;}
			table {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;border:1px solid #000;}			
			thead tr{font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;font-weight:bold;background-color:#dddddd;}
			tbody tr {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;}
			td {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;}
			th {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;text-align:left;}
			.tableheaderrow {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;font-weight:bold;background-color:#dddddd;color:#fff;}
			.bodystyle {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;	font-size: 12px;}
			.small {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 9px;}
			.medium {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;}
			.big {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 16px;}
			.xbig {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 24px;}
			.expanded {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 12px;line-height: 16px;letter-spacing: 2px;}
			.justified {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;text-align: justify;}
			.footer {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;font-size: 6px;color: #CCCCCC;}
			.box1 {padding: 3px;border-width: thin;border-style: solid;border-color: #CCCCCC #666666 #666666 #CCCCCC;}
			.box2 {font-style: italic;word-spacing: 2pt;padding: 3px;border-width: thin;border-style: solid;}
			.style2 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; }
			.style3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; font-weight: bold; }
			.style4 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; font-style: italic; }
		</style>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			<!--- // define a few page vars --->
			<cfparam name="totalstudentloandebt" default="0">
			<cfparam name="totalpayments" default="0">
			<cfparam name="totalintrate" default="0">
			<cfparam name="avgintrate" default="0">	
			
			<!--- // default our variables to zero values for empty strings --->
			<cfparam name="totalincome" default="0.00">
			<cfparam name="totaldeductions" default="0.00">
			<cfparam name="netincome" default="0.00">
			<cfparam name="totalexpenses" default="0.00">
			
			
			
				
				
				
				
			<cfdocument
				format = "pdf"
				name="solutiondoc"
				marginBottom = "1.0"
				marginTop = "1.0"
				marginLeft = "1.0"
				marginRight = "1.0"					
				scale = "100"
				bookmark="yes"
				fontembed="yes"
				>
					
					
				<cfoutput>	
					
					
					
					<cfdocumentsection name="Cover Page">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
					
						<img src="#compdetails.complogo#">
						
						
						
						<div align="center" style="margin-top:150px;">
							<h1><strong>Student Loan Advisory Program</strong></h1><br /><br />
							
							<h3>Understand Your Loans...</h3>							
							<h3>Know Your Options</h3>
						</div>
						
						<br /><br />
						
						
						
						<div align="center" style="margin-top:150px;">
							<span class="bodystyle">
								Prepared for: #leaddetail.leadfirst# #leaddetail.leadlast# <br />
								Prepared on: #DateFormat( Now(), "MM/DD/YYYY" )# <br />
								Prepared by: #session.username#
							</span>
						</div>
						
						
					
					</cfdocumentsection>
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					<cfdocumentsection name="Personal Data">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
					
				
							<img src="#compdetails.complogo#">
					
								<br /><br /><br />
					
									<span class="bodystyle">Date: #DateFormat( Now(), "MM/DD/YYYY" )# </span><br /><br />
									
									<p class="bodystyle" style="margin-top:25px;">
									#leaddetail.leadfirst# #leaddetail.leadlast# <br />
									#leaddetail.leadadd1# #leaddetail.leadadd2# <br />
									#leaddetail.leadcity#, #leaddetail.leadstate#   #leaddetail.leadzip#
									</p>
									
									
									<p class="bodystyle" style="margin-top:25px;">
									Client ID: #leaddetail.leadid# <br />
									Payment Due Date:   <br />
									Payment Amount:     <br />					
									Payment Frequency:  <br />
									First Payment Due Date:    <br />
									</p>
									
									<br />
																
									<p class="bodystyle">Enclosed is your own unique Student Loan Debt Resolution packet.  The packet includes a brochure to help you better understand the student loan landscape, loan types, options and tips to help you manage your budget and your debt.  The packet also includes a list of your specific options based on your student loan debt worksheet, nswers to the student loan debt questionnaire, steps on how to implement those options and tips on what to consider as your are implementing your chosen solution.  Please review this packet carefully as it discusses points that are extremely important to the success of your Student Loan Advisory Program.  Please feel free to call your Student Loan Specialist if you have any questions about the program.</p>
									
									
									<p class="bodystyle" style="margin-top: 30px;">
										Sincerely, <br /><br /><br />							
										
										#session.username# <br />
										#compdetails.companyname# <br />
										Student Loan Advisory Program
									</p>
					
					
				
									
					
					</cfdocumentsection>
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					<cfdocumentsection name="Table of Contents">
					
							<cfdocumentitem type="footer">
								<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
							</cfdocumentitem>
							
							
							<div style="margin-top:50px;">
							
							
							
								<div align="center"><h2><strong>Table of Contents</strong></h2></div>
							
							
									<p class="bodystyle" style="margin-top:50px;margin-left:25px;">
									<span class="bodystyle">I.  Student Loan Action Plan</span>
										<p style="margin-left:35px;">
										   <span class="bodystyle">
											   a. &nbsp; Your Student Loan Debts and Loan Types<br />
											   b. &nbsp; Personal Data and Budget Summary <br />						   
											   c. &nbsp; Your Student Loan Solutions and Options <br />
											   d. &nbsp; Steps to Implement Your Chosen Solutions
										   </span>
										</p>
									</p>
							
							
									<p class="bodystyle" style="margin-top:50px;margin-left:25px;">
									<span class="bodystyle">II. Student Loan Advisory Manual</span>
										<p style="margin-left:35px;">
										   <span class="bodystyle">
										   a. &nbsp; Understanding Loan Types <br />
										   b. &nbsp; Understanding Repayment Types  <br />
										   c. &nbsp; Understanding Cancellation and Loan Forgiveness <br />
										   d. &nbsp; Understanding Postponements <br />										   
										   e. &nbsp; Understanding the Effects of Interest <br />
										   f. &nbsp; Understanding Your Obligations  <br />
										   g. &nbsp; Understanding Your Budget <br />
										   h. &nbsp; Understanding the Consequences of Not Making Payments <br />
										   i. &nbsp;&nbsp; Conclusions
										   </span>
										</p>
									</p>
							
							
								</div>		
						
						
					</cfdocumentsection>
					
					
					
					
					
					<cfdocumentsection name="Your Student Loans">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
					
					
					
					
							<!--- // show the student loan debt worksheets --->
							<div style="margin-top:25px;">
							
								<h2 style="text-align:center;margin-bottom:10px;">Your Student Loans</h2>
							
								<br />
							
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td bgcolor="black">
											<table width="100%" border="0" cellpadding="5" cellspacing="1">
												<thead>
													<tr class="tableheaderrow" bgcolor="##dddddd">																	
														<th align="left">Creditor</th>					
														<th align="left">Account</th>
														<th align="left">Balance</th>
														<th align="left">Payment</th>																	
														<th align="left">Rate</th>
														<th align="left">Due Date</th>							
													</tr>
												</thead>
												<tbody>																		
													<cfloop query="worksheetlist">
														<tr bgcolor="white">																	
															<td>#servname#</td>						
															<td>#acctnum#</td>
															<td>#dollarformat(loanbalance)#</td>
															<td>#dollarformat(currentpayment)#</td>
															<td>#numberformat(intrate, '999.99')#%</td>
															<td>#dateformat(paymentduedate, 'mm/dd/yyy')#</td>																																										
														</tr>															
																	
														<cfset totalstudentloandebt = totalstudentloandebt + loanbalance />
														<cfset totalpayments = totalpayments + currentpayment />
														<cfset totalintrate = totalintrate + intrate />
														<cfset avgintrate = totalintrate / worksheetlist.recordcount />
																	
													</cfloop>
																								
													<!--- // do sub totals and average interest rate --->
													<cfoutput>
														<tr bgcolor="white" style="font-weight:bold;">
															<td colspan="2" style="color:black;text-align:right;">TOTALS:</td>
															<td>#dollarformat(totalstudentloandebt)#</td>
															<td >#dollarformat(totalpayments)#</td>
															<td>#numberformat(avgintrate, '999.99')#%</td>
															<td>&nbsp;</td>										
														</tr>
													</cfoutput>
																
												</tbody>
											</table>
										</td>
									</tr>
								</table>
						
							</div>
							
							
					</cfdocumentsection>		
							
							
							
							
							
							
					<cfdocumentsection name="Your Loan Types">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
								
								
							<h2 style="text-align:center;margin-top:25px;">Your Loan Types</h2>
								
								<br />
								
								<cfquery datasource="#application.dsn#" name="loantypes">
									select lc.loancode, lc.codedescr, sl.loancodeid
									  from loancodes lc, slworksheet sl
									 where lc.loancodeid = sl.loancodeid
									   and sl.leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
									order by lc.loancode asc
								</cfquery>
								
								
								<!--- // output the loan types --->
								<cfloop query="loantypes">
									<ul>
										<li>#codedescr#</li>
									</ul>
								</cfloop>
							
							
					</cfdocumentsection>
							
							
							
							
							
							
							
							
					
						
					
				
					
					<cfdocumentsection name="Your Monthly Budget Summary">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>					
				
				
							<!--- // show the detailed budget summary --->
							<div style="margin-top:10px;">							
							
								<!--- // begin budget summary --->
								<table width="100%"  border="0" cellspacing="0" cellpadding="10">
									
									<tr>
										<td colspan="2"><div align="center" class="style3">MONTHLY BUDGET SUMMARY </div></td>
									</tr>
									
									<tr valign="top">
										<td width="50%" bgcolor="##f2f2f2"><div align="left">INCOME</div></td>			
										<td width="50%" bgcolor="##f2f2f2"><div align="left">EXPENSES</div></td>
									</tr>
									
									
									<!--- // income section --->
									<tr valign="top">
										<td>
											<table width="100%"  border="0" cellspacing="0" cellpadding="5">
												<tr>
													<td colspan="2" class="style2"><strong>Primary Income </strong></td>
												</tr>
												<!--- // primary income and totals --->
												<tr>
													<td width="29%" class="style2">Gross Monthly Income: </td>
													<td width="71%" class="style2">#dollarformat( budget.primarygrossmonthly )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Federal Withholding </td>
													<td class="style2">#dollarformat( budget.primarywithholding )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; FICA </td>
													<td class="style2">#dollarformat( budget.primaryfica )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Medicare</td>
													<td class="style2">#dollarformat( budget.primarymedicare )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; 401k/Retirement </td>
													<td class="style2">#dollarformat( budget.primary401k )#</td>
												</tr>
												  
												  
												<tr>
													<td class="style2">&bull; Benefits </td>
													<td class="style2">#dollarformat( budget.primarybenefits )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Other Withholding </td>
													<td class="style2"><cfif budget.primarycitytax neq 0.00>City Tax: #dollarformat( budget.primarycitytax )# <br /></cfif><cfif budget.primarystatetax neq 0.00>State Tax: #dollarformat( budget.primarystatetax )#</cfif></td>
												</tr>
												  
												<tr>
													<td class="style4">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
												  
												<tr>
													<td class="style4">Other Income </td>
													<td class="style2">&nbsp;</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Part Time Job </td>
													<td class="style2">#dollarformat( budget.primaryparttimejob )# <cfif budget.primaryparttimejobdescr is not ""> - #budget.primaryparttimejobdescr#</cfif></td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Pension </td>
													<td class="style2">#dollarformat( budget.primarypension )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; SSI </td>
													<td class="style2">#dollarformat( budget.primaryssi )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Child Support </td>
													<td class="style2">#dollarformat( budget.primarychildsupport )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Rental Property </td>
													<td class="style2">#dollarformat( budget.primaryrentalproperty )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Food Stamps </td>
													<td class="style2">#dollarformat( budget.primaryfoodstamps )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&bull; Other Income</td>
													<td class="style2">#dollarformat( budget.primaryincomeothera )# <cfif budget.primaryincomeotheradescr is not ""> - #budget.primaryincomeotheradescr#</cfif></td>
												</tr>
												  
												<tr>
													<td class="style3">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
												  
												<tr>
													<td class="style3">Primary Net Income </td>
													<td class="style2">#dollarformat( budget.primarytotalincome )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
												  
												<!--- // secondary income and totals --->
												<tr>
													<td colspan="2" class="style2"><strong>Secondary Income </strong></td>
												</tr>
													  
												<tr>
													<td class="style2">Gross Monthy Income </td>
													<td class="style2">#dollarformat( budget.secondarygrossmonthly )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Federal Withholding</td>
													<td class="style2">#dollarformat( budget.secondarywithholding )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; FICA </td>
													<td class="style2">#dollarformat( budget.secondaryfica )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Medicare </td>
													<td class="style2">#dollarformat( budget.secondarymedicare )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; 401k/Retirment </td>
													<td class="style2">#dollarformat( budget.secondary401k )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Benefits </td>
													<td class="style2">#dollarformat( budget.secondarybenefits )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Other Withholding </td>
													<td class="style2"><cfif budget.secondarycitytax neq 0.00>City Tax: #dollarformat( budget.secondarycitytax )# <br /></cfif><cfif budget.secondarystatetax neq 0.00>State Tax: #dollarformat( budget.secondarystatetax )#</cfif></td>
												</tr>
													  
												<tr>
													<td class="style4">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
													  
												<tr>
													<td class="style4">Other Income </td>
													<td class="style2">&nbsp;</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Part Time Job </td>
													<td class="style2">#dollarformat( budget.secondaryparttimejob )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Pension </td>
													<td class="style2">#dollarformat( budget.secondarypension )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; SSI </td>
													<td class="style2">#dollarformat( budget.secondaryssi )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Child Support </td>
													<td class="style2">#dollarformat( budget.secondarychildsupport )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Rental Property </td>
													<td class="style2">#dollarformat( budget.secondaryrentalproperty )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Food Stamps </td>
													<td class="style2">#dollarformat( budget.secondaryfoodstamps )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&bull; Other Income</td>
													<td class="style2">#dollarformat( budget.secondaryincomeothera )# <cfif budget.secondaryincomeotheradescr is not ""> - #budget.secondaryincomeotheradescr#</cfif></td>
												</tr>
													  
												<tr>
													<td class="style3">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
													  
												<tr>
													<td class="style3">Secondary Net Income </td>
													<td class="style2">#dollarformat( budget.secondarytotalincome )#</td>
												</tr>
													  
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
													  
												<tr>
													<td class="style3">Combined Total Net Income </td>
													<td class="style2">#dollarformat( budget.primarytotalincome + budget.secondarytotalincome )#</td>
												</tr>
											</table>
										</td>
										
										<!--- // expenses --->
										<td>
											<table width="100%"  border="0" cellspacing="0" cellpadding="5">
												<tr>
													<td width="30%" class="style3">Home and Shelter </td>
													<td width="70%" class="style2"><cfif budget.sheltertotal neq 0.00><strong>#dollarformat( budget.sheltertotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Mortgage/Rent </td>
													<td class="style2">#dollarformat( budget.mortgage1 )#</td>
												</tr>
												
												<tr>
													<td class="style2">&bull; 2nd Mortgage </td>
													<td class="style2">#dollarformat( budget.mortgage2 )#</td>
												</tr>
												
												<tr>
													<td class="style2">&bull; 3rd Mortgage </td>
													<td class="style2">#dollarformat( budget.mortgage3 )#</td>
												</tr>
												
												<tr>
													<td class="style2">&bull; Real Estate Taxes </td>
													<td class="style2">#dollarformat( budget.realestatetax )#</td>
												</tr>
												
												<tr>
													<td class="style2">&bull; HOA/Condo Dues </td>
													<td class="style2">#dollarformat( budget.hoacondodues )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Insurance </td>
													<td class="style2">#dollarformat( budget.homerentinsurance )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Automobiles</td>
													<td class="style2"><cfif budget.autototal neq 0.00><strong>#dollarformat( budget.autototal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Car Payment </td>
													<td class="style2">#dollarformat( budget.auto1 )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; 2nd Car Payment </td>
													<td class="style2">#dollarformat( budget.auto2 )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; 3rd Car Payment</td>
													<td class="style2">#dollarformat( budget.auto3 )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; 4th Car Payment </td>
													<td class="style2">#dollarformat( budget.auto4 )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Utilities</td>
													<td class="style2"><cfif budget.utilitytotal neq 0.00><strong>#dollarformat( budget.utilitytotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Electric </td>
													<td class="style2">#dollarformat( budget.electric )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Water </td>
													<td class="style2">#dollarformat( budget.water )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Trash </td>
													<td class="style2">#dollarformat( budget.trash )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Gas </td>
													<td class="style2">#dollarformat( budget.gas )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Cable </td>
													<td class="style2">#dollarformat( budget.cable )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Internet </td>
													<td class="style2">#dollarformat( budget.internet )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Local Telephone </td>
													<td class="style2">#dollarformat( budget.phone )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Cell Phone </td>
													<td class="style2">#dollarformat( budget.cellular )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Transportation</td>
													<td class="style2"><cfif budget.transtotal neq 0.00><strong>#dollarformat( budget.transtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Gasoline </td>
													<td class="style2">#dollarformat( budget.gasoline )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Tolls </td>
													<td class="style2">#dollarformat( budget.tolls )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Car Repairs </td>
													<td class="style2">#dollarformat( budget.autorepairs )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; State License/Tags </td>
													<td class="style2">#dollarformat( budget.autotags )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Public Transportation </td>
													<td class="style2">#dollarformat( budget.publictrans )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Groceries and Dining </td>
													<td class="style2"><cfif budget.foodtotal neq 0.00><strong>#dollarformat( budget.foodtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Groceries </td>
													<td class="style2">#dollarformat( budget.groceries )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; House Supplies </td>
													<td class="style2">#dollarformat( budget.homesupply )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Outside Meals (non-ent) </td>
													<td class="style2">#dollarformat( budget.mealsoutnonent )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Outside Meals (ent) </td>
													<td class="style2">#dollarformat( budget.mealsoutent )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; School Lunches </td>
													<td class="style2">#dollarformat( budget.schoollunch )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Tobacco/Cigarettes </td>
													<td class="style2">#dollarformat( budget.tobacco )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Insurance</td>
													<td class="style2"><cfif budget.insurancetotal neq 0.00><strong>#dollarformat( budget.insurancetotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Life Insurance </td>
													<td class="style2">#dollarformat( budget.lifeinsurance )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Major Medical </td>
													<td class="style2">#dollarformat( budget.medicaldental )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Auto Insurance </td>
													<td class="style2">#dollarformat( budget.autoinsurance )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Long Term Care </td>
													<td class="style2">#dollarformat( budget.longtermcare )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Medical Expenses </td>
													<td class="style2"><cfif budget.medtotal neq 0.00><strong>#dollarformat( budget.medtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Medical Savings (HSA) </td>
													<td class="style2">#dollarformat( budget.hsaacct )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Prescriptions</td>
													<td class="style2">#dollarformat( budget.prescriptions )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Co-Pays/Deductibles </td>
													<td class="style2">#dollarformat( budget.copaydeduct )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; OTC Drugs </td>
													<td class="style2">#dollarformat( budget.overcounterpills )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Child Care </td>
													<td class="style2"><cfif budget.childcaretotal neq 0.00><strong>#dollarformat( budget.childcaretotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Day Care</td>
													<td class="style2">#dollarformat( budget.childcare )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; After School Care </td>
													<td class="style2">#dollarformat( budget.aftercare )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Child Activities </td>
													<td class="style2">#dollarformat( budget.childactivity )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Domestic Court Orders </td>
													<td class="style2"><cfif budget.domesticorder neq 0.00><strong>#dollarformat( budget.domesticorder )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Alimony </td>
													<td class="style2">#dollarformat( budget.alimony )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Child Support </td>
													<td class="style2">#dollarformat( budget.childsupport )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Judgements/Bank Levy </td>
													<td class="style2">#dollarformat( budget.banklevy )#</td>
												</tr>
											
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
											
												<tr>
													<td class="style3">Household Expenses </td>
													<td class="style2"><cfif budget.misctotal neq 0.00><strong>#dollarformat( budget.misctotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Clothing </td>
													<td class="style2">#dollarformat( budget.clothing )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Recreation </td>
													<td class="style2">#dollarformat( budget.recreation )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Student Loans </td>
													<td class="style2">#dollarformat( budget.studentloans )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Family Loans </td>
													<td class="style2">#dollarformat( budget.familyloans )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Personal Grooming </td>
													<td class="style2">#dollarformat( budget.personalgrooming )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Dry Cleaning </td>
													<td class="style2">#dollarformat( budget.drycleaning )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Other Family Expense </td>
													<td class="style2">#dollarformat( budget.familyexpenseother )#<cfif budget.familyexpenseotherdescr is not ""> for #budget.familyexpenseotherdescr#</cfif>
												</tr>
											
												<tr>
													<td class="style2">&bull; Charitable Donations </td>
													<td class="style2">#dollarformat( budget.donations )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Memberships </td>
													<td class="style2">#dollarformat( budget.memberships )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Pest Control </td>
													<td class="style2">#dollarformat( budget.pestcontrol )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Security System </td>
													<td class="style2">#dollarformat( budget.securitysystem )#</td>
												</tr>
											
												<tr>
													<td class="style2">&bull; Yard/Pool Maintenance </td>
													<td class="style2">#dollarformat( budget.yardmaint )#</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
									
							</div>
				
					
					</cfdocumentsection>
					
					
					
					
					
					
					
					<cfdocumentsection name="Action Plan">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
					
					
							<!--- // start the solution presentation action plan items --->
							<!--- // solution implementation and consolidation calculator --->
							<div style="margin-top:10px;">							
								
								
								<!--- // a few solution presentation variables --->
								<cfparam name="option" default="">
								<cfparam name="subcat" default="">
								<cfparam name="creditor" default="">
								<cfparam name="acctnumber" default="">
								<cfparam name="tree" default="">
								<cfparam name="narrative" default="">
								
								<cfloop query="solutionpresent">						
									<cfset option = #solutionoption# />
									<cfset subcat = #solutionsubcat# />
									<cfset creditor = #servname# />
									<cfset acctnumber = #acctnum# />
									<cfset narrative = #urldecode( solutionnotes )# />
									
									<cfif solutionoptiontree eq 1>
										<cfset tree = "direct" />
									<cfelseif solutionoptiontree eq 2>
										<cfset tree = "FFEL" />
									<cfelseif solutionoptiontree eq 3>
										<cfset tree = "perkins" />
									<cfelseif solutionoptiontree eq 4>
										<cfset tree = "direct consolidation" />
									<cfelseif solutionoptiontree eq 5>
										<cfset tree = "health professional">
									<cfelseif solutionoptiontree eq 6>
										<cfset tree = "parent plus" />
									<cfelseif solutionoptiontree eq 7>	
										<cfset tree = "private loans" />							
									</cfif>
									
									<cfquery datasource="#application.dsn#" name="showplan">
										select ap.optiontree, ap.optiondescr, ap.optionsubcat, ap.actionplanheader, ap.actionplanbodya
										  from actionplan ap
										 where ap.optiondescr = <cfqueryparam value="#trim( option )#" cfsqltype="cf_sql_varchar" />
										   and ap.optionsubcat = <cfqueryparam value="#trim( subcat )#" cfsqltype="cf_sql_varchar" />								   
										   and ap.optiontree LIKE <cfqueryparam value="%#tree#%" cfsqltype="cf_sql_varchar" />								   
									  order by ap.actionplanid asc					
									</cfquery>
									
									<!--- // now loop over the action plan items and produce output --->
									<!--- // this is a nested loop --->
									<cfloop query="showplan">		
										
										<h2 style="margin-top:25px;"><strong>#optiondescr# #optionsubcat#</strong></h2>
										<h4 style="margin-top:5px;"><strong>#creditor#  Account Number: #acctnumber#</strong></h4> <br />
										<h4 style="margin-top:5px;"><strong>Loan Type: #ucase( tree )#</strong></h4><br />
										
										<p><i>Counselor notes on selected solution:</i></p>										
										<p>#narrative#</p>
										
											<br />
										
										
										<p style="font-weight:bold;font-size:18px;">Steps to Implement Solution</p>
										<p>#urldecode( actionplanbodya )#</p>							
									
									
										
																
										<!--- // if any of the selected solutions include consolidation --->
										<!--- // prepare the presentation document to show the calculator 
										<cfif trim( optiondescr ) contains "consolidation">
											
											show the calculator if necessary...
										
										</cfif>
										--->
									</cfloop>							
								</cfloop>
							</div>
					
					</cfdocumentsection>
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					<cfdocumentsection name="Advisory Manual">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>		
				
						<!--- // get the advisory manual --->
						<cfquery datasource="#application.dsn#" name="manual">
							select actionplanheader, actionplanbodya
							  from actionplan
							 where optiontree = <cfqueryparam value="Advisory" cfsqltype="cf_sql_varchar" />
							   and optiondescr = <cfqueryparam value="Manual" cfsqltype="cf_sql_varchar" />						   
						  order by tocorder asc
						</cfquery>
				
				
						<div style="margin-top:25px;">
					
							<cfloop query="manual">							
								<h3 style="text-align:center;"><strong><font size="10">#actionplanheader#</font></strong></h3><br />
								#actionplanbodya#<br /><br />					
							</cfloop>
					
						</div>
						
						
					</cfdocumentsection>
					
				</cfoutput>
				
				
			</cfdocument>		
			
			
			
			
			
			<!--- // now auto-save the solution presentation pdf document to the client's document library --->
			<cfpdf action="write" destination="#ExpandPath('library\clients\solutions')#\#solutiondoc#">
			
			
			<!--- // save the library record to the database --->
			<cfquery datasource="#application.dsn#" name="savesolutionpresentation">
				insert into documents(docsuuid,leadid,docname,docfileext,docpath,docdate,docuploaddate,uploadedby,docactive,doctype)
					values(
						   <cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
						   <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
						   <cfqueryparam value="#session.leadid#-#listfirst( solutiondoc, "." )#" cfsqltype="cf_sql_varchar" />,
						   <cfqueryparam value=".pdf" cfsqltype="cf_sql_varchar" />,
						   <cfqueryparam value="#solutiondoc#" cfsqltype="cf_sql_varchar" />,
						   <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
						   <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
						   <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
						   <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
						   <cfqueryparam value="S" cfsqltype="cf_sql_char" />
						   );
			</cfquery>
			
			
			