
				
				<cfinvoke component="apis.com.eventservice" method="geteventname" returnvariable="eventname">
					<cfinvokeargument name="eventname" value="#url.event#">
				</cfinvoke>
				
				<div id="masthead">
					
					<div class="container">
						
						<div class="masthead-pad">
							<cfoutput>
								<div class="masthead-text">
									<h2>#eventname#</h2>
									<cfif trim(eventname) is "Dashboard"><p>You are currently working on <a href="##">14 leads</a>, with <a href="##">37 total tasks</a>.</p><cfelseif trim(eventname) is "Calendar"><p>You have <a href="##">14 appointments today</a> and <a href="##">29 total appointments</a>.</p></cfif>									
								</div> <!-- // .masthead-text -->
							</cfoutput>
						</div>
						
					</div> <!-- // .container -->	
					
				</div> <!-- // .masthead -->