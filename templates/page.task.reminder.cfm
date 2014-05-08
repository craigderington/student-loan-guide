
			
			
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
			
			
			
			
			

			<!--- // student loan master task list page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-tasks"></i>							
									<h3>Student Loan Task Reminder for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</cfoutput>
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">						
									
									
									
									
									
									
									
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->