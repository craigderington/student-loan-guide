
				
				
				<!--- // include data access components --->
				<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
					<cfinvokeargument name="companyid" value="#session.companyid#">
				</cfinvoke>				
				
				<cfinvoke component="apis.com.leads.leadgateway" method="getmtasks" returnvariable="mtasklist">
					<cfinvokeargument name="companyid" value="#session.companyid#">
				</cfinvoke>
				
				<!--- // CLD 9-9-2014 // get some company settings --->
				<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
				</cfinvoke>
				
				
				
				<!--- define our form variables --->
				<cfparam name="lead" default="">
				<cfparam name="source" default="">
				<cfparam name="first" default="">
				<cfparam name="last" default="">
				<cfparam name="email" default="">
				<cfparam name="today" default="">
				<cfparam name="company" default="">
				<cfparam name="userid" default="">
				<cfparam name="phonenum" default="">
				<cfparam name="provider" default="">
				
				
				
				<!--- // create new lead inquiry --->	
			
				<div class="container">
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Create New Inquiry</h3>						
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
											<cfset lead = structnew() />
											<cfset lead.leaduniqid = #createuuid()# />
											<cfset lead.source = form.leadsource />
											<cfset lead.first = trim( form.firstname ) />
											<cfset lead.last = trim( form.lastname ) />
											<cfset lead.email = trim( form.email ) />
											<cfset lead.company = #session.companyid# />
											<cfset lead.userid = #session.userid# />
											<cfset lead.phonenum = trim( form.phone ) />
											<cfset lead.provider = #form.provider# />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<!--- // manipulate some strings for proper case --->
											<cfset lead.first = rereplace(lead.first , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
											<cfset lead.last = rereplace(lead.last , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
										
												<!--- // 12-03-2013 // let's check for duplicate data entries // do not allow duplicates --->
												<cfquery datasource="#application.dsn#" name="checkdupe">
													select l.leadid, l.leaduuid, l.leadlast, l.leadfirst
													  from leads l
													 where l.companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
													   and l.leadfirst = <cfqueryparam value="#lead.first#" cfsqltype="cf_sql_varchar" />
													   and l.leadlast = <cfqueryparam value="#lead.last#" cfsqltype="cf_sql_varchar" />
												</cfquery>

												<cfif checkdupe.recordcount eq 0>
													
													<cfquery datasource="#application.dsn#" name="createlead">
														insert into leads(leaduuid, companyid, userid, leadsourceid, leaddate, leadfirst, leadlast, leademail, leadphonetype, leadphonenumber, leadmobileprovider, leadactive, leadesign)
															values (
																	<cfqueryparam value="#lead.leaduniqid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																	<cfqueryparam value="#lead.company#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#lead.source#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																	<cfqueryparam value="#trim( lead.first )#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#trim( lead.last )#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#trim( lead.email )#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="Mobile" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#lead.phonenum#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#lead.provider#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																	<cfif companysettings.useportal eq 1> 
																	  <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																   <cfelse>
																      <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																   </cfif>
																   ); select @@identity as newleadid
													</cfquery>
													
													<!--- // create the lead summary --->
													<cfquery datasource="#application.dsn#" name="summary">
														insert into slsummary(leadid, slinquirydate, slreason, slbalance, slmonthly)
															values (
																	<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="Student Loan Help" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="0.00" cfsqltype="cf_sql_float" />,
																	<cfqueryparam value="0.00" cfsqltype="cf_sql_float" />														
																   ); 
													</cfquery>

													<!--- // create the client budget --->
													<cfquery datasource="#application.dsn#" name="budget">
														insert into budget(budgetuuid, leadid, payfreq)
															values (
																	<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																	<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,															
																	<cfqueryparam value="Bi-Weekly" cfsqltype="cf_sql_varchar" />																														
																   ); 
													</cfquery>
													
													<!--- // add client record to the esign table --->
													<cfquery datasource="#application.dsn#" name="esign1">
														insert into esign( esuuid, leadid, esdatestamp, escompleted )
															values(
																   <cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																   <cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																   <cfif companysettings.useportal eq 1> 
																	  <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																   <cfelse>
																      <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																   </cfif>
																   );
													</cfquery>
													
													<!--- // create the lead master task list --->
													<cfloop query="mtasklist">
														
														<cfparam name="taskuuid" default="">												
														<cfparam name="taskstatus" default="">
														<cfparam name="taskduedate" default="">
														<cfparam name="nextdate" default="">
														
														<cfset taskuuid = #createuuid()# />
														<cfset taskstatus = "Assigned" />												
														<cfset nextdate = DateAdd( "d", 2, today ) />
														
														<cfquery datasource="#application.dsn#" name="mtasks">
															insert into tasks(taskuuid, mtaskid, leadid, userid, taskstatus, taskduedate, tasklastupdated, tasklastupdatedby)
																values (
																		<cfqueryparam value="#taskuuid#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#mtasklist.mtaskid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#taskstatus#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#nextdate#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar" />														
																		);
														</cfquery>
														
													</cfloop>									
													
													<!--- // log the activity --->
													<cfquery datasource="#application.dsn#" name="logact">
														insert into activity(leadid, userid, activitydate, activitytype, activity)
															values (
																	<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																	<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#session.username# added a new lead to the system" cfsqltype="cf_sql_varchar" />
																	); select @@identity as newactid
													</cfquery>
													
													<!--- // create recent activity record --->
													<cfquery datasource="#application.dsn#" name="logrecent">
														insert into recent(userid, leadid, activityid, recentdate)
															values (
																	<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />
																	);
													</cfquery>
							
													<!--- redirect based on the button clicked in the actions --->
									
													<cfif isdefined( "form.saveleadcontinue" )>							
														
														<cfset session.leadid = #createlead.newleadid# />
														
														<cfoutput>
															<script>
																self.location="#application.root#?event=page.summary"
															</script>
														</cfoutput>
														
													<cfelseif isdefined( "form.savelead" )>
														
														<cfoutput>
															<script>
																self.location="#application.root#?event=page.leads"
															</script>
														</cfoutput>
														
													<cfelse>
									
														<cfoutput>
															<script>
																self.location="#application.root#?event=page.index"
															</script>
														</cfoutput>
										
													</cfif>					
												
												<!--- // if a duplicate record exists - show error and a link to select the exisitng record --->
												<cfelse>
													
													<!--- // throw an alert that a duplidate lead name was found --->
													<div class="alert alert-error">
														<a class="close" data-dismiss="alert">&times;</a>
														<h5><error>Oops, an existing database record was found with the same lead name you entered...</error></h5>
														<ul>														
															<li class="formerror"><cfoutput>#checkdupe.leadfirst# #checkdupe.leadlast# already exists in the database.  Select the existing record by <a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#checkdupe.leaduuid#"><strong>clicking here</strong></a>...</cfoutput></li>															
														</ul>
													</div>
													
												
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
									
									
									<div class="tab-pane active" id="newlead">
										<cfoutput>	
										<form id="newlead-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">
											<fieldset>												
													
												<div class="control-group" style="margin-top:10px;">											
													<label class="control-label" for="leadsource">Lead Source</label>
													<div class="controls">
														<select name="leadsource" id="leadsource">
															<option value="" selected>Select Lead Source</option>
															<cfloop query="leadsources">
																<option value="#leadsourceid#"<cfif isdefined( "form.leadsource" ) and form.leadsource eq leadsourceid>selected</cfif>>#leadsource#</option>
															</cfloop>
														</select>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												
												<div class="control-group">											
													<label class="control-label" for="firstname">First Name</label>
													<div class="controls">
														<input type="text" class="input-medium" id="firstname" name="firstname" <cfif isdefined( "form.firstname" )>value="#form.firstname#"</cfif>>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="lastname">Last Name</label>
													<div class="controls">
														<input type="text" class="input-medium" id="lastname" name="lastname" <cfif isdefined( "form.lastname" )>value="#form.lastname#"</cfif>>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="lastname">Mobile Phone</label>
													<div class="controls">
														<input type="text" class="input-medium" id="phone" name="phone" <cfif isdefined( "form.phone" )>value="#form.phone#"</cfif>>&nbsp;
														<select name="provider" id="provider" class="input-large">
																<option value="" selected>Select Mobile Provider</option>															  
																<option value="@txt.att.net">AT&amp;T</option>
																<option value="@message.alltel.com">Alltel</option>
																<option value="@myboostmobile.com">Boost Mobile</option>
																<option value="@mycellone.com">Cellular South</option>
																<option value="@cingularme.com">Consumer Cellular</option>
																<option value="@mymetropcs.com">Metro PCS</option>
																<option value="@messaging.nextel.com">Nextel</option>
																<option value="@messaging.sprintpcs.com">Sprint</option>
																<option value="@gmomail.net">T-Mobile</option>
																<option value="@vtext.com">Verizon</option>
																<option value="@vmobl.com">Virgin Mobile</option>
														</select>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="email">Email Address</label>
													<div class="controls">
														<input type="text" class="input-large" id="email" name="email" <cfif isdefined( "form.email" )>value="#form.email#"</cfif>>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->							
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Inquiry</button>
													<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Save Inquiry & Continue</button>													
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.leads'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="leadsource|'Please select a lead source from the list.;firstname|'Lead First Name' is a required field.;lastname|'Lead Last Name' is a required field.;email|'Lead Email' is a required field." />									
													<input name="validate_email" type="hidden" value="email|'Lead E-mail Address' must be a valid e-mail address." />
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->			
				
					
				
					<div style="height:200px;"></div>
				
				
				</div><!-- /container -->