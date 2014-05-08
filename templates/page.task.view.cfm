
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadtasks" returnvariable="tasklist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.tasks.taskgateway" method="gettask" returnvariable="taskdetail">
				<cfinvokeargument name="taskid" value="#url.taskid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.tasks.taskgateway" method="gettaskreminder" returnvariable="taskreminder">
				<cfinvokeargument name="taskid" value="#url.taskid#">
			</cfinvoke>
			
			<cfparam name="gotopage" default="">
				<cfif taskdetail.mtaskname contains "reason for inquiry">
					<cfset gotopage = "#application.root#?event=page.summary" />
				<cfelseif taskdetail.mtaskname contains "contact information">
					<cfset gotopage = "#application.root#?event=page.summary" />
				<cfelseif taskdetail.mtaskname contains "outcome">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "debt balance">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "monthly payment">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "loans selected">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "loan status">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "enrollment documents">
					<cfset gotopage = "#application.root#?event=page.enroll.status" />
				<cfelseif taskdetail.mtaskname contains "specialist assigned">
					<cfset gotopage = "#application.root#?event=page.enroll" />
				<cfelseif taskdetail.mtaskname contains "fee schedule">
					<cfset gotopage = "#application.root#?event=page.fees" />
				<cfelse>
					<cfset gotopage = "#application.root#?event=page.summary" />
				</cfif>
			
			
			<!--- // additonal stylesheet for large support buttons --->
			<link href="./js/plugins/faq/faq.css" rel="stylesheet"> 
			
			
			

			<!--- // student loan view task detail page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span8">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-tasks"></i>							
									<h3>Student Loan Task: #taskdetail.mtaskname# for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</cfoutput>
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">						
									
									<table width="100%"  border="0" cellspacing="0" cellpadding="7">
										<cfoutput>
										<tr>
											<td colspan="2" width="25%"><a href="#application.root#?event=page.tasks" class="label label-default" style="padding:7px;"><i class="icon-circle-arrow-left"></i> Return to Task List</a><a href="#gotopage#" class="label label-info" style="padding:7px;margin-left:7px;"><i class="icon-circle-arrow-right"></i> Go To Task</a>
											<a href="#application.root#?event=page.task.edit&taskid=#taskdetail.taskuuid#" style="padding:7px;margin-left:7px;" class="label label-success"><i class="icon-save"></i> Edit Task</a><a href="javascript:void;" style="padding:7px;margin-left:7px;" class="label label-warning"><i class="icon-calendar"></i> View Task Reminders</a><a href="javascript:void;" style="padding:7px;margin-left:7px;" class="label label-inverse"><i class="icon-calendar"></i> Create Reminder</a>
											</td>											
										</tr>
										</cfoutput>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<cfoutput query="taskdetail">
										<tr>
											<td width="25%"><div align="right">ID:</div></td>
											<td width="75%">#taskuuid#</td>
										</tr>
										<tr>
											<td><div align="right">Task Name: </div></td>
											<td>#mtaskname#</td>
										</tr>
										<tr>
											<td><div align="right">Task Description: </div></td>
											<td>#mtaskdescr#</td>
										</tr>
										<tr>
											<td><div align="right">Status:</div></td>
											<td>#taskstatus#</td>
										</tr>
										<tr>
											<td><div align="right"></div></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td><div align="right">Due Date: </div></td>
											<td>#dateformat( taskduedate, 'mm/dd/yyyy' )#</td>
										</tr>
										<tr>
											<td><div align="right">Last Updated: </div></td>
											<td>#dateformat( tasklastupdated, 'mm/dd/yyyy' )#</td>
										</tr>
										<tr>
											<td><div align="right"></div></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td><div align="right">Task Notes: </div></td>
											<td><cfif tasknotes is "">None Entered<cfelse>#tasknotes#</cfif></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>										
										</cfoutput>
									</table>
									
									
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span8 -->
						
						
						<!--- // right sidebar --->
						<div class="span4">
					
							<div class="widget widget-plain">
								
								<div class="widget-content">									
									<cfoutput>
										<a href="#application.root#?event=page.task.edit&taskid=#taskdetail.taskuuid#" class="btn btn-large btn-secondary btn-support-ask">Edit This Task</a>
										<a href="#application.root#?event=page.task.reminder&taskid=#taskdetail.taskuuid#" class="btn btn-large btn-default btn-support-ask">Create Task Reminder</a>
										<a href="#application.root#?event=page.task.create" class="btn btn-large btn-primary btn-support-ask">Create New Task</a>				
										<a href="#application.root#?event=page.tasks" class="btn btn-large btn-tertiary btn-support-ask">View Client Tasks</a>														
									</cfoutput>							
								</div> <!-- /widget-content -->
									
							</div> <!-- /widget -->
							
							
							
							<div class="widget stacked widget-box">
								
								<div class="widget-header">	
									<h3>Client Task List</h3>			
								</div> <!-- /widget-header -->
								
								<div class="widget-content">
									
									<ul class="news-items">
									<cfoutput query="tasklist" maxrows="5">		
									<li>
										<div class="news-item-detail">										
											<a href="#application.root#?event=page.task.edit&taskid=#tasklist.taskuuid#" class="news-item-title">#tasklist.mtaskname#</a>
											<p class="news-item-preview"><span class="label label-<cfif trim( tasklist.taskstatus ) is "assigned">important<cfelseif trim( taskstatus ) is "in progress">info<cfelseif trim( taskstatus ) is "completed">success</cfif>">#tasklist.taskstatus#</span>&nbsp;<span class="label label-inverse">#dateformat( tasklist.tasklastupdated, 'mm/dd/yyyy' )#</span></p>
										</div>									
									</li>
									</cfoutput>
								</ul>
									
								</div> <!-- /widget-content -->
								
							</div> <!-- /widget -->
							
						</div> <!-- /span4 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->