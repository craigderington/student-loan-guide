




				<!--- // get our data access objects --->				
				
				<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
				</cfinvoke>

				
				<cfoutput>
					<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
						<html>
							<head>
								
								<meta http-equiv="Content-Type" content="text/html; charset=utf-8">								
									<title>
										#companysettings.companyname# | Your Student Loan Advisor Portal is Ready!
									</title>								
							</head>

							<body>
								<table width="680" border="0" cellspacing="0" cellpadding="10">
									<tr>
										<td><img src="https://www.studentloanadvisoronline.com/#companysettings.complogo#"></td>
									</tr>
									 <tr>
										<td>
											<p class=p0  style="margin-bottom:10pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; color:rgb(0,92,0); font-weight:bold; font-size:16.0000pt; font-family:'Cambria'; " >Student&nbsp;Loan&nbsp;Advisory&nbsp;Program&nbsp;</span><br/>        
											<span style="mso-spacerun:'yes'; color:rgb(124,124,124); font-weight:bold; font-size:12.0000pt; font-family:'Cambria'; " >Provided&nbsp;By&nbsp;Consumer Debt Counselors</span></p>
											
											<p class=p0  style="margin-bottom:10pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Congratulations!&nbsp;&nbsp;Your&nbsp;online&nbsp;client portal account&nbsp;has&nbsp;been&nbsp;established&nbsp;and&nbsp;you&nbsp;are&nbsp;one&nbsp;step&nbsp;closer&nbsp;to&nbsp;more&nbsp;manageable&nbsp;student&nbsp;loan&nbsp;payments.</span></p>
													
											<p class=p0  style="margin-bottom:10pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Please&nbsp;login&nbsp;to&nbsp;your&nbsp;Student&nbsp;Loan&nbsp;Counseling&nbsp;Portal&nbsp;account&nbsp;using&nbsp;the&nbsp;following&nbsp;temporary&nbsp;username&nbsp;and&nbsp;password:</span></p>
										</td>
									 </tr>
									  
									 <tr>
										<td>
											<div style="background-color:##f2f2f2;border:1px solid ##333;padding:12px;">
												<p class=p0  style="margin-bottom:5pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-weight:bold; font-size:12.0000pt; font-family:'Cambria'; " >Username:&nbsp;#lead.email#</span></p>
												<p class=p0  style="margin-bottom:5pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-weight:bold; font-size:12.0000pt; font-family:'Cambria'; " >Password:&nbsp;The&nbsp;last&nbsp;six&nbsp;digits&nbsp;of&nbsp;your&nbsp;social&nbsp;security&nbsp;number.</span></p>
											</div>
										</td>
									 </tr>
									  
									 <tr>
										<td>
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >After&nbsp;successfully&nbsp;logging&nbsp;into&nbsp;your&nbsp;account,&nbsp;you&nbsp;will be able to review your information and electronically sign your student loan advisory agreement and payment authorization form.</span></p>
												
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Prior to signing your documents, you will be able to correct any inaccurate information. If for any reason, the fee schedule payment dates or payment amounts do not match what you originall agreed to pay, please stop now; contact your Student Loan Advisor before completing this portion of the process.</span></p>
										  
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Once you have digitally signed your program enrollment documents, you will receive a confirmation email acknowledging your enrollment status.  Shortly after completing the ESIGN process, you will be contacted by your Intake Advisor to schedule your Student Loan Advisory counseling session.</span></p>
																				  
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Before your counseling session, please take a moment to complete your Portal tasks.  See the Client Portaldash board for more information.  If you have any questions, please call us at 1-800-820-9232.</span></p>
										   
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >We&nbsp;look&nbsp;forward&nbsp;to&nbsp;working&nbsp;with&nbsp;you.&nbsp;&nbsp;</span></p>
										</td>
									</tr>
									  
									<tr>
										<td><a href="http://www.studentloanadvisoronline.com" style="border:1px solid ##999;background-color:##006600;color:white;font-size:12.0000pt;font-family:'Cambria';font-weight:bold;padding:10px;vertical-align:middle;text-decoration:none;">Login Now &raquo;&raquo; </a></td>
									</tr>
								</table>
							</body>
						</html>
				</cfoutput>