
			
			
			<!--- // call our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>	

			<cfinvoke component="apis.com.implementation.implementgateway" method="getreferences" returnvariable="referenceslist">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			
			
			<!--- // delete the reference --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletereference">
				<cfparam name="refid" default="">
				<cfif structkeyexists( url, "refid" ) and isvalid( "integer", url.refid )>
					<cfset refid = url.refid />
					<cfquery datasource="#application.dsn#" name="killreference">
						delete from leadreferences
						 where referenceid = <cfqueryparam value="#refid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cflocation url="#application.root#?event=page.implement.personal.references&msg=deleted" addtoken="no" >
				</cfif>	
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<!--- declare forms vars --->			
			<cfparam name="reffirstname" default="">
			<cfparam name="reflastname" default="">
			<cfparam name="refadd1" default="">
			<cfparam name="refadd2" default="">
			<cfparam name="refcity" default="">
			<cfparam name="refstate" default="">		
			<cfparam name="refzip" default="">
			<cfparam name="refphone" default="">
			<cfparam name="refemail" default="">
			<cfparam name="refrelation" default="">
			<cfparam name="today" default="">
			
			
			
			
			<!--- implementation personal references page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<!--- show system messages --->
						<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The personal reference was successfully modified.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>
						<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-success">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> DELETE SUCCESS!</strong>  The personal reference was successfully deleted.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>
						</cfif>
						<!--- // end system messages --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Implementation Enrollment Personal References for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
									<!--- // form processing --->
									<cfif isdefined( "form.fieldnames" )>
										
										<cfscript>
											objValidation = createobject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields( form );
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset ref = structnew() />
											<cfset ref.leadid = form.leadid />
											<cfset ref.refid = form.refid />
											<cfset ref.reffirstname = trim( form.reffirstname ) />
											<cfset ref.reflastname = trim( form.reflastname ) />
											<cfset ref.refadd1 = trim( form.refadd1 ) />
											<cfset ref.refadd2 = trim( form.refadd2 ) />
											<cfset ref.refcity = trim( form.refcity ) />
											<cfset ref.refstate = trim( ucase( form.refstate )) />
											<cfset ref.refzip = trim( form.refzip ) />
											<cfset ref.refphone = trim( form.refphone ) />
											<cfset ref.refemail = trim( form.refemail ) />
											<cfset ref.refrelation = trim( form.refrelation ) />
																	
											
											<!--- format phone number --->
											<cfset ref.refphone = rereplace( ref.refphone, "[-]", "", "all" ) />
											
											
											<!--- // some other variables --->
											<cfset today = createodbcdatetime( now() ) />																					
											
											
											<cfif ref.refid neq 0>											
											
												<cfquery datasource="#application.dsn#" name="savereference">
													update leadreferences
													   set reffirstname = <cfqueryparam value="#ref.reffirstname#" cfsqltype="cf_sql_varchar" />,
														   reflastname = <cfqueryparam value="#ref.reflastname#" cfsqltype="cf_sql_varchar" />,
														   refaddress1 = <cfqueryparam value="#ref.refadd1#" cfsqltype="cf_sql_varchar" />,
														   refaddress2 = <cfqueryparam value="#ref.refadd2#" cfsqltype="cf_sql_varchar" />,			  
														   refcity = <cfqueryparam value="#ref.refcity#" cfsqltype="cf_sql_varchar" />,
														   refstate = <cfqueryparam value="#ref.refstate#" cfsqltype="cf_sql_varchar" />,
														   refzip = <cfqueryparam value="#ref.refzip#" cfsqltype="cf_sql_varchar" />,
														   refphone1 = <cfqueryparam value="#ref.refphone#" cfsqltype="cf_sql_varchar" />,
														   refemail = <cfqueryparam value="#ref.refemail#" cfsqltype="cf_sql_varchar" />,
														   refrelation = <cfqueryparam value="#ref.refrelation#" cfsqltype="cf_sql_varchar" />
													 where referenceid = <cfqueryparam value="#ref.refid#" cfsqltype="cf_sql_integer" />
												</cfquery>											
											
											
											<cfelse>
												
												<cfquery datasource="#application.dsn#" name="addreference">
													insert into leadreferences(leadid, reffirstname, reflastname, refaddress1, refaddress2, refcity, refstate, refzip, refphone1, refemail, refrelation)
													     values( 
																<cfqueryparam value="#ref.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#ref.reffirstname#" cfsqltype="cf_sql_varchar" />,
														        <cfqueryparam value="#ref.reflastname#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refadd1#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refadd2#" cfsqltype="cf_sql_varchar" />,			  
																<cfqueryparam value="#ref.refcity#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refstate#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refzip#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refphone#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refemail#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ref.refrelation#" cfsqltype="cf_sql_varchar" />
															   );
												</cfquery>
												
												
											</cfif>
											
												
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#ref.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# saved personal references for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#ref.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																);
												</cfquery>											
											
												
												
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
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.implement.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
												
													<ul class="nav nav-tabs">
														<cfoutput>
														<li><a href="#application.root#?event=page.implement.personal">Borrower Information</a></li>
														<li><a href="#application.root#?event=page.implement.personal.partner">Spouse/Partner Information</a></li>															
														<li class="active"><a href="#application.root#?event=#url.event#">Personal References</a></li>
														</cfoutput>
													</ul>
													
													<h3><i class="icon-bar-chart"></i> Implementation | <cfif structkeyexists( url, "fuseaction" )><cfif url.refid eq 0>Add New Personal Reference<cfelse>Edit Personal Reference</cfif><cfelse>Personal References </cfif></h3>
													
													<p>For solution implementation, individuals and borrowers are required by the Department of Education to provide at least 2 personal references.  You should complete the fields below to capture spouse or partner personal information to complete DOE solution implementation forms..</p>
													
													<br>
													
													
													<cfif structkeyexists( url, "fuseaction" )>
													
														<cfinvoke component="apis.com.implementation.implementgateway" method="getreferencedetail" returnvariable="referencedetail">
															<cfinvokeargument name="referenceid" value="#url.refid#">
														</cfinvoke>
														
														
														
																	<cfoutput>
																	<form id="edit-personal-references" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&refid=#url.refid#" style="margin-left:10px;">
																		<fieldset>				
																			
																			<div class="control-group">											
																				<label class="control-label" for="reffirstname">First Name</label>
																				<div class="controls">
																					<input type="text" class="input-large" placeholder="Enter Reference First Name" name="reffirstname" value="<cfif isdefined( "form.reffirstname" )>#form.reffirstname#<cfelse>#referencedetail.reffirstname#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->												
																			
																			<div class="control-group">											
																				<label class="control-label" for="reflastname">Last Name</label>
																				<div class="controls">
																					<input type="text" class="input-large" placeholder="Enter Reference Last Name" name="reflastname" value="<cfif isdefined( "form.reflastname" )>#form.reflastname#<cfelse>#referencedetail.reflastname#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="refadd1">Address</label>
																				<div class="controls">
																					<input type="text" class="input-large" placeholder="Address 1" name="refadd1" value="<cfif isdefined( "form.refadd1" )>#form.refadd1#<cfelse>#referencedetail.refaddress1#</cfif>" />
																					<input type="text" class="input-medium" placeholder="Address 2" name="refadd2" value="<cfif isdefined( "form.refadd2" )>#form.refadd2#<cfelse>#referencedetail.refaddress2#</cfif>" />
																					
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="refcity">City, State, Zip</label>
																				<div class="controls">
																					<input type="text" class="input-large" placeholder="Enter City" name="refcity" value="<cfif isdefined( "form.refcity" )>#form.refcity#<cfelse>#referencedetail.refcity#</cfif>" />
																					<input type="text" class="input-mini" placeholder="State" name="refstate" value="<cfif isdefined( "form.refstate" )>#form.refstate#<cfelse>#referencedetail.refstate#</cfif>" maxlength="2" onchange="javascript:this.value=this.value.toUpperCase();"  />
																					<input type="text" class="input-small" placeholder="Zip Code" name="refzip" value="<cfif isdefined( "form.refzip" )>#form.reflastname#<cfelse>#referencedetail.refzip#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="refphone">Phone</label>
																				<div class="controls">
																					<input type="text" class="input-medium" maxlength="15" name="refphone" value="<cfif isdefined( "form.refphone" )>#form.refphone#<cfelse>#referencedetail.refphone1#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="reflastname">Email Address</label>
																				<div class="controls">
																					<input type="text" class="input-xlarge" placeholder="Enter Email Address" name="refemail" value="<cfif isdefined( "form.reflastname" )>#form.refemail#<cfelse>#referencedetail.refemail#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="reflastname">Relationship to Borrower</label>
																				<div class="controls">
																					<input type="text" class="input-large" placeholder="Enter Relationship" name="refrelation" value="<cfif isdefined( "form.refrelation" )>#form.refrelation#<cfelse>#referencedetail.refrelation#</cfif>" />
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->									
																										
																		
																		<!--- // form action --->
																		<br />
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="savereference"><i class="icon-save"></i> Save Reference</button>							
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.implement.personal.references'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="refid" value="#url.refid#" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;reffirstname|The reference first name is required to save this record.;reflastname|The reference last name is also required.;refadd1|The address is required.;refcity|The city is required.;refstate|The state is required.;refzip|The zip code is required.;refphone|The phone number is required.;refrelation|The reference relationship is required.;" />															
																		</div> <!-- /form-actions -->														
																			
																	</fieldset>
																</form>
																</cfoutput>
												
												
												
												
												
												
												
													<cfelse>
													
														
															<cfif referenceslist.recordcount gt 0>
			
																	<!--- // show references table --->
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<tr>
																				<th width="10%">Actions</th>																		
																				<th>Reference Name</th>
																				<th>Address</th>
																				<th>Phone</th>
																				<th>Email</th>
																				<th>Relation</th>
																			</tr>
																		</thead>
																		<tbody>
																			<cfoutput query="referenceslist">																		
																				<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
																					<cfinvokeargument name="phonenumber" value="#referenceslist.refphone1#">
																				</cfinvoke>
																				<tr>
																					<td class="actions">																	
																						
																						<a href="#application.root#?event=#url.event#&fuseaction=editreference&refid=#referenceid#" class="btn btn-mini btn-warning">
																							<i class="btn-icon-only icon-ok"></i>										
																						</a>									
																						
																						<a href="#application.root#?event=#url.event#&fuseaction=deletereference&refid=#referenceid#" onclick="javascript:return confirm('Are you sure you want to delete this reference?  This action can not be un-done.');" class="btn btn-mini btn-inverse">
																							<i class="btn-icon-only icon-trash"></i>										
																						</a>
																						
																					</td>																		
																				<td>#reffirstname# #reflastname#</td>
																				<td>#refaddress1# <a href="javascript:;" rel="popover" data-content="#refaddress1# #refaddress2#<br />#refcity#, #refstate# #refzip#" data-original-title="#reffirstname# #reflastname# Address"><i style="margin-left:5px;" class="icon-btn-only icon-paper-clip"></i></a></td>
																				<td>#phonenumber#</td>
																				<td>#refemail#</td>
																				<td>#refrelation#</td>
																			</tr>
																			</cfoutput>
																		</tbody>
																	</table>
																	
																	<cfoutput>
																		<a style="margin-top:15px;" href="#application.root#?event=#url.event#&fuseaction=editreference&refid=0" class="btn btn-default btn-small"><i class="icon-plus"></i> Add Reference</a>
																	</cfoutput>
																		
															<cfelse>
															
																<cfoutput>	
																	<div class="alert alert-block alert-info" style="padding:35px;">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<h5><i class="icon-check"></i> NO REFERENCES FOUND!</strong></h5>
																		<p style="margin-top:15px;"><a href="#application.root#?event=#url.event#&fuseaction=editreference&refid=0" class="btn btn-default btn-small"><i class="icon-plus"></i> Add Reference</a></p>
																	</div>		
																</cfoutput>
															
															</cfif>
														
													
													</cfif>
												
													
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												
												</div> <!-- / .tab1 -->										 
												
											</div> <!-- /.tab-content -->
											
										</div> <!-- / .span8 -->			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style=+"margin-top:150px;"></div>
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		