
				
				
				<!--- // get our loan servicer detail --->
				<cfinvoke component="apis.com.system.servicers" method="getservicer" returnvariable="srvdetail">				
				
				<!--- define our form variables --->
				<cfparam name="servid" default="">
				<cfparam name="servname" default="">				
				<cfparam name="broadcastmsg" default="">		
				
				
				<!--- // create the loan servicer form --->	
			
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Delete #srvdetail.servname# </h3>						
								</div> <!-- /.widget-header -->
								</cfoutput>
								
								
								<div class="widget-content">						
									
									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->											
											<cfset servid = #form.servid# />
											<cfset servname = #form.servname# />
											<cfset today = #CreateODBCDateTime(now())# />
											
											<cfquery datasource="#application.dsn#" name="killservicer">
												delete 
												  from servicers										 
												 where servid = <cfqueryparam value="#servid#" cfsqltype="cf_sql_integer" />	  
											</cfquery>
											
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# deleted the loan servicer #servname# from the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>										

											<cflocation url="#application.root#?event=page.menu.servicers&msg=deleted" addtoken="no">
								
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#"</cfoutput></li>
														</cfloop>
													</ul>
											</div>
								
										</cfif>
									</cfif>
									
									<!--- // end form processing --->
									
									
									<div class="tab-pane active" id="killservicer">
										<cfoutput>	
										<form id="killervicer-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&srvid=#srvdetail.servid#">
											<fieldset>									
												
												<div class="form">
													<h5>Are you absolutley sure you want to delete loan servicer <strong>#srvdetail.servname#</strong>?  
													<br />
													<h4>Loan Servicer ID: #srvdetail.servid#</h4>
													
													<br /><br />
													<h5 style="font-weight:bold;color:red;"><i class="icon-warning-sign"></i> This action can not be undone...</h5>												
												</div>											
													
												<br /><br />
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-danger" name="killservicer"><i class="icon-save"></i> Delete Loan Servicer</button>																										
													<a name="cancel" class="btn btn-secondary" onclick="location.href='#application.root#?event=page.menu.servicers'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">												
													<input type="hidden" name="servid" value="#srvdetail.servid#" />
													<input type="hidden" name="servname" value="#srvdetail.servname#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="servid|'Loan Servicer ID' is a required field.;" />												
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->
					
					<div style="margin-top: 250px;"></div>
				
				</div><!-- /container -->