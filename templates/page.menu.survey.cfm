
		
		
		<cfinvoke component="apis.com.clients.surveygateway" method="getsurvey" returnvariable="survey1">


		<!--- // menu system data - survey --->
		
		
		<div class="main">	
				
			<div class="container">
					
				<div class="row">
			
					<div class="span12">
					
					<cfif structkeyexists(url, "msg")>						
							<div class="row">
								<div class="span12">
									<cfif url.msg is "saved">
										<div class="alert alert-notice">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>Success!</strong>  The student loan question was successfully updated.  Please select another question to continue...
										</div>									
									</cfif>
								</div>								
							</div>							
						</cfif>	
							
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-copy"></i>							
								<h3>Manage Student Loan Questionnaire</h3>						
							</div> <!-- //.widget-header -->
								
							<div class="widget-content">						
								
								<table class="table table-bordered table-striped table-highlight">
									<thead>
										<tr>
											<th>Actions</th>
											<th style="text-align:center;">SLQID</th>
											<th>Survey Question</th>
											<th>Status</th>											
										</tr>
									</thead>
									<tbody>
										<cfoutput query="survey1">										
										<tr>											
											<td class="actions">											
														
													<a href="#application.root#?event=#url.event#.edit&surveyid=#slqid#" class="btn btn-small btn-primary">
														<i class="btn-icon-only icon-pencil"></i>										
													</a>
													<!---
													<a href="#application.root#?event=#url.event#" class="btn btn-small btn-inverse">
														<i class="btn-icon-only icon-trash"></i>										
													</a>
													--->
											</td>											
											<td style="text-align:center;">#slqid#</td>
											<td>#slqtext#</td>
											<td><cfif active eq 1><span class="label label-success">ACTIVE</span><cfelse><span class="label label-important">INACTIVE</span></cfif></td>											
										</tr>
										</cfoutput>
									</tbody>
								</table>	

								<div class="clear"></div>
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->			
				
				
				<div style="height:100px;"></div>			
				
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->