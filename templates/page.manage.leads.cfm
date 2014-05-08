


			<!--- // protect the admin page --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="no">
			</cfif>

			
			<!--- // get lead sources for the filter --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">				
			</cfinvoke>

			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.admin.leadmanagementgateway" method="getleadlist" returnvariable="leadlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">	
			</cfinvoke>
			
			
			<!--- // process a request to delete the selected lead  --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletelead">
				<cfif structkeyexists( url, "leadid" ) and isvalid( "uuid", url.leadid )>
					<cfparam name="leadid" default="#url.leadid#">
					<cfset leadid = #url.leadid# />
						<cfinvoke component="apis.com.admin.leadmanagementgateway" method="killallleaddata" returnvariable="killstat">
							<cfinvokeargument name="leadid" value="#leadid#">
						</cfinvoke>
					
						<!---// if the purge variable returns tey, redirect, otherwise return false --->
						<cfif isdefined( "killstat" ) and killstat is "success">
							<cflocation url="#application.root#?event=#url.event#&msg=purgecomplete" addtoken="yes">
						<cfelseif isdefined( "killstat" ) and killstat is "killfail">
							<cflocation url="#application.root#?event=#url.event#&msg=purgefail" addtoken="yes">
						</cfif>
					
				</cfif>
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<!--- // page to manage all lead information --->
			<div class="main">
			
				<div class="container">
				
					<div class="row">		
						
						<div class="span12">					
							
							<!--- // show system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "purgecomplete" and structkeyexists( url, "cfid" )>
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-check"></i> DELETE SUCCESS! </h5>	
									<P>The lead was successfully purged from the system.  Please select another record to continue...</p>							
								</div>
							</cfif>
						
							<div class="widget stacked">
								
								<cfoutput>
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>Company Administration | Manage All Client Data <cfif structkeyexists( url, "fuseaction" )> | Modify Client Settings </cfif></h3>
									</div>
								</cfoutput>
								
								<div class="widget-content">
								
								<!--- // validate CFC Form Processing --->							
								<cfif not structkeyexists( form, "filtermyresults" )>	
									<cfif isdefined( "form.fieldnames" )>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields( form );
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />											
											<cfset lead.source = #form.leadsource# />
											<cfset lead.status = #form.leadstatus# />
											<cfset lead.first = trim( form.firstname ) />
											<cfset lead.last = trim( form.lastname ) />
											<cfset lead.add1 = trim( form.address1 ) />
											<cfset lead.add2 = trim( form.address2 ) />
											<cfset lead.city = trim( form.city ) />
											<cfset lead.state = ucase(left( form.state, 2 )) />
											<cfset lead.zip = left( form.zipcode,5 ) />					
											<cfset lead.email = trim( form.emailaddress ) />
											<cfset lead.enrollcounselor = #form.enrollmentcounselor# />
											
											<!--- get form checkbox data --->
											<cfif isdefined( "form.chkactive" )>
												<cfset lead.active = 1 />
											<cfelse>
												<cfset lead.active = 0 />
											</cfif>
											
											<cfif isdefined( "form.chkesign" )>
												<cfset lead.esign = 1 />
											<cfelse>
												<cfset lead.esign = 0 />
											</cfif>
											
											<cfif isdefined( "form.chkadvisory" )>
												<cfset lead.leadconv = 1 />
											<cfelse>
												<cfset lead.leadconv = 0 />
											</cfif>
											
											<cfif isdefined( "form.chkimpl" )>
												<cfset lead.leadimp = 1 />
											<cfelse>
												<cfset lead.leadimp = 0 />
											</cfif>
											
											<cfif isdefined( "form.chkwelcome" )>
												<cfset lead.welcomemsg = 1 />
											<cfelse>
												<cfset lead.welcomemsg = 0 />
											</cfif>							
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<!--- // manipulate some strings for proper case --->
											<cfset lead.first = rereplace( lead.first , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
											<cfset lead.last = rereplace( lead.last , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
											
											<cfquery datasource="#application.dsn#" name="saveleaddetails">
													update leads
													   set leadsourceid = <cfqueryparam value="#lead.source#" cfsqltype="cf_sql_integer" />,
														   leadstatusid = <cfqueryparam value="#lead.status#" cfsqltype="cf_sql_integer" />,
														   userid = <cfqueryparam value="#lead.enrollcounselor#" cfsqltype="cf_sql_integer" />,
														   leadfirst = <cfqueryparam value="#lead.first#" cfsqltype="cf_sql_varchar" />,														   
														   leadlast = <cfqueryparam value="#lead.last#" cfsqltype="cf_sql_varchar" />,
														   leadadd1 = <cfqueryparam value="#lead.add1#" cfsqltype="cf_sql_varchar" />,
														   leadadd2 = <cfqueryparam value="#lead.add2#" cfsqltype="cf_sql_varchar" />,
														   leadcity = <cfqueryparam value="#lead.city#" cfsqltype="cf_sql_varchar" />,
														   leadstate = <cfqueryparam value="#lead.state#" cfsqltype="cf_sql_varchar" />,
														   leadzip = <cfqueryparam value="#lead.zip#" cfsqltype="cf_sql_varchar" />,														   
														   leademail = <cfqueryparam value="#lead.email#" cfsqltype="cf_sql_varchar" />,
														   leadactive = <cfqueryparam value="#lead.active#" cfsqltype="cf_sql_bit" />,
														   leadconv = <cfqueryparam value="#lead.leadconv#" cfsqltype="cf_sql_bit" />,
														   leadesign = <cfqueryparam value="#lead.esign#" cfsqltype="cf_sql_bit" />,
														   leadimp = <cfqueryparam value="#lead.leadimp#" cfsqltype="cf_sql_bit" />,
														   leadwelcomehome = <cfqueryparam value="#lead.welcomemsg#" cfsqltype="cf_sql_bit" />
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
											</cfquery>										
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated and saved the client data for #lead.first# #lead.last#." cfsqltype="cf_sql_varchar" />
															); 
											</cfquery>									
											
											<!-- // show the save operation result --->
											<div class="alert alert-info">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><strong><i class="icon-check"></i> CLIENT DATA SAVED!</strong></h5>
													<p>The client data was updated successfully.   <a href="index.cfm?event=page.manage.leads">Click here to return to client list.</a></p>
											</div>	
											
								
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
								</cfif>
								<!--- // end form processing --->			
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									<cfif not structkeyexists( url, "fuseaction" )>
									
									
											<!--- // filter lead list data set --->								
											<cfoutput>
												<div class="well">
													<p><i class="icon-check"></i> Filter Your Results</p>
													<form class="form-inline" name="filterresults" method="post">													
														<select name="leadsource" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
															<option value="">Filter Lead Source</option>
																<cfloop query="leadsources">
																	<option value="#leadsourceid#"<cfif isdefined( "form.leadsource" ) and form.leadsource eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
																</cfloop>												
														</select>									
														<input type="text" name="leadname" onchange="javascript:this.form.submit();" style="margin-left:5px;" class="input-large" placeholder="Filter By Name" value="<cfif isdefined( "form.leadname" )>#trim( form.leadname )#</cfif>" /> 
														<input type="text" name="leaddate" style="margin-left:5px;" class="input-medium" placeholder="Filter by Date" id="datepicker-inline4" value="<cfif isdefined( "form.leaddate" )>#dateformat( form.leaddate, 'mm/dd/yyyy' )#</cfif>">		
														<input type="hidden" name="filtermyresults">
														<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
														<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
													</form>
												</div>
											</cfoutput>
											<!--- // end filter --->							
									
											
											<!--- // show default data grid --->
											<cfif leadlist.recordcount gt 0>

												<!--- activity log pagination --->
												<cfparam name="startrow" default="1">
												<cfparam name="displayrows" default="50">
												<cfparam name="torow" default="0">												
												
												<cfset torow = startrow + ( displayrows - 1 ) />
												<cfif torow gt leadlist.recordcount>
													<cfset torow = leadlist.recordcount />
												</cfif>												
												
												<cfset next = startrow + displayrows>
												<cfset prev = startrow - displayrows>
												
												<cfoutput>
													<h5><i style="margin-right:5px;" class="icon-th-large"></i> Found #leadlist.recordcount# records found | Displaying #startrow# to #torow#      <span class="pull-right"><a style="margin-bottom:5px;" href="#application.root#?event=page.admin" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a> <cfif prev gte 1><a style="margin-left:5px;margin-bottom:5px;" href="#application.root#?event=#url.event#&startrow=#prev#" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Previous #displayrows# Records</a></cfif><cfif next lte leadlist.recordcount><a style="margin-bottom:5px;margin-left:5px;" class="btn btn-small btn-default" href="#application.root#?event=#url.event#&startrow=#next#">Next <cfif ( leadlist.recordcount - next ) lt displayrows>#evaluate(( leadlist.recordcount - next ) + 1 )#<cfelse>#displayrows#</cfif> Records <i class="icon-circle-arrow-right"></i></a></cfif></h5>
												</cfoutput>
											
												
												<table id="tablesorter" class="table table-bordered table-striped tablesorter">
													<thead>
														<tr>
															<th width="15%">Actions</th>													
															<th width="15%">Lead Source</th>
															<th width="30%">Client Name</th>
															<th width="20%">Status</th>
															<th width="20%">Services</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="leadlist" startrow="#startrow#" maxrows="#displayrows#">
															<tr>
																<td class="actions">								
																	<a title="Select Lead" href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" target="_blank" class="btn btn-mini btn-warning">
																		<i class="btn-icon-only icon-ok"></i>										
																	</a>
																	
																	<a title="Edit Lead Settings" href="#application.root#?event=#url.event#&fuseaction=editleadsettings&leadid=#leaduuid#" class="btn btn-mini btn-default">
																		<i class="btn-icon-only icon-edit"></i>										
																	</a>
																			
																	<a title="Delete All Lead Data" href="#application.root#?event=#url.event#&fuseaction=deletelead&leadid=#leaduuid#" onclick="javascript:return confirm('Are you sure you want to delete this record?  This will delete the selected lead data in all tables.  This action can not be un-done.  Continue?');" class="btn btn-mini btn-inverse">
																		<i class="btn-icon-only icon-trash"></i>										
																	</a>														
																</td>												
																<td>#leadsource#</td>
																<td>#leadfirst# #leadlast# (#leadid#)</td>
																<td><cfif leadactive eq 1><span class="label label-success">Active<cfelse><span class="label label-important">Inactive</cfif></span></td>
																<td><span class="label label-info">Advisory</span>  <cfif leadimp eq 1><span style="margin-left:5px;" class="label label-inverse">Implementation</span></cfif></td>
															</tr>	
														</cfoutput>											
													</tbody>
												</table>
											
											
											
											<!--- // if the recordset is empty // show this instead ---->
											<cfelse>
											
											
												
												<div class="alert alert-block alert-error" style="padding:25px;">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<h5><i style="font-weight:bold;" class="icon-warning-sign"></i> SORRY, NO RECORDS FOUND!</h5>
													<p>There are no records matching your input or the recordset is empty.  Please reset the filter above and try again... </p>
												</div>
												
											
											
											</cfif>
											
									
									
									
									
									
									
									
									
									
									<cfelse>
									
										
										
										
										
										
										
										
										
										
										
										<cfinvoke component="apis.com.admin.leadmanagementgateway" method="getleaddetail" returnvariable="leaddetail">
											<cfinvokeargument name="leadid" value="#url.leadid#">
										</cfinvoke>
										
										<cfinvoke component="apis.com.admin.leadmanagementgateway" method="getenrollmentcounselors" returnvariable="enrollmentcounselors">
											<cfinvokeargument name="companyid" value="#session.companyid#">
										</cfinvoke>
										
										<cfinvoke component="apis.com.admin.leadmanagementgateway" method="getintakeadvisors" returnvariable="intakeadvisors">
											<cfinvokeargument name="companyid" value="#session.companyid#">
										</cfinvoke>
										
										<cfinvoke component="apis.com.admin.leadmanagementgateway" method="getslsadvisors" returnvariable="slsadvisors">
											<cfinvokeargument name="companyid" value="#session.companyid#">
										</cfinvoke>
										
										<cfinvoke component="apis.com.leads.leadgateway" method="getleadstatus" returnvariable="leadstatus">
										
										
										
										
										
										
										
										
										
											<div class="well">
										
												<cfoutput>
														<h5><i style="margin-right:5px;" class="icon-user"></i> Selected Record:  #leaddetail.leadfirst# #leaddetail.leadlast# <span class="pull-right"><cfif isdefined( "form.__authtoken" )><a style="padding:5px;" href="#application.root#?event=#url.event#" class="label label-default"><i class="icon-spinner icon-spin"></i> Return to List</a></cfif>  <cfif leaddetail.leadactive eq 1><span style="padding:5px;margin-left:7px;" class="label label-info"><i class="icon-check"></i> Active<cfelse><span style="padding:5px;" class="label label-inverse"><i class="icon-check-emtpy"></i> Inactive</cfif></span></h5>										
														
														<br>
														
														<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=editleadsettings&leadid=#leadid#">
															
															<fieldset>
																
																
																<div class="span6">
																
																
																	<div class="control-group">											
																		<label class="control-label" for="leadsource">Lead Source</label>
																		<div class="controls">
																			<select name="leadsource" id="leadsource" class="large">
																				<cfloop query="leadsources">
																					<option value="#leadsourceid#"<cfif leaddetail.leadsourceid eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
																				</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="leadstatus">Lead Status</label>
																		<div class="controls">
																			<select name="leadstatus" id="leadstatus" class="large">
																				<cfloop query="leadstatus">
																					<option value="#leadstatusid#"<cfif leaddetail.leadstatusid eq leadstatus.leadstatusid>selected</cfif>>#leadstatus#</option>
																				</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																	
																	
																	<div class="control-group">											
																		<label class="control-label" for="firstname">First Name</label>
																		<div class="controls">
																			<input type="text" class="input-large" name="firstname" id="firstname" value="#leaddetail.leadfirst#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	
																	<div class="control-group">											
																		<label class="control-label" for="lastname">Last Name</label>
																		<div class="controls">
																			<input type="text" class="input-large" name="lastname" id="lastname" value="#leaddetail.leadlast#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="lastname">Address</label>
																		<div class="controls">
																			<input type="text" class="input-large" name="address1" id="address1" value="#leaddetail.leadadd1#">&nbsp;&nbsp;<input type="text" class="input-small" name="address2" id="address2" value="#leaddetail.leadadd2#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<div class="control-group">											
																		<label class="control-label" for="lastname">City, State, Zip</label>
																		<div class="controls">																	
																			<input type="text" class="input-medium" name="city" id="city" value="<cfif isdefined( "form.city" )>#trim( form.city )#<cfelse>#leaddetail.leadcity#</cfif>">
																			<input type="text" class="input-small span1" name="state" id="state" value="<cfif isdefined( "form.state" )>#trim( form.state )#<cfelse>#leaddetail.leadstate#</cfif>">&nbsp;&nbsp;
																			<input type="text" class="input-small span1" name="zipcode" id="zipcode" value="<cfif isdefined( "form.zipcode" )>#trim( form.zipcode )#<cfelse>#leaddetail.leadzip#</cfif>">
																		</div> <!-- /controls -->			
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="lastname">Email Address </label>
																		<div class="controls">
																			<input type="text" class="input-large" name="emailaddress" id="emailaddress" value="#trim( leaddetail.leademail )#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->											
																	
																	<br /><br /><br />													
																	
																		<!--- // form buttons --->									
																		<button style="margin-top:50px;margin-left:75px;" type="submit" class="btn btn-secondary btm-medium" name="savelead"><i class="icon-save"></i> Save Data</button>
																		<a style="margin-top:50px;" href="#application.root#?event=#url.event#" class="btn btn-primary btn-medium"><i class="icon-remove-sign"></i> Cancel</a>
																		<cfif isdefined( "form.__authtoken" )>
																		<a style="margin-top:50px;" href="#application.root#?event=#url.event#" class="btn btn-default btn-medium"><i class="icon-spinner icon-spin"></i> Return to List</a>
																		</cfif>
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="leadid|Lead ID is is a required field.;leadstatus|The lead status is required to save the record.;leadsource|The lead source is required to save the record.;enrollmentcounselor|The enrollmetn counselor is required to save the record.;firstname|The first name is required to save the record.;lastname|The last name is required to save the record.;" />	
																	
																
																
																</div><!-- / .span4 -->
																
																
																
																
																<!---// next column --->
																<div class="span4">
																
																
																	<div class="control-group">											
																		<label class="control-label" for="leadsource">Enrollment Counselor</label>
																		<div class="controls">
																			<select name="enrollmentcounselor" id="enrollmentcounselor">
																				<cfloop query="enrollmentcounselors">
																					<option value="#userid#"<cfif leaddetail.userid eq enrollmentcounselors.userid>selected</cfif>>#firstname# #lastname#</option>
																				</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<div class="control-group">											
																		<label class="control-label" for="leadsource">Intake Advisor</label>
																		<div class="controls">
																			<select name="intakeadvisor" id="intakeadvisor">
																				<cfloop query="intakeadvisors">
																					<option value="#userid#"<cfif leaddetail.userid eq intakeadvisors.userid>selected</cfif>>#firstname# #lastname#</option>
																				</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="leadsource">Student Loan Advisor</label>
																		<div class="controls">
																			<select name="slsadvisor" id="slsadvisor">
																				<cfloop query="slsadvisors">
																					<option value="#userid#"<cfif leaddetail.userid eq slsadvisors.userid>selected</cfif>>#firstname# #lastname#</option>
																				</cfloop>
																			</select>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="username">Username </label>
																		<div class="controls">
																			<input type="text" class="input-large" name="username" id="username" value="#trim( leaddetail.leadusername )#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="password">Password </label>
																		<div class="controls">
																			<input type="text" class="input-large" name="password" id="password" placeholder="To Change Password, Enter New...">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">
																		<label class="control-label" for="chkactive"><strong><i class="icon-th-large" style="margin-right:5px;"></i> Advanced Settings</strong></label>
																		<div class="controls">
																			<label class="checkbox">
																				<input type="checkbox" name="chkactive"<cfif leaddetail.leadactive eq 1>checked</cfif>>
																					Lead Active
																			</label>
																			<label class="checkbox">
																				<input type="checkbox" name="chkesign"<cfif leaddetail.leadesign eq 1>checked</cfif>>
																					Lead E-Sign
																			</label>
																			<label class="checkbox">
																				<input type="checkbox" name="chkadvisory"<cfif leaddetail.leadconv eq 1>checked</cfif>>
																					Lead Advisory
																			</label>
																			<label class="checkbox">
																				<input type="checkbox" name="chkimpl"<cfif leaddetail.leadimp eq 1>checked</cfif>>
																					Lead Implementation
																			</label>
																			<label class="checkbox">
																				<input type="checkbox" name="chkwelcome"<cfif leaddetail.leadwelcomehome eq 1>checked</cfif>>
																					Lead Welcome Message
																			</label>																			
																			
																		</div>
																	</div>													
																
																</div><!-- / .span4 -->						
																							
															</fieldset>
														</form>
														</cfoutput>
										
												</div><!-- / .well -->
											
										
									
									</cfif><!-- // not query structure --->
									
								</div><!-- / .widget-content -->							
							
							</div><!-- / .widget -->					
						
						</div><!-- / .span12 -->				
					
					</div><!-- / .row -->
					<cfif leadlist.recordcount lt 5>
						<div style="margin-top:300px;"></div>
					</cfif>
				</div><!-- / .container -->			
			
			</div><!-- / .main -->
							
					