
			
			
			
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.messages.messagegateway" method="getmessages" returnvariable="msglist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfif structkeyexists( form, "msglib" )>
				<cfinvoke component="apis.com.messages.messagegateway" method="getmessage" returnvariable="msgdetail">
					<cfinvokeargument name="msgid" value="#form.msglib#">
				</cfinvoke>			
			</cfif>
			
			<!--- // some form variables --->
			<cfparam name="today" default="">
			<cfparam name="emailmsg" default="">
			


			<!--- // send a client a text message --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<cfif structkeyexists(url, "msg") and url.msg is "sent">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The email message was sent successfully...  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Send an Email to #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									<cfif structkeyexists( form, "sendleademail" )>	
										<cfif isDefined("form.fieldnames")>
											<cfscript>
												objValidation = createObject("component","apis.com.ui.validation").init();
												objValidation.setFields(form);
												objValidation.validate();
											</cfscript>

											<cfif objValidation.getErrorCount() is 0>			
												
												<cfset lead = structnew() />
												<cfset lead.leadid = #form.leadid# />
												<cfset lead.msgsubject = #form.msgsubject# />
												<cfset lead.msg = #form.emailmsg# />											
												<cfset lead.noteuuid = #createuuid()# />
												<cfset today = #CreateODBCDateTime(now())# />											
												
												<!--- // create the notes database record --->
												<cfquery datasource="#application.dsn#" name="addleadnote">
													insert into notes(leadid, noteuuid, userid, notedate, notetext, removed, systemnote)
														values (
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#lead.noteuuid#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="#lead.msg#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="0" cfsqltype="cf_sql_bit" />,
																<cfqueryparam value="1" cfsqltype="cf_sql_bit" />	
															   );
												</cfquery>

												<cfmail from="#GetAuthUser()#" to="#leaddetail.leademail#" subject="#lead.msgsubject#" replyto="#GetAuthUser()#">#lead.msg#</cfmail>
												
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# sent a system generated email message to the client." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																);
												</cfquery>											
												
												<cflocation url="#application.root#?event=#url.event#&msg=sent" addtoken="no">
									
											<!--- If the required data is missing - throw the validation error --->
											<cfelse>
											
												<div class="alert alert-error">
													<a class="close" data-dismiss="alert">&times;</a>
														<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
														<ul>
															<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
																<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#</cfoutput></li>
															</cfloop>
														</ul>
												</div>
									
											</cfif>
										</cfif>
									</cfif>	
									<!--- // end form processing --->
												
									
									<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											
												<cfoutput>
												
													
													<h3><i class="icon-envelope"></i> Send Email Message <span class="pull-right"><a href="#application.root#?event=page.txtmsg" class="btn btn-small btn-secondary"><i class="icon-mobile-phone"></i> Send a Text Message</a></span></h3>
													
													<p>Please enter your message in the text field below or select an email message from the library...</p>
													
													<br>
													
													<form name="message-library-select" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
														<fieldset>
															<div class="control-group">											
																<label class="control-label" for="msglib">Message Library</label>
																<div class="controls">
																	<select name="msglib" id="msglib" class="input-large" onchange="this.form.submit();">
																		<option value="" selected>Select Library Message</option>
																		<cfloop query="msglist">
																			<option value="#msgid#"<cfif isdefined( "form.msglib" ) and form.msglib eq msglist.msgid>selected</cfif>>#msgname#</option>
																		</cfloop>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
														</fieldset>
													</form>
													
													<form id="send-text-message" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
														<fieldset>																					
															
															<div style="padding-left:50px;">
																<div class="well">																
																	<h5>Sender: #session.username#  (#GetAuthUser()#)</h5>
																	<h5>Recipient: #leaddetail.leadfirst# #leaddetail.leadlast#</h5>
																	<h5>Email Address: #leaddetail.leademail#</h5>
																</div>
															</div>
															
															<div style="margin-top:25px;"></div>														
															
															<div class="control-group">											
																<label class="control-label" for="msgsubject">Message Subject</label>
																<div class="controls">
																	<input type="text" name="msgsubject" class="input-large" <cfif isdefined( "form.msgsubject" )>value="#form.msgsubject#"<cfelseif isdefined( "form.msglib" )>value="#msgdetail.msgname#"</cfif> />																
																</div> <!-- /controls -->																
															</div> <!-- /control-group -->	
															
															<div class="control-group">											
																<label class="control-label" for="emailmsg">Message Content</label>
																<div class="controls">
																	<textarea name="emailmsg" class="span6" rows="6"><cfif isdefined( "form.emailmsg" )>#form.emailmsg#<cfelseif isdefined( "form.msglib" )>#urldecode( msgdetail.msgtext )#</cfif></textarea>																	
																	<p class="help-block"><i>Email messages are automatically saved to the client notes section.</i></p>
																</div> <!-- /controls -->																
															</div> <!-- /control-group -->	
															
															<div style="margin-top:50px;"></div>
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="sendleademail"><i class="icon-envelope"></i> Send Message</button>																
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">						
																<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;emailmsg|Please enter your message content before sending the message...;msgsubject|Please enter an email subject for this message." />									
															</div>
														</fieldset>
													</form>
																	
																				 
												</cfoutput>
											
										</div><!-- /.span8 -->
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:75px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->