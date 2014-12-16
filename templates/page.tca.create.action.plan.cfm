
			
			
			
			
			
			<!--- // define a few page vars --->
			<cfparam name="totalstudentloandebt" default="0.00">
			<cfparam name="totalpayments" default="0">
			<cfparam name="totalintrate" default="0">
			<cfparam name="avgintrate" default="0">	
			<cfparam name="paytype" default="">
			<cfparam name="totalpayments" default="0.00">
			<cfparam name="today" default="">
			
			<!--- // client variables --->
			<cfparam name="imgsrc" default="https://www.studentloanadvisoronline.com/img/logos/tca-action-plan-img.png">					
			<cfparam name="clientid" default="#url.clientid#">
			<cfparam name="planid" default="#url.planid#">
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
			
			
			
			<!--- // check to make sure our client id variable is a numeric value --->
			<cfif not isnumeric( url.clientid )>
				<cflocation url="#application.root#?event=page.tca.solution.final&planerror=1" addtoken="no">
			<cfelse>
				<cfset clientid = url.clientid />
				<cfset planid = url.planid />
			</cfif>
			
			
			<cfset cplead = false />
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

			<cfif leaddetail.leadsourceid eq 46>
				<cfset cplead = true />
			</cfif>
			
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
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolutiondetail" returnvariable="tcasolutiondetail">
				<cfinvokeargument name="leadid" value="#clientid#">
				<cfinvokeargument name="planid" value="#planid#">
			</cfinvoke>	
			
			<cfset imgsrc = "https://www.studentloanadvisoronline.com/" & companysettings.complogo />
			
			
			<cfoutput>
			
			
				<!--- // begin TCA Action Plan --->
				<cfdocument 
					format = "PDF" 
					bookmark = "yes"    
					marginBottom = "1.0" 
					marginLeft = "1.0" 
					marginRight = "1.0" 
					marginTop = "0.5" 
					saveAsName = "TCA Action Plan"
					name="coverpage"
					>
					
						<cfdocumentitem type="footer">
							<p style="font-family:Verdana,sans-serif;font-size:12px;color:##3399CC;text-align:center;">
								#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
								<u>#companysettings.email#</u> &bull; #phonenumber#
							</p>
						</cfdocumentitem>
							
							<html>
								<body>						
									
									<div align="center" style="margin-bottom:25px;">
										<img src="#imgsrc#">
									</div>
									
									<div align="left" style="margin-bottom:20px;">
										<p style="font-family:Verdana,sans-serif;font-size:14px;">
											#leaddetail.leadfirst# #leaddetail.leadlast# <br />											
											#leaddetail.leadadd1#  <cfif leaddetail.leadadd2 neq "">&nbsp;&nbsp;#leaddetail.leadadd2#</cfif><br />
											#leaddetail.leadcity#, #leaddetail.leadstate# &nbsp;&nbsp;#leaddetail.leadzip#																				
										</p>		
									</div>
									
									<div align="left" style="margin-bottom:20px;">
										<p style="font-family:Verdana,sans-serif;font-size:14px;">
											#leaddetail.leadfirst#,																			
										</p>		
									</div>
									
									<div align="left" style="margin-bottom:10px;">
										<p style="font-family:Verdana,sans-serif;font-size:14px;">
											We would like to thank you for completing your student loan counseling session with #companysettings.companyname# ("#companysettings.dba#").  If at any point you have additional questions or need further assistance, please do not hesitate to call our Student Loan Department.  Our phone number is <strong>#phonenumber#</strong> and our email is <strong>#companysettings.email#</strong>.
										</p>
									</div>
									
									<div align="left" style="margin-bottom:10px;">
										<h5 style="font-family:Verdana,sans-serif;font-size:14px;">Counselor Comments:</h5>
										<p style="font-family:Verdana,sans-serif;font-size:14px;">#urldecode( tcasolutiondetail.tcasolutionnarrative )#</p>
									</div>
								
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
							<p style="font-family:Verdana,sans-serif;font-size:12px;color:##3399CC;text-align:center;">
								#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
								<u>#companysettings.email#</u> &bull; #phonenumber#
							</p>
						</cfdocumentitem>				
									
							<div align="center" style="margin-bottom:25px;">
									<img src="#imgsrc#">
								</div>
							
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
													<cfloop query="worksheetlist">
														<tr style="background-color:white;font-family:Verdana,sans-serif;font-size:12px;text-align:left;">
															<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>
															<td>#codedescr#</td>
															<td>#statuscodedescr#</td>
															<td>#dollarformat( loanbalance )#</td>
															<td>#numberformat( intrate, '999.99' )#%</td>
														</tr>
														<cfset totalstudentloandebt = numberformat( totalstudentloandebt + loanbalance, "999.99" ) />
													</cfloop>

													
													
													<!--- // totals row --->
													<tr style="background-color:##f2f2f2;font-family:Verdana,sans-serif;font-size:12px;text-align:left;">
														<td colspan="3">&nbsp;</td>
														<td>#dollarformat( totalstudentloandebt )#</td>
														<td>&nbsp;</td>
													</tr>
												
												</tbody>
												
												
												
											</table>
										</table>
									</small>
							</div>
										
					

				</cfdocument>
				
				
				
				
				
				<!--- // budget, payment info & closing thank you --->
				
				
				<cfdocument 
					format = "PDF"
					bookmark = "yes"
					marginBottom = "1.0"
					marginLeft = "1.0"
					marginRight = "1.0"
					marginTop = "0.5"	
					name="thankyou"			
					>
					
						<cfdocumentitem type="footer">
							<p style="font-family:Verdana,sans-serif;font-size:12px;color:##3399CC;text-align:center;">
								#companysettings.address1# &bull; #companysettings.city#, #companysettings.state# &nbsp;&nbsp; #companysettings.zip# <br />
								<u>#companysettings.email#</u> &bull; #phonenumber#
							</p>
						</cfdocumentitem>
					
						
							<html>
								
								<body>					
									
									<div align="center" style="margin-bottom:25px;">
										<img src="#imgsrc#">
									</div>
									
									<!--- // for a little spacing --->							
									<p>&nbsp;</p>
									
									<!--- // budget --->
									<h4 style="font-family:Verdana,sans-serif;font-size:14px;">BUDGET</h4>
									
									<cfif cplead is false>
									
										<p style="font-family:Verdana,sans-serif;font-size:14px;">Please see Addendum A for a copy of your detailed budget.</p>
									
									<cfelse>
										<!--- // clearpoint lead --->
										<p style="font-family:Verdana,sans-serif;font-size:14px;">
											We highly recommend that you review the budget with your created Clearpoint counselor.  We encourage you look into the resources and recommendations made by your counselor to further assist you in handling your finances.  If #companysettings.dba# can be of further assistance, please do not hesitate to contact at #phonenumber#.
										</p>
									
									</cfif>
									
									<!--- // for a little spacing --->							
									<p>&nbsp;</p>
									
									<!--- // payment info --->
									<h4 style="font-family:Verdana,sans-serif;font-size:14px;">PAYMENT</h4>
									
									<p style="font-family:Verdana,sans-serif;font-size:14px;">Per our conversation, we have setup <cfif trim( paytype ) eq "single"> a one-time payment<cfelse> #clientfees.recordcount# payment cycle</cfif> for your comprehensive counseling session.  <cfif trim( paytype ) eq "single">Payments will be processed in the amount of #totalpayments# on #dateformat( clientfees.feeduedate[1] )#<cfelse>Payments will be processed in the amount of #totalpayments# starting on #dateformat( clientfees.feeduedate[1], "mm/dd/yyyy" )#, <cfif clientfees.recordcount eq 2>#dateformat( clientfees.feeduedate[2], "mm/dd/yyyy" )#<cfelseif clientfees.recordcount eq 3>#dateformat( clientfees.feeduedate[3], "mm/dd/yyyy" )#<cfelse>Some future dates...</cfif></cfif>.
									
									
									</p>
									
									<!--- // for a little spacing --->							
									<p>&nbsp;</p>
									
									<p style="font-family:Verdana,sans-serif;font-size:14px;">#companysettings.dba# appreciates you utilizing our service to assist in your student loan repayments.  Please let us know how we are doing and pass along our information to your friends and family who may also be struggling with their student loan payments.</p>
									
									<p>&nbsp;</p>
									<p>&nbsp;</p>
									
									
									<p style="font-family:Verdana,sans-serif;font-size:14px;">Sincerely,</p>
									<p>&nbsp;</p>
									<p>&nbsp;</p>
									
									<p style="font-family:Verdana,sans-serif;font-size:14px;">#session.username# 
										<br />
											#phonenumber#
										<br />
											<u>
												#companysettings.email#
											</u>
									</p>
									
								</body>
							</html>			

				</cfdocument>
				
				
				<!--- // budget addendum --->
				
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
						<p style="font-family:Verdana,sans-serif;font-size:16px;color:##999;text-align:center;margin-top:25px;">
							Addendum A <br />
							Your Monthly Budget
						</p>
					</cfdocumentitem>
					
					<html>
						<body>
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
						</body>
					
					</html>
					
					
				</cfdocument>
				
				<!--- // servicers contact infor addendum --->
				<cfif trim( tcasolutiondetail.idrconsol ) eq 'Y'>
					
					<!--- // servicer contacts --->
					<cfinvoke component="apis.com.nslds.nsldsgateway" method="getnsldslist" returnvariable="nsldslist">
						<cfinvokeargument name="leadid" value="#session.leadid#">
					</cfinvoke>
					
					
					<cfdocument
						format = "PDF"
						bookmark = "yes"
						marginBottom = "1.0"
						marginLeft = "1.0"
						marginRight = "1.0"
						marginTop = "1.0"
						name="servicers"			
						>		
									
						<cfdocumentitem type="header">	
							<p style="font-family:Verdana,sans-serif;font-size:16px;color:##999;text-align:center;margin-top:25px;">
								Addendum B <br />
								Your Loan Servicer Contact Information
							</p>
						</cfdocumentitem>
						
						<html>
							<body>
								<cfloop query="nsldslist">
									<div style="margin-bottom:10px;">
										
											<p style="font-family:Verdana,sans-serif;font-size:14px;">
											   <i>#nslschool#</i> <br />
											   <strong>#companyname#</strong><br />
											   #companyadd1# <br />
											   <cfif trim( companyadd2 ) neq "loan contact street address 2">
											   #companyadd2# <br />
											   </cfif>
											   #companycity#, #companystate#, #companyzip# <br />
											   #companyphone# <br />
											   <cfif trim( companyemail ) neq "loan contact email address">
											   #companyemail#
											   </cfif>
											</p>
									</div>
								</cfloop>
							</body>
						</html>
					</cfdocument>
				</cfif>

						<!--- // Use the cfpdf tag to merge the cover page generated in ColdFusion with pages from PDF
								 files in solution source document locations. --->
							
							<cfset clientdocsavevar = leaddetail.leadid & '-' & leaddetail.leadfirst & '-' & leaddetail.leadlast & '-Action-Plan-' & dateformat( today, "mm-dd-yyyy" ) & '.pdf' />
							
							<cfpdf action="merge" destination="#expandpath( 'library\clients\solutions\' & '#clientdocsavevar#' )#" overwrite="yes" keepBookmark="yes">
								
								<!--- // get the cover page from above --->
								<cfpdfparam source="coverpage">
								
								<!--- // insert the loan summary from above --->
								<cfpdfparam source="loansummary">
								
								<!--- // now begin including static solution documents --->
								
								<cfif trim( tcasolutiondetail.consol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-consolidation.pdf">
								</cfif>
								
								<cfif trim( tcasolutiondetail.idrconsol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-consolidation-idr.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.pslfconsol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-pslf-consolidation.pdf">						
								</cfif>												
														
								<cfif trim( tcasolutiondetail.ibr ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-ibr-non-consolidated.pdf">						
								</cfif>
														
								<cfif trim( tcasolutiondetail.icr ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-icr.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.paye ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-paye.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.rehab ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-rehabilitation.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.pslf ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-pslf.pdf">
								</cfif>									
														
								<cfif trim( tcasolutiondetail.tlf ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-tlf.pdf">
								</cfif>														
														
								<cfif trim( tcasolutiondetail.forbear ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-forbearance.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.unempdefer ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-unemployment-deferment.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.econdefer ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline.com\library\company\tca\tca-economic-hardship-deferment.pdf">
								</cfif>
								
								
								<!--- // insert the the final thank you page --->
								<cfpdfparam source="thankyou">
								
								<!--- // insert addendums --->
								<cfif cplead is false>
									<cfpdfparam source="budget">
								</cfif>
								
								
								<cfif trim( tcasolutiondetail.idrconsol ) eq 'Y'>
									<cfpdfparam source="servicers">
								</cfif>
								
							</cfpdf>
				
						
							<!--- // add the document to the client's document library --->
							
							<cfquery datasource="#application.dsn#" name="dodocsaverecord">
								insert into documents(docuuid, leadid, docname, docfileext, docpath, docdate, docuploaddate, uploadedby, docactive, doctype, doccatid)
									values (
											<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
											<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="TCA Action Plan" cfsqltype="cf_sql_varchar" />,
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
				
							<!--- // output some info for the user --->
						
						
							<div class="main">	
							
								<div class="container">
									
									<div class="row">
							
										<div class="span12">
											
											<div class="widget stacked">
											
												<div class="widget-header">		
													<i class="icon-paste"></i>							
													<h3>Take Charge America &raquo; Completed Action Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
	
	
	
					