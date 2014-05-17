


		<cfcomponent displayname="commsgateway">
	
				<cffunction name="init" access="public" output="false" returntype="commsgateway" hint="Returns an initialized comms gateway object function.">		
					<!--- // return this reference. --->
					<cfreturn this />
				</cffunction>

				<cffunction name="sendclientlogin" access="public" output="false" hint="I trigger the portal login email to the client.">
						<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
						<cfargument name="companyemail" type="string" required="yes">
						<cfargument name="companyname" type="string" required="yes">
						<cfargument name="sendto" type="string" required="yes">
						<cfset msgstatus = "" />	
						
						
						
							
							<cfif isvalid( "email", arguments.sendto ) and isvalid( "email", arguments.companyemail )>			
								
								
								<cfmail from="#arguments.companyemail# (#arguments.companyname#)" to="#arguments.sendto#" bcc="craig@efiscal.net" subject="Important Information from your Student Loan Advisor Team" type="HTML">
										
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
		