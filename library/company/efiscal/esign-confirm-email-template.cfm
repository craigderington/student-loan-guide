




				<!--- // get our data access objects --->				
				
				<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
					<cfinvokeargument name="leadid" value="#session.leadid#">
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
											<p class=p0  style="margin-bottom:10pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; color:rgb(0,92,0); font-weight:bold; font-size:16.0000pt; font-family:'Cambria'; " >Student&nbsp;Loan&nbsp;Counseling&nbsp;Program&nbsp;</span><br/>        
											<span style="mso-spacerun:'yes'; color:rgb(124,124,124); font-weight:bold; font-size:12.0000pt; font-family:'Cambria'; " >Provided&nbsp;By&nbsp;Money&nbsp;Management&nbsp;International</span></p>
											
											<p class=p0  style="margin-bottom:10pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >Thanks for completing the application process by electronically signing your documents online.  To make changes to the information you provided or to review or print these documents, simply log back into the Student Loan Counseling Portal and select ESIGN in the navigation menu.</span></p>											
										</td>
									</tr>							 
									  
									<tr>
										<td>										  
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >If&nbsp;you&nbsp;have&nbsp;questions&nbsp;before&nbsp;your&nbsp;scheduled&nbsp;counseling&nbsp;appointment,&nbsp;our&nbsp;team&nbsp;of&nbsp;student&nbsp;loan&nbsp;counselors&nbsp;is&nbsp;available&nbsp;to&nbsp;assist&nbsp;you&nbsp;Monday&nbsp;through&nbsp;Friday&nbsp;from&nbsp;8am&nbsp;to&nbsp;5pm&nbsp;CST&nbsp;at&nbsp;888.922.9723.</span></p>
										   
										  <p class=p0 style="margin-bottom:10pt; margin-top:0pt;"><span style="mso-spacerun:'yes'; font-size:12.0000pt; font-family:'Cambria'; " >We&nbsp;look&nbsp;forward&nbsp;to&nbsp;working&nbsp;with&nbsp;you.&nbsp;&nbsp;</span></p>
										</td>
									</tr>
									
									<tr>
										<td>
											<div style="background-color:##f2f2f2;border:1px solid ##333;padding:12px;">
												<p class=p0  style="margin-bottom:5pt; margin-top:0pt; " ><span style="mso-spacerun:'yes'; font-weight:bold; font-size:12.0000pt; font-family:'Cambria'; " >Student Loan Counseling Documents and eSigntaures Completed on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#.</span></p>
											</div>
										</td>
									 </tr>
									  
									<tr>
										<td><a href="http://www.studentloanadvisoronline.com" style="border:1px solid ##999;background-color:##006600;color:white;font-size:12.0000pt;font-family:'Cambria';font-weight:bold;padding:10px;vertical-align:middle;text-decoration:none;">Login Now &raquo;&raquo; </a></td>
									</tr>
									
								</table>
							</body>
						</html>
				</cfoutput>