
				
				
				<!--- form processing --->			
				
				<cfif structkeyexists(form, "savelead") or structkeyexists(form, "saveleadcontinue")>
					
					<cfparam name="lead" default="">
					<cfparam name="first" default="">
					<cfparam name="last" default="">
					<cfparam name="email" default="">
					<cfparam name="today" default="">
					<cfparam name="company" default="">
					<cfparam name="userid" default="">
					
					<!--- define our structure and set form values--->
					<cfset lead = structnew() />
					<cfset lead.first = #form.firstname# />
					<cfset lead.last = #form.lastname# />
					<cfset lead.email = #form.email# />
					<cfset lead.company = #session.companyid# />
					<cfset lead.userid = #session.userid# />
					
					<!--- some other variables --->
					<cfset today = #CreateODBCDateTime(now())# />				
						
							<cfquery datasource="#application.dsn#">
								insert into leads(companyid, userid, leadsourceid, leaddate, leadfirst, leadlast, leademail, leadactive)
									values (
											<cfqueryparam value="#lead.company#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#lead.userid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="12" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
											<cfqueryparam value="#lead.first#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#lead.last#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#lead.email#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
										   ); select @@identity as newleadid
							</cfquery>
							
							<!--- redirect based on the button clicked in the actions --->
							
							<cfif isdefined("form.saveleadcontinue")>							
								
								<cfset session.leadid = #newleadid# />
								
								<cfoutput>
									<script>
										self.location="#application.dsn#?event=page.summary"
									</script>
								</cfoutput>
								
							<cfelseif isdefined("form.savelead")>
								
								<cfoutput>
									<script>
										self.location="#application.root#?event=page.leads"
									</script>
								</cfoutput>
								
							<cfelse>
							
								<cfoutput>
									<script>
										self.location="#application.root#?event=page.index"
									</script>
								</cfoutput>
								
							</cfif>		



				<!--- // create new lead inquiry --->
				
			
			
				<div class="container">
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Create New Inquiry</h3>						
								</div> <!-- /.widget-header -->
								
								<div class="widget-content">						
									
									<div class="tab-pane active" id="newlead">
										<cfoutput>	
										<form id="newlead-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">
											<fieldset>												
													
												<div class="control-group">											
													<label class="control-label" for="firstname">First Name</label>
													<div class="controls">
														<input type="text" class="input-medium" id="firstname" name="firstname">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="lastname">Last Name</label>
													<div class="controls">
														<input type="text" class="input-medium" id="lastname" name="lastname">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="email">Email Address</label>
													<div class="controls">
														<input type="text" class="input-large" id="email" name="email">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->							
													
												<br />												
														
												<div class="form-actions">
													<input type="submit" name="savelead" id="savelead" value="Save Inquiry" class="btn btn-default">
													<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Inquiry</button>
													<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Save Inquiry & Continue</button>													
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.index'"><i class="icon-remove-sign"></i> Cancel</a>
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="__authToken" value="#randout#" />
													
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->			
				
					
				
					<div style="height:200px;"></div>
				
				
				</div><!-- /container -->