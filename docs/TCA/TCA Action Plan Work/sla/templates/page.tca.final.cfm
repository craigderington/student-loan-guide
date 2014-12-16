






			<!--- // Take Charge America Workflow --->
			
			
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsurvey" returnvariable="clientsurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
				
				
				
			
					<cfoutput>
						<div class="main">	
							
							<div class="container">
								
								<div class="row">
						
									<div class="span8">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-sitemap"></i>							
												<h3>Take Charge America &raquo; Print Action Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">									
											
												<br />
																	
																							
											
											
											</div>
										</div>
									</div>
									
									
									
									
									
									
									
									
									
									
									
									
									<!--- // 11-18-2014 // add sidebar --->
									
									<div class="span4">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-list-alt"></i>							
												<h3>The Solutions You've Selected</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
											
												{{{ solution summary }}}
												
												
												
												
												
												
											
											</div>
										</div>
										
																	
										
									</div>									
								</div>
								<div style="margin-top:150px;"></div>
							</div>
						</div>
					</cfoutput>