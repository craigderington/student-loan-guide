



			<!--- // get our data access component objects --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.system.companysettings" method="getcompanydocs" returnvariable="companydocs">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.messages.messagegateway" method="getmessages" returnvariable="msglist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!--- // check to see if we need to get the message id from the library --->
			<cfif structkeyexists( form, "msglib" )>
				<cfinvoke component="apis.com.messages.messagegateway" method="getmessage" returnvariable="msgdetail">
					<cfinvokeargument name="msgid" value="#form.msglib#">
				</cfinvoke>			
			</cfif>		
			
			<!--- // some form variables --->
			<cfparam name="today" default="">
			<cfparam name="emailmsg" default="">
			
			
			<!--- begin page --->
			<div class="main">
				<div class="container">
					<div class="row">
						<div class="span12">
							<div class="widget stacked">
								
								
								
								
								
								
								
								<cfoutput>
									<div class="widget-header">
										
										<cfif structkeyexists( url, "fuseaction" )>
											<cfif trim( url.fuseaction ) is "email">
												<i class="icon-envelope"></i> 
												<h3>Send Enrollment Documents to #leaddetail.leadfirst# #leaddetail.leadlast# by Email</h3>
											<cfelseif trim( url.fuseaction ) is "print">
												<i class="icon-print"></i> 
												<h3>Print Enrollment Documents for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
											<cfelse>
												<i class="icon-warning-sign" style="color:red;"></i> 
												<h3 style="color:red;">Unknown Enrollment Document Option for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
											</cfif>
										</cfif>
										
									</div><!-- / .widget-header -->
								</cfoutput>
								
								
								
								<div class="widget-content">
									
								
									<!--- // do this if the request is to send by email --->
									<cfif structkeyexists( url, "fuseaction" )>
									
									
										<cfif trim( url.fuseaction ) is "email">
										
													
													<cfoutput>					
													
														<div class="span8">
															
															<form name="message-library-select" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&do=#url.do#">
																<fieldset>
																	<div class="control-group">											
																		<label class="control-label" for="msglib"><strong>Select Library Message</strong></label>
																		<div class="controls">
																			<select name="msglib" id="msglib" class="input-xlarge" onchange="this.form.submit();">
																				<option value="" selected>Select Library Message</option>
																				<cfloop query="msglist">
																					<option value="#msgid#"<cfif isdefined( "form.msglib" ) and form.msglib eq msglist.msgid>selected</cfif>>#msgname#</option>
																				</cfloop>
																			</select>
																			<p class="help-block">Please select an email from the company message library or enter your own message...</p>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																</fieldset>
															</form>
														
															
															
															
																<div class="well">													
															
																	<form id="create-enrollment-docs-to-send" class="form-horizontal" method="post" action="#application.root#?event=page.client.agreement.email" style="margin-left;10px;">
																		
																		<fieldset>				
																			
																			<div style="padding:20px;border:1px ##999 dotted;">
																																				
																						<h5>Sender: #session.username#  (#GetAuthUser()#)</h5>
																						<h5>Recipient: #leaddetail.leadfirst# #leaddetail.leadlast#</h5>
																						<h5>Email Address: #leaddetail.leademail#</h5>
																					
																				</div>
																				
																				<div style="margin-top:25px;"></div>														
																				
																				<div class="control-group">											
																					<label class="control-label" for="msgsubject">Message Subject</label>
																					<div class="controls">
																						<input type="text" name="msgsubject" class="input-xlarge" <cfif isdefined( "form.msgsubject" )>value="#form.msgsubject#"<cfelseif isdefined( "form.msglib" )>value="#msgdetail.msgname#"<cfelse>value="Your Student Loan Enrollment Documents Are Attached"</cfif> />																
																					</div> <!-- /controls -->																
																				</div> <!-- /control-group -->	
																				
																				<div class="control-group">											
																					<label class="control-label" for="emailmsg">Message Content</label>
																					<div class="controls">
																						<textarea name="emailmsg" class="span5" rows="10"><cfif isdefined( "form.emailmsg" )>#form.emailmsg#<cfelseif isdefined( "form.msglib" )>#urldecode( msgdetail.msgtext )#</cfif></textarea>																	
																						<p class="help-block"><i>Email messages are automatically saved to the client notes section.</i></p>
																					</div> <!-- /controls -->																
																				</div> <!-- /control-group -->

																				<div class="control-group">											
																					<label class="control-label" for="msgsubject"><strong>Attachment:</strong></label>
																					<div class="controls">
																						<i style="font-weight:bold;" class="icon-paper-clip icon-2x"></i> <a target="_blank" href="#application.root#?event=page.client.agreement&fuseaction=generatedocuments&clientid=#leaddetail.leadid#">#leaddetail.leadfirst#-#leaddetail.leadlast#-#leaddetail.leadid#-#compdetails.dba#-Enrollment-Agreement.pdf</a>
																					</div> <!-- /controls -->																
																				</div> <!-- /control-group -->
																				
																				<div style="margin-top:50px;"></div>
																				<div class="form-actions">													
																					<button type="submit" class="btn btn-secondary" name="sendclientagreementbyemail"><i class="icon-envelope"></i> Send Enrollment Documents &amp; Email Message</button>																
																					<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																					<input name="utf8" type="hidden" value="&##955;">						
																					<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																
																					<input type="hidden" name="__authToken" value="#randout#" />
																					<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;emailmsg|Please enter your message content before sending the message...;msgsubject|Please enter an email subject for this message." />									
																				</div>																										
																			
																		</fieldset>
																	</form>
														
														
																</div>
														
															</div>
														
														
														
															<div class="span3">						
															
																<div class="widget-header">
																	<i class="icon-paste"></i>
																	<h3>Enrollment Details</h3>
																</div>
																
																<div class="widget-content">
																	
																	
																	<i class="icon-calendar" style="margin-bottom:10px;"></i> &nbsp; Enrollment Information
																	
																	<ul>										
																		<li>Enrollment Advisor: #leaddetail.enrolladvisor#</li>	
																		<li>Enrollment Date: #dateformat( leadsummary.slenrolldate, "mm/dd/yyyy" )#</li>
																		<li>Program Enrolled: Advisory Services</li>																																		
																	</ul>
																	
																	<br />
																	
																	
																	<i class="icon-money" style="margin-bottom:10px;"></i> &nbsp; Fee Schedule
																	
																	<ul>
																		<cfloop query="clientfees">
																			<li>#dateformat( feeduedate, "mm/dd/yyyy" )# - #dollarformat( feeamount )#</li>
																		</cfloop>
																	</ul>				
																	
																	
																</div>
															
																<br />
																
																
																<div class="widget-header">
																	<i class="icon-paper-clip"></i>
																	<h3>Additional Options</h3>
																</div>
																
																<div class="widget-content">
																	
																	<a style="margin-bottom:7px;" href="#application.root#?event=page.client.agreement&fuseaction=generatedocuments&clientid=#leaddetail.leadid#" class="btn btn-small btn-secondary" target="_blank"><i class="icon-print"></i> Print Agreement</a> 
																	<br />
																	<a style="margin-bottom:7px;" href="../library/company#companydocs.enrollagreepath#" class="btn btn-small btn-default" target="_blank"><i class="icon-print"></i> View Agreement</a> 
																	
																</div>
															
															
															</div>
														
														
													
													</cfoutput>
										
										
										</cfif>
										
										
										
										<cfif trim( url.fuseaction ) is "print">
										
											<h4><i class="icon-file-alt"></i> Print Client Agreements</h4>																					
											<p class="help-block">Please click the button below to generate the appropriate client agreement.</p>
											
											
												<div class="span7">																				
														
													<cfoutput>															
														<iframe name="#companydocs.dba#" src="../library/company/#companydocs.enrollagreepath#" height="700" width="600" align="left" seamless></iframe>
													</cfoutput>														
																									
												</div>
												
												
												<div class="span3">
												
												
													<cfoutput>								
														
														<cfif clientfees.recordcount eq 0>
															
															<a class="btn btn-medium btn-default" style="margin-bottom:7px;" disabled onclick="javascript:alert('Sorry, you can not generate a client enrollment agreement without a fee schedule.');"><i class="icon-print"></i> Print Advisory Agreement</a>											
																														
														<cfelse>														
															
															<a style="margin-bottom:7px;" href="#application.root#?event=page.client.agreement&clientID=#leaddetail.leadid#&fuseaction=generatedocuments" class="btn btn-medium btn-default" target="_blank"><i class="icon-print"></i> Print Advisory Agreement</a>											
															<a style="margin-bottom:7px;" href="#application.root#?event=#url.event#&fuseaction=email&do=#url.do#" style="margin-left:5px;" class="btn btn-medium btn-warning"><i class="icon-envelope"></i> Send Agreement by Email</a>													
															<a style="margin-bottom:7px;" href="#application.root#?event=page.lead.login" style="margin-left:5px;" class="btn btn-medium btn-secondary"><i class="icon-user"></i> Send E-Sign Invite</a>
																										
															<cfif leaddetail.leadimp eq 1>
																
																<a href="javascript:;" class="btn btn-medium btn-inverse"><i class="icon-print"></i> Print Implementation Agreement</a>
																<a href="javascript:;" class="btn btn-medium btn-warning"><i class="icon-envelope"></i> Send Implementation Agreement by Email</a>
															
															</cfif>
														
														</cfif>
														
													</cfoutput>											
												
												
												</div>
											
											
										</cfif>									
									
									
									
									
									
									
									
									</cfif><!--- / .query string exists + fuseaction --->	
								
									
									<div style="margin-bottom:100px;"></div>
								
								
								
								</div><!-- / .widget-content -->				
							
							
							
							
							
							</div><!-- / .widget -->							
						</div><!-- / .span12 -->
						<div style="margin-top:300px;"></div>
					</div><!-- / .row -->
				</div><!-- / .container -->			
			</div><!-- / .main -->