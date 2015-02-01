



			
			
			
			
			
			
			
			
			
			
			<!--- partial view // spa // manage company outcomes --->
			<cfinvoke component="apis.com.system.companymenus" method="getcompanyoutcomes" returnvariable="outcomeslist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>		
			<!---<cfdump var="#outcomeslist#" label="My Client Outcomes List">--->
			
			
			<!--- // process the forms and query string action --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editoutcome">			
				<cfif structkeyexists( url, "ocid" ) and isvalid( "integer", url.ocid ) >					
					<cfset oc = structnew() />
					<cfparam name="ocid" default="#url.ocid#">					
						<cfif ocid eq 0>						
							<cfquery datasource="#application.dsn#" name="addoutcome">
								insert into outcomes(companyid, outcomedescr)
									values(
											<cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value=" " cfsqltype="cf_sql_varchar" />																		
										   );						
							</cfquery>							
							<cflocation url="#application.root#?event=#url.event#&thismsg=added" addtoken="yes"	>						
						<cfelse>						
							<cfset oc.outcomedescr = trim( form.outcomedescr ) />
							<cfset oc.companyid = form.comid />
							<cfset oc.ocid = form.ocid />							
								<cfif oc.outcomedescr is "">
									<cfset oc.outcomedescr = "Undefined" />
								</cfif>							
								<cfquery datasource="#application.dsn#" name="editoutcome">
									update outcomes
									   set outcomedescr = <cfqueryparam value="#oc.outcomedescr#" cfsqltype="cf_sql_varchar" />								   								
									 where outcomeid = <cfqueryparam value="#oc.ocid#" cfsqltype="cf_sql_integer" />
								</cfquery>							
								<cflocation url="#application.root#?event=#url.event#&thismsg=saved" addtoken="yes">					
						</cfif>					
				</cfif>				
			</cfif>
			
			<!--- // delete client outcome --->
			<cfif structkeyexists( url, "fuseaction" ) and trim( url.fuseaction ) is "deleteoutcome">
				<cfparam name="ocid" default="">
				<cfparam name="compid" default="">
					<cfif structkeyexists( url, "ocid" ) and isvalid( "integer", url.ocid )>
						<cfset ocid = url.ocid />
						<cfset compid = session.companyid />
							<cfparam name="myid" default="">
								<cfquery datasource="#application.dsn#" name="getoutcomedetail">
									select outcomeid
									  from outcomes
									 where outcomeid = <cfqueryparam value="#ocid#" cfsqltype="cf_sql_integer" />
									   and companyid = <cfqueryparam value="#compid#" cfsqltype="cf_sql_integer" />
								</cfquery>
										
										<cfif getoutcomedetail.recordcount eq 1>									
											
											<cfset myid = getoutcomedetail.outcomeid />
											<!--- // // remove for development
											<cfquery datasource="#application.dsn#" name="checkexistingleads">
												select count(*) as totalleads
												  from leads
												 where leadsourceid = <cfqueryparam value="#thisleadsourceid#" cfsqltype="cf_sql_integer" />
											</cfquery>											
											<cfif checkexistingleads.totalleads eq 0>
											--->											
												<cfquery datasource="#application.dsn#" name="killclientoutcome">
													delete 
													  from outcomes
													 where outcomeid = <cfqueryparam value="#myid#" cfsqltype="cf_sql_integer" />
													   and companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
												</cfquery>											
												<!--- // redirect and display message --->
												<cflocation url="#application.root#?event=#url.event#&thismsg=deleted" addtoken="no">											
											<!---
											<cfelse>											
												<!--- // redirect and display message --->
												<cflocation url="#application.root#?event=#url.event#&msg=error&errorid=1" addtoken="no">												
											</cfif>
											--->
										<cfelse>
										
											<cflocation url="#application.root#?event=#url.event#&msg=error&errorid=2" addtoken="no">	
										
										</cfif>
					</cfif>						
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
							<!--- // show system messages --->
							<cfif structkeyexists( url, "thismsg" ) and trim( url.thismsg ) is "saved">								
								<div class="alert alert-block alert-success">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-check"></i> SYSTEM MESSAGE</h5>
									<p>The new client outcome record was successfully saved...</p>
								</div>							
							<cfelseif structkeyexists( url, "thismsg" ) and trim( url.thismsg ) is "added">
								<div class="alert alert-block alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-plus-sign"></i> SYSTEM MESSAGE</h5>
									<p>A new record has been added.  Please enter the outcome description and click Save!</p>
								</div>
							<cfelseif structkeyexists( url, "thismsg" ) and trim( url.thismsg ) is "deleted">							
								<!--- // show the message that the delete transaction completed successfully --->
								<div class="alert alert-block alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
										<h5><i style="font-weight:bold;" class="icon-check"></i> SYSTEM MESSAGE</h5>
										<p>The client outcome record was successfully deleted from the system.</p>
								</div>												
							<cfelseif structkeyexists( url, "thismsg" ) and trim( url.thismsg ) is "error">								
									<cfif structkeyexists( url, "errorid" ) and url.errorid eq 1>
									<!--- // show the validation error that the lead source is in use and can not be deleted --->
										<div class="alert alert-block alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
												<h5><i style="font-weight:bold;" class="icon-warning-sign"></i> SYSTEM MESSAGE</h5>
												<p>Sorry, the client outcome can not be deleted.  It is currently in use by active clients.</p>
										</div>
									<cfelseif structkeyexists( url, "errorid" ) and url.errorid eq 2>
									<!--- // show the validation error that the lead source is in use and can not be deleted --->
										<div class="alert alert-block alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
												<h5><i style="font-weight:bold;" class="icon-warning-sign"></i> SYSTEM MESSAGE</h5>
												<p>Sorry, the client outcome can not be deleted.  There was a problem retrieving the correct record from the database.</p>
										</div>
									<cfelse>
										<div class="alert alert-block alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
											<h5><i style="font-weight:bold;" class="icon-warning-sign"></i> SYSTEM MESSAGE</h5>
											<p>An unknown error has occured...</p>
										</div>
									</cfif>
														
							</cfif>				
								
								
								<cfoutput>

									<h5 style="margin-top:7px;"><i class="icon-list-alt"></i> Client Outcomes <cfif isdefined( "outcomeslist" ) and outcomeslist.recordcount gt 0><span style="margin-left:10px;padding:4px;" class="label label-inverse"> #outcomeslist.recordcount# </span></cfif></h5>
								
									<cfif outcomeslist.recordcount eq 0>							
										<div class="alert alert-block alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<h5><i style="font-weight:bold;" class="icon-check"></i> No Outcomes Found!</h5>
											<p>Click the button below to begin...</p>
											<p>&nbsp;</p>
											<p><a href="#application.root#?event=#url.event#&fuseaction=editoutcome&ocid=0" class="btn btn-default btn-small"><i class="icon-plus"></i> Add New Client Outcome</a></p>
										</div>							
									<cfelse>											
											<a href="#application.root#?event=#url.event#&fuseaction=editoutcome&ocid=0" class="btn btn-default btn-mini" style="margin-bottom:10px;"><i class="icon-plus"></i> Add New Client Outcome</a>
											<table class="table tablesorter table-striped table-highlight">
												<thead>
													<tr>														
														<th>Edit Outcome</th>														
														<th class="action">Delete</th>
													</tr>
												</thead>
												<tbody>
													<cfloop query="outcomeslist">														
														<tr>
															<form name="edit-contact-methods-inline" class="form-inline" action="#cgi.script_name#?event=#url.event#&fuseaction=editoutcome&ocid=#outcomeid#" method="post">
																<td><input type="text" name="outcomedescr" class="input-large" value="#trim( outcomedescr )#" <cfif trim( outcomedescr ) is "">placeholder="Enter Outcome Name"</cfif> /> <button style="margin-left:7px;margin-top:-10px;" type="submit" class="btn btn-small btn-secondary" name="savemethod"><i class="icon-save"></i> Save</button></td>																									
																<input name="ocid" type="hidden" value="#outcomeid#" />
																<input name="comid" type="hidden" value="#session.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<td class="actions">
																	
																	<!--- // delete record action --->
																	<a href="#application.root#?event=#url.event#&fuseaction=deleteoutcome&ocid=#outcomeid#" class="btn btn-mini btn-primary" onclick="return confirm('Are you sure you want to delete the selected client outcome?');">
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