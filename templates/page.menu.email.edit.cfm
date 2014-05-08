

				<!--- get our message from the database --->
				<cfinvoke component="apis.com.messages.messagegateway" method="getmessage" returnvariable="msgdetail">
					<cfinvokeargument name="msgid" value="#url.msgid#">
				</cfinvoke>
				
				
				<!--- // email library --->					
				
				
				<!--- define our form variables --->
				<cfparam name="msgid" default="">
				<cfparam name="msgtype" default="">
				<cfparam name="msgname" default="">
				<cfparam name="msgtext" default="">							
				
				
				<!--- // edit email library message --->	
			
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-envelope"></i>							
									<h3>Edit Library Email Message</h3>						
								</div> <!-- /.widget-header -->
								
								<div class="widget-content">						
									
									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->
											<cfset msg = structnew() />
											<cfset msg.msgid = #form.msgid# />
											<cfset msg.msgtype = #form.msgtype# />
											<cfset msg.msgname= #form.msgname# />
											<cfset msg.msgtext = #form.msgtext# />											
																				
											<!--- // manipulate some strings for proper case --->											
											<cfset msg.msgtext = urlencodedformat(msg.msgtext) />											
											<cfset today = #CreateODBCDateTime(now())# />
										
											<cfquery datasource="#application.dsn#" name="addservicer">
												update dbo.messages												   
												   set  msgtype = <cfqueryparam value="#msg.msgtype#" cfsqltype="cf_sql_varchar" />,
														msgname = <cfqueryparam value="#msg.msgname#" cfsqltype="cf_sql_varchar" />,
														msgtext = <cfqueryparam value="#msg.msgtext#" cfsqltype="cf_sql_varchar" />														
												 where  msgid = <cfqueryparam value="#msg.msgid#" cfsqltype="cf_sql_integer" /> 		  
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# edited the library email message #msg.msgname# in the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>

											<cflocation url="#application.root#?event=page.menu.email&msg=saved" addtoken="no">
								
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#"</cfoutput></li>
														</cfloop>
													</ul>
											</div>
								
										</cfif>
									</cfif>
									
									<!--- // end form processing --->
									
									
									<div class="tab-pane active" id="newservicer">
										<cfoutput>	
										<form id="editemail-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&msgid=#msgdetail.msgid#">
											<fieldset>									
												<br />
												
												<div class="control-group">									
													<label class="control-label" for="msgtype">Message Type</label>
													<div class="controls">
														<select name="msgtype" id="msgtype">
															<option value="Enrollment"<cfif trim( msgdetail.msgtype ) is "enrollment">selected</cfif>>Enrollment</option>
															<option value="Implementation"<cfif trim( msgdetail.msgtype ) is "implementation">selected</cfif>>Implementation</option>
															<option value="General"<cfif trim( msgdetail.msgtype ) is "general">selected</cfif>>General</option>
															<option value="Loan Servicer"<cfif trim( msgdetail.msgtype ) is "loan servicer">selected</cfif>>Loan Servicer</option>
															<option value="Text"<cfif trim( msgdetail.msgtype ) is "text">selected</cfif>>Text Message</option>
														</select>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="msgname">Message Title</label>
													<div class="controls">
														<input type="text" class="input-medium span3" id="msgname" name="msgname" value="#msgdetail.msgname#">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="msgtext">Message Text</label>
													<div class="controls">
														<textarea name="msgtext" id="msgtext" class="input-large span8" rows="8">#urldecode(msgdetail.msgtext)#</textarea> 
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->												
																			
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="saveservicer"><i class="icon-save"></i> Save Email</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.email'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">
													<input name="msgid" id="msgid" type="hidden" value="#msgdetail.msgid#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="msgtype|'Email Message Type' is a required field.;msgname|'Email Message Title' is a required field.;msgtext|'Email Message Text' is a required field." />								
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->			
				
					
				
					<div style="height:100px;"></div>
				
				
				</div><!-- /container -->