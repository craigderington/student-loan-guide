


				<!---- get our data access components --->
				<cfinvoke component="apis.com.system.doccat" method="getdoccats" returnvariable="doccats">			
				
				<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editcat">
					<cfif structkeyexists( url, "catid" ) and isvalid( "integer", url.catid )>
						<cfinvoke component="apis.com.system.doccat" method="getdoccatdetail" returnvariable="doccatdetail">
							<cfinvokeargument name="catid" value="#url.catid#">
						</cfinvoke>
					</cfif>				
				</cfif>
				
				
				
				
				<!--- // delete the document category --->
				<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletecat">
					<cfif structkeyexists( url, "catid" ) and isvalid( "integer", url.catid )>
						<cfparam name="catid" default="#url.catid#">
						
						<!--- // first, check to see if any library documents are bound to this category --->
						<cfquery datasource="#application.dsn#" name="getcat">
							select doccatid, doccat
							  from doccategory
							 where doccatid = <cfqueryparam value="#catid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<cfquery datasource="#application.dsn#" name="checkcat">
							select count(*) as totaldocs
							  from documents
							 where doccatid = <cfqueryparam value="#getcat.doccatid#" cfsqltype="cf_sql_integer" />
						</cfquery>

							<!--- // if records found, abort operation and redirect --->
							<cfif checkcat.totaldocs gt 0>							
								<cfoutput>
									<script>
										alert('Sorry, the document category #getcat.doccat# can not be deleted.  #getcat.doccat# is the category for #checkcat.totaldocs# documents in the library.');
										self.location="javascript:history.back(-1);"
									</script>
								</cfoutput>								
							<cfelse>							
								<!--- // allow the delete operation --->
								<cfquery datasource="#application.dsn#" name="killcat">
									delete 
									  from doccategory
									 where doccatid = <cfqueryparam value="#getcat.doccatid#" cfsqltype="cf_sql_integer" />
								</cfquery>
								<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">								
							</cfif>
					</cfif>
				</cfif>
				
				
				
				
				<div class="main">				
				
					<div class="container">
					
						<div class="row">

								<!--- system messages --->
								<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
									<div class="span12">									
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The document category was saved successfully...
										</div>										
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
									<div class="span12">									
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The document category was successfully added...
										</div>										
									</div>	
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
									<div class="span12">									
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The document category was successfully deleted...
										</div>										
									</div>									
								</cfif>												
								<!-- // end system messages --->
						
							
							
									<div class="span8">
									
										<div class="widget stacked">
										
											<!--- // validate CFC Form Processing --->							
											
											<cfif isDefined("form.fieldnames")>
												<cfscript>
													objValidation = createObject("component","apis.com.ui.validation").init();
													objValidation.setFields(form);
													objValidation.validate();
												</cfscript>

												<cfif objValidation.getErrorCount() is 0>							
													
													<!--- define our structure and set form values--->
													<cfset cat = structnew() />
													<cfset cat.doccatid = #form.catid# />
													<cfset cat.doccat = trim( form.doccat ) />										
																						
													<!--- // manipulate some strings for proper case --->															
													<cfset today = #CreateODBCDateTime(now())# />
													
														<cfif cat.doccatid neq 0>
												
															<cfquery datasource="#application.dsn#" name="addcategory">
																update doccategory											   
																   set doccat = <cfqueryparam value="#cat.doccat#" cfsqltype="cf_sql_varchar" />														
																 where doccatid = <cfqueryparam value="#cat.doccatid#" cfsqltype="cf_sql_integer" /> 		  
															</cfquery>
															
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																			<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# edited the document category #cat.doccat#" cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>

															<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
														
														<cfelse>
															
															<cfquery datasource="#application.dsn#" name="addcategory">
																insert into doccategory(doccat)										   
																   values(
																		  <cfqueryparam value="#cat.doccat#" cfsqltype="cf_sql_varchar" />
																		  );														 		  
															</cfquery>
															
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																			<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# added document category #cat.doccat#" cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>
															
															<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
														
														</cfif>
										
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
										
										
										
										
										
										
										
										
											<div class="widget-header">
												<i class="icon-paste"></i> 
												<h3>Administration | System Menus | Manage Document Categories</h3>
											</div>
											
											<div class="widget-content">
												
												<cfif doccats.recordcount gt 0>
												
													<table class="table table-bordered table-striped table-highlight">
														<thead>
															<tr>
																<th width="15%">Actions</th>												
																<th>Document Category</th>
															</tr>
														</thead>
														<tbody>
															<cfoutput query="doccats">
																<tr>
																	<td class="actions">															
																		<a href="#application.root#?event=#url.event#&fuseaction=editcat&catid=#doccatid#" title="Edit Category" class="btn btn-mini btn-inverse">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>																
																		<a href="#application.root#?event=#url.event#&fuseaction=deletecat&catid=#doccatid#" onclick="javascript:return confirm('Are you sure you want to delete this document category?  This action can not be un-done!');" title="Delete Category" class="btn btn-mini btn-default">
																			<i class="btn-icon-only icon-trash"></i>										
																		</a>														
																	</td>						
																	<td>#doccat#</td>
																</tr>										
															</cfoutput>												
														</tbody>
													</table>								
													
												<cfelse>
												
													<div class="alert alert-block alert-info">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
															<h3><i style="font-weight:bold;" class="icon-warning-sign"></i>WARNING!</h3>
															<p>There are no document categories defined in the system....</p>
													</div>									
												
												
												</cfif>
												
											
											</div>
										
										
										</div>
										
										
									
									
									</div><!-- / .span8 -->
							
							
							
									<div class="span4">
									
										<div class="widget stacked">
											
											<div class="widget-header">
												<i style="margin-right: 5px;" class="icon-paste"></i> <cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editcat"> Edit Document Category<cfelse> Add Document Category</cfif>
											</div>
											
											
											<div class="widget-content">
												
															<cfoutput>
																<form id="edit-this-form" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																		<div class="control-group">											
																			<label style="margin-left:-100px;" class="control-label" for="doccat">Category</label>
																			<div class="controls">
																				<input style="margin-left:-100px;" type="text" class="input-large" placeholder="Add Category" name="doccat" id="doccat" value="<cfif isdefined( "form.doccat" )>#trim( form.doccat )#<cfelse><cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editcat">#doccatdetail.doccat#</cfif></cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->												
																		<br />									
																			
																			<cfif structkeyexists( url, "fuseaction" )>
																				<button style="margin-left:78px;" type="submit" class="btn btn-small btn-primary" name="savecat"><i class="icon-save"></i> Save Document Category</button>
																				<a href="#application.root#?event=#url.event#" class="btn btn-small btn-default" name="cancel"><i class="icon-remove"></i> Cancel</a>
																			<cfelse>
																				<button style="margin-left:78px;" type="submit" class="btn btn-small btn-secondary" name="savecat"><i class="icon-save"></i> Add New Category</button>
																				<button type="reset" name="reset" class="btn btn-default btn-small"><i class="icon-reorder"></i> Reset																
																			</cfif>
																			<input name="utf8" type="hidden" value="&##955;">												
																			<input type="hidden" name="catid" value="<cfif structkeyexists( url, "catid" )>#url.catid#<cfelse>0</cfif>" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="doccat|You must enter a document category to save the record." />										
																																
																	</fieldset>
																</form>
															</cfoutput>		
												
											</div>								
											
										</div><!-- / .widget -->


										<div class="widget stacked">
											
											<div class="widget-header">
												<i style="margin-right: 5px;" class="icon-paste"></i> More System Menu Options
											</div>											
											
											<cfoutput>
												<div class="widget-content">															
													<ul style="list-style:none;">
														<li><a href="#application.root#?event=page.menu"><i class="icon-chevron-right"></i> Menu Home</li></a>
														<li><a href="#application.root#?event=page.menu.servicers"><i class="icon-chevron-right"></i> Servicers</li></a>
														<li><a href="#application.root#?event=page.menu.email"><i class="icon-chevron-right"></i> Message Library</li></a>
														<li><a href="#application.root#?event=page.reports"><i class="icon-chevron-right"></i> Reports</li></a>
														<li><a href="#application.root#?event=page.reminders"><i class="icon-chevron-right"></i> Reminders</li></a>
														<li><a href="#application.root#?event=page.menu.portal.tasks"><i class="icon-chevron-right"></i> Portal Tasks</li></a>
														<li><a href="#application.root#?event=page.menu.plans"><i class="icon-chevron-right"></i> Action Plans</li></a>
														<li><a href="#application.root#?event=page.menu.steps"><i class="icon-chevron-right"></i> Implementation Steps</li></a>
														<li><a href="#application.root#?event=page.menu.jobs"><i class="icon-chevron-right"></i> Job Conditions</li></a>
													</ul>	
												</div>								
											</cfoutput>
										</div><!-- / .widget -->
									
									</div><!-- / .span4 -->
						
						</div><!-- / .row -->
						<div style="margin-top:175px;"></div>
						
					</div><!-- /.container -->
					
				</div><!-- / .main -->