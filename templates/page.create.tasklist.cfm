
				
				
				
										<cfquery datasource="#application.dsn#" name="mtasklist">
											select mtaskid, mtaskuuid, companyid, mtasktype, mtaskorder, mtaskname, mtaskdescr
											  from mtask
											 where companyid = <cfqueryparam value="446" cfsqltype="cf_sql_varchar" />
											   and mtaskactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />											  
										  order by mtasktype, mtaskorder asc		  
										</cfquery>				
																				
											
											<!--- // create the lead master task list --->
											<cfloop query="mtasklist">
												
												<cfparam name="today" default="">
												<cfparam name="taskuuid" default="">												
												<cfparam name="taskstatus" default="">
												<cfparam name="taskduedate" default="">
												<cfparam name="nextdate" default="">
												<cfparam name="idate" default="">
												<cfparam name="fdate" default="">
												
												<cfset taskuuid = #createuuid()# />
												<cfset taskstatus = "Assigned" />												
												<cfset today = #CreateODBCDateTime(Now())# />
												<cfset nextdate = DateAdd( "d", 3, today ) />
												<cfset idate = dateAdd( "d", 5, today ) />
												<cfset fdate = DateAdd( "d", 7, today ) />
												
												<cfquery datasource="#application.dsn#" name="mtasks">
													insert into tasks(taskuuid, mtaskid, leadid, userid, taskstatus, taskduedate, tasklastupdated, tasklastupdatedby)
														values (
																<cfqueryparam value="#taskuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																<cfqueryparam value="#mtasklist.mtaskid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="775" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="988" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#taskstatus#" cfsqltype="cf_sql_varchar" />,
																
																<cfif trim( mtasklist.mtasktype ) is "E">
																	<cfqueryparam value="#nextdate#" cfsqltype="cf_sql_timestamp" />,
																<cfelseif  trim( mtasklist.mtasktype ) is "F">
																	<cfqueryparam value="#fdate#" cfsqltype="cf_sql_timestamp" />,
																<cfelseif  trim( mtasklist.mtasktype ) is "I">
																	<cfqueryparam value="#idate#" cfsqltype="cf_sql_timestamp" />,
																</cfif>
																
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Melissa Towell" cfsqltype="cf_sql_varchar" />														
																);
												</cfquery>
												
											</cfloop>									
											
											
							
											
									
									
										<div class="container">
											<div class="span12">
												<div class="tab-pane active" id="newlead">
													<cfoutput>	
														The new task list has been created...
													</cfoutput>
												</div>
											</div>
										</div>
									
									
								