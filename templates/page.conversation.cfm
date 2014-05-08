	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.convo.convogateway" method="getadvisors" returnvariable="advisorlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.convo.convogateway" method="getconvo" returnvariable="convolist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.convo.convogateway" method="getconvoclosed" returnvariable="convoclosedlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			
			<!--- // invoke compone to close the thread --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "closethread">
				<cfif structkeyexists( url, "thread" ) and isvalid( "uuid", url.thread )>
					<cfset thisthread = #trim( url.thread )# />
					<cfquery datasource="#application.dsn#" name="markthreadclosed">
						update conversation
						   set convoclosed = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
						       convostatus = <cfqueryparam value="Closed" cfsqltype="cf_sql_varchar" />
						 where convouuid = <cfqueryparam value="#thisthread#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
					<cflocation url="#application.root#?event=page.conversation&msg=thread.closed" addtoken="no">
				</cfif>
			</cfif>	
			
			
			<!--- // include the tinymce js path --->
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>	
			
			<!--- // initialize tinymce for the rich text editor --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "cd1",
					width: 840,
					height: 400
				 });
			</script>
			
			
			
			<cfparam name="today" default="">
			<cfparam name="threadwriter" default="">
			<cfset today = createodbcdatetime( now() ) />
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "posted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  Your conversation reply was posted and the Advisor notified by email.  Please check back shortly for a response...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "replyposted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-comments-alt"></i> REPLY SUCCESS!</strong>  Your reply posted successfully...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "thread.closed">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>THREAD CLOSED!</strong>  The conversation thread was closed...
										</div>										
									</div>								
								</div>
							</cfif>	
						
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-comments"></i>							
										<h3>Ask Us A Question</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define and set form values--->											
											<cfset convo = structnew() />
											<cfset convo.leadid = #form.leadid# />
											<cfset convo.cuuid = #createuuid()# />
											<cfset convo.convoid = #form.convoid# />											
											<cfset convo.note = #urlencodedformat( form.mytextarea )# />
											<cfset convo.today = #createodbcdatetime( now() )# />
											
											<cfif isdefined( "form.rgadvid" )>
												<cfset convo.advisorid = #form.rgadvid# />
											</cfif>
											
											<cfif isuserinrole( "bclient" )>
												<cfset convo.threadwriterid = #form.leadid# />
												<cfset convo.threadwriter = "#session.username#" />
											<cfelse>
												<cfset convo.threadwriterid = #session.userid# />
												<cfset convo.threadwriter = "#session.username#" />
											</cfif>
											
											<cfif structkeyexists( form, "convoid" )>
											
												<cfif form.convoid eq 0>
											
													<cfquery datasource="#application.dsn#" name="createconvo">
														insert into conversation(convouuid, userid, advisorid, convodatetime, convostatus, convoclosed)
															values(
																   <cfqueryparam value="#convo.cuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																   <cfqueryparam value="#convo.leadid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#convo.advisorid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#convo.today#" cfsqltype="cf_sql_timestamp" />,
																   <cfqueryparam value="Open" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="0" cfsqltype="cf_sql_bit" />													
																   ); select @@identity as newconvo
													</cfquery>

													<cfquery datasource="#application.dsn#" name="addreply">
														insert into conversation_reply(convoid, userid, threadwriter, replytext, replydatetime)
															values(
																   <cfqueryparam value="#createconvo.newconvo#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#convo.threadwriterid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#convo.threadwriter#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#convo.note#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#convo.today#" cfsqltype="cf_sql_timestamp" />														   
																  ); select @@identity as newthreadid
													</cfquery>
													
													<!--- // log the user activity --->
													<cfquery datasource="#application.dsn#" name="logact">
														insert into activity(leadid, userid, activitydate, activitytype, activity)
															values (
																	<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="Record Created" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#session.username# added a new question in the Ask Us section." cfsqltype="cf_sql_varchar" />
																	);
													</cfquery>	

													<cfinvoke component="apis.com.convo.convogateway" method="sendemailnotification" returnvariable="msgstatus">
														<cfinvokeargument name="convoid" value="#createconvo.newconvo#">
														<cfinvokeargument name="thisthreadid" value="#addreply.newthreadid#">
													</cfinvoke>
														
											
													<cflocation url="#application.root#?event=page.conversation&msg=posted" addtoken="no">
												
												
												<cfelse>											
													
													<cfquery datasource="#application.dsn#" name="addreply">
														insert into conversation_reply(convoid, userid, threadwriter, replytext, replydatetime)
															values(
																   <cfqueryparam value="#convo.convoid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#convo.threadwriterid#" cfsqltype="cf_sql_integer" />,																  
																   <cfqueryparam value="#convo.threadwriter#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#convo.note#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#convo.today#" cfsqltype="cf_sql_timestamp" />														   
																  ); select @@identity as newthreadid
													</cfquery>
													
													<!--- // log the user activity --->
													<cfquery datasource="#application.dsn#" name="logact">
														insert into activity(leadid, userid, activitydate, activitytype, activity)
															values (
																	<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#convo.threadwriterid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="Record Created" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="The user replied to a thread in the Ask Us section." cfsqltype="cf_sql_varchar" />
																	);
													</cfquery>
													
													
													<cfinvoke component="apis.com.convo.convogateway" method="sendemailnotification" returnvariable="msgstatus">
														<cfinvokeargument name="convoid" value="#convo.convoid#">
														<cfinvokeargument name="thisthreadid" value="#addreply.newthreadid#">
													</cfinvoke>
													
												
													<cfif isuserinrole( "bclient" )>													
														<cflocation url="#application.root#?event=page.conversation&msg=replyposted" addtoken="no">
													<cfelse>
														<cfparam name="tempA" default="">
														<cfparam name="tempZ" default="">
														<cfset tempA = structdelete( session, "leadid") />
														<cfset tempZ = structdelete( session, "leadconv" ) />
														<cflocation url="#application.root#?event=page.message.center" addtoken="yes">
													</cfif>
												</cfif>
											</cfif>
								
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

									<div class="tab-content">
												
										<div class="tab-pane active" id="tab1">
											
											<cfif not structkeyexists( url, "fuseaction" ) and not structkeyexists( url, "thread" )>
													<cfoutput>											
														<a href="#application.root#?event=page.conversation&fuseaction=new" class="btn btn-default btn-small"><i class="icon-comments"></i> Ask A Question</a>
													</cfoutput>									
											
													<br /><br /><br />									
												
												<cfif convolist.recordcount gt 0>												
													<h4 style="margin-top:10px;margin-bottom:10px;"><i class="icon-comments-alt"></i> Your Open Conversations </h4>
														<table class="table table-bordered table-striped table-highlight">
															<thead>
																<tr>
																	<th width="15%">Actions</th>
																	<th>Advisor</th>
																	<th>Date/Time</th>
																	<th>Status</th>
																	<th>New Messages</th>
																</tr>
															</thead>
															<tbody>
																<cfoutput query="convolist">
																	<tr>
																		<td class="actions">																			
																			<a href="#application.root#?event=#url.event#&fuseaction=thread&thread=#convouuid#" class="btn btn-mini btn-warning" title="Read Thread">
																				<i class="btn-icon-only icon-ok"></i>										
																			</a>
																			
																			<cfif convoclosed eq 0>
																				<a href="#application.root#?event=#url.event#&fuseaction=closethread&thread=#convouuid#" onclick="return confirm('Are you sure you want to close this thread?');" class="btn btn-mini btn-secondary" title="Close Thread">
																					<i class="btn-icon-only icon-remove-sign"></i>										
																				</a>																				
																			</cfif>
																		</td>																
																		<td>#advisorfirst# #advisorlast#</td>
																		<td>#dateformat( convodatetime, "mm/dd/yyyy" )# @ #timeformat( convodatetime, "hh:mm tt" )# </td>
																		<td><cfif convostatus is "open"><span style="padding:3px;" class="label label-success">Open</span><cfelse><span style="padding:3px;" class="label label-info">Closed</span></cfif></td>
																		<td><cfif totalnewmsgs eq 0><span style="padding:3px;" class="label label-success">#totalnewmsgs#</span><cfelse><span style="padding:3px;" class="label label-important">#totalnewmsgs#</span></cfif></td>
																	</tr>
																</cfoutput>												
															</tbody>
														</table>
													
														
												<!--- // show the closed conversation list --->
												<cfelseif convoclosedlist.recordcount gt 0>												
													<h4 style="margin-top:10px;margin-bottom:10px;"><i class="icon-comments"></i> Your Closed Conversations </h4>
															<table class="table table-bordered table-striped">
																<thead>
																	<tr>
																		<th width="15%">Actions</th>
																		<th>Advisor</th>
																		<th>Date/Time</th>
																		<th>Status</th>																		
																	</tr>
																</thead>
																<tbody>
																	<cfoutput query="convoclosedlist">
																		<tr>
																			<td class="actions">																			
																				<a href="#application.root#?event=#url.event#&fuseaction=thread&thread=#convouuid#" class="btn btn-mini btn-warning" title="Read Thread">
																					<i class="btn-icon-only icon-ok"></i>										
																				</a>																		
																			</td>																
																			<td>#advisorfirst# #advisorlast#</td>
																			<td>#dateformat( convodatetime, "mm/dd/yyyy" )# @ #timeformat( convodatetime, "hh:mm tt" )# </td>
																			<td><cfif convostatus is "open"><span style="padding:3px;" class="label label-success">Open</span><cfelse><span style="padding:3px;" class="label label-info">Closed</span></cfif></td>																			
																		</tr>
																	</cfoutput>												
																</tbody>
															</table>
													
												
												
												<cfelseif convolist.recordcount eq 0 and convoclosedlist.recordcount eq 0>
													
														<div class="alert alert-info">
															<button type="button" class="close" data-dismiss="alert">&times;</button>
															<strong>NO CONVERSATIONS FOUND</strong>  You don't have any open conversations.  Use the <strong>Ask Us</strong> button above to get started...
														</div>
													
												</cfif>
												
											<cfelse>
													
													<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "new">
														<h4><i class="icon-comments-alt"></i> Ask Us a Question</h4>
														<h6><small>Enter the details of your question below.  Please be as descriptive as possible.</small></h5>
															<cfoutput>
																
																
																
																<!-- Place this in the body of the page content -->
																<form name="mytextareaform" action="#application.root#?event=#url.event#&fuseaction=new" method="post">
																	
																	<textarea name="mytextarea" id="cd1"></textarea>										
																
																	<br />


																	<div class="control-group">
																		<label class="control-label" for="rgadvid"><strong>Your Advisors</strong></label>
																			<div class="controls">
																				<cfloop query="advisorlist">
																					<label class="radio">
																						<input type="radio" name="rgadvid" value="#userid#">
																							#firstname# #lastname#
																						</label>
																				</cfloop>
																			</div>
																	</div>
																	
																	<br />
																	
																	<div class="form-actions">											
																		<button type="submit" class="btn btn-secondary" name="askusnow"><i class="icon-save"></i> Post Your Question</button>
																		<a href="#cgi.http_referer#" class="btn btn-primary"><i class="icon-repeat"></i> Cancel</a>
																		<input name="utf8" type="hidden" value="&##955;">
																		<input type="hidden" name="convoid" value="0" />																		
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																		
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input type="hidden" name="validate_require" value="leadid|The form is missing required data in order to post this data.  Please go back and try again...;rgadvid|Please select one of your advisors to whom to post this question." />
																	</div>
																	
																	
																
																</form>
															</cfoutput>													
													
													<cfelseif structkeyexists( url, "thread" ) and ( structkeyexists( url, "thread" ) and isvalid( "uuid", url.thread ))>													
														
														<cfinvoke component="apis.com.convo.convogateway" method="getconvothread" returnvariable="convothread">
															<cfinvokeargument name="thread" value="#url.thread#">
														</cfinvoke>
														
														<cfinvoke component="apis.com.convo.convogateway" method="markreplyread" returnvariable="convothreadid">
															<cfinvokeargument name="thread" value="#url.thread#">
															<cfinvokeargument name="userid" value="#session.userid#">
														</cfinvoke>
														
															<cfoutput>																
																<a href="<cfif isuserinrole( "bclient" )>#application.root#?event=page.conversation<cfelse>#application.root#?event=page.message.center</cfif>" class="btn btn-primary btn-mini pull-right" style="margin-top:-15px;margin-left:5px;"><i class="icon-circle-arrow-left"></i> Message Center</a><cfif convothread.recordcount gt 0><a href="#application.root#?event=page.conversation&fuseaction=closethread&thread=#url.thread#" onclick="return confirm('Are you sure you want to mute this conversation?');" class="btn btn-default btn-mini pull-right" style="margin-top:-15px;margin-left:5px;"><i class="icon-comments"></i> Mute Conversation</a></cfif>
															</cfoutput>
															
															<cfoutput query="convothread">																
																<blockquote style="margin-top:20px;margin-bottom:35px;">
																	#urldecode( replytext )# <br />
																	<small>#threadwriter# on #dateformat( replydatetime, "full" )# @ #timeformat( replydatetime, "hh:mm:ss tt" )#</small>
																</blockquote>															
															</cfoutput>
															
															
															
															<br /><br /><br />
															
																<cfif convothread.convoclosed eq 0>
																	<cfoutput>													
																	
																		<!-- Place this in the body of the page content -->
																		<form name="mytextareaform" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&thread=#url.thread#" method="post">
																			
																			<textarea name="mytextarea" id="cd1"></textarea>														
																			
																			<br />
																			
																			<div class="form-actions">											
																				<button type="submit" class="btn btn-secondary" name="askusnow"><i class="icon-save"></i> Post Your Reply</button>
																				<a href="#cgi.http_referer#" class="btn btn-primary"><i class="icon-repeat"></i> Cancel</a>
																				<input name="utf8" type="hidden" value="&##955;">													
																				<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																				<input type="hidden" name="convoid" value="#convothread.convoid#" />
																				<input type="hidden" name="conuuid" value="#convothread.convouuid#" />																			
																				<input type="hidden" name="__authToken" value="#randout#" />
																				<input type="hidden" name="validate_require" value="leadid|The form is missing required data in order to post this data.  Please go back and try again...;convoid|The form has an internal error and required data is not present.  Please go back and try again..." />
																			</div>
																			
																			
																		
																		</form>
																	
																	
																	</cfoutput>			
																
																
																<cfelse>
																
																
																	<span style="padding:5px;" class="label label-important">Conversation Closed</span>
																	
																
																</cfif>
														
													
													</cfif>
													
											</cfif>
													
										</div> <!-- / .tab1 -->										 
											
									</div> <!-- / .tab-content -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:335px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		