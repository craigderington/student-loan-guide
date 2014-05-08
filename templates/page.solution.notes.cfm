

			
			
			<!--- // get our data access components --->		
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutions" returnvariable="solutionlist">		
				<cfinvokeargument name="sid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutiondetails" returnvariable="solutiondetails">		
				<cfinvokeargument name="sid" value="#url.sid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutiontasks" returnvariable="solutiontasks">		
				<cfinvokeargument name="sid" value="#url.sid#">
			</cfinvoke>

			
			<!--- // include the tinymce js path --->
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
			
			
			
			<!--- // initialize tinymce for the rich text editor --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "cd1",
					width: 840,
					height: 400
				 });
			</script>
			
			
			
			<!-- // begin solution notes and specialist narrative page --->
			<div class="main">
				
				<div class="container">			
					
					<div class="row">					
						
						<div class="span9">
							<div class="widget stacked">							
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Solution Narrative &amp; Explanation for #leaddetail.leadfirst# #leaddetail.leadlast# | <cfif solutiondetails.solutionoptiontree eq 1>Direct Loan<cfelseif solutiondetails.solutionoptiontree eq 2>Stafford Loan<cfelseif solutiondetails.solutionoptiontree eq 2><cfelseif solutiondetails.solutionoptiontree eq 3>Perkins Loan<cfelseif solutiondetails.solutionoptiontree eq 4>Direct Consolidation<cfelseif solutiondetails.solutionoptiontree eq 5>Health Professional<cfelseif solutiondetails.solutionoptiontree eq 6>Parent PLUS<cfelseif solutiondetails.solutionoptiontree eq 7>Private Loan</cfif> | #solutiondetails.solutionoption# </h3>						
								</div> <!-- //.widget-header -->
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
											
											<!--- define and set form values--->											
											<cfset ssid = #form.soluuid# />
											<cfset snote = #urlencodedformat( form.mytextarea )# />
											<cfset today = #createodbcdatetime( now() )# />
											
											<cfquery datasource="#application.dsn#" name="savesolutionnotes">
												update solution
												  set solutionnotes = <cfqueryparam value="#snote#" cfsqltype="cf_sql_varchar" />
												where solutionuuid = <cfqueryparam value="#ssid#" cfsqltype="cf_sql_varchar" maxlength="35" />
											</cfquery>											
											
											<!--- // log the user activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# saved a narrative and detailed explanation for student loan solution #solutiondetails.solutionoption#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>										
											
											<cflocation url="#application.root#?event=page.solution&msg=saved" addtoken="no">
								
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
									
									
									
									<h6><small>Please enter a detailed explanation narrative for this solution.  You should include a description as to why this solution was chosen...</small></h5>
									<cfoutput>
										<!-- Place this in the body of the page content -->
										<form name="mytextareaform" action="#application.root#?event=#url.event#&sid=#solutiondetails.solutionuuid#" method="post">
											
											<textarea name="mytextarea" id="cd1">#urldecode( solutiondetails.solutionnotes )#</textarea>										
										
											<br />									
											
											<div class="form-actions">											
												<button type="submit" class="btn btn-secondary" name="savesolutionnote"><i class="icon-save"></i> Save Solution Narrative</button>
												<a href="#cgi.http_referer#" class="btn btn-primary"><i class="icon-repeat"></i> Cancel</a>
												<input name="utf8" type="hidden" value="&##955;">													
												<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
												<input type="hidden" name="soluuid" value="#solutiondetails.solutionuuid#" />
												<input type="hidden" name="__authToken" value="#randout#" />
												<input type="hidden" name="validate_require" value="soluuid|The solution unique identifier is required to save the narrative.  Please try again." />
											</div>
											
										
										</form>
									</cfoutput>
								</div>
							
							</div><!-- /.widget -->
						</div><!-- /.span9 -->


						<div class="span3">
							<div class="widget stacked">							
								<div class="widget-header">		
									<i class="icon-sitemap"></i>							
									<h3>Solution Details</h3>						
								</div> <!-- //.widget-header -->
								
								<cfoutput>
								<div class="widget-content">							
									<strong>Current Selected Solution: <br /><br />
									<cfif solutiondetails.solutionoptiontree eq 1>Direct Loan<cfelseif solutiondetails.solutionoptiontree eq 2>Stafford Loan<cfelseif solutiondetails.solutionoptiontree eq 2><cfelseif solutiondetails.solutionoptiontree eq 3>Perkins Loan<cfelseif solutiondetails.solutionoptiontree eq 4>Direct Consolidation<cfelseif solutiondetails.solutionoptiontree eq 5>Health Professional<cfelseif solutiondetails.solutionoptiontree eq 6>Parent PLUS<cfelseif solutiondetails.solutionoptiontree eq 7>Private Loan</cfif>
									<br />#solutiondetails.solutionoption#</strong>
									
								</div>
								</cfoutput>
								
							</div><!-- /.widget -->						
							
							<div class="widget stacked">							
								<div class="widget-header">		
									<i class="icon-tasks"></i>							
									<h3>Solution Follow Up Tasks</h3>						
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">							
									<cfif solutiontasks.recordcount gt 0>
										<ul>
											<cfoutput query="solutiontasks">
												<li><i class="icon-tasks"></i> <a href="javascript:;">#soltaskname#</a></li>
											</cfoutput>
										</ul>
									<cfelse>
										<i class="icon-warning-sign"></i>  No tasks have been created. <br /> <a href="javascript:;" class="btn btn-mini btn-secondary" style="margin-top:10px;"><i class="icon-tasks"></i> Create New Task</a>
									</cfif>									
								</div>
							
							</div><!-- /.widget -->							
							
							<div class="widget stacked">							
								<div class="widget-header">		
									<i class="icon-check"></i>							
									<h3>Other Solutions</h3>						
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">							
									<ul>
										<cfoutput query="solutionlist">
											<li><strong><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></strong><br />
										        <i>#solutionoption#</i>
											</li>
										</cfoutput>
									</ul>
								</div>
							
							</div><!-- /.widget -->						
							
							
						</div><!-- / .span3 -->
							
							
					</div><!-- / .row -->	
					
					
				</div><!-- /.container -->		
				
				
				
			</div><!-- /.main -->