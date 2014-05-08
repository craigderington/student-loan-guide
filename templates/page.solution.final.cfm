	
		
		
		<!--- // make the application sleep for a few second in order for the solution presentation document to load and update the solutions as completed --->
		
		<cfscript>
			thread = createobject( "java", "java.lang.Thread" );
			thread.sleep(10000);
		</cfscript>
		
	
		<!--- // get our data access objects --->
		
		<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
			
		<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
			
		<cfinvoke component="apis.com.solutions.solutiongateway" method="getcompletedsolutions" returnvariable="completedsolutions">
			<cfinvokeargument name="leadid" value="#session.leadid#">
			<cfinvokeargument name="solcomp" value="1">
		</cfinvoke>
		
		
		<!--- // delete solution if selected by student loan specialist --->
		<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletesolution">
			<cfparam name="solutionid" default="">
			<cfif structkeyexists( url, "solutionid" ) and isvalid( "uuid", url.solutionid )>
				<cfset solutionid = url.solutionid />
					
					<cfquery datasource="#application.dsn#" name="getworksheet">
						select solutionworksheetid
						  from solution
						 where solutionuuid = <cfqueryparam value="#solutionid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>		
				
					<cfquery datasource="#application.dsn#" name="killsolution">
						delete
						  from solution
						 where solutionuuid = <cfqueryparam value="#solutionid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
					
					<cfquery datasource="#application.dsn#" name="saveworksheet">
						update slworksheet
						   set completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						 where worksheetid = <cfqueryparam value="#getworksheet.solutionworksheetid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">
			</cfif>
		</cfif>
		
		
		
		
		
		
		<div class="main">
			<div class="container">
				<div class="row">
					<div class="span12">

						<!--- // system messages --->
						<cfif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SUCCESS!</strong>  The selected solution was successfully deleted from the client's profile.  Please navigate to the option tree to find a new solution for the selected loan...
										</div>										
									</div>								
								</div>
						</cfif>
						
						<div class="widget stacked">
							
							<cfoutput>
							<div class="widget-header">		
								<i class="icon-book"></i>							
									<h3>Solution Presentation Completed for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
							</div> <!-- //.widget-header -->
							</cfoutput>
							
							<div class="widget-content">
									
								<cfif completedsolutions.recordcount gt 0>
								
									<div class="alert alert-block alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<h4><strong><i class="icon-check"></i> SOLUTION PRESENTATION COMPLETE!</strong></h4>
										<p>The student loan solution presentation is now complete.  Please either select <i>"Generate Implementation Plan"</i> to create the implementation plan for the selected client solutions; or select <i>"Close Client File"</i> to finish working with this client.</p> 
									</div>						
									
									<table class="table table-bordered table-striped">
										<thead>
											<tr>															
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" ) or isuserinrole( "sls" )>
												<th class="actions">Remove</th>
												</cfif>
												<th>Servicer</th>												
												<th>Chosen Solution</th>
												<th>Loan Type</th>
												<th>Solution Date</th>
											</tr>
										</thead>
										<tbody>
										<cfoutput query="completedsolutions">
											<tr>																												
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" ) or isuserinrole( "sls" )>
												<td><a href="#application.root#?event=#url.event#&fuseaction=deletesolution&solutionid=#solutionuuid#" onclick="return confirm('Are you sure you want to delete this solution?  This action can not be undone.');" class="btn btn-mini btn-secondary"><i class="btn-icon-only icon-remove"></i></a></td>
												</cfif>
												<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>												
												<td>#solutionsubcat# #solutionoption#</td>
												<td>#codedescr#</td>
												<td>#dateformat( solutiondate, "mm/dd/yyyy" )#</td>
											</tr>
										</cfoutput>
										</tbody>
									</table>
								
								

									<cfoutput>	
										<cfif completedsolutions.recordcount gt 0>
											<cfif leaddetail.leadimp eq 1>
												<a href="#application.root#?event=page.create.plan" class="btn btn-medium btn-primary"><i class="icon-cogs"></i> Generate Implementation Plan</a>
											</cfif>
										</cfif>
										
										<a href="#application.root#?event=page.close" class="btn btn-medium btn-secondary" style="margin-left: 5px;"><i class="icon-remove-circle"></i> Close Client File</a> <cfif structkeyexists( url, "msg" )><a href="#application.root#?event=page.tree" style="margin-left: 5px;" class="btn btn-medium btn-tertiary"><i class="icon-sitemap"></i> Go To Option Tree</a></cfif> <a href="#application.root#?event=page.tasks" style="margin-left: 5px;" class="btn btn-medium btn-default"><i class="icon-tasks"></i> View Client Tasks</a>
									</cfoutput>
								
								<cfelse>
								
									
									<cfoutput>								
										<a href="#application.root#?event=page.close" class="btn btn-medium btn-secondary" style="margin-left: 5px;"><i class="icon-remove-circle"></i> Close Client File</a> <cfif structkeyexists( url, "msg" )><a href="#application.root#?event=page.tree" style="margin-left: 5px;" class="btn btn-medium btn-tertiary"><i class="icon-sitemap"></i> Go To Option Tree</a></cfif> <a href="#application.root#?event=page.tasks" style="margin-left: 5px;" class="btn btn-medium btn-default"><i class="icon-tasks"></i> View Client Tasks</a>
									</cfoutput>
								
								
								</cfif>
								
								
							</div><!-- ./widget-content -->
							
							
						</div>
					</div>		
				</div>
				<div style="height:275px;"></div>
			</div>
		</div>