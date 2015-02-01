
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadtasks" returnvariable="tasklist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="gettaskprogress" returnvariable="taskprogress">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfparam name="progresspercent" default="">
			<cfset progresspercent = ( taskprogress.taskcomp / taskprogress.totaltasks ) * 100.00 />
			<cfset progresspercent = numberformat( progresspercent, "999.99" ) />
			
			
			<link href="./css/pages/reports.css" rel="stylesheet">
			

			<!--- // student loan master task list page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<!--- // show system messages --->
						<cfif structkeyexists(url, "msg") and url.msg is "taskupdated">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The selected task details have been successfully updated.  Please select a task to continue...
									</div>										
								</div>								
							</div>							
						</cfif>
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-tasks"></i>							
									<h3>Student Loan Task List for #leaddetail.leadfirst# #leaddetail.leadlast# </h3>
									</cfoutput>
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">		
									
									
									<!--- // show the task stats --->
									
									<div id="big_stats" class="cf">
										<cfoutput>
											<div class="stat">								
												<h4>Tasks Assigned</h4>
												<span class="value">#taskprogress.taskassigned#</span>								
											</div> <!-- .stat -->
											
											<div class="stat">								
												<h4>Tasks In Progress</h4>
												<span class="value">#taskprogress.taskinpg#</span>								
											</div> <!-- .stat -->
											
											<div class="stat">								
												<h4>Tasks Pending</h4>
												<span class="value">#taskprogress.taskpend#</span>								
											</div> <!-- .stat -->
											
											<div class="stat">								
												<h4>Tasks Completed</h4>
												<span class="value">#taskprogress.taskcomp#</span>								
											</div> <!-- .stat -->
										</cfoutput>
									</div>
									
									
										
									<!--- // show the task progress bar --->
									<cfoutput>
										<div class="progress progress-primary progress-striped active">
											<div class="bar" style="width: #progresspercent#%"></div> <!-- /.bar -->				
										</div>
									</cfoutput>
									
									<cfif not isuserinrole( "bclient" )>
										<cfoutput>
											<cfif not structkeyexists( url, "filter" )>
												<span style="margin-top:-15px;margin-bottom:5px;" class="pull-right"><a href="#application.root#?event=#url.event#&filter=true" class="btn btn-mini btn-inverse"><i class="icon-reorder"></i> Show Task Filter</a></span>
											<cfelse>
												<span style="margin-top:-15px;margin-bottom:5px;" class="pull-right"><a href="#application.root#?event=#url.event#" class="btn btn-mini btn-inverse"><i class="icon-reorder"></i> Hide Task Filter</a></span>
											</cfif>
										</cfoutput>
									</cfif>
									
									<!--- // report filter --->									
									<cfif structkeyexists( url, "filter" ) and url.filter is true>	
										<cfoutput>
											<div class="well">
												<p><i class="icon-tasks"></i> <strong>Filter Tasks</strong></p>
													
													<form class="form-inline" method="post" action="#cgi.script_name#?event=#url.event#&filter=#url.filter#">													
														
														<label class="radio">
															<input style="margin-left:25px;" name="rgtasktype" type="radio" value="E" <cfif isdefined( "form.rgtasktype" ) and trim( form.rgtasktype ) is "E">checked</cfif> onclick="javascript:this.form.submit();" /> <strong>Enrollment</strong>
														</label>
														<label class="radio">
															<input style="margin-left:25px;" name="rgtasktype" type="radio" value="N" <cfif isdefined( "form.rgtasktype" ) and trim( form.rgtasktype ) is "N">checked</cfif> onclick="javascript:this.form.submit();" /> <strong>Intake</strong>
														</label>
														<label class="radio">
															<input style="margin-left:25px;" name="rgtasktype" type="radio" value="O" <cfif isdefined( "form.rgtasktype" ) and trim( form.rgtasktype ) is "O">checked</cfif> onclick="javascript:this.form.submit();" /> <strong>Advisory</strong>
														</label>
														<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
														<input type="hidden" name="filtertasks" value="YES" />
														<cfif isdefined( "form.rgtasktype" )>
															<a href="#application.root#?event=page.tasks" class="btn btn-mini btn-secondary" style="margin-left:55px;"><i class="icon-retweet"></i> Reset Task List</a>
														</cfif>

														
													</form>
											</div>
											</cfoutput>
										</cfif>
										<!--- // end filter --->
									
									
									
									
								
														
									
										<cfif tasklist.recordcount gt 0>
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<cfif not isuserinrole( "bclient" )><th width="15%">Actions</th></cfif>
														<th>Type</th>
														<th>Name</th>
														<th>Status</th>
														<th>Task Date</th>
														<th>Last Update</th>
													</tr>
												</thead>
												<tbody>
													
													<cfoutput query="tasklist">
													
														<cfparam name="gotopage" default="">
															<cfif mtaskname contains "reason for inquiry">
																<cfset gotopage = "#application.root#?event=page.summary" />
															<cfelseif mtaskname contains "contact information">
																<cfset gotopage = "#application.root#?event=page.summary" />
															<cfelseif mtaskname contains "user login">
																<cfset gotopage = "#application.root#?event=page.lead.login" />
															<cfelseif mtaskname contains "outcome">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "debt balance">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "monthly payment">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "loans selected">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "loan status">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "enrollment documents">
																<cfset gotopage = "#application.root#?event=page.enroll.status" />
															<cfelseif mtaskname contains "specialist assigned">
																<cfset gotopage = "#application.root#?event=page.enroll" />
															<cfelseif mtaskname contains "fee schedule">
																<cfset gotopage = "#application.root#?event=page.fees" />
															<cfelseif mtaskname contains "debt worksheet">
																<cfset gotopage = "#application.root#?event=page.worksheet" />
															<cfelseif mtaskname contains "monthly budget">
																<cfset gotopage = "#application.root#?event=page.budget" />
															<cfelseif mtaskname contains "questionnaire">
																<cfset gotopage = "#application.root#?event=page.survey" />
															<cfelseif mtaskname contains "adjusted gross income">
																<cfset gotopage = "#application.root#?event=page.repayments" />															
															<cfelseif (( mtaskname contains "notified" ) or ( mtaskname contains "solution presentation" ))>
																<cfset gotopage = "nontaskpage" />
															<cfelse>
																<cfset gotopage = "#application.root#?event=page.summary" />
															</cfif>
																
																
																<tr>
																	<cfif not isuserinrole( "bclient" )>
																	<td class="actions">																		
																		<a href="#application.root#?event=page.task.view&taskid=#taskuuid#" class="btn btn-mini btn-primary" title="View Task"><i class="btn-icon-only icon-ok"></i></a>																			
																		<a href="#application.root#?event=page.task.edit&taskid=#taskuuid#" class="btn btn-mini btn-secondary" title="Edit Task"><i class="btn-icon-only icon-pencil"></i></a>																		
																		<a href="#application.root#?event=page.task.reminder&taskid=#taskuuid#" class="btn btn-mini btn-default" title="Create Reminder"><i class="btn-icon-only icon-calendar"></i></a>																		
																		<cfif trim( gotopage ) neq "nontaskpage"><a href="#gotopage#" title="Go to Task" class="btn btn-mini btn-tertiary"><i class="btn-icon-only icon-circle-arrow-right"></i></a></cfif>																													
																	</td>
																	</cfif>
																	<td><cfif trim( mtasktype ) is "E"><span class="label label-default">Enrollment</span><cfelseif trim( mtasktype ) is "O"><span class="label label-inverse">Advisory</span><cfelseif trim( mtasktype ) is "N"><span class="label label-warning">Intake</span><cfelseif trim( mtasktype ) is "S"><span class="label label-info">Implementation</span></cfif></td>
																	<td>#mtaskname#</td>
																	<td><span class="label label-<cfif trim( taskstatus ) is "assigned">important<cfelseif trim( taskstatus ) is "completed">success<cfelseif trim( taskstatus ) is "in progress">info</cfif>">#taskstatus#</span></td>
																	<td><cfif taskcompleteddate is ""><span class="label label-warning">#dateformat( taskduedate, 'mm/dd/yyyy' )#</span><cfelse><span class="label label-success">#dateformat( taskcompleteddate, 'mm/dd/yyyy' )#</span></cfif></td>
																	<td><span class="label label-inverse">#dateformat( tasklastupdated, 'mm/dd/yyyy' )#</span></td>
																	
																</tr>
													</cfoutput>
													
												</tbody>
											</table>
									
									
										<cfelse>
									
									
										
											Opps, there seems to be a problem.  The client task list was not been created for this client.  Please contact your administrator.
									
									
										</cfif>
									
									<!--- // pagingation for recordset 
										<div class="pagination">
											<ul>
												<li><a href="javascript:;">Prev</a></li>
												<li class="active"><a href="javascript:;">1</a></li>
												<li><a href="javascript:;">2</a></li>
												<li><a href="javascript:;">3</a></li>
												<li><a href="javascript:;">4</a></li>
												<li><a href="javascript:;">Next</a></li>
											</ul>
										</div>
									--->
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->