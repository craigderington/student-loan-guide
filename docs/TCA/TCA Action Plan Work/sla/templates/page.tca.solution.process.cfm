												
												
												
						
						
						
						<!--- // include our data components and api --->
						<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
							<cfinvokeargument name="leadid" value="#session.leadid#">
						</cfinvoke>
			
			
			
			
			
						<cfoutput>
							<div class="main">	
								
								<div class="container">
									
									<div class="row">
							
										<div class="span12">
											
											<div class="widget stacked">
												
												<div class="widget-header">		
													<i class="icon-sitemap"></i>							
													<h3>Take Charge America - Processing Solutions for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
												</div> <!-- //.widget-header -->
												
												<div class="widget-content">
													
													<!---
													<h4><i style="padding:30px;color:orange;" class="icon-spinner icon-spin icon-4x"></i>Processing...  Please wait...</h4>
													--->
													
													
													<cfif structkeyexists( form, "create-action-plan" )>	
														<cfif isdefined( "form.fieldnames" )>
															<cfscript>
																objValidation = createobject( "component","apis.com.ui.validation" ).init();
																objValidation.setFields( form );
																objValidation.validate();
															</cfscript>

															<cfif objValidation.getErrorCount() is 0>			
																
																<cfset lead = structnew() />
																<cfset lead.leadid = form.leadid />																									
																<cfset lead.solutionuuid = #createuuid()# />
																
																<cfset lead.userid = session.userid />
																<cfset lead.solutiontext = urlencodedformat( form.solutiontext ) />
																
																<!--- // now figure out which option are present in our structure
																		 then default to NO,  if not found --->
																
																<cfif isdefined( "form.idrconsol" )>
																	<cfset lead.idrconsol = "Y" />
																<cfelse>
																	<cfset lead.idrconsol = "N" />
																</cfif>
																
																<cfif isdefined( "form.consol" )>
																	<cfset lead.consol = "Y" />
																<cfelse>
																	<cfset lead.consol = "N" />
																</cfif>
																
																<cfif isdefined( "form.econdefer" )>
																	<cfset lead.econdefer = "Y" />
																<cfelse>
																	<cfset lead.econdefer = "N" />
																</cfif>
																
																<cfif isdefined( "form.forbear" )>
																	<cfset lead.forbear = "Y" />
																<cfelse>
																	<cfset lead.forbear = "N" />
																</cfif>
																
																<cfif isdefined( "form.ibr" )>
																	<cfset lead.ibr = "Y" />
																<cfelse>
																	<cfset lead.ibr = "N" />
																</cfif>
																
																<cfif isdefined( "form.icr" )>
																	<cfset lead.icr = "Y" />
																<cfelse>
																	<cfset lead.icr = "N" />
																</cfif>
																
																<cfif isdefined( "form.paye" )>
																	<cfset lead.paye = "Y" />
																<cfelse>
																	<cfset lead.paye = "N" />
																</cfif>
																
																<cfif isdefined( "form.pslfconsol" )>
																	<cfset lead.pslfconsol = "Y" />
																<cfelse>
																	<cfset lead.pslfconsol = "N" />
																</cfif>
																
																<cfif isdefined( "form.pslf" )>
																	<cfset lead.pslf = "Y" />
																<cfelse>
																	<cfset lead.pslf = "N" />
																</cfif>
																
																<cfif isdefined( "form.rehab" )>
																	<cfset lead.rehab = "Y" />
																<cfelse>
																	<cfset lead.rehab = "N" />
																</cfif>
																
																<cfif isdefined( "form.tlf" )>
																	<cfset lead.tlf = "Y" />
																<cfelse>
																	<cfset lead.tlf = "N" />
																</cfif>
																
																<cfif isdefined( "form.unempdefer" )>
																	<cfset lead.unempdefer = "Y" />
																<cfelse>
																	<cfset lead.unempdefer = "N" />
																</cfif>			
																
																<cfset today = now() />
																
																<!--- // create the notes database record --->
																<cfquery datasource="#application.dsn#" name="addtcasolution">
																	insert into tcasolutions(leadid, tcasolutionuuid, tcasolutiondate, idrconsol, consol, econdefer, forbear, ibr, icr, paye, pslfconsol, pslf, rehab, tlf, unempdefer, tcasolutionuserid, tcasolutionnarrative )
																		values (
																				<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#lead.solutionuuid#" cfsqltype="cf_sql_varchar" />,																			
																				<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																				<cfqueryparam value="#lead.idrconsol#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.consol#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.econdefer#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.forbear#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.ibr#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.icr#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.paye#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.pslfconsol#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.pslf#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.rehab#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.tlf#" cfsqltype="cf_sql_char" />,
																				<cfqueryparam value="#lead.unempdefer#" cfsqltype="cf_sql_char" />,											
																				<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#lead.solutiontext#" cfsqltype="cf_sql_varchar" />
																			   );
																</cfquery>

																<!--- // log the user activity ---->													
																<cfquery datasource="#application.dsn#" name="logact">
																	insert into activity(leadid, userid, activitydate, activitytype, activity)
																		values (
																				<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																				<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																				<cfqueryparam value="#session.username# selected client solutions and prepared action plan." cfsqltype="cf_sql_varchar" />
																				); select @@identity as newactid
																</cfquery>
																
																<cfquery datasource="#application.dsn#">
																	insert into recent(userid, leadid, activityid, recentdate)
																		values (
																				<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																				);
																</cfquery>
																
																<cflocation url="#application.root#?event=page.tca.solution.final" addtoken="no">
																<!---
																<cfdump var="#lead#" label="Lead Dump">
																--->
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
																		
																		<p>&nbsp;</p>
																		<p><i class="icon-circle-arrow-left"></i> <a href="#application.root#?event=page.tree">Click here to go back and start over...</a></p>
																</div>
													
															</cfif>
														</cfif>
													</cfif>	
													<!--- // end form processing --->
												</div>
											</div>											
										</div>
									</div>
									<div style="margin-top:250px;"></div>
								</div>
							</div>
						</cfoutput>