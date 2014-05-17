


			<!--- // get our data access components --->		
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.implementation.implementgateway" method="getsolutiongroupbyservicer" returnvariable="solutiongroupbyservicer">
				<cfinvokeargument name="leadid" value="#session.leadid#">				
			</cfinvoke>
			
			<!--- // set a few params --->
			<cfparam name="today" default="">
			<cfparam name="arrsolutionlist" default="">
			<cfparam name="counter" default="0">
			<cfparam name="statucode" default="">
			<cfset today = now() />
			<cfset statuscode = "C" />
			
			
			<!--- // add some client side js to toggle check all --->
			<script type="text/javascript">				
				function do_this(){

					var checkboxes = document.getElementsByName('chksolutionlist');
					var button = document.getElementById('toggle');

					if(button.value == 'Check All'){
						for (var i in checkboxes){
							checkboxes[i].checked = 'FALSE';
						}
						button.value = 'Uncheck All'
					}else{
						for (var i in checkboxes){
							checkboxes[i].checked = '';
						}
						button.value = 'Check All';
					}
				}
			</script>
			
			
			
			<div class="main">
			
				<div class="container">
				
					<div class="row">
					
						<div class="span12">
							
							<div class="widget stacked">
								
								
								<cfoutput>
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>Create Implementation Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>									
									</div><!-- / .widget-header -->
								</cfoutput>
														
								
								
								<div class="widget-content">
								
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									<!--- // begin form processing --->
									<cfif isDefined( "form.fieldnames" )>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>										
											
											<cfset arrsolutionlist = listtoarray( form.chksolutionlist, "," ) />
											<cfset arrservicerid = listtoarray( form.servid ) />
											<cfset arrsolutionoption = listtoarray( form.solutionoption ) />
											<cfset arrsolutionsubcat = listtoarray( form.solutionsubcat ) />
											<cfset arrsolutionoptiontree = listtoarray( form.optiontree ) />
											
												<!--- // loop over the array and insert our plans --->
												<cfloop from="1" to="#arraylen( arrsolutionlist )#" index="j" step="1">					
													
													<!--- // create implementation plan --->
													<cfquery datasource="#application.dsn#" name="createplan">
														insert into implement(planuuid, servid, leadid, solutionid, solutionoption, solutionsubcat, impstartdate, impcompleted)
															values(																   
																   <cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																   <cfqueryparam value="#arrservicerid[j]#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																   <cfqueryparam value="#replace( arrsolutionlist[j], ":", ",", "all" )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
																   <cfqueryparam value="#trim( arrsolutionoption[j] )#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#trim( arrsolutionsubcat[j] )#" cfsqltype="cf_sql_varchar" />,
																   <cfqueryparam value="#createodbcdatetime( today )#" cfsqltype="cf_sql_timestamp" />,
																   <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																  ); select @@identity as newimpid
													</cfquery>												
														
														<!--- // get the implementation steps --->
														<cfquery datasource="#application.dsn#" name="getsteps">
															select msimpstepid, msimpcat, msimptype, msimpstepcat, msimpstepstat
															  from masterstepsimpl
															 where msimpcat like <cfqueryparam value="%#trim( arrsolutionoptiontree[j] )#%" cfsqltype="cf_sql_varchar" />
															   and msimptype like <cfqueryparam value="#trim( arrsolutionoption[j] )#" cfsqltype="cf_sql_varchar" />
															   and msimpstepcat like <cfqueryparam value="#trim( arrsolutionsubcat[j] )#" cfsqltype="cf_sql_varchar" />
															   and msimpstepstat = <cfqueryparam value="#trim( statuscode )#" cfsqltype="cf_sql_char" />
														  order by msimpstepid asc
														</cfquery>
													
														
														<!--- // nested loop // loop the implementation steps for the plan --->
														<cfloop query="getsteps">				
															<!--- // add the implementation steps --->				
															<cfquery datasource="#application.dsn#" name="addimplsteps">
																insert into leadimplementsteps(leadimpplanuuid, implementid, msimpstepid, stepassigndate)
																	values(
																			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																			<cfqueryparam value="#createplan.newimpid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#getsteps.msimpstepid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#createodbcdatetime( today )#" cfsqltype="cf_sql_timestamp" />									   
																		  );
															</cfquery>					
															
														</cfloop>											
														
														<!--- // update the solution to set the flag for implementation plan created --->
														<cfquery datasource="#application.dsn#" name="saveplans">
															update solution
															   set solutionplancreated = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
															 where solutionid IN( <cfqueryparam value="#replace( arrsolutionlist[j], ":", ",", "all" )#" cfsqltype="cf_sql_integer" list="yes" /> )
														</cfquery>
														
														
												</cfloop>						
											
												<cfset session.leadimp = 1 />									
												
												<!--- // then redirect to the next step in the process --->														
												<cflocation url="#application.root#?event=page.solution.implement" addtoken="no">	
											
											

											<!---<cfdump var="#arrsolutionlist#" label="Solution List">--->
											
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
															
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
														<ul>
															<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
																<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#</cfoutput></li>
															</cfloop>
														</ul>
											</div>				
															
										</cfif>										
															
									</cfif>
									<!--- // end form processing --->
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
									
									<cfif solutiongroupbyservicer.recordcount gt 0>
									
										<form class="form-horizontal" name="solutiongroupbyservicer" method="post">
											
											<fieldset>
											
												<h5 style="margin-bottom:7px;color:#ff0000;"><i class="icon-bookmark"></i> Completed Solutions Grouped by Solution Type and Servicer.  Please select which implementation plans you would like to create.</h5>
												
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>												
															<th width="2%" class="actions">Select</th>												
															<th>Servicer</th>												
															<th>Chosen Solution</th>												
															<th>Total Loans</th>												
														</tr>
													</thead>
													<tbody>
														<cfoutput query="solutiongroupbyservicer">
															
															<cfparam name="solutionlist" default="">														
															
															<cfinvoke component="apis.com.implementation.implementgateway" method="getsolutionlistbyid" returnvariable="solutionlistbyid">
																<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
																<cfinvokeargument name="servid" value="#servicerid#">													
																<cfinvokeargument name="solutionsubcat" value="#solutionsubcat#">
																<cfinvokeargument name="solutionoption" value="#solutionoption#">
																
																<cfif servicerid eq -1>
																	<cfinvokeargument name="srvname" value="#nslservicer#">
																<cfelse>
																	<cfinvokeargument name="srvname" value="#servname#">
																</cfif>
																
															</cfinvoke>
															
															<cfset solutionlist = valuelist( solutionlistbyid.solutionid, ":" ) />									
															
															<tr>
																<td><div align="center"><input type="checkbox" name="chksolutionlist" value="#solutionlist#" /></div>
																<td><cfif servicerid eq -1>#nslservicer#<cfelse>#servname#</cfif></td>
																<td>#solutionsubcat# #solutionoption#</td>
																<td><span class="label label-default" style="padding:5px;">#totalsolutions#</span></td>
																<input type="hidden" name="servid" value="#servicerid#" />
																<input type="hidden" name="counter" value="#counter#" />
																<input type="hidden" name="optiontree" value="#solutionoptiontree#" />
																<input type="hidden" name="solutionoption" value="#solutionoption#" />
																<input type="hidden" name="solutionsubcat" value="#solutionsubcat#" />
															</tr>
															<cfset counter = counter + 1 />
														</cfoutput>
														
													</tbody>
											
												</table>
												
												<div style="margin-left:5px;margin-top:3px;">
													<input type="button" id="toggle" onclick="do_this();" value="Check All" class="btn btn-mini btn-default"> 
												</div>

												<cfoutput>
													<br />
													<div class="form-actions">													
														<button style="margin-left:5px;" type="submit" class="btn btn-secondary" name="createimpplans"><i class="icon-cogs"></i> Create Implementation Plans</button>																										
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.solution.final'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="chksolutionlist|Please select at least one solution group to create the implementation plan.;leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again." />
														
													</div> <!-- /form-actions -->
												</cfoutput>
												
												
											
											</fieldset>
										
										</form>
									
									<cfelse>
									
										<!--- // if the recordset is empty, show a message... --->
											<cfoutput>								
												<div style="padding:30px;" class="alert alert-block alert-error">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<h4><strong>NO COMPLETED SOLUTIONS FOUND!</strong><h4> 
													<p>Sorry, we could not find any completed solutions that require an implementation plan to be created, or implementation plans have already been created for all completed solutions.  Please re-visit the Option Tree.</p>
													
													
													<a style="margin-top:25px;" href="#application.root#?event=page.tree" class="btn btn-secondary"><i class="icon-sitemap"></i> Go to Option Tree</a> <a style="margin-top:25px;margin-left:10px;" href="#application.root#?event=page.solution" class="btn btn-default"><i class="icon-shopping-cart"></i> Go to Solution Cart</a>
													
													
												</div>		
											</cfoutput>
									
									</cfif>
									
									
									
									
								</div><!-- / .widget-content -->
							
							</div><!-- / .widget -->						
							
						</div><!-- / .span12 -->
					
					</div><!-- / .row -->
					<div style="margin-top:275px;"></div>
				
				</div><!-- / .container -->		
			
			</div><!-- / .main -->