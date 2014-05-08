


			<!--- // get our data access components --->
			<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboard" returnvariable="mydashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.users.usergateway" method="getloginsummary" returnvariable="qloginsum">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.users.usergateway" method="getloginsbymonth" returnvariable="qloginmonths">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
				
			<!--- Testing the use of partials in the templating engine --->
			<cfif not isuserinrole( "bclient" )>
				<div class="widget stacked widget-box">											
				
				
					<div class="widget-header">
						<i class="icon-tasks"></i>
							<h3>Additional Info</h3>
					</div> <!-- /widget-header -->										
							
					<div class="widget-content">
						
						<ul>
							<cfoutput>
								<li> Total Leads: #mydashboard.totalleads#</li>
								<li> Clients Enrolled: #mydashboard.totalclients#</li>
								<li> Total Loans: #mydashboard.totalloans#</li>
								<li> Active Reminders: 18</li>
							</cfoutput>
						</ul>						
					</div>					
				</div> <!-- /widget -->
			
			</cfif>
			
			<div class="widget stacked widget-box">											
				
				<div class="widget-header">
					<i class="icon-desktop"></i>
						<h3>Login Summary</h3>
				</div> <!-- /widget-header -->										
						
				<div class="widget-content">					
					
					<h5>From IP</h5>
						<ul>
							<cfoutput query="qloginsum">
								<li>#loginip#:&nbsp;#totallogins#</li>							
							</cfoutput>					
						</ul>
					
					<br />
					
					<h5>By Month and Year</h5>
						<ul>
							<cfoutput query="qloginmonths">
								<li>#monthasstring( thismonth )#&nbsp;#thisyear#:&nbsp;#totalmonths#</li>							
							</cfoutput>					
						</ul>
					
				</div>					
			</div> <!-- /widget -->