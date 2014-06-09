

			
			
			<!--- // get our data access components --->			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!--- // swap client status --->
			<cfif structkeyexists( url, "fuseaction" )>
				<cfparam name="newstatus" default="">
				<cfparam name="leadid" default="">
				<cfset leadid = #session.leadid# />
				
				<cfif trim( url.fuseaction ) is "swapstatus">
					<cfquery datasource="#application.dsn#" name="getstatus">
						select l.leadid, l.leadactive
						  from leads l
						 where l.leadid = <cfqueryparam value="#leadid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					<cfif getstatus.leadactive eq 1>
						<cfset newstatus = 0 />
					<cfelse>
						<cfset newstatus = 1 />
					</cfif>
					
					<cfquery datasource="#application.dsn#" name="changestatus">
						update leads 
						   set leadactive = <cfqueryparam value="#newstatus#" cfsqltype="cf_sql_bit" /> 
						 where leadid = <cfqueryparam value="#getstatus.leadid#" cfsqltype="cf_sql_integer" />
					</cfquery>		
					
					<cflocation url="#application.root#?event=#url.event#&msg=status.updated" addtoken="yes" />
				</cfif>
			</cfif>


			<!--- define form vars --->
			<cfparam name="firstname" default="">
			<cfparam name="lastname" default="">
			<cfparam name="leadsource" default="">
			<cfparam name="streetaddress" default="">
			<cfparam name="address2" default="">
			<cfparam name="city" default="">
			<cfparam name="state" default="">
			<cfparam name="zipcode" default="">
			<cfparam name="phonetype" default="">
			<cfparam name="phone" default="">
			<cfparam name="altphonetype" default="">
			<cfparam name="altphone" default="">
			<cfparam name="email" default="">
			<cfparam name="username" default="">
			<cfparam name="password" default="">
			<cfparam name="provider" default="">
			<cfparam name="dobmonth" default="">
			<cfparam name="dobday" default="">
			<cfparam name="dobyear" default="">
			
			
			<!--- lead summary page --->	
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- // system messages --->
							
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The inquiry details were successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "status.updated">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The status was successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
								
							</cfif>	
							<cfif isdefined( "taskmsg" )>						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-notice">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>TASK SUCCESS!</strong>  <cfoutput>#taskmsg#</cfoutput>
										</div>										
									</div>								
								</div>							
							</cfif>	
							
							
							<!--- start page content + details and draw form --->
							
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-ok"></i>							
									<h3>Inquiry Summary for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>					
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
											
											<!--- define our structure and set form values--->
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											
											<!--- // 2-19-2014 // hide the lead source form element from the bclient user role --->											
											<cfif isdefined( "form.leadsource" )>
												<cfset lead.source = #form.leadsource# />
											<cfelse>
												<cfquery datasource="#application.dsn#" name="getls">
													select leadsourceid
													  from leads
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfset lead.source = #getls.leadsourceid# />
											</cfif>

											<cfset lead.first = #form.firstname# />
											<cfset lead.last = #form.lastname# />
											<cfset lead.add1 = #form.streetaddress# />
											<cfset lead.add2 = #form.address2# />
											<cfset lead.city = #form.city# />
											<cfset lead.state = #ucase(left(form.state, 2))# />
											<cfset lead.zip = #left(form.zipcode,5)# />
											<cfset lead.phonetype = #form.phonetype# />
											<cfset lead.phone = #trim( left( form.phone,12 ))# />
											<cfset lead.altphonetype = #form.altphonetype# />
											<cfset lead.altphone = #trim( form.altphone )# />
											<cfset lead.email = #form.email# />
											<cfset lead.company = #session.companyid# />
											<cfset lead.userid = #session.userid# />
											
											<cfif isdefined("form.provider") and form.provider is not "">
												<cfset lead.provider = #form.provider# />
											<cfelse>
												<cfset lead.provider = "None" />
											</cfif>
											
											<!--- // 12-13-2013 // add lead date of birth --->
											<cfset lead.leaddobmonth = #form.dobmonth# />
											<cfset lead.leaddobday = #form.dobday# />
											<cfset lead.leaddobyear = #form.dobyear# />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<!--- // manipulate some strings for proper case --->
											<cfset lead.first = rereplace( lead.first , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
											<cfset lead.last = rereplace( lead.last , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
											<cfset lead.phone = rereplace( lead.phone, "[-]", "", "all" ) />
											<cfset lead.altphone = rereplace( lead.altphone, "[-]", "", "all" ) />
											
											<cfquery datasource="#application.dsn#" name="saveleaddetails">
													update leads
													   set leadsourceid = <cfqueryparam value="#lead.source#" cfsqltype="cf_sql_integer" />,
														   leadfirst = <cfqueryparam value="#lead.first#" cfsqltype="cf_sql_varchar" />,
														   leadlast = <cfqueryparam value="#lead.last#" cfsqltype="cf_sql_varchar" />,
														   leadadd1 = <cfqueryparam value="#lead.add1#" cfsqltype="cf_sql_varchar" />,
														   leadadd2 = <cfqueryparam value="#lead.add2#" cfsqltype="cf_sql_varchar" />,
														   leadcity = <cfqueryparam value="#lead.city#" cfsqltype="cf_sql_varchar" />,
														   leadstate = <cfqueryparam value="#lead.state#" cfsqltype="cf_sql_varchar" />,
														   leadzip = <cfqueryparam value="#lead.zip#" cfsqltype="cf_sql_varchar" />,
														   leadphonetype = <cfqueryparam value="#lead.phonetype#" cfsqltype="cf_sql_varchar" />,
														   leadphonenumber = <cfqueryparam value="#lead.phone#" cfsqltype="cf_sql_varchar"/>,
														   leademail = <cfqueryparam value="#lead.email#" cfsqltype="cf_sql_varchar" />,
														   leadphonetype2 = <cfqueryparam value="#lead.altphonetype#" cfsqltype="cf_sql_varchar" />,
														   leadphonenumber2 = <cfqueryparam value="#lead.altphone#" cfsqltype="cf_sql_varchar" />,
														   leadmobileprovider = <cfqueryparam value="#lead.provider#" cfsqltype="cf_sql_varchar" />,
														   leaddobmonth = <cfqueryparam value="#lead.leaddobmonth#" cfsqltype="cf_sql_numeric" />,
														   leaddobday = <cfqueryparam value="#lead.leaddobday#" cfsqltype="cf_sql_numeric" />,
														   leaddobyear = <cfqueryparam value="#lead.leaddobyear#" cfsqltype="cf_sql_numeric" />
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
												<cfinvokeargument name="leadid" value="#session.leadid#">
												<cfinvokeargument name="taskref" value="coninfo">
											</cfinvoke>
											
											<cfif isuserinrole( "bclient" )>
												<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
													<cfinvokeargument name="portaltaskid" value="1407">
													<cfinvokeargument name="leadid" value="#session.leadid#">
												</cfinvoke>
											</cfif>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated and saved the inquiry details for #lead.first# #lead.last#." cfsqltype="cf_sql_varchar" />
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
											
											<cfset broadcastmsg = "Success!  The lead summary details have been successfully updated..." />
											
											<cfif structkeyexists( form, "savelead" )>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											<cfelseif structkeyexists( form, "saveleadcontinue" )>
												<cfif not isuserinrole( "bclient" )>
													<cflocation url="#application.root#?event=page.enroll" addtoken="no">
												<cfelse>
													<cflocation url="#application.root#?event=page.budget" addtoken="no">
												</cfif>
											<cfelse>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
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

									
									
										<!--- // sidebar navigation --->									
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">			
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tabbable">
												<!---
												<cfif not isuserinrole( "bclient" )>
													<cfoutput>
													<ul class="nav nav-tabs">
														<li class="active">
															<a href="#application.root#?event=page.summary">Profile</a>
														</li>
														<li>
															<a href="#application.root#?event=page.lead.login">User Login</a>
														</li>														
														<li>
															<a href="#application.root#?event=page.banking">ACH Details</a>
														</li>
													</ul>
													</cfoutput>
												</cfif>												
												--->

												<div class="tab-content">					
													
													<div class="tab-pane active" id="tab1">
														<cfoutput>
														<h3><i class="icon-user"></i> Contact Information <span style="float:right;font-size:14px;">Entered On: #dateformat(leaddetail.leaddate, "mm/dd/yyyy")#</span></h3>										
														<p style="color:##ff0000;">* Denotes a required field  <cfif not isuserinrole( "bclient" )><span class="pull-right"><a href="#application.root#?event=#url.event#&fuseaction=swapstatus" onclick="return confirm('Are you sure you want to change this client\'s status?');" class="btn btn-small <cfif leaddetail.leadactive eq 1>btn-default"><i class="icon-remove-sign"></i> Inactivate File</a><cfelse>btn-success"><i class="icon-ok-sign"></i> Activate File</a></cfif></span></cfif></p>
														<br>
														
														<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
															<fieldset>
																<cfif not isuserinrole( "bclient" )>
																	<div class="control-group">											
																		<label class="control-label" for="leadsource">Inquiry Source <span style="color:##ff0000;">*</span></label>
																		<div class="controls">
																			<select name="leadsource" id="leadsource">
																			<cfloop query="leadsources">
																				<option value="#leadsourceid#"<cfif leaddetail.leadsourceid eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
																			</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->														
																</cfif>

																<div class="control-group">											
																	<label class="control-label" for="firstname">First Name <span style="color:##ff0000;">*</span></label>
																	<div class="controls">
																		<input type="text" class="input-large" name="firstname" id="firstname" value="<cfif isdefined( "form.firstname" )>#trim( form.firstname )#<cfelse>#leaddetail.leadfirst#</cfif>">
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																
																<div class="control-group">											
																	<label class="control-label" for="lastname">Last Name <span style="color:##ff0000;">*</span></label>
																	<div class="controls">
																		<input type="text" class="input-large" name="lastname" id="lastname" value="<cfif isdefined( "form.lastname" )>#trim( form.lastname )#<cfelse>#leaddetail.leadlast#</cfif>">
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="lastname">Address <span style="color:##ff0000;">*</span></label>
																	<div class="controls">
																		<input type="text" class="input-large" name="streetaddress" id="streetaddress" value="<cfif isdefined( "form.streetaddress" )>#trim( form.streetaddress )#<cfelse>#leaddetail.leadadd1#</cfif>">																	
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="lastname">Address 2</label>
																	<div class="controls">
																		<input type="text" class="input-medium" name="address2" id="address2" value="<cfif isdefined( "form.address2" )>#trim( form.address2 )#<cfelse>#leaddetail.leadadd2#</cfif>">
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="lastname">City, State, Zip <span style="color:##ff0000;">*</span></label>
																	<div class="controls">																	
																		<input type="text" class="input-medium" name="city" id="city" value="<cfif isdefined( "form.city" )>#trim( form.city )#<cfelse>#leaddetail.leadcity#</cfif>">
																		<input type="text" class="input-small span1" name="state" id="state" value="<cfif isdefined( "form.state" )>#trim( form.state )#<cfelse>#leaddetail.leadstate#</cfif>">&nbsp;&nbsp;
																		<input type="text" class="input-small span1" name="zipcode" id="zipcode" value="<cfif isdefined( "form.zipcode" )>#trim( form.zipcode )#<cfelse>#leaddetail.leadzip#</cfif>">
																	</div> <!-- /controls -->			
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="email">Phone</label>
																	<div class="controls">
																		<select name="phonetype" id="phonetype" class="input-small">
																			<option value="Home"<cfif trim( leaddetail.leadphonetype ) is "home">selected</cfif>>Home</option>
																			<option value="Office"<cfif trim( leaddetail.leadphonetype ) is "office">selected</cfif>>Office</option>
																			<option value="Mobile"<cfif trim( leaddetail.leadphonetype ) is "mobile">selected</cfif>>Mobile</option>
																			<option value="Other"<cfif trim( leaddetail.leadphonetype ) is "other">selected</cfif>>Other</option>
																		</select>&nbsp;&nbsp;<input type="text" class="input-medium" name="phone" id="phone" value="<cfif isdefined( "form.phone" )>#trim( form.phone )#<cfelse>#leaddetail.leadphonenumber#</cfif>">
																		
																		<cfif trim( leaddetail.leadphonetype ) is "mobile">
																		<!--- // add mobile provider for text messaging --->
																		<select name="provider" id="provider" class="input-large">
																			<option value=""<cfif trim( leaddetail.leadmobileprovider ) is "">selected</cfif>>Select Mobile Provider</option>															  
																			<option value="@txt.att.net"<cfif trim( leaddetail.leadmobileprovider ) is "@txt.att.net">selected</cfif>>AT&amp;T</option>
																			<option value="@message.alltel.com"<cfif trim( leaddetail.leadmobileprovider ) is "@message.alltel.com">selected</cfif>>Alltel</option>
																			<option value="@myboostmobile.com"<cfif trim( leaddetail.leadmobileprovider ) is "@myboostmobile.com">selected</cfif>>Boost Mobile</option>
																			<option value="@mycellone.com"<cfif trim( leaddetail.leadmobileprovider ) is "@mycellone.com">selected</cfif>>Cellular South</option>
																			<option value="@cingularme.com"<cfif trim( leaddetail.leadmobileprovider ) is "@cingularme.com">selected</cfif>>Consumer Cellular</option>
																			<option value="@mymetropcs.com"<cfif trim( leaddetail.leadmobileprovider ) is "@mymetropcs.com">selected</cfif>>Metro PCS</option>
																			<option value="@messaging.nextel.com"<cfif trim( leaddetail.leadmobileprovider ) is "@messaging.nextel.com">selected</cfif>>Nextel</option>
																			<option value="@messaging.sprintpcs.com"<cfif trim( leaddetail.leadmobileprovider ) is "@messaging.sprintpcs.com">selected</cfif>>Sprint</option>
																			<option value="@gmomail.net"<cfif trim( leaddetail.leadmobileprovider ) is "@gmomail.net">selected</cfif>>T-Mobile</option>
																			<option value="@vtext.com"<cfif trim( leaddetail.leadmobileprovider ) is "@vtext.com">selected</cfif>>Verizon</option>
																			<option value="@vmobl.com"<cfif trim( leaddetail.leadmobileprovider ) is "@vmobl.com">selected</cfif>>Virgin Mobile</option>
																		</select>
																		</cfif>
																		<!--- // if the phone type is mobile and the mobile provider is not an empty string, show the send text button --->	
																		<cfif not isuserinrole( "bclient" ) and ( trim( leaddetail.leadphonetype ) is "mobile" and ( trim( leaddetail.leadmobileprovider ) is not "none" and trim( leaddetail.leadmobileprovider) is not "" ))><a href="#application.root#?event=page.txtmsg" class="btn btn-small" style="margin-left:5px;"><i class="icon-comment"></i> Send Text</a>
																		</cfif>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="altphone">Alt Phone</label>
																	<div class="controls">
																		<select name="altphonetype" id="altphonetype" class="input-small">
																			<option value="Home"<cfif trim(leaddetail.leadphonetype2) is "home">selected</cfif>>Home</option>
																			<option value="Office"<cfif trim(leaddetail.leadphonetype2) is "office">selected</cfif>>Office</option>
																			<option value="Mobile"<cfif trim(leaddetail.leadphonetype2) is "mobile">selected</cfif>>Mobile</option>
																			<option value="Other"<cfif trim(leaddetail.leadphonetype2) is "other">selected</cfif>>Other</option>
																		</select>&nbsp;&nbsp;<input type="text" class="input-medium" name="altphone" id="altphone" value="<cfif isdefined( "form.altphone" )>#trim( form.altphone )#<cfelse>#leaddetail.leadphonenumber2#</cfif>">
																		
																		<cfif trim( leaddetail.leadphonetype ) is not "mobile" and trim( leaddetail.leadphonetype2 ) is "mobile" >
																		<!--- // add mobile provider for text messaging --->
																		<select name="provider" id="provider" class="input-large">
																			<option value=""<cfif trim( leaddetail.leadmobileprovider ) is "">selected</cfif>>Select Mobile Provider</option>															  
																			<option value="@txt.att.net"<cfif trim( leaddetail.leadmobileprovider ) is "@txt.att.net">selected</cfif>>AT&amp;T</option>
																			<option value="@message.alltel.com"<cfif trim( leaddetail.leadmobileprovider ) is "@message.alltel.com">selected</cfif>>Alltel</option>
																			<option value="@myboostmobile.com"<cfif trim( leaddetail.leadmobileprovider ) is "@myboostmobile.com">selected</cfif>>Boost Mobile</option>
																			<option value="@mycellone.com"<cfif trim( leaddetail.leadmobileprovider ) is "@mycellone.com">selected</cfif>>Cellular South</option>
																			<option value="@cingularme.com"<cfif trim( leaddetail.leadmobileprovider ) is "@cingularme.com">selected</cfif>>Consumer Cellular</option>
																			<option value="@mymetropcs.com"<cfif trim( leaddetail.leadmobileprovider ) is "@mymetropcs.com">selected</cfif>>Metro PCS</option>
																			<option value="@messaging.nextel.com"<cfif trim( leaddetail.leadmobileprovider ) is "@messaging.nextel.com">selected</cfif>>Nextel</option>
																			<option value="@messaging.sprintpcs.com"<cfif trim( leaddetail.leadmobileprovider ) is "@messaging.sprintpcs.com">selected</cfif>>Sprint</option>
																			<option value="@gmomail.net"<cfif trim( leaddetail.leadmobileprovider ) is "@gmomail.net">selected</cfif>>T-Mobile</option>
																			<option value="@vtext.com"<cfif trim( leaddetail.leadmobileprovider ) is "@vtext.com">selected</cfif>>Verizon</option>
																			<option value="@vmobl.com"<cfif trim( leaddetail.leadmobileprovider ) is "@vmobl.com">selected</cfif>>Virgin Mobile</option>
																		</select>
																		</cfif>
																		
																		<cfif not isuserinrole( "bclient" ) and ( trim(leaddetail.leadphonetype2) is "mobile" and ( trim( leaddetail.leadmobileprovider ) is not "" and trim( leaddetail.leadmobileprovider ) is not "none" ))><a href="#application.root#?event=page.txtmsg" class="btn btn-small" style="margin-left:5px;"><i class="icon-comment"></i> Send Text</a></cfif>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																
																<div class="control-group">											
																	<label class="control-label" for="email">Email Address <span style="color:##ff0000;">*</span></label>
																	<div class="controls">
																		<input type="text" class="input-large" name="email" id="email" value="<cfif isdefined( "form.email" )>#trim( form.email )#<cfelse>#leaddetail.leademail#</cfif>">
																		<cfif isvalid( "email", leaddetail.leademail ) and not isuserinrole( "bclient" )><a href="#application.root#?event=page.email" class="btn btn-small" style="margin-left:5px;"><i class="icon-envelope"></i> Send Email</a></cfif>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<!--- // 12-13-2013 // add date of birth --->
																<div class="control-group">											
																	<label class="control-label" for="dobmonth">Date of Birth</label>
																	<div class="controls">
																		<select name="dobmonth" id="dobmonth" class="input-medium">
																			<cfloop from="1" to="12" index="month" step="1">
																				<option value="#month#"<cfif leaddetail.leaddobmonth eq month>selected</cfif>>#monthasstring(month)#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobday" id="dobday" class="input-small">
																			<cfloop from="1" to="31" index="j">
																				<option value="#j#"<cfif leaddetail.leaddobday eq j>selected</cfif>>#j#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobyear" id="doyear" class="input-small">
																			<cfloop from="2013" to="1920" index="q" step="-1">
																				<option value="#q#"<cfif leaddetail.leaddobyear eq q>selected</cfif>>#q#</option>																			
																			</cfloop>																	
																		</select>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																
																
																
																<br />											
																
																
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Contact Details</button>
																	<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Save Contact &amp; Continue</button>	
																	<cfif structkeyexists(session, "leadconv")>
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.clients'"><i class="icon-remove-sign"></i> Cancel</a>
																	<cfelse>
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.leads'"><i class="icon-remove-sign"></i> Cancel</a>
																	</cfif>
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;firstname|'Inquiry First Name' is a required field.;lastname|'Inquiry last Name' is a required field.;streetaddress|'Inquiry address' is required to save the record.;city|'Inquiry city of residence' is required to save this record.;state|'The inquiry state' is required to save the record.;zipcode|'The inquiry zip code' is a required field;email|'The inquiry email address' is a required field." />									
																	<input name="validate_email" type="hidden" value="email|'The E-mail Address' must be a valid e-mail address." />
																	<!---
																	<input name="validate_password" type="hidden" value="Password1|Password2|The passwords do not match.  Please check your input and re-enter..." />
																	--->
																</div> <!-- /form-actions -->
																
															</fieldset>
														</form>
														</cfoutput>				
													</div> <!-- /#tab1 -->										 
												
												</div> <!-- /.tab-content -->
											
											</div><!-- /.tabbale -->

										</div> <!-- /.span8 -->
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		