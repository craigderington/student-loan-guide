			
			
			
			
			
			
			
			
			
			
								<!--- // partial view // spa // manage company contact methods --->
								<cfinvoke component="apis.com.system.companymenus" method="getcompanycontactmethods" returnvariable="contactmethods">
									<cfinvokeargument name="companyid" value="#session.companyid#">
								</cfinvoke>		
								<!---<cfdump var="#contactmethods#" label="My Contact Methods">--->
			
			
								<!--- // process the forms and query string action --->
								<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editmethod">			
									<cfif structkeyexists( url, "methodid" ) and isvalid( "integer", url.methodid ) >					
										<cfset thismethod = structnew() />
										<cfparam name="methodid" default="#url.methodid#">					
											<cfif methodid eq 0>						
												<cfquery datasource="#application.dsn#" name="addcontactmethod">
													insert into contactmethod(companyid, contactmethod)
														values(
																<cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value=" " cfsqltype="cf_sql_varchar" />																		
															   );						
												</cfquery>							
												<!--- // redirect and display message --->
												<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="yes"	>						
											<cfelse>						
												<cfset thismethod.contactmethodname = trim( form.contactmethodname ) />
												<cfset thismethod.companyid = form.comid />
												<cfset thismethod.methodid = form.methodid />							
													<cfif thismethod.contactmethodname is "">
														<cfset thismethod.contactmethodname = "Undefined" />
													</cfif>							
													<cfquery datasource="#application.dsn#" name="editcontactmethod">
														update contactmethod
														   set contactmethod = <cfqueryparam value="#thismethod.contactmethodname#" cfsqltype="cf_sql_varchar" />								   								
														 where contactmethodid = <cfqueryparam value="#thismethod.methodid#" cfsqltype="cf_sql_integer" />
													</cfquery>							
													<!--- // redirect and display message --->
													<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="yes">					
											</cfif>					
									</cfif>				
								</cfif>
			
			
								<!--- // delete contact method --->
								<cfif structkeyexists( url, "fuseaction" ) and trim( url.fuseaction ) is "deletemethod">
									<cfparam name="methodid" default="">
										<cfif structkeyexists( url, "methodid" ) and isvalid( "integer", url.methodid )>
											<cfset methoidid = url.methodid />
												<cfparam name="myid" default="">
													<cfquery datasource="#application.dsn#" name="getcontactmethod">
														select contactmethodid
														  from contactmethod
														 where contactmethodid = <cfqueryparam value="#methodid#" cfsqltype="cf_sql_integer" />
													</cfquery>						
													
													<cfset myid = getcontactmethod.contactmethodid />																
															<!---	// remove for development 
																<cfquery datasource="#application.dsn#" name="checkexistingleads">
																	select count(*) as totalleads
																	  from leads
																	 where leadsourceid = <cfqueryparam value="#thisleadsourceid#" cfsqltype="cf_sql_integer" />
																</cfquery>													
																<cfif checkexistingleads.totalleads eq 0>
																--->
																	<cfquery datasource="#application.dsn#" name="killleadsource">
																		delete 
																		  from contactmethod
																		 where contactmethodid = <cfqueryparam value="#myid#" cfsqltype="cf_sql_integer" />
																	</cfquery>											
																	<!--- // redirect and display message --->
																	<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">											
																<!---
																<cfelse>											
																	<!--- // redirect and display message --->
																	<cflocation url="#application.root#?event=#url.event#&msg=error" addtoken="no">												
																</cfif>
																--->

																
										</cfif>						
								</cfif>			
			
						
								<!--- // show system messages --->
								<cfif structkeyexists( url, "msg" ) and trim( url.msg ) is "saved">								
									<div class="alert alert-block alert-success">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<h5><i style="font-weight:bold;" class="icon-check"></i> SYSTEM MESSAGE</h5>
										<p>The new contact method record was successfully saved...</p>
									</div>							
								<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "added">
									<div class="alert alert-block alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<h5><i style="font-weight:bold;" class="icon-plus-sign"></i> SYSTEM MESSAGE</h5>
										<p>A new record has been added.  Please enter the contact method name and click Save!</p>
									</div>
								<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "deleted">							
									<!--- // show the message that the delete transaction completed successfully --->
									<div class="alert alert-block alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
											<h5><i style="font-weight:bold;" class="icon-check"></i> SYSTEM MESSAGE</h5>
											<p>The contact method record was successfully deleted from the system.</p>
									</div>												
								<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "error">	
									<cfoutput>
										<!--- // show the validation error that the lead source is in use and can not be deleted --->
											<div class="alert alert-block alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
													<h5><i style="font-weight:bold;" class="icon-warning-sign"></i> SYSTEM MESSAGE</h5>
													<p>Sorry, the contact method can not be deleted.  It is currently being used by active clients. <cfif isdefined( "checkexistingleads.totalleads" )> to #checkexistingleads.totalleads# client record<cfif checkexistingleads.totalleads gt 1>s</cfif></cfif></p>
											</div>
									</cfoutput>							
								</cfif>	
								
								
								<cfoutput>
									<h5 style="margin-top:7px;"><i class="icon-list-alt"></i> Contact Methods <cfif isdefined( "contactmethods" ) and contactmethods.recordcount gt 0><span style="margin-left:10px;padding:4px;" class="label label-inverse"> #contactmethods.recordcount# </span></cfif></h5>
								
									<cfif contactmethods.recordcount eq 0>		
										<div class="alert alert-block alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<h5><i style="font-weight:bold;" class="icon-check"></i> No Records Found!</h5>
											<p>Click the button below to begin...</p>
											<p>&nbsp;</p>
											<p><a href="#application.root#?event=#url.event#&fuseaction=editmethod&methodid=0" class="btn btn-default btn-small"><i class="icon-plus"></i> Add New Contact Method</a></p>
										</div>								
									<cfelse>										
											<a href="#application.root#?event=#url.event#&fuseaction=editmethod&methodid=0" class="btn btn-default btn-mini" style="margin-bottom:10px;"><i class="icon-plus"></i> Add New Contact Method</a>
											<table class="table tablesorter table-striped table-highlight">
												<thead>
													<tr>														
														<th>Edit Contact Method</th>														
														<th class="action">Delete</th>
													</tr>
												</thead>
												<tbody>
													<cfloop query="contactmethods">														
														<tr>
															<form name="edit-contact-methods-inline" class="form-inline" action="#cgi.script_name#?event=#url.event#&fuseaction=editmethod&methodid=#contactmethodid#" method="post">
																<td><input type="text" name="contactmethodname" class="input-large" value="#trim( contactmethod )#" <cfif trim( contactmethod ) is "">placeholder="Enter Contact Method Name"</cfif> /> <button style="margin-left:7px;margin-top:-10px;" type="submit" class="btn btn-small btn-secondary" name="savemethod"><i class="icon-save"></i> Save</button></td>																									
																<input name="methodid" type="hidden" value="#contactmethodid#" />
																<input name="comid" type="hidden" value="#session.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<td class="actions">
																	
																	<!--- // delete contact method --->
																	<a href="#application.root#?event=#url.event#&fuseaction=deletemethod&methodid=#contactmethodid#" class="btn btn-mini btn-primary" onclick="return confirm('Are you sure you want to delete the selected contact method?');">
																		<i class="btn-icon-only icon-trash"></i>										
																	</a>
																	
																	
																</td>
															</form>
														</tr>														
													</cfloop>
												</tbody>
											</table>		
									</cfif>								
								</cfoutput>