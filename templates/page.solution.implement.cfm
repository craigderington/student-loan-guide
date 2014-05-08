


				<!--- get our data access components --->
				<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<cfinvoke component="apis.com.implementation.implementgateway" method="getimplementplans" returnvariable="impplans">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<cfinvoke component="apis.com.implementation.implementgateway" method="getsolutiongroupbyservicer" returnvariable="solutiongroupbyservicer">
					<cfinvokeargument name="leadid" value="#session.leadid#">								
				</cfinvoke>				
				
				
					<!--- // mark step completed --->
					<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "markcompleted">
						<cfparam name="stepid" default="">
						<cfparam name="tabnum" default="">
						<cfparam name="today" default="#now()#">
						<cfif structkeyexists( url, "iid" ) and isvalid( "uuid", url.iid )>
							<cfset stepid = left( url.iid, 35 ) />
							<cfset tabnum = trim( url.tab ) />
							<cfquery datasource="#application.dsn#" name="markstepcompleted">
								update leadimplementsteps
								   set stepcompdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
									   stepcompbyuser = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
									   stepstatus = <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" />
								 where leadimpplanuuid = <cfqueryparam value="#stepid#" cfsqltype="cf_sql_varchar" maxlength="35" />
							</cfquery>						
							<!--- // log the activity --->
							<cfquery datasource="#application.dsn#" name="logact">
								insert into activity(leadid, userid, activitydate, activitytype, activity)
									values (
											<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
											<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#session.username# marked an implementation step completed for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
											);
							</cfquery>
							<cflocation url="#application.root#?event=#url.event#&msg=saved&tab=#tabnum#" addtoken="yes">				
						<cfelse>					
							<script>
								alert('Sorry, the implementation step unique identifier is malformed and the operation has been aborted.  Please go back and try again...');
								self.location="javascript:history.back(-1);"
							</script>				
						</cfif>				
					</cfif>
					<!--- // end mark completed --->
				
				
				
				
				<div class="main">
					
					<div class="container">
						
						<div class="row">
							
							<div class="span12">
							
								<!--- // show system messages --->
								<cfoutput>
									<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
										<div class="row">
											<div class="span12">										
												<div class="alert alert-info">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong><i class="icon-check"></i> SUCCESS!</strong>  The implementation step was successfully marked completed by #session.username# on #dateformat( now(), "mm/dd/yyyy" )#...
												</div>										
											</div>								
										</div>
									<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
										<div class="row">
											<div class="span12">										
												<div class="alert alert-success">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong>SUCCESS!</strong>  The note was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
												</div>										
											</div>								
										</div>
									<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
										<div class="row">
											<div class="span12">										
												<div class="alert alert-error">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong>SYSTEM ERROR!</strong>  Sorry, the note could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
												</div>										
											</div>								
										</div>
									</cfif>
								</cfoutput>
								
								<div class="widget stacked">
									<cfoutput>
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>Implementation Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</div>
									</cfoutput>
									
									<div class="widget-content">
										
										<div class="span3">
											<cfinclude template="page.implement.nav.cfm">
										</div><!-- / .span3 -->
										
										<div class="span8">
											<h3><i class="icon-cogs"></i> Solution Implementation Plans   <cfif solutiongroupbyservicer.recordcount neq 0><span class="pull-right"><a href="index.cfm?event=page.create.plan" class="btn btn-small btn-secondary"><i class="icon-cogs"></i> Create New Plan</a></span></cfif></h3>
											<p>The following tabs below contain the master implementation steps you will need to complete in order to implement the selected student loan solution.  Please begin by selecting the solution and reviewing the master steps to implement the solution.</p>						
											
											<div class="tabbable">
												<ul class="nav nav-tabs">
													<cfoutput query="impplans">
														<li <cfif not structkeyexists( url, "tab" ) and impplans.currentrow eq 1>class="active"<cfelseif structkeyexists( url, "tab" ) and url.tab is "#trim( replace( solutionsubcat, " ", "", "all" ) )#-#implementid#">class="active"</cfif>>
															<a href="###trim( replace( solutionsubcat, " ", "", "all" ) )#-#implementid#" data-toggle="tab"><strong>#solutionoption#</strong> - #solutionsubcat# - #implementid#</a>
														</li>
													</cfoutput>
												</ul>
											
												<div class="tab-content">
													<cfoutput query="impplans">
														
														<div class="tab-pane <cfif not structkeyexists( url, "tab" ) and impplans.currentrow eq 1>active<cfelseif structkeyexists( url, "tab" ) and url.tab is "#trim( replace( solutionsubcat, " ", "", "all" ) )#-#implementid#">active</cfif>" id="#trim( replace( solutionsubcat, " ", "", "all" ) )#-#implementid#">
															
															<!--- // show the servicer and school/loan type info --->
															<cfinvoke component="apis.com.implementation.implementgateway" method="getimplementedsolutions" returnvariable="implementedsolutions">
																<cfinvokeargument name="solutionid" value="#impplans.solutionid#">
															</cfinvoke>												
															
															<h5 style="margin-top:5px;margin-bottom:5px;"><i class="icon-th-large"></i> <cfif implementedsolutions.servicerid eq -1>#implementedsolutions.nslservicer#<cfelse>#implementedsolutions.servname#</cfif>   <span class="pull-right"><a href="javascript:;" onclick="window.open('templates/clientimplementnotes.cfm?planid=#impplans.planuuid#','','scrollbars=yes,location=no,status=yes,tollbar=no,width=960,height=700');" class="btn btn-mini btn-secondary"><i class="icon-copy"></i> Plan Notes</a></span></h5>
															
															<!--- // loop the implemented solution info inside the tab // show nsl servicer, school and solution date --->
															<cfloop query="implementedsolutions">								
																<ul style="list-style:none;">																	
																	<li style="margin-left:-25px;"><i class="icon-circle"></i> #codedescr# &bull; #attendingschool# &bull; Completed: #dateformat( solutioncompdate, "mm/dd/yyyy" )#																
																</ul>
															</cfloop>
															
															
															
															<!--- // call the master step componenent and pass in the implement id of the selected solution --->
															<cfinvoke component="apis.com.implementation.implementgateway" method="getplansteps" returnvariable="plansteps">
																<cfinvokeargument name="impid" value="#impplans.implementid#">
															</cfinvoke>														
															<cfparam name="stepx" default="">																
																
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<tr>
																			<th width="5%">Actions</th>
																			<th>Step Number</th>
																			<th>Step Description</th>
																			<th>Step Date</th>
																			<th>Status</th>
																		</tr>
																	</thead>
																	<tbody>
																		<cfloop query="plansteps">																			
																			<cfset stepx = plansteps.currentrow - 1 />
																			<tr>
																				<td class="actions">																					
																					
																					<cfif plansteps.currentrow eq 1 and plansteps.stepstatus[1] is not "completed" >
																						<a title="Mark Step Completed" href="#application.root#?event=#url.event#&fuseaction=markcompleted&iid=#leadimpplanuuid#&tab=#trim( replace( impplans.solutionsubcat, " ", "", "all" ) )#-#impplans.implementid#" class="btn btn-mini btn-warning" onclick="javascript:return confirm('Are you sure you want to mark this step completed?');">
																							<i class="btn-icon-only icon-ok"></i>										
																						</a>
																					<cfelseif plansteps.currentrow eq 1 and plansteps.stepstatus[1] is "completed" >
																						<div align="center">
																							<i class="btn-icon-only icon-check"></i>
																						</div>
																					</cfif>
																					
																					
																					<cfif plansteps.currentrow neq 1 and plansteps.stepstatus[stepx] is "completed" >
																						<cfif plansteps.stepstatus is not "completed">
																							<a title="Mark Step Completed" href="#application.root#?event=#url.event#&fuseaction=markcompleted&iid=#leadimpplanuuid#&tab=#trim( replace( impplans.solutionsubcat, " ", "", "all" ) )#-#impplans.implementid#" class="btn btn-mini btn-warning" onclick="javascript:return confirm('Are you sure you want to mark this step completed?');">
																								<i class="btn-icon-only icon-ok"></i>									
																							</a>
																						<cfelse>
																							<cfif plansteps.stepcompdate neq "">																								
																								<div align="center"><i class="btn-icon-only icon-check"></i></div>																		
																							</cfif>
																						</cfif>
																					</cfif>																						
																				</td>																				
																				<td>#msimpstepnum#</td>
																				<td>#msimpsteptask#</td>
																				<td><cfif stepstatus is not "completed">#dateformat( stepassigndate, 'mm/dd/yyyy' )#<cfelse><span class="label label-success">#dateformat( stepcompdate, 'mm/dd/yyyy' )#</span></cfif></td>																				
																				<td><cfif stepcompdate is ""><span class="label label-warning">#stepstatus#</span><cfelse><span class="label label-success">#stepstatus#</span> &nbsp; <a href="javascript:;" rel="popover" data-original-title="#msimpsteptask#" data-content="Step Status: #stepstatus#<br>Date Completed: #dateformat( stepcompdate, 'mm/dd/yyyy')#<br>Completed By: #stepcompbyuser#"><i class="icon-info-sign"></i></a></cfif></td>
																			</tr>
																		</cfloop>
																	</tbody>
																</table>
														</div>
													</cfoutput>
												
												</div><!-- / .tab-content -->
											
											</div><!-- / .tabbable -->								
										
										</div><!-- -/ .span8 -->										
										
									</div>									
								</div>				
								
							</div>				
							
						</div>
						<div style="margin-top:200px;"></div>
					</div>
				
				</div>