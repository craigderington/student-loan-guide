	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.librarygateway" method="getformslist" returnvariable="formslist">
				<cfinvokeargument name="companyid" value="#leaddetail.companyid#">
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
										<i class="icon-file-alt"></i>							
										<h3>Forms Library</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">

									<cfif formslist.recordcount gt 0>
									
										<table class="table table-bordered table-highlight">
											<thead>
												<tr>
													<cfif isuserinrole( "admin" )>
													<th width="10%">Actions</th>
													<cfelse>
													<th width="5%">Actions</th>
													</cfif>
													<th width="30%">Document Name</th>
													<th>Description</th>
													<th>Date</th>												
												</tr>
											</thead>
											<tbody>
												<cfoutput query="formslist" group="doccat">
												<tr style="background-color:##f2f2f2;">
													<td colspan="4"><strong>#doccat#</strong></td>
												</tr>											
													<cfoutput>
													<tr>												
														<td>
															<a href="library/forms/#docpath#" class="btn btn-mini btn-warning" target="_blank">
																<i class="btn-icon-only icon-ok"></i>									
															</a>															
														</td>
														<td>#docname#</td>
														<td>#docdescr#</td>
														<td>#dateformat( docdate, "mm/dd/yyyy" )#</td>												
													</tr>
													</cfoutput>
												</cfoutput>
											</tbody>
										</table>
									
									<cfelse>
									
										<div class="alert alert-block alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i> NO FORMS FOUND!</strong>  
											<p>Sorry, no library form records were found in the database.  Please check back later...  Once your solution plan has been created, all necessary student loan forms will be made available for download an use.</p>
											<p><cfoutput>#session.companyid#</cfoutput>
									</cfif>		
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<cfif formslist.recordcount lt 10>
						<div style="margin-top:650px;"></div>
					<cfelse>
						<div style="margin-top:350px;"></div>
					</cfif>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		