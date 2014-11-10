













					
						
						
						<div class="main">
						
							<div class="container">
							
								<div class="row">
								
									<div class="span12">
						
										<div class="widget stacked">
										
											<div class="widget-header">
												<i class="icon-cogs"></i> 
												<h3>Student Loan Advisor Online | System Information | Vanco Web Services | Service Logout</h3>											
											</div>
											
											<div class="widget-content">
											
											
													<!--- // set each web service to inactive
															 so we can login the next day 
															 and get new session and request id's --->						 
															 
													<cfquery datasource="#application.dsn#" name="getactivewebservices">
														select webserviceid, companyid, webserviceclientid, webserviceisactive, webservicerequesttype
														  from webservice
														 where webserviceisactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
														   and webservicerequesttype = <cfqueryparam value="login" cfsqltype="cf_sql_varchar" /> 
													</cfquery>
													
													<cfif getactivewebservices.recordcount gt 0>
														
														
														<cfloop query="getactivewebservices">
															
															<cfset wsid = getactivewebservices.webserviceid />
																
																<cfquery datasource="#application.dsn#" name="updatewebservice">
																	update webservice
																	   set webserviceisactive = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																	 where webserviceid = <cfqueryparam value="#wsid#" cfsqltype="cf_sql_integer" />								  
																</cfquery>
																
																<!--- // update any additional vanco services --->
																<cfquery datasource="#application.dsn#" name="getvancoservices">
																	 select webserviceid
																	   from webservice
																	  where companyid = <cfqueryparam value="#getactivewebservices.companyid#" cfsqltype="cf_sql_integer" />
																		and webserviceprovidername = <cfqueryparam value="Vanco" cfsqltype="cf_sql_varchar" />
																		and ( 
																			   webservicerequesttype = <cfqueryparam value="efttransparentredirect" cfsqltype="cf_sql_varchar" />
																		 or    webservicerequesttype = <cfqueryparam value="eftaddcompletetransaction" cfsqltype="cf_sql_varchar" /> 
																			)
																</cfquery>
																
																<cfloop query="getvancoservices">
																	<cfquery datasource="#application.dsn#" name="setallservicesinactive">
																		update webservice
																		   set webserviceisactive = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																		 where webserviceid = <cfqueryparam value="#getvancoservices.webserviceid#" cfsqltype="cf_sql_integer" />				
																	</cfquery>
																</cfloop>
																
																
																
																
														</cfloop>
														
														<!-- // output the service client id of the logged out services --->
														<cfoutput query="getactivewebservices">
															<div style="margin-bottom:5px;">
																<h5><i class="icon-cogs"></i>  &nbsp; <small>#getactivewebservices.webserviceclientid# :: #getactivewebservices.webservicerequesttype# service is now logged out...The web service is now inactive.</small></h5>
															</div>					
														</cfoutput>									
												
												
													<cfelse>				
														
														
														<h5><i class="icon-info-sign"></i> No active web services responded to the query...  Operation aborted.</h5>
														
														
													</cfif>
													
													<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
														<cfoutput>														
															<a href="#application.root#?event=page.settings.webservices" class="btn btn-small btn-secondary" style="margin-top:25px;margin-left:10px;"><i class="icon-circle-arrow-left"></i> Back to Web Services</a>
															<a href="#application.root#?event=page.settings" class="btn btn-small btn-primary" style="margin-top:25px;margin-left:5px;"><i class="icon-cogs"></i> Company Settings</a>
															<a href="#application.root#?event=page.admin" class="btn btn-small btn-default" style="margin-top:25px;margin-left:5px;"><i class="icon-list-alt"></i> Administration</a>
														</cfoutput>
													</cfif>										
													
													
											</div><!--/ .widget-content -->
											
										</div><!-- / .widget -->
										
									</div><!-- / .span12 -->
									
								</div><!-- / .row -->
								<cfif getactivewebservices.recordcount lt 10 >
									<div style="margin-top:300px;"></div>
								</cfif>
								
							</div><!-- / .container -->
							
						</div><!-- / .main -->