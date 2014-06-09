


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
		
		<!--- // set client to implementation true so they can create an implementation plan --->
		<cfquery datasource="#application.dsn#" name="markleadimp">
			update leads
			   set leadimp = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />		   
		     where leadid = <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />			   
		</cfquery>
		
		<!--- // task automation // update task and mark completed --->
		<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
			<cfinvokeargument name="leadid" value="#session.leadid#">
			<cfinvokeargument name="taskref" value="spgen">
		</cfinvoke>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
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
				marginBottom = "0.75"
				marginTop = "0.75"
				marginLeft = "0.75"
				marginRight = "0.75"					
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
							<h1 style="font-family:Verdana;font-size:38px;"><strong>Student Loan Advisory Program</strong></h1><br /><br />
							
							<h3 style="font-family:Verdana;font-size:22px;">Understand Your Loans...</h3>							
							<h3 style="font-family:Verdana;font-size:20px;">Know Your Options</h3>
						</div>
						
						<br /><br />
						
						
						
						<div align="center" style="margin-top:100px;">
							<p style="font-family:Verdana;font-size:12px;">
								Prepared for: #leaddetail.leadfirst# #leaddetail.leadlast# <br />
								Prepared on: #DateFormat( Now(), "MM/DD/YYYY" )# <br />
								Prepared by: #session.username#
							</p>
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
							
							
							
								<div align="center"><h2 style="font-size:32px;font-family:Verdana;"><strong>Table of Contents</strong></h2></div>
							
							
									<p style="margin-top:50px;margin-left:25px;">
									<p style="font-size:22px;font-family:Verdana;font-weight:bold;">I.  Student Loan Action Plan</p>										
										   <p style="margin-left:20px;font-size:14px;font-family:Verdana;">
											   a. &nbsp; Your Student Loan Debts and Loan Types<br />
											   b. &nbsp; Personal Data and Budget Summary <br />						   
											   c. &nbsp; Your Student Loan Solutions and Options <br />
											   d. &nbsp; Steps to Implement Your Chosen Solutions
										   </p>
										</p>
									</p>
							
							
									<p style="margin-top:50px;margin-left:25px;">
									<p style="font-size:22px;font-family:Verdana;font-weight:bold;">II. Student Loan Advisory Manual</p>
										<p style="margin-left:20px;font-size:14px;font-family:Verdana;">										 
										   a. &nbsp; Understanding Loan Types <br />
										   b. &nbsp; Understanding Repayment Types  <br />
										   c. &nbsp; Understanding Cancellation and Loan Forgiveness <br />
										   d. &nbsp; Understanding Postponements <br />										   
										   e. &nbsp; Understanding the Effects of Interest <br />
										   f. &nbsp; Understanding Your Obligations  <br />
										   g. &nbsp; Understanding Your Budget <br />
										   h. &nbsp; Understanding the Consequences of Not Making Payments <br />
										   i. &nbsp;&nbsp; Conclusions										  
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
							
								<h2 style="font-family:Verdana;font-size:28px;font-weight:bold;text-align:center;margin-bottom:10px;">Your Student Loans</h2>
							
								<br />
							
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td bgcolor="black">
											<table width="100%" border="0" cellpadding="10" cellspacing="1">
												<thead>
													<tr bgcolor="##f2f2f2" style="font-size:12px;font-family:Verdana;">																	
														<th align="left">Servicer</th>														
														<th align="left">Balance</th>
														<th align="left">Payment</th>																	
														<th align="left">Rate</th>																					
													</tr>
												</thead>
												<tbody>																		
													<cfloop query="worksheetlist">
														<tr bgcolor="white" style="font-size:12px;font-family:Verdana;">																	
															<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>															
															<td>#dollarformat(loanbalance)#</td>
															<td>#dollarformat(currentpayment)#</td>
															<td>#numberformat(intrate, '999.99')#%</td>																																																								
														</tr>															
																	
														<cfset totalstudentloandebt = totalstudentloandebt + loanbalance />
														<cfset totalpayments = totalpayments + currentpayment />
														<cfset totalintrate = totalintrate + intrate />
														<cfset avgintrate = totalintrate / worksheetlist.recordcount />
																	
													</cfloop>
																								
													<!--- // do sub totals and average interest rate 
													<cfoutput>
														<tr bgcolor="lightgoldenrodyellow" style="font-size:12px;font-family:Verdana;font-weight:bold;">
															<td style="color:black;font-weight:bold;font-family:Verdana;font-size:12px;text-align:right;">TOTALS:</td>
															<td>#dollarformat(totalstudentloandebt)#</td>
															<td >#dollarformat(totalpayments)#</td>
															<td>#numberformat(avgintrate, '999.99')#%</td>																								
														</tr>
													</cfoutput>
													--->			
												</tbody>
											</table>
										</td>
									</tr>
								</table>
						
							</div>
							
							
					</cfdocumentsection>		
							
							
							
							
							
					<!--- // remove this page 
					<!--- // 4-24-2014 // --->
					<cfdocumentsection name="Your Loan Types">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>
								
								
							<h2 style="font-family:Verdana;font-size:28px;text-align:center;margin-top:25px;">Your Loan Types</h2>
								
								<br />
								
								<cfquery datasource="#application.dsn#" name="loantypes">
									select lc.loancode, lc.codedescr, sl.loancodeid, sl.attendingschool
									  from loancodes lc, slworksheet sl
									 where lc.loancodeid = sl.loancodeid
									   and sl.leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
									order by lc.loancode asc
								</cfquery>
								
								
								<!--- // output the loan types --->
								<cfloop query="loantypes">
									<ul style="list-style:none;font-family:Verdana;font-size:24px;">
										<li style="font-family:Verdana;font-size:20px;">#codedescr#:<br />
										<span style="font-family:Verdana;font-size:16px;">while attending #attendingschool#</span>																				
										</li>
									</ul>
								</cfloop>
							
							
					</cfdocumentsection>
					---->		
							
							
							
							
							
							
							
					
						
					
				
					
					<cfdocumentsection name="Your Monthly Budget Summary">
					
						<cfdocumentitem type="footer">
							<span class="footer"><font size="-2" color="##999">Page #cfdocument.currentpagenumber#</font></span>
						</cfdocumentitem>					
				
				
							<!--- // show the detailed budget summary --->
							<div style="margin-top:10px;">							
							
								<!--- // begin budget summary --->
								<table width="100%"  border="0" cellspacing="0" cellpadding="5">
									
									<tr>
										<td colspan="2"><div align="center" style="font-family:Verdana;font-size:26px;font-weight:bold;">MONTHLY BUDGET SUMMARY </div></td>
									</tr>
									
									<tr valign="top">
										<td width="50%" bgcolor="##f2f2f2"><div align="left" style="font-family:Verdana;font-size:12px;font-weight:bold;">INCOME</div></td>			
										<td width="50%" bgcolor="##f2f2f2"><div align="left" style="font-family:Verdana;font-size:12px;font-weight:bold;">EXPENSES</div></td>
									</tr>
									
									
									<!--- // income section --->
									<tr valign="top">
										<td>
											<table width="100%"  border="0" cellspacing="0" cellpadding="5">
												<tr>
													<td colspan="2" style="font-family:Verdana;font-size:12px;"><strong>Primary Income </strong></td>
												</tr>
												<!--- // primary income and totals --->
												<tr>
													<td width="60%" style="font-family:Verdana;font-size:10px;">Gross Monthly Income: </td>
													<td width="40%" style="font-family:Verdana;font-size:10px;font-weight:bold;">#dollarformat( budget.primarygrossmonthly )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Federal Withholding </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primarywithholding )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; FICA </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryfica )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Medicare</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primarymedicare )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 401k/Retirement </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primary401k )#</td>
												</tr>
												  
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Benefits </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primarybenefits )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Other Withholding </td>
													<td style="font-family:Verdana;font-size:10px;"><cfif budget.primarycitytax neq 0.00>City Tax: #dollarformat( budget.primarycitytax )# <br /></cfif><cfif budget.primarystatetax neq 0.00>State Tax: #dollarformat( budget.primarystatetax )#</cfif></td>
												</tr>
												  
												
												  
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Other Income </td>
													<td >&nbsp;</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Part Time Job </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryparttimejob )# <cfif budget.primaryparttimejobdescr is not ""> - #budget.primaryparttimejobdescr#</cfif></td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Pension </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primarypension )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; SSI </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryssi )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Child Support </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primarychildsupport )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Rental Property </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryrentalproperty )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Food Stamps </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryfoodstamps )#</td>
												</tr>
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Other Income</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.primaryincomeothera )# <cfif budget.primaryincomeotheradescr is not ""> - #budget.primaryincomeotheradescr#</cfif></td>
												</tr>
												  
												
												  
												<tr>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">Primary Net Income </td>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">#dollarformat( budget.primarytotalincome )#</td>
												</tr>
												  
												<tr>
													<td class="style2">&nbsp;</td>
													<td class="style2">&nbsp;</td>
												</tr>
												  
												<!--- // secondary income and totals --->
												<tr>
													<td colspan="2" style="font-family:Verdana;font-size:12px;font-weight:bold;"><strong>Secondary Income </strong></td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">Gross Monthy Income </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarygrossmonthly )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Federal Withholding</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarywithholding )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; FICA </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryfica )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Medicare </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarymedicare )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 401k/Retirment </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondary401k )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Benefits </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarybenefits )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Other Withholding </td>
													<td style="font-family:Verdana;font-size:10px;"><cfif budget.secondarycitytax neq 0.00>City Tax: #dollarformat( budget.secondarycitytax )# <br /></cfif><cfif budget.secondarystatetax neq 0.00>State Tax: #dollarformat( budget.secondarystatetax )#</cfif></td>
												</tr>
													  
												
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">Other Income </td>
													<td>&nbsp;</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Part Time Job </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryparttimejob )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Pension </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarypension )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; SSI </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryssi )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Child Support </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondarychildsupport )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Rental Property </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryrentalproperty )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Food Stamps </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryfoodstamps )#</td>
												</tr>
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">&bull; Other Income</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.secondaryincomeothera )# <cfif budget.secondaryincomeotheradescr is not ""> - #budget.secondaryincomeotheradescr#</cfif></td>
												</tr>
													  
												
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">Secondary Net Income </td>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">#dollarformat( budget.secondarytotalincome )#</td>
												</tr>
													  
												
													  
												<tr>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">Combined Total Net Income </td>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;">#dollarformat( budget.primarytotalincome + budget.secondarytotalincome )#</td>
												</tr>
											</table>
										</td>
										
										<!--- // expenses --->
										<td>
											<table width="100%"  border="0" cellspacing="0" cellpadding="5">
												<tr>
													<td width="60%" style="font-family:Verdana;font-size:12px;font-weight:bold;">Home and Shelter </td>
													<td width="40%" style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.sheltertotal neq 0.00><strong>#dollarformat( budget.sheltertotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Mortgage/Rent </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.mortgage1 )#</td>
												</tr>
												
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 2nd Mortgage </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.mortgage2 )#</td>
												</tr>
												
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 3rd Mortgage </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.mortgage3 )#</td>
												</tr>
												
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Real Estate Taxes </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.realestatetax )#</td>
												</tr>
												
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; HOA/Condo Dues </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.hoacondodues )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Insurance </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.homerentinsurance )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Automobiles</td>
													<td style="font-family:Verdana;font-size:10px;font-weight:bold;"><cfif budget.autototal neq 0.00><strong>#dollarformat( budget.autototal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Car Payment </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.auto1 )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 2nd Car Payment </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.auto2 )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 3rd Car Payment</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.auto3 )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; 4th Car Payment </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.auto4 )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Utilities</td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.utilitytotal neq 0.00><strong>#dollarformat( budget.utilitytotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Electric </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.electric )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Water </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.water )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Trash </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.trash )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Gas </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.gas )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Cable </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.cable )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Internet </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.internet )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Local Telephone </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.phone )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Cell Phone </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.cellular )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Transportation</td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.transtotal neq 0.00><strong>#dollarformat( budget.transtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Gasoline </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.gasoline )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Tolls </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.tolls )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Car Repairs </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.autorepairs )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; State License/Tags </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.autotags )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Public Transportation </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.publictrans )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Groceries and Dining </td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.foodtotal neq 0.00><strong>#dollarformat( budget.foodtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Groceries </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.groceries )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; House Supplies </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.homesupply )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Outside Meals (non-ent) </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.mealsoutnonent )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Outside Meals (ent) </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.mealsoutent )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; School Lunches </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.schoollunch )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Tobacco/Cigarettes </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.tobacco )#</td>
												</tr>

												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Insurance</td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.insurancetotal neq 0.00><strong>#dollarformat( budget.insurancetotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Life Insurance </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.lifeinsurance )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Major Medical </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.medicaldental )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Auto Insurance </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.autoinsurance )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Long Term Care </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.longtermcare )#</td>
												</tr>										
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Medical Expenses </td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.medtotal neq 0.00><strong>#dollarformat( budget.medtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
												
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Medical Savings (HSA) </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.hsaacct )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Prescriptions</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.prescriptions )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Co-Pays/Deductibles </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.copaydeduct )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; OTC Drugs </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.overcounterpills )#</td>
												</tr>

												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>												
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Child Care </td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.childcaretotal neq 0.00><strong>#dollarformat( budget.childcaretotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Day Care</td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.childcare )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; After School Care </td>
													<td class="style2">#dollarformat( budget.aftercare )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Child Activities </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.childactivity )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Domestic Court Orders </td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.domesticorder neq 0.00><strong>#dollarformat( budget.domesticorder )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Alimony </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.alimony )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Child Support </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.childsupport )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Judgements/Bank Levy </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.banklevy )#</td>
												</tr>

												<tr>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
													<td style="font-family:Verdana;font-size:10px;">&nbsp;</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;">Household Expenses </td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;"><cfif budget.misctotal neq 0.00><strong>#dollarformat( budget.misctotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Clothing </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.clothing )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Recreation </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.recreation )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Student Loans </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.studentloans )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Family Loans </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.familyloans )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Personal Grooming </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.personalgrooming )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Dry Cleaning </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.drycleaning )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Other Family Expense </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.familyexpenseother )#<cfif budget.familyexpenseotherdescr is not ""> for #budget.familyexpenseotherdescr#</cfif>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Charitable Donations </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.donations )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Memberships </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.memberships )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Pest Control </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.pestcontrol )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Security System </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.securitysystem )#</td>
												</tr>
											
												<tr>
													<td style="font-family:Verdana;font-size:10px;">&bull; Yard/Pool Maintenance </td>
													<td style="font-family:Verdana;font-size:10px;">#dollarformat( budget.yardmaint )#</td>
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
									
									<cfif servid neq -1>
										<cfset creditor = #servname# />									
									<cfelse>
										<cfset creditor = #nslservicer# />
									</cfif>
									
									
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
										
										<h2 style="margin-top:25px;font-family:Verdana;font-weight:bold;font-size:18px;"><strong>#optionsubcat# #optiondescr#</strong></h2>
										<h4 style="margin-top:5px;font-family:Verdana;font-weight:bold;font-size:18px;"><strong>#creditor#</strong></h4> <br />
										<h4 style="margin-top:5px;font-family:Verdana;font-weight:bold;font-size:18px;"><strong>Loan Type: #ucase( tree )# LOAN</strong></h4><br />
										
										<p style="font-family:Verdana;font-weight:bold;font-size:12px;"><i>Counselor notes on selected solution:</i></p>										
										<p style="font-family:Verdana;font-weight:bold;font-size:12px;">#narrative#</p>
										
											<br />
										
										
										<p style="font-family:Verdana;font-weight:bold;font-size:20px;">Steps to Implement Solution</p>
										<p style="font-family:Verdana;font-weight:bold;font-size:12px;">#urldecode( actionplanbodya )#</p>							
									
									
										
																
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
								<h3 style="text-align:center;font-family:Verdana;font-weight:bold;font-size:20px;"><strong>#actionplanheader#</strong></h3><br />
								#actionplanbodya#<br /><br />					
							</cfloop>
					
						</div>
						
						
					</cfdocumentsection>
					
				</cfoutput>
				
				
			</cfdocument>		
			
			
			
			
			
			<!--- // now auto-save the solution presentation pdf document to the client's document library 
			<cfpdf action="write" destination="#ExpandPath('library\clients\solutions')#\Solution-Presentation.pdf">--->
			
			
			<!--- // save the library record to the database
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
			--->
			
			