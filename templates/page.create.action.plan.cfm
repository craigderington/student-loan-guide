
			
			
			
			
			
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
			<cfparam name="clientdocsavevar" default="">
			
			<!--- // default our variables to zero values for empty strings --->
			<cfparam name="totalincome" default="0.00">
			<cfparam name="totaldeductions" default="0.00">
			<cfparam name="netincome" default="0.00">
			<cfparam name="totalexpenses" default="0.00">
			
			
			<!--- // check to make sure our client id variable is a numeric value --->
			<cfif not isnumeric( url.clientid )>
				<cflocation url="#application.root#?event=page.tca.solution" addtoken="no">
			<cfelse>
				<cfset clientid = url.clientid />				
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
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolution" returnvariable="tcasolutiondetail">
				<cfinvokeargument name="leadid" value="#clientid#">				
			</cfinvoke>	
			
			<cfset imgsrc = "https://www.studentloanadvisoronline.com/" & companysettings.complogo />
			
			
			<cfoutput>
			
			
				<!--- // begin TCA Action Plan --->
				<cfdocument 
					format = "PDF" 
					bookmark = "yes"    
					marginBottom = "0.5" 
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
										<img src="#imgsrc#" width="400" height="76">
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
										<p style="font-family:Verdana,sans-serif;font-size:14px;">#urldecode( tcasolutions.tcasolutionnarrative )#</p>
									</div>
								
								</body>
							</html>					
						
				
				
				</cfdocument>
				
				
				<!--- // hide this for now  --->
				
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
									<img src="#imgsrc#" width="400" height="76">
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
										<img src="#imgsrc#" width="400" height="76">
									</div>
									
									<!--- // for a little spacing --->							
									<p>&nbsp;</p>
									
									<!--- // budget --->
									<h4 style="font-family:Verdana,sans-serif;font-size:14px;">BUDGET</h4>
									
									<cfif cplead is false>
									
										<p style="font-family:Verdana,sans-serif;font-size:14px;">Please see addendum A for your detail budget.</p>
									
									<cfelse>
										<!--- // clearpoint lead --->
										<p style="font-family:Verdana,sans-serif;font-size:14px;">
											We highly recommend that you review the budget with your created Clearpoint counselor.  We encourage you look into the resources and recommendations made by your counselor to further assist you in handling your finances.  If TCA can be of further assistance do not hesitate to contact us at <u>http://www.takechargeamerica.org/</u> or call 866-528-0588.
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
											<td width="26%" style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Average Monthly</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Net Salary Wages </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Client Monthly Net Wages/Salary </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$7,500.00</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Client Monthly Net Wages/Salary </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$3200.00</td>
										  </tr>
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Net Salary/Wages Total</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">$10,700.00</td>
										  </tr>
										  <tr bgcolor="##999">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Other Income </td>
											<td>&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Part Time Job </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Pension</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Social Security</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Child Support </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Rental Property </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Food Stamps </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Other Income: {{ // if other income: do descr }} </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$0.00</td>
										  </tr>
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Other Income Total </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##999">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Total Monthly Household Income </td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">$10,700.00</td>
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
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Automobiles</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Utilities</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Transportation</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Groceries &amp; Dining</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Insurance</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Medical Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Child Care</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Domestic Court Orders</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Household Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">&nbsp;</td>
										  </tr>
										  <tr bgcolor="black">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Total Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">$1,795.00</td>
										  </tr>
										  <tr bgcolor="##666">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Budget Summary</td>
											<td>&nbsp;</td>
										  </tr>
										  <tr bgcolor="##f2f2f2">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Total Monthly Income</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$10,700.00</td>
										  </tr>
										  <tr bgcolor="white">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">Total Monthly Expenses</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 14px;">$1795.00</td>
										  </tr>
										  <tr bgcolor="black">
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">Monthly Surplus/Deficit</td>
											<td style="font-family: Verdana, Arial, Helvetica, sans-serif;color:white;font-size: 14px;">$8,905.00</td>
										  </tr>
										</table></td>
									  </tr>
									</table>
						</body>
					
					</html>
					
					
				</cfdocument>
				
				

						<!--- // Use the cfpdf tag to merge the cover page generated in ColdFusion with pages from PDF
								 files in different locations. --->
							
							<cfset clientdocsavevar = leaddetail.leadid & '-' & leaddetail.leadfirst & '-' & leaddetail.leadlast & '-Action-Plan-' & dateformat( today, "mm-dd-yyyy" ) & '.pdf' />
							
							<cfpdf action="merge" destination="#expandpath( 'library\clients\solutions\' & '#clientdocsavevar#' )#" overwrite="yes" keepBookmark="yes">
								
								<!--- // get the cover page from above --->
								<cfpdfparam source="coverpage">
								
								<!--- // insert the loan summary from above --->
								<cfpdfparam source="loansummary">
								
								<!--- // now begin including static solution documents --->
								
								<cfif trim( tcasolutiondetail.consol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-consolidation.pdf">
								</cfif>
								
								<cfif trim( tcasolutiondetail.idrconsol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-consolidation-idr.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.pslfconsol ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-pslf-consolidation.pdf">						
								</cfif>												
														
								<cfif trim( tcasolutiondetail.ibr ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-ibr-non-consolidated.pdf">						
								</cfif>
														
								<cfif trim( tcasolutiondetail.icr ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-icr.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.paye ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-paye.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.rehab ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-rehabilitation.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.pslf ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-pslf.pdf">
								</cfif>									
														
								<cfif trim( tcasolutiondetail.tlf ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-tlf.pdf">
								</cfif>														
														
								<cfif trim( tcasolutiondetail.forbear ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-forbearance.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.unempdefer ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-unemployment-deferment.pdf">
								</cfif>
														
								<cfif trim( tcasolutiondetail.econdefer ) eq 'Y'>
									<cfpdfparam source="D:\WWW\studentloanadvisoronline\library\company\tca\tca-economic-hardship-deferment.pdf">
								</cfif>
								
								
								<!--- // insert the the final thank you page --->
								<cfpdfparam source="thankyou">
								
								<!--- // insert addendums --->
								<cfif cplead is false>
									<cfpdfparam source="budget">
								</cfif>
								
								<!---
								<cfif trim( tcasolutiondetail.idrconsol ) eq 'Y'>
									<cfpdfparam source="servicers">
								</cfif>
								--->
							</cfpdf>
				
							<!--- // task automation // update task and mark completed --->
							<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
								<cfinvokeargument name="leadid" value="#session.leadid#">
								<cfinvokeargument name="taskref" value="spgen">
							</cfinvoke>
				
				
						<!--- // output some info for the user --->
						
						
							<div style="padding:100px;">
							
								<h4>Document Successfully Generated</h4>
								<p>Your action plan has been successfully generated.  
								   <a style="color:red;" href="library/clients/solutions/#clientdocsavevar#" target="_blank">Please click here to open the document.</a>
								</p>
							
							</div>
						
			</cfoutput>
	
	
	
					