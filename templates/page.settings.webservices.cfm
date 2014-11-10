


			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>	
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.webservices.webservices" method="getwebservices" returnvariable="webservices">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!-- // to edit a web service, get the webservice uuid from the query string --->
			<cfif ( structkeyexists( url, "fuseaction" ) and url.fuseaction eq "editwebservice" ) and ( structkeyexists( url, "wsid" ) and isvalid( "uuid", url.wsid ))>		
				<cfparam name="wsid" default="#url.wsid#">
				<cfset wsid = url.wsid />					
					<cfinvoke component="apis.com.webservices.webservices" method="getwebservice" returnvariable="webservicedetail">
						<cfinvokeargument name="wsid" value="#wsid#">
					</cfinvoke>
			
			<!--- // execute a web service logout --->
			<cfelseif ( structkeyexists( url, "fuseaction" ) and url.fuseaction eq "dovancologout" ) and ( structkeyexists( url, "wsid" ) and isvalid( "uuid", url.wsid ))>
				
				<cfparam name="wsid" default="#url.wsid#">
				<cfset wsid = url.wsid />
				
					<cfquery datasource="#application.dsn#" name="getcompanywebservice">
						select webserviceid, webserviceclientid, webserviceisactive, webservicerequesttype
						  from webservice
						 where webserviceuuid = <cfqueryparam value="#wsid#" cfsqltype="cf_sql_varchar" maxlength="35" />						  
					</cfquery>
																			
															
					<cfquery datasource="#application.dsn#" name="updatewebservice">
						update webservice
						   set webserviceisactive = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						 where companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />								  
					</cfquery>
						
					<cflocation url="#application.root#?event=#url.event#&msg=logout&status=ok" addtoken="no">					
								
				
			
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			<div class="main">
			
				<div class="container">					
					
					<div class="row">
					
						<div class="span12">
						
							
							<!--- // show system alerts & messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">								
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-check"></i> WEB SERVICE SUCCESSFULLY ADDED!</h5>
									<p>A new system web service was added...  </p>
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "logout">								
								<div class="alert alert-success">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<p><i style="font-weight:bold;" class="icon-check"></i> Vanco Logout Successful!</p>									
								</div>	
							</cfif>						
						
							<div class="widget stacked">
							
								<!--- // form processing --->
									<cfif isdefined( "form.fieldnames" )>
										<cfscript>
											objValidation = createobject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset ws = structnew() />
											<cfset ws.companyid = form.companyid />
											<cfset ws.requesttype = trim( form.requesttype ) />											
											<cfset ws.providername = trim( form.providername ) />
											<cfset ws.posturl = trim( form.posturl ) />
											<cfset ws.clientid = trim( form.clientid ) />
											<cfset ws.loginuserid = trim( form.loginuserid ) />
											<cfset ws.loginpass = trim( form.loginpass ) />
											<cfset ws.encryptkey = trim( form.encryptkey ) />
											<cfset ws.frameid = trim( form.frameid ) />
											
											<!--- // some other variables --->
											<cfset ws.today = #createodbcdatetime( now() )# />	
											<cfset ws.serviceuuid = #createuuid()# />									
																															
											<!--- // insert the new web service record and update the company settings --->
											<cfquery datasource="#application.dsn#" name="addwebservice">
												insert into webservice(webserviceuuid, companyid, webserviceprovidername, webservicerequesttype, webserviceposturl, webserviceloginuserid, webserviceloginpassword, webserviceclientid, webserviceframeid, webserviceapiencryptkey, webserviceisactive, webservicedatecreated)
													values(
															<cfqueryparam value="#ws.serviceuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															<cfqueryparam value="#ws.companyid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#ws.providername#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.requesttype#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.posturl#" cfsqltype="cf_sql_varchar" maxlength="100" />,															
															<cfqueryparam value="#ws.loginuserid#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.loginpass#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.clientid#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.frameid#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#ws.encryptkey#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="0" cfsqltype="cf_sql_bit" />,
															<cfqueryparam value="#ws.today#" cfsqltype="cf_sql_timestamp" />
														   );
											</cfquery>							
											
											<!--- // log the client activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#ws.today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# added a new web service for #ws.providername# for #compdetails.companyname#" cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																				
											
											<!--- // redirect to save message --->
											<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">						
											
											
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
									<!--- // end form processing --->
								
								
							
							
							
								
									<cfoutput>
								
								
										<div class="widget-header">
											<i class="icon-cogs"></i>
											<h3>System Settings for #compdetails.companyname#</h3>
										</div>
								
								
										<div class="widget-content">							
										
											<!--- // settings nav tabs --->
											<ul class="nav nav-tabs">
												<li><a href="#application.root#?event=page.settings">Company Summary</a></li>
												<li><a href="#application.root#?event=page.settings.api">API Key</a></li>
												<li><a href="#application.root#?event=page.settings.welcomemessage">Welcome Message</a></li>
												<li class="active"><a href="#application.root#?event=#url.event#">Webservices</a></li>										
												<li><a href="#application.root#?event=page.settings.docs">Source Documents</a></li>
												<li><a href="#application.root#?event=page.settings.other">Other Settings</a></li>																											
											</ul>							
																			
												
											<cfif not structkeyexists( url, "fuseaction" )>
												
												<a href="#application.root#?event=#url.event#&fuseaction=addwebservice" class="btn btn-small btn-inverse" style="margin-left:20px;margin-bottom:10px;"><i class="icon-plus"></i> Add Web Service</a>
												
												<cfif webservices.recordcount gt 0>
													<!--- // draw table for webservices data grid --->
													<table class="table table-bordered table-striped table-highlight">
														<thead>
															<tr>
																<th width="10%">Actions</th>
																<th>Provider</th>
																<th>Request Type</th>
																<th>Login User</th>
																<th>Client ID</th>
																<th>Last Login Date</th>
																<th>Status</th>
															</tr>
														</thead>
														<tbody>														
															<cfloop query="webservices">
																<tr>
																	<td class="actions">																
																		<a href="javascript:void(0);" class="btn btn-mini btn-warning">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>
																		<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin"  )>
																			<cfif ( trim( webserviceprovidername ) eq "vanco" ) and ( trim( webservicerequesttype ) eq "login" )>
																				<cfif webserviceisactive neq 1>
																					<a title="Vanco Login" href="#application.root#?event=page.vanco.weblogin" class="btn btn-mini btn-secondary" onclick="javascript:confirm('Are you sure you want to login to Vanco Web Services?');">
																						<i class="btn-icon-only icon-key"></i>										
																					</a>
																				<cfelse>
																					<a title="Vanco Log Out" href="#application.root#?event=#url.event#&fuseaction=dovancologout&wsid=#webserviceuuid#" class="btn btn-mini btn-secondary" onclick="javascript:confirm('Are you sure you want to log out of Vanco Web Services?');">
																						<i class="btn-icon-only icon-off"></i>										
																					</a>
																				</cfif>
																			</cfif>
																		
																		</cfif>
																	</td>												
																	<td>#webserviceprovidername#</td>
																	<td>#webservicerequesttype#</td>
																	<td>#webserviceloginuserid#</td>
																	<td>#webserviceclientid#</td>
																	<td><cfif webservicelastlogindatetime is not "">#dateformat( webservicelastlogindatetime, "mm/dd/yyyy" )# - #timeformat( webservicelastlogindatetime, "hh:mm:ss tt" )#<cfelse>Undefined</cfif></td>
																	<td><cfif webserviceisactive eq 1><span class="label label-success">Active</span><cfelse><span class="label label-default">Inactive</span></cfif></td>
																</tr>
															</cfloop>											
														</tbody>
													</table>
													<div style="margin-top:100px;"></div>
												<cfelse>
													<div style="margin-top:20px;"></div>
													<div class="alert alert-info">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
														<h5><i style="font-weight:bold;" class="icon-check"></i> No Web Services Registered!</h5>
														<p>Please use the button above to add a new web service. </p>
													</div>
												
												</cfif>		
											<cfelseif structkeyexists( url, "fuseaction" ) and url.fuseaction is "addwebservice">			
												
												<br />
												
												<h5 style="margin-left:-10px;"><i class="icon-cogs"></i> Add New Web Service</h5>
												
												<hr size="1" style="margin-top:5px;margin-bottom:5px;color:##f2f2f2;">
												
												<br />
												
												<form id="create-webservices-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#">
																					
													<fieldset>											
							
														<div class="control-group">											
															<label class="control-label" for="providername">Provider Name</label>
																<div class="controls">
																	<input type="text" class="input-large" name="providername" id="providername" value="<cfif isdefined( "form.providername" )>#form.providername#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="requesttype">Request Type</label>
																<div class="controls">
																	<select name="requesttype" id="requesttype" class="input-large">
																		<option value="login">Login</option>
																		<option value="efttransparentredirect">EFT Transparent Redirect</option>																	
																		<option value="eftaddcompletetransaction">EFT Add Complete Transaction</option>
																	</select>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="posturl">Post URL</label>
																<div class="controls">
																	<input type="text" class="input-xxlarge" name="posturl" id="posturl" value="<cfif isdefined( "form.posturl" )>#form.posturl#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="loginuserid">Login Username</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="loginuserid" id="loginuserid" value="<cfif isdefined( "form.loginuserid" )>#form.loginuserid#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="loginpass">Login Password</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="loginpass" id="loginpass" value="<cfif isdefined( "form.loginpass" )>#form.loginpass#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="clientid">Service Client ID</label>
																<div class="controls">
																	<input type="text" class="input-small" name="clientid" id="clientid" value="<cfif isdefined( "form.clientid" )>#form.clientid#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="frameid">Frame ID</label>
																<div class="controls">
																	<input type="text" class="input-small" name="frameid" id="frameid" value="<cfif isdefined( "form.frameid" )>#form.frameid#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="encryptkey">Encryption Key</label>
																<div class="controls">
																	<input type="text" class="input-xlarge" name="encryptkey" id="encryptkey" value="<cfif isdefined( "form.encryptkey" )>#form.encryptkey#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->								
																
														<br />
														
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savewebservice"><i class="icon-save"></i> Save Web Service</button>																
															<a href="#application.root#?event=page.settings.webservices" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
															<input name="utf8" type="hidden" value="&##955;">							
															<input type="hidden" name="companyid" value="#compdetails.companyid#" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="encryptkey|The web service encryption key is required to save the record.;clientid|The web service client ID is required.;loginuserid|The web service login user ID is required.;loginpass|The web service login password is required.;posturl|The web service post URL is required.;requesttype|The web service request type is required.;providername|The provider name is required." />
														</div> <!-- /form-actions -->
																						
													</fieldset>
															
												</form>
											
											
											<cfelseif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editwebservice">

												{{ this }}

											</cfif>								
										
										</div><!-- / .widget-content -->
									
									</cfoutput>	
								
								
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->
					<cfif webservices.recordcount lt 10>
						<div style="margin-top:250px;"></div>
					</cfif>
					
				</div><!-- / .container -->
			
			</div><!-- / .main -->
			
			
			
			