


		<cfcomponent displayname="commsgateway">
	
				<cffunction name="init" access="public" output="false" returntype="commsgateway" hint="Returns an initialized comms gateway object function.">		
					<!--- // return this reference. --->
					<cfreturn this />
				</cffunction>

				<cffunction name="sendclientlogin" access="public" output="false" hint="I trigger the portal login email to the client.">
						<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
						<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
						<cfargument name="cat" type="any" required="yes" default="client-login">
						<cfargument name="companyemail" type="string" required="yes">
						<cfargument name="companyname" type="string" required="yes">
						<cfargument name="sendto" type="string" required="yes">
						<cfargument name="templatepath" type="string" required="yes">
						<cfset msgstatus = "" />				
						
							
							<cfif isvalid( "email", arguments.sendto ) and isvalid( "email", arguments.companyemail )>			
								
								<!--- // new method // dynamic email templates per company 
								<cfquery datasource="#application.dsn#" name="getemailtemplate">
									select templateid, companyid, templatecategory, templatecreatedate, 
									       templatecontent, lastupdated, lastupdatedby
									  from emailtemplates
									 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
									   and templatecategory = <cfqueryparam value="#arguments.cat#" cfsqltype="cf_sql_varchar" />
								</cfquery>
								--->
								
								<cfmail from="#arguments.companyemail# (#arguments.companyname#)" to="#arguments.sendto#" subject="Student Loan Counseling Portal Available" type="HTML">
										
																				
										<cfinclude template="#arguments.templatepath#">
										
										
										
										<!--- // old method // static template
										<html>
											<head>
												<title>Student Loan Advisor Online - Email Notification</title>						
											</head>
											
											
												<cfoutput>
													<body>
														<table width="60%"  border="0" cellspacing="0" cellpadding="25">
															<tr>
																<td colspan="2"><div align="center"><img src="http://www.efiscal.net/images/sla-email-header-1.png" width="447" height="40"></div></td>
															</tr>
																  
															<tr>
																<td colspan="2" style="font-family:Verdana;font-size:12px;color:red;text-align:center;">Please make note of this important message from your Student Loan Advisor team.</span></td>
															</tr>
																  
																  
																  <tr>
																	<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">#arguments.companyname#</td>
																	<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">Date: #dateformat( now(), "mm/dd/yyyy" )#</td>
																  </tr>
																  
																  
																  <tr>
																	<td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="25">
																	  <tr>
																		<td colspan="2" style="font-family:Verdana;font-size:12px;font-weight:bold;">
																			
																			<div align="center">
																				Username:  #arguments.sendto#
																				<br /><br />
																				Password:  <br />
																				Last 6 of your social security number
																			</div>
																			
																			<br /><br /><br /><br />
																			
																			<div align="center">
																				<a href="http://www.studentloanadvisoronline.com/index.cfm?event=page.index" style="border-top: 1px solid black;background:darkblue;padding: 5px 10px;color: white;font-size: 14px;font-family: Verdana;text-decoration: none;vertical-align: middle;">Login to Your Student Loan Portal</a>
																			</div>
																		
																		
																		</td>
																	  </tr>
																	  <tr>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																	  </tr>
																	  <tr>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																	  </tr>
																	</table></td>
																  </tr>
																  <tr>
																	<td colspan="2"><div align="center">
																	  <p style="font-family:Verdana:font-size:8px;text-align:center">This message is sent on behalf of <a href="http://www.studentloanadvisoronline.com" target="_blank">Student Loan Advisor Online</a></p>
																	  </div></td>
																  </tr>
																</table>
													</body>
												</cfoutput>
										</html>
										--->
																
								</cfmail>
								
								<cfset msgstatus = "Message sent successfully..." />
								
							
							<cfelse>
							
								
								<cfset msgstatus = "Lead email address not properly formattted..." />
								
							
							</cfif>	
							
							<!--- //
								<cfset msgstatus = structnew() />								
								<cfset mcompayname = structinsert( msgstatus, "mcompanyname", arguments.companyname ) />
								<cfset mcompanyemail = structinsert( msgstatus, "mcompanyemail", arguments.companyemail ) />
								<cfset mleadid = structinsert( msgstatus, "mleadid", arguments.leadid ) />
								<cfset msendto = structinsert( msgstatus, "msendto", arguments.sendto ) />
							
							---->
						<cfreturn msgstatus>
					</cffunction>				
					
					
					
					<cffunction name="sendclientesigncomplete" access="public" output="false" hint="I trigger the advisor notification upon successful portal esign.">
						<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">						
						<cfset msgstatus = "" />	
						
							<cfquery datasource="#application.dsn#" name="leadinfo">
								select l.leadid, l.leadfirst, l.leadlast, u.userid, l.leademail, 
								       u.email, c.companyname, c.email as compemail
								  from leads l, users u, company c
								 where l.userid = u.userid
								   and l.companyid = c.companyid
								   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							</cfquery>
							
							<cfquery datasource="#application.dsn#" name="intakeinfo">
								select la.leadassignuserid, u.email
								  from leadassignments la, users u
								 where la.leadassignuserid = u.userid
								   and la.leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
								   and la.leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
							</cfquery>
						
							
							<cfif isvalid( "email", leadinfo.email ) and isvalid( "email", leadinfo.compemail )>			
								
								
								<cfmail from="#leadinfo.compemail# (#leadinfo.companyname#)" to="#leadinfo.email#" cc="#intakeinfo.email#" bcc="craig@efiscal.net" subject="SLA - Client Completed E-Sign on #dateformat( now(), "mm/dd/yyyy" )#" type="HTML">
									<cfmailparam name="Reply-to" value="#leadinfo.email#">	
										<html>
											<head>
												<title>Student Loan Advisor Online - Email Notification</title>						
											</head>
											
											
												<cfoutput>
													<body>
														<table width="60%"  border="0" cellspacing="0" cellpadding="25">
															<tr>
																<td colspan="2"><div align="center"><img src="http://www.efiscal.net/images/sla-email-header-1.png" width="447" height="40"></div></td>
															</tr>
																  
															<tr>
																<td colspan="2" style="font-family:Verdana;font-size:12px;color:red;text-align:center;">Please make note of this important message from Student Loan Advisor Online.</span></td>
															</tr>
																  
																  
																  <tr>
																	<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">#leadinfo.companyname#</td>
																	<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">Date: #dateformat( now(), "mm/dd/yyyy" )#</td>
																  </tr>
																  
																  
																  <tr>
																	<td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="25">
																	  <tr>
																		<td colspan="2" style="font-family:Verdana;font-size:12px;font-weight:bold;">
																			
																			<cfoutput>
																			<div align="center">
																				#leadinfo.leadfirst# #leadinfo.leadlast# successfully completed the Student Loan Advisor Online Client Portal electronic signature section on #dateformat( now(), "mm/dd/yyyy" )#...
																			</div>
																			</cfoutput>
																			<br /><br /><br /><br />
																			
																			
																		
																		
																		</td>
																	  </tr>
																	  <tr>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																	  </tr>
																	  <tr>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																	  </tr>
																	</table></td>
																  </tr>
																  <tr>
																	<td colspan="2"><div align="center">
																	  <p style="font-family:Verdana:font-size:8px;text-align:center">This message is sent on behalf of <a href="http://www.studentloanadvisoronline.com" target="_blank">Student Loan Advisor Online</a></p>
																	  </div></td>
																  </tr>
																</table>
													</body>
												</cfoutput>
										</html>

																
								</cfmail>
								
								<cfset msgstatus = "Message sent successfully..." />
								
							
							<cfelse>
							
								
								<cfset msgstatus = "Lead email address not properly formattted..." />
								
							
							</cfif>	
							
							<!--- //
								<cfset msgstatus = structnew() />								
								<cfset mcompayname = structinsert( msgstatus, "mcompanyname", arguments.companyname ) />
								<cfset mcompanyemail = structinsert( msgstatus, "mcompanyemail", arguments.companyemail ) />
								<cfset mleadid = structinsert( msgstatus, "mleadid", arguments.leadid ) />
								<cfset msendto = structinsert( msgstatus, "msendto", arguments.sendto ) />
							
							---->
						<cfreturn msgstatus>
					</cffunction>
					
					
					
					
					
			
			</cfcomponent>
		