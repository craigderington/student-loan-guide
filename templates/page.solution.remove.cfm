

			
			
			<!--- // get our data access components --->		
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutiondetails" returnvariable="solutiondetails">		
				<cfinvokeargument name="sid" value="#url.sid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutiontasks" returnvariable="solutiontasks">
				<cfinvokeargument name="sid" value="#url.sid#">
			</cfinvoke>
				
				
				
				
			<!--- // create the form  to remove the solution from the cart --->	
			<div class="main">
			
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
									<div class="widget-header">		
										<i class="icon-book"></i>							
										<h3>Remove Student Loan Solution from Solution Cart</h3>						
									</div> <!-- /.widget-header -->
								</cfoutput>
								
								
								<div class="widget-content">						
									
									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->											
											<cfset solutionuuid = #form.solutionuuid# />											
											<cfset today = #CreateODBCDateTime(now())# />
											
											<cfquery datasource="#application.dsn#" name="thissolution">
												select solutionid, solutionuuid, solutionworksheetid
												  from solution
												 where solutionuuid = <cfqueryparam value="#solutionuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												   and leadid = <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<!--- // remove the solution --->
											<cfquery datasource="#application.dsn#" name="killsolution">
												delete
												  from solution
												 where solutionid = <cfqueryparam value="#thissolution.solutionid#" cfsqltype="cf_sql_integer" />
											</cfquery>

											<!--- // update the worksheet to make sure we are unchecking to include in a consolidation --->
											<cfquery datasource="#application.dsn#" name="cascadeworksheet">
												update slworksheet
												   set incconsol = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
												 where worksheetid = <cfqueryparam value="#thissolution.solutionworksheetid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# removed a solution from the student loan cart in the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>										

											<cflocation url="#application.root#?event=page.solution&msg=deleted" addtoken="no">
								
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
									
									
									<div class="tab-pane active" id="killjob">
										<cfoutput>	
										<form id="killsolution-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&sid=#solutiondetails.solutionuuid#">
											<fieldset>									
												
												<div class="form">
													<h5>Are you absolutley sure you want to remove <strong><i>#solutiondetails.solutionoption#</i></strong> from the cart?  
													<br />
													<h6>Option Tree: <cfif solutiondetails.solutionoptiontree eq 1>Direct Loan<cfelseif solutiondetails.solutionoptiontree eq 2>Stafford Loan<cfelseif solutiondetails.solutionoptiontree eq 2><cfelseif solutiondetails.solutionoptiontree eq 3>Perkins Loan<cfelseif solutiondetails.solutionoptiontree eq 4>Direct Consolidation<cfelseif solutiondetails.solutionoptiontree eq 5>Health Professional<cfelseif solutiondetails.solutionoptiontree eq 6>Parent PLUS<cfelseif solutiondetails.solutionoptiontree eq 7>Private Loan</cfif><br />
													    Solution ID: #solutiondetails.solutionuuid# <br />
													    Servicer:  #solutiondetails.servname# <br />
														Balance: #dollarformat( solutiondetails.loanbalance )# <br />
														Account Number: #solutiondetails.acctnum#</h6>
													
													<br /><br />
													<cfif solutiontasks.recordcount eq 0>
														<h5 style="font-weight:bold;color:green;"><i class="icon-ok-sign"></i> You will be able to easily attach a new solution for the selected debt worksheet...</h5>												
													<cfelse>
														<h5 style="font-weight:bold;color:red;"><i class="icon-warning-sign"></i> The selected solution can not be deleted because there <cfif solutiontasks.recordcount gt 1> are #solutiontasks.recordcount# tasks currently assigned to this record<cfelse>is 1 task currently assigned to this record</cfif>.  Please delete the tasks first before removing the solution.</h5>
													</cfif>
												
												</div>											
													
												<br /><br />
														
												<div class="form-actions">													
													<cfif solutiontasks.recordcount eq 0>
													<button type="submit" class="btn btn-danger" name="killjob"><i class="icon-remove-sign"></i> Remove Solution</button>																										
													</cfif>
													<a name="cancel" class="btn btn-secondary" onclick="location.href='#cgi.http_referer#'"><i class="icon-circle-arrow-left"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">
													<input type="hidden" name="solutionuuid" value="#solutiondetails.solutionuuid#" />
													<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="solutionuuid|'The unique solution identifier' is required to remove the selected solution from the cart..." />												
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

			</div><!-- -/ .main -->
			