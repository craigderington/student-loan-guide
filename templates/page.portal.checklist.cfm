	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfparam name="today" default="">
			<cfset today = createodbcdatetime( now() ) />
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The client enrollment fee schedule has been successfully created.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The enrollment fee was successfully deleted from the client's schedule.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  There was a problem with the selected document record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>	
						
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-check"></i>							
										<h3>Your Student Loan Checklist</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">

									<div class="tab-content">
												
										<div class="tab-pane active" id="tab1">
											
											<div style="margin-top:20px;margin-left:50px;">
											
												<cfoutput>											
												<p><i class="icon-check-empty"></i> Checklist Item 1 <small><span style="margin-left:125px;">Completed On: #dateformat( today, "mm/dd/yyyy" )#</span></small></p>
												<p><i class="icon-check-empty"></i> Checklist Item 2</p>
												<p><i class="icon-check-empty"></i> Checklist Item 3</p>
												<p><i class="icon-check-empty"></i> Checklist Item 4</p>
												<p><i class="icon-check-empty"></i> Checklist Item 5</p>
												<p><i class="icon-check-empty"></i> Checklist Item 6</p>
												<p><i class="icon-check-empty"></i> Checklist Item 7</p>
												<p><i class="icon-check-empty"></i> Checklist Item 8</p>
												<br /><br />
												<p><small><i class="icon-calendar"></i> Last Updated: #dateformat( today, "long" )#</small></p>
												
												</cfoutput>
												

													<br />
													<br />
													<br />			
													<br />
													<br />
													<br />
											</div>		
													
										</div> <!-- / .tab1 -->										 
											
									</div> <!-- / .tab-content -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:335px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		