


			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>			
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.admin.companyadmingateway" method="getusercomp" returnvariable="compuserdetail">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.deptadmingateway" method="getdepts" returnvariable="deptlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>

			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "edit.dept">
				<cfinvoke component="apis.com.admin.deptadmingateway" method="getdept" returnvariable="deptdetail">
					<cfinvokeargument name="deptid" value="#url.deptid#">
				</cfinvoke>
			</cfif>
			
			
			
			<!--- // define form vars --->
			<cfparam name="deptname" default="">
			<cfparam name="coid" default="">
			
			
			
			
			
			<!--- delete the department record based on the query string param --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "kill.dept" >
			
				<cfparam name="deptid" default="">
				<cfset deptid = #url.deptid# />
					
					<cfif structkeyexists( url, "deptid" ) and isvalid( "uuid", url.deptid )>					
						
						<!--- // get the department record --->
						<cfquery datasource="#application.dsn#" name="getdeptfordelete">
							select deptid, deptname
							  from dept
							 where deptuuid = <cfqueryparam value="#deptid#" cfsqltype="cf_sql_varchar" maxlength="35" />
						</cfquery>
						
						<!--- // check to make sure there are no uses bound to this department before allowing delete operation --->
						<cfquery datasource="#application.dsn#" name="getdeptusers">
							select userid, deptid
							  from users
							 where deptid = <cfqueryparam value="#getdeptfordelete.deptid#" cfsqltype="cf_sql_integer" />
							   and companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<cfif getdeptusers.recordcount eq 0>					
						
							<!--- // ok, no users - now delete the record --->
							<cfquery datasource="#application.dsn#" name="checkdupedept">
								delete
								  from dept
								 where deptid = <cfqueryparam value="#getdeptfordelete.deptid#" cfsqltype="cf_sql_integer" />
							</cfquery>
							
							<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">
						
						<cfelse>
							
							<cfoutput>
								<script>
									alert('Sorry, #getdeptfordelete.deptname# can not be deleted because there are #getdeptusers.recordcount# users bound to this record.  Operation aborted...');
									self.location="javascript:history.back(-1);"
								</script>
							</cfoutput>
							
							
						</cfif>
					
					</cfif>
			
			</cfif>
			<!--- // end delete operation --->
			
			
			
			
			
			
			
			
			<!--- // company department administration and default data grid --->
			
			
			<div class="main">	
					
				<div class="container">
						
					<div class="row">
				
						<div class="span12">
							
							<!--- // system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved" >
								<div class="alert alert-info">												
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> SUCCESS!</strong>  The new department was successfully added to this company profile...									
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted" >
								<div class="alert alert-error">												
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> SUCCESS!</strong>  The department was successfully removed from this company's profile...									
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "updated" >
								<div class="alert alert-notice">												
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> SUCCESS!</strong>  The department was successfully saved and updated for this company's profile...									
								</div>
							</cfif>	
							
							
							
							
							
							
							
							
							<!--- // page header --->
							<div class="widget stacked">
								
								
								<cfoutput>
									<div class="widget-header">		
										<i class="icon-book"></i>							
										<h3>Manage Company Departments for #compuserdetail.companyname#</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>
							
								<div class="widget-content">

									
									
									
									
									
									
									
									
									
									
									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset dept = structnew() />
											<cfset dept.deptID = #url.deptid# />
											<cfset dept.deptname = #form.deptname# />
											<cfset dept.deptuuid = #createuuid()# />
											<cfset dept.compid = #form.coid# />
											<cfif isdefined("form.chkstatus")>
												<cfset dept.status = 1 />
											<cfelse>
												<cfset dept.status = 0 />
											</cfif>
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />					
											
												<!--- // check for duplicate department entry --->
												<cfquery datasource="#application.dsn#" name="checkdupedept">
													select deptid, deptname
													  from dept
													 where companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
													   and deptname = <cfqueryparam value="#dept.deptname#" cfsqltype="cf_sql_varchar" />
												</cfquery>
												
												
												<!--- // check to make sure we are not allowing a duplicate department name for the same company --->
												<cfif checkdupedept.recordcount eq 1 and dept.deptid eq 0>
													
													<cfoutput>
														<script>
															alert('Sorry, #dept.deptname# already exists for this company...');
															self.location="javascript:history.back(-1);"
														</script>
													</cfoutput>
												
												
												<cfelse>										
												
													<cfif dept.deptid EQ 0>
													
														<!--- // create the database record --->
														<cfquery datasource="#application.dsn#" name="adddept">
															insert into dept(deptuuid, companyid, deptname, active)
																values (
																		<cfqueryparam value="#dept.deptuuid#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#dept.compid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#dept.deptname#" cfsqltype="cf_sql_varchar" />,															
																		<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																	   );
														</cfquery>											
														
														<!--- // log the activity --->
														<cfquery datasource="#application.dsn#" name="logact">
															insert into activity(leadid, userid, activitydate, activitytype, activity)
																values (
																		<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#session.username# added a company department for #session.companyname#." cfsqltype="cf_sql_varchar" />
																		);
														</cfquery>																					
														
														<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
												
													<cfelse>
														
														<!--- // update the database record --->
														<cfquery datasource="#application.dsn#" name="savedept">
															update dept
															   set deptname = <cfqueryparam value="#dept.deptname#" cfsqltype="cf_sql_varchar" />,
																   deptuuid = <cfqueryparam value="#dept.deptuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															       active = <cfqueryparam value="#dept.status#" cfsqltype="cf_sql_bit" />
															 where deptid = <cfqueryparam value="#checkdupedept.deptID#" cfsqltype="cf_sql_integer" />
														</cfquery>											
														
														<!--- // log the user activity --->
														<cfquery datasource="#application.dsn#" name="logact2">
															insert into activity(leadid, userid, activitydate, activitytype, activity)
																values (
																		<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="Record Updated" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="The user updated the company department #dept.deptname# for #session.companyname#." cfsqltype="cf_sql_varchar" />
																		);
														</cfquery>																					
														
														<cflocation url="#application.root#?event=#url.event#&msg=updated" addtoken="no">
														
														
													</cfif>
												
												</cfif>
										
										
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
									<!-- // end form processing --->





















									<!--- // begin department data grid --->
									<cfif not structkeyexists( url, "fuseaction" )>	
										<cfif deptlist.recordcount gt 0>
											<cfoutput>
											<div class="float:left;margin-top:-10px;">Found #deptlist.recordcount# Department<cfif deptlist.recordcount gt 1>s</cfif> for #session.companyname#...</div>
											<div style="float:right;margin-bottom:5px;"><a href="#application.root#?event=page.depts&fuseaction=add.dept&deptID=0" class="btn btn-mini btn-secondary"><i class="icon-building"></i> Add Department</a></div>
											</cfoutput>
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<th width="10%">Actions</th>
														<th width="15%">Company</th>
														<th>Department</th>
														<th>Status</th>												
													</tr>
												</thead>
												<tbody>
													<cfoutput query="deptlist">
														<tr>
															<td class="actions">														
																<a href="#application.root#?event=#url.event#&fuseaction=edit.dept&deptid=#deptuuid#" class="btn btn-mini btn-warning">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>															
																															
																<a href="#application.root#?event=#url.event#&fuseaction=kill.dept&deptid=#deptuuid#" onclick="return confirmDelete();" class="btn btn-mini btn-inverse">
																	<i class="btn-icon-only icon-trash"></i>										
																</a>														
															</td>												
															<td>#companyname#</td>
															<td><strong>#deptname#</strong></td>															
															<td><cfif active eq 1><span class="label label-success">Active</span><cfelse><span class="label label-info">Inactive</span></cfif></td>
														</tr>
													</cfoutput>
												</tbody>
											</table>
	
											
											<cfif isuserinrole( "admin" )>
												<cfoutput>
													<a style="margin-top:50px;" href="#application.root#?event=page.admin.company" class="btn btn-small btn-default" ><i style="margin-right:5px;" class="icon-circle-arrow-left"></i> Return to Company Admin</a>
												</cfoutput>
											</cfif>
										
										
										<cfelse>
											
											
											
											<div class="alert alert-info">
												<cfoutput>
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong><i class="icon-warning-sign"></i> NO RECORDS FOUND!</strong>  Sorry, no company departments were found.  Please <a href="#application.root#?event=page.depts&fuseaction=add.dept&deptid=0">click here</a> to add a new department.
												</cfoutput>
											</div>
										
										
										
										</cfif>
									
									
									
									
									
									
									<cfelse>
									
									
									
										
										
										
										
										
										<!--- // begin add new department form --->
										<cfif structkeyexists( url, "deptid" ) and url.deptid is "0">
										
											<cfoutput>
												<br />
												<form id="adddept-admin" class="form-horizontal" method="post" action="#application.root#?event=page.depts&fuseaction=add.dept&deptID=0">
													<fieldset>						
																		
														<div class="control-group">											
															<label class="control-label" for="deptname">Department Name</label>
																<div class="controls">
																	<input type="text" name="deptname" class="input-large" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->										
																																							
																		
														<br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savedept"><i class="icon-save"></i> Add Department</button>																										
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.depts'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">													
															<input type="hidden" name="coid" value="#session.companyid#" />													
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="deptname|Please enter the department name.;coid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.">
													</fieldset>
												</form>										
											</cfoutput>
										
										
										<cfelse>
											
											<!--- // if the department id is a valid uuid - then show the edit form --->
												
												<cfoutput>
													<br />
													<form id="editdept-admin" class="form-horizontal" method="post" action="#application.root#?event=page.depts&fuseaction=edit.dept&deptid=#deptdetail.deptuuid#">
														<fieldset>						
																			
															<div class="control-group">											
																<label class="control-label" for="deptname">Department Name</label>
																	<div class="controls">
																		<input type="text" name="deptname" class="input-large" value="#deptdetail.deptname#" />
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">
																<label class="control-label">Status</label>
																	<div class="controls">
																		<label class="checkbox">
																			<input type="checkbox" name="chkStatus" value="1"<cfif deptdetail.active eq 1>checked</cfif>>
																				This department is active
																		</label>							
																	</div>
															</div>
																																								
																			
															<br />
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="savedept"><i class="icon-save"></i> Save Department</button>																										
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.depts'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">													
																<input type="hidden" name="coid" value="#session.companyid#" />
																<input type="hidden" name="deptid" value="#deptdetail.deptuuid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="deptname|Please enter the department name.;coid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.">
														</fieldset>
													</form>
												</cfoutput>
										
										
										
										</cfif>
										
										
									
									
									
									</cfif>
									<div class="clear"></div>
									
									
								</div> <!-- //.widget-content -->	
										
							</div> <!-- //.widget -->
								
						</div> <!-- //.span12 -->
							
					</div> <!-- //.row -->			
					
					
					<div style="height:250px;"></div>			
					
				</div> <!-- //.container -->
				
			</div> <!-- //.main -->
			
			
			
			
			
			
			
			
			
			<script language="JavaScript">
				<!--
				// *** CLD - 2007-08-06 - Alert Confirm Delete
				function confirmDelete() {
					var agree=confirm("Are you sure you want to delete this company department?");
						if (agree)
					return true ;
					else
						return false ;
					}
				// -->
			</script>

			
			
			
			
			
			