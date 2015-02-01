
			
			
			
			
			
			<!--- // define a few page vars --->
			<cfparam name="totalstudentloandebt" default="0.00">
			<cfparam name="totalpayments" default="0">
			<cfparam name="totalintrate" default="0">
			<cfparam name="avgintrate" default="0">	
			<cfparam name="paytype" default="">
			<cfparam name="totalpayments" default="0.00">
			<cfparam name="today" default="">
			
			<!--- // client variables --->
			<cfparam name="imgsrc" default="">					
			<cfparam name="clientid" default="">
			<cfparam name="planid" default="">
			<cfparam name="clientdocsavevar" default="">
			
			<!--- // default our variables to zero values for empty strings --->
			<cfparam name="totalincome" default="0.00">
			<cfparam name="totaldeductions" default="0.00">
			<cfparam name="netincome" default="0.00">
			<cfparam name="totalexpenses" default="0.00">
			<cfparam name="totalotherincome" default="0.00">
			<cfparam name="calcprimaryincome" default="0.00">
			<cfparam name="calcsecondaryincome" default="0.00">
			<cfparam name="totalprimarydeductions" default="0.00">			
			<cfparam name="totalsecondarydeductions" default="0.00">
			
			<cfparam name="cplead" default="false">
			
			<!--- // check to make sure our client id variable is a numeric value --->
			<cfif not ( isnumeric( url.clientid )) and not ( isvalid( "uuid", url.planid ))>
				<cflocation url="#application.root#?event=page.mmi.solution.final&planerror=1" addtoken="no">
			<cfelse>
				<cfset clientid = url.clientid />
				<cfset planid = url.planid />
			</cfif>			
			
			<cfset today = now() />
			
			
			<!--- // include our data components for our api --->
			<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
				<cfinvokeargument name="leadid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
				<cfinvokeargument name="phonenumber" value="#companysettings.phone#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>		
		
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfif clientfees.recordcount gt 1>
				<cfset paytype = "multi" />
				<cfset totalpayments = dollarformat( clientfees.feeamount * clientfees.recordcount ) />
			<cfelse>
				<cfset paytype = "single" />
				<cfset totalpayments = dollarformat( clientfees.feeamount ) />
			</cfif>		
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.solutions.mmisolutiongateway" method="getmmisolution" returnvariable="mmisolutions">
				<cfinvokeargument name="leadid" value="#clientid#">
				<cfinvokeargument name="planid" value="#planid#">
			</cfinvoke>									
										
			<cfinvoke component="apis.com.solutions.mmisolutiongateway" method="getmmisolutiondetail" returnvariable="mmisolutiondetail">
				<cfinvokeargument name="mmisolutionid" value="#mmisolutions.mmisolutionid#">										
			</cfinvoke>
			
			<cfset imgsrc = "https://www.studentloanadvisoronline.com/library/company/mmi/mmi-action-plan-header-image-sm.png" />
			
			
			
			
				<!--- // begin MMI Action Plan --->
				<cfdocument 
					format = "PDF" 
					bookmark = "yes"    
					marginBottom = "1.0" 
					marginLeft = "1.0" 
					marginRight = "1.0" 
					marginTop = "0.5" 
					saveAsName = "MMI Action Plan"
					name="coverpage"
					>
					
						<cfdocumentitem type="footer">
							<cfoutput>
								<p style="font-family:Verdana,sans-serif;font-size:12px;color:##247353;text-align:center;">
									#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
									<u>#companysettings.email#</u> &bull; #phonenumber#
								</p>
							</cfoutput>
						</cfdocumentitem>
							
							<html>
								<body>						
									
									<cfoutput>
									<div align="left" style="margin-bottom:30px;">
										<img src="#imgsrc#">
									</div>
									
										<div align="left" style="margin-bottom:20px;">
											<p style="font-family:Verdana,sans-serif;font-size:14px;">
												#leaddetail.leadfirst# #leaddetail.leadlast# <br />											
												<cfif ( leaddetail.leadadd1 neq "" ) and ( leaddetail.leadcity neq "" )>
												#leaddetail.leadadd1#  <cfif leaddetail.leadadd2 neq "">&nbsp;&nbsp;#leaddetail.leadadd2#</cfif><br />
												#leaddetail.leadcity#, #leaddetail.leadstate# &nbsp;&nbsp;#leaddetail.leadzip#
												<cfelse>
													No Client Address Entered
												</cfif>
											</p>		
										</div>
										
										<div align="left" style="margin-bottom:20px;">
											<p style="font-family:Verdana,sans-serif;font-size:14px;">
												#leaddetail.leadfirst#,																			
											</p>		
										</div>
										
										<div align="left" style="margin-bottom:10px;">
											<p style="font-family:Verdana,sans-serif;font-size:14px;margin-bottom:7px;">Congratulations on completing the first step towards a more manageable student loan payment.  During your recent counseling session, we reviewed your current income, living expenses, and student loan debts to help evaluate your overall financial situation.</p>
											
											<p style="font-family:Verdana,sans-serif;font-size:14px;margin-bottom:7px;">Based on the information you provided, we have created a customized budget and action plan for you.  Enclosed is a copy for your review, which contains the options we discussed along with steps on how to implement your chosen solution, as well as a few tips to consider while working through the process.</p>
											
											<p style="font-family:Verdana,sans-serif;font-size:14px;margin-bottom:7px;">Please review the enclosed packet carefully, as it covers important information and instructions for successfully addressing your student loan debt concerns.  Please feel free to contact me if you have any questions about the packet.</p>

											<p style="font-family:Verdana,sans-serif;font-size:14px;margin-bottom:12px;">Thank you again for choosing Money Management International.

											<p style="font-family:Verdana,sans-serif;font-size:14px;margin-bottom:14px;">Sincerely,</p>

											<p style="font-family:Verdana,sans-serif;font-size:14px;">#session.username#</p>
											
										</div>						
									</cfoutput>
								</body>
							</html>					
						
				
				
				</cfdocument>
				
				
				<!--- // loan summary --->
				
				<cfdocument 
					format = "PDF"
					bookmark = "yes"
					marginBottom = "1.0"
					marginLeft = "1.0"
					marginRight = "1.0"
					marginTop = "0.5"
					name="loansummary"
					>					
						
						<cfdocumentitem type="footer">
							<cfoutput>
								<p style="font-family:Verdana,sans-serif;font-size:12px;color:##247353;text-align:center;">
									#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
									<u>#companysettings.email#</u> &bull; #phonenumber#
								</p>
							</cfoutput>
						</cfdocumentitem>				
									
							<!--- // 2-1-2015 // MMI reqs removal of image header on inner pages
							<div align="left" style="margin-bottom:15px;">
								<cfoutput>
									<img src="#imgsrc#">
								</cfoutput>
							</div>
							--->
							
							<div align="left">
								
								<h4 style="font-family:Verdana,sans-serif;font-size:14px;">Loan Summary</h4>
									<small>
										<table border="0" width="100%" cellspacing="0" cellpadding="0">
											<table width="100%" cellspacing="1" cellpadding="5" bgcolor="black">
												
												<thead>
													<tr style="background-color:##3399CC;color:white;font-family:Verdana,sans-serif;font-size:12px;text-align:left;">
														<th>Servicer</th>
														<th>Loan Type</th>
														<th>Loan Status</th>
														<th>Loan Balance</th>
														<th>Interest Rate</th>
													</th>
												</thead>
												
												<tbody>
													<cfoutput query="worksheetlist">
														<tr style="background-color:white;font-family:Verdana,sans-serif;font-size:12px;text-align:left;">
															<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>
															<td>#codedescr#</td>
															<td>#statuscodedescr#</td>
															<td>#dollarformat( loanbalance )#</td>
															<td>#numberformat( intrate, '999.99' )#%</td>
														</tr>
														<cfset totalstudentloandebt = numberformat( totalstudentloandebt + loanbalance, "999.99" ) />
													</cfoutput>

													
													
													<!--- // totals row --->
													<tr style="background-color:#f2f2f2;font-family:Verdana,sans-serif;font-size:12px;text-align:left;">
														<td colspan="3">&nbsp;</td>
														<cfoutput>
														<td>#dollarformat( totalstudentloandebt )#</td>
														</cfoutput>
														<td>&nbsp;</td>
													</tr>
												
												</tbody>							
											</table>
										</table>
									</small>
							</div>
										
					

				</cfdocument>			
				
				
				<!--- // budget --->
				
				<cfdocument
					format = "PDF"
					bookmark = "yes"
					marginBottom = "1.0"
					marginLeft = "1.0"
					marginRight = "1.0"
					marginTop = "1.0"
					name="budget"			
					>		
								
					<cfdocumentitem type="header">	
						<p style="font-family:Verdana,sans-serif;font-size:16px;color:#247353;text-align:center;margin-top:15px;">							
							Your Monthly Budget
						</p>
					</cfdocumentitem>
					
					<html>
						<body>
							<cfoutput>
							<table width="680"  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="black"><table width="100%"  border="0" cellpadding="5" cellspacing="1">
										  <tr bgcolor="black">
											<td width="74%" style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">INCOME</td>
											<td width="26%" style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Monthly Cost</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Net Salary Wages </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>								  
										  
											<!--- // set our totals for the primary income payroll deductions --->			
											<cfset totalprimarydeductions = budget.primarywithholding + budget.primaryfica + budget.primarymedicare + budget.primary401k + budget.primarybenefits + budget.primarycitytax + budget.primarystatetax />
											<cfset totalprimarydeductions = numberformat( totalprimarydeductions, "99.99" ) />									
											<cfset totalsecondarydeductions = budget.secondarywithholding + budget.secondaryfica + budget.secondarymedicare + budget.secondary401k + budget.secondarybenefits + budget.secondarycitytax + budget.secondarystatetax />
											<cfset totalsecondarydeductions = numberformat( totalsecondarydeductions, "99.99" ) />
										
											<cfset calcprimaryincome = numberformat( budget.primarygrossmonthly - totalprimarydeductions, "99999.99" ) />
											<cfset calcsecondaryincome = numberformat( budget.secondarygrossmonthly - totalsecondarydeductions, "99999.99" ) />
										  
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Client Monthly Net Wages/Salary </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( calcprimaryincome )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Client Monthly Net Wages/Salary </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( calcsecondaryincome )#</td>
										  </tr>
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Net Salary/Wages Total</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">#dollarformat( calcprimaryincome + calcsecondaryincome )#</td>
										  </tr>
										  
										  <tr bgcolor="##999">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Other Income </td>
											<td>&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Part Time Job </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primaryparttimejob + budget.secondaryparttimejob )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Pension</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primarypension + budget.secondarypension )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Social Security</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primaryssi + budget.secondaryssi )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Child Support </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primarychildsupport + budget.secondarychildsupport )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Rental Property </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primaryrentalproperty + budget.secondaryrentalproperty )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Food Stamps </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primaryfoodstamps + budget.secondaryfoodstamps )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Other Income: <cfif budget.primaryincomeotheradescr neq "">#trim( budget.primaryincomeotheradescr )#</cfif> </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.primaryincomeothera )#</td>
										  </tr>
										  
										  <cfset totalotherincome = budget.primaryparttimejob + budget.secondaryparttimejob + budget.primarypension + budget.secondarypension + budget.primaryssi + budget.secondaryssi + budget.primarychildsupport + budget.secondarychildsupport + budget.primaryrentalproperty + budget.secondaryrentalproperty + budget.primaryfoodstamps + budget.secondaryfoodstamps + budget.primaryincomeothera />
										 										  
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Other Income Total </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">#dollarformat( totalotherincome )#</td>
										  </tr>
										  <tr bgcolor="##999">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Total Monthly Household Income </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">#dollarformat( totalincome + totalotherincome )#</td>
										  </tr>
										  <tr bgcolor="black">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Monthly Living Expenses </td>
											<td>&nbsp;</td>
										  </tr>
										  
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Expenses (by category):</td>
											<td>&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Home and Shelter</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.sheltertotal )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Automobiles</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.autototal )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Utilities</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.utilitytotal )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Transportation</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.transtotal )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Groceries &amp; Dining</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.foodtotal )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Insurance</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.insurancetotal )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Medical Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.medtotal )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Child Care</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.childcaretotal )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Domestic Court Orders</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.domesticorder )#</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Household Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( budget.misctotal )#</td>
										  </tr>
										  
										  <cfset totalexpenses = budget.sheltertotal + budget.misctotal + budget.domesticorder + budget.childcaretotal + budget.medtotal + budget.insurancetotal + budget.foodtotal + budget.transtotal + budget.utilitytotal + budget.autototal />
										  
										  <tr bgcolor="black">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Total Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">#dollarformat( totalexpenses )#</td>
										  </tr>
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Budget Summary</td>
											<td>&nbsp;</td>
										  </tr>
										  
										  <cfset totalincome = budget.primarytotalincome + budget.secondarytotalincome />
										  
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Total Monthly Income</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( totalincome )#</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Total Monthly Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">#dollarformat( totalexpenses )#</td>
										  </tr>
										  <tr bgcolor="black">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Monthly Surplus/Deficit</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">#dollarformat( totalincome - totalexpenses )#</td>
										  </tr>
										  
										</table></td>
									  </tr>
									</table>
								</cfoutput>
						</body>
					
					</html>
					
					
				</cfdocument>
				
				
				<!--- // narrative --->
				
				
				<cfdocument 
					format = "PDF"
					bookmark = "yes"
					marginBottom = "1.0"
					marginLeft = "1.0"
					marginRight = "1.0"
					marginTop = "0.5"	
					name="narrative"			
					>
					
						<cfdocumentitem type="footer">
							<cfoutput>
								<p style="font-family:Verdana,sans-serif;font-size:12px;color:##247353;text-align:center;">
									#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
									<u>#companysettings.email#</u> &bull; #phonenumber#
								</p>
							</cfoutput>
						</cfdocumentitem>
					
						
							<html>
								
								<body>					
									<cfoutput>
										<!--- 2/2/2015 - remove
										<div align="left" style="margin-bottom:15px;">
											<img src="#imgsrc#">
										</div>
										--->
										<div align="left" style="margin-bottom:10px;">
											<h5 style="font-family:Verdana,sans-serif;font-size:14px;">Counselor Comments:</h5>
											<p style="font-family:Verdana,sans-serif;font-size:14px;">#urldecode( mmisolutions.mmisolutionnarrative )#</p>
										</div>
									</cfoutput>
								</body>
							</html>			

				</cfdocument>
				
				
				<!--- // solutions --->
				
				
				<cfdocument 
					format = "PDF"
					bookmark = "yes"
					marginBottom = "1.0"
					marginLeft = "1.0"
					marginRight = "1.0"
					marginTop = "0.5"	
					name="solutions"			
					>
					
						<cfdocumentitem type="footer">
							<cfoutput>
								<p style="font-family:Verdana,sans-serif;font-size:12px;color:##247353;text-align:center;">
									#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
									<u>#companysettings.email#</u> &bull; #phonenumber#
								</p>
							</cfoutput>
						</cfdocumentitem>
					
						
							<html>
								
								<body>								
									
									<cfoutput>	
								
										<cfloop query="mmisolutiondetail">					
											
											<cfquery datasource="#application.dsn#" name="showplan">
												select ap.optiontree, ap.optiondescr, ap.optionsubcat, ap.actionplanheader, ap.actionplanbodya
												  from actionplan ap
												 where ap.optiondescr IN(<cfqueryparam value="#trim( mmisolutiondetail.mmisolutionoption )#" cfsqltype="cf_sql_varchar" />)
												   and ap.optionsubcat IN(<cfqueryparam value="#trim( mmisolutiondetail.mmisolutionsubcat )#" cfsqltype="cf_sql_varchar" list="yes" />)								   
												   and ap.optiontree LIKE <cfqueryparam value="%#mmisolutiondetail.mmisolutiontree#%" cfsqltype="cf_sql_varchar" />								   
											  order by ap.actionplanid asc					
											</cfquery>
										
												<!--- // now loop over the action plan items and produce output --->
												<!--- // this is a nested loop --->
														
													<h2 style="margin-top:5px;font-family:Verdana;font-weight:bold;font-size:16px;"><strong>Loan Type: #ucase( mmisolutiondetail.mmisolutiontree )#</strong></h2><br />
													
													
													<cfloop query="showplan">
														<h3 style="margin-top:25px;font-family:Verdana;font-weight:bold;font-size:14px;"><strong>#optionsubcat# #optiondescr# </strong></h3>			
														
														
														<p style="font-family:Verdana;font-weight:bold;font-size:14px;">Steps to Implement Solution</p>
														<p style="font-family:Verdana;font-weight:bold;font-size:12px;">#urldecode( showplan.actionplanbodya )#</p>							
													</cfloop>
													
													<!---
													<cfdump var="#showplan#" label="Plan Query">
													--->

										</cfloop>
									
									</cfoutput>			
																		
												<!--- // if any of the selected solutions include consolidation --->
												<!--- // prepare the presentation document to show the calculator 
												<cfif trim( optiondescr ) contains "consolidation">
													
													show the calculator if necessary...
												
												</cfif>
												--->							
								</body>
							</html>			

				</cfdocument>
				
				

						<!--- // Use the cfpdf tag to merge the cover page generated in ColdFusion with pages from PDF
								 files in solution source document locations. --->
							
							<cfset clientdocsavevar = leaddetail.leadid & '-' & leaddetail.leadfirst & '-' & leaddetail.leadlast & '-Action-Plan-' & dateformat( today, "mm-dd-yyyy" ) & '.pdf' />
							
							<cfpdf action="merge" destination="#expandpath( 'library\clients\solutions\' & '#clientdocsavevar#' )#" overwrite="yes" keepBookmark="yes">
								
								<!--- // get the cover page from code above --->
								<cfpdfparam source="coverpage">
								
								<!--- // insert the loan summary from code above --->
								<cfpdfparam source="loansummary">
								
								<!--- // insert budget from code above --->
								<cfpdfparam source="budget">								
								
								<!--- // insert the the narrative page from the code above --->
								<cfpdfparam source="narrative">
								
								<!--- // insert the presented solutions from the code above --->
								<cfpdfparam source="solutions">
								
								<!--- // insert the static pages --->
								<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\mmi\mmi-document-resources.pdf">
								
								<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\mmi\mmi-blank-counseling-agreement.pdf">
								
								<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\mmi\mmi-privacy-notice.pdf">
								
							</cfpdf>
				
						
							<!--- // add the document to the client's document library --->
							
							<cfquery datasource="#application.dsn#" name="dodocsaverecord">
								insert into documents(docuuid, leadid, docname, docfileext, docpath, docdate, docuploaddate, uploadedby, docactive, doctype, doccatid)
									values (
											<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
											<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="MMI Action Plan" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value=".pdf" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#clientdocsavevar#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
											<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
											<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
											<cfqueryparam value="S" cfsqltype="cf_sql_char" />,
											<cfqueryparam value="490751" cfsqltype="cf_sql_integer" />
											);
							</cfquery>
							
							<!--- // log the activity --->
							<cfquery datasource="#application.dsn#" name="logact">
								insert into activity(leadid, userid, activitydate, activitytype, activity)
									values (
											<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
											<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#session.username# generated a solution action plan for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
											);
							</cfquery>
							
							<!--- // task automation // update task and mark completed --->
							<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
								<cfinvokeargument name="leadid" value="#session.leadid#">
								<cfinvokeargument name="taskref" value="spgen">
							</cfinvoke>
				
							<!--- // output some info for the user --->
						
							<cfoutput>
							<div class="main">	
							
								<div class="container">
									
									<div class="row">
							
										<div class="span12">
											
											<div class="widget stacked">
											
												<div class="widget-header">		
													<i class="icon-paste"></i>							
													<h3>#session.companyname# &raquo; Completed Action Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
												</div> <!-- //.widget-header -->
											
												<div class="widget-content">
								
													<h5 style="color:green;"><i class="icon-ok"></i> Document Successfully Generated</h5>
													<p>Your action plan has been successfully generated.  
													   <a style="color:blue;" href="library/clients/solutions/#clientdocsavevar#" target="_blank">Please click here to open the document.</a>
													</p>
													
													<br />
													<br />
													<br />
													
													<a class="btn btn-medium btn-secondary" href="#application.root#?event=page.close"><i class="icon-remove"></i> Close Client File</a>
													<a style="margin-left:5px;" class="btn btn-medium btn-tertiary" href="#application.root#?event=page.tree"><i class="icon-home"></i> Return to Options</a> 
													
													
													
												</div>
											</div>
										</div>
									</div>
									<div style="margin-top:250px;"></div>
								</div>							
							</div>
							</cfoutput>
			
	
	
	
					