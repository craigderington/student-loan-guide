




								<cfoutput>
									<div class="well">
										<p><i class="icon-check"></i> Filter Your Results</p>
										<form class="form-inline" name="filterresults" method="post">																				
											<select name="counselors" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
												<option value="">Select Counselor</option>
												<cfloop query="reportroles">
													<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles>selected>#thisrole#</option>
												</cfloop>												
											</select>
											<input type="text" name="docdate" style="margin-left:5px;" class="input-medium" placeholder="Select Date Filter" id="datepicker-inline4" value="<cfif isdefined( "form.docdate" )>#dateformat( form.docdate, 'mm/dd/yyyy' )#</cfif>">		
											<input type="hidden" name="filtermyresults">
											<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
											<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
										</form>
									</div>
								</cfoutput>
								
								
								<!---
									<cfif structkeyexists( form, "filtermyresults" )>
										<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
											and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
										</cfif>
										<cfif structkeyexists( form, "docdate" ) and form.docdate is not "" and form.docdate is not "Select Date Filter">
											and s.slenrolldate <= <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" />
										</cfif>					   
									</cfif>
								   --->
								   
								   
								   
								   
								   <!--- // report filter 
									<cfinvoke component="apis.com.reports.reportgateway" method="getreportroles" returnvariable="reportroles">
										<cfinvokeargument name="companyid" value="#session.companyid#">
										<cfinvokeargument name="roletype" value="counselor">
									</cfinvoke>
									<cfoutput>
										<div class="well">
											<p><i class="icon-check"></i> Filter Your Results</p>
											<form class="form-inline" name="filterresults" method="post">																				
												<select name="counselors" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
													<option value="">Select Counselor</option>
													<cfloop query="reportroles">
														<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
													</cfloop>												
												</select>
												<input type="text" name="docdate" style="margin-left:5px;" class="input-medium" placeholder="Select Date Filter" id="datepicker-inline4" value="<cfif isdefined( "form.docdate" )>#dateformat( form.docdate, 'mm/dd/yyyy' )#</cfif>">		
												<input type="hidden" name="filtermyresults">
												<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
												<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
											</form>
										</div>
									</cfoutput>
									--->
									
									
									
									
									