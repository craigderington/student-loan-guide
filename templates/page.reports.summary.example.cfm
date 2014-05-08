
			
			
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data access components --->
						
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">				
			</cfinvoke>
				
			<cfinvoke component="apis.com.reports.reportgateway" method="getreportroles" returnvariable="reportroles">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="roletype" value="counselor">
			</cfinvoke>
			
			<!--- // lets play with some dates --->
			<cfparam name="today" default="">
			<cfparam name="lastyear" default="">			
			<cfparam name="mtd1" default="">
			<cfparam name="mtd2" default="">
			<cfparam name="startfirstqtr" default="">
			<cfparam name="endfirstqtr" default="">
			<cfparam name="start2ndqtr" default="">
			<cfparam name="end2ndqtr" default="">
			<cfparam name="start3rdqtr" default="">
			<cfparam name="start4thqtr" default="">
			
			<!--- // ok set our params --->
			<cfset today = createodbcdate( now() ) />
			<cfset lastyear = dateadd( 'yyyy', -1, today ) />
			<cfset lastmonth = dateadd( "m", -1, today ) />
			<cfset mtd1 = createdate( year( today ), month( today ), 1 ) />
			<cfset mtd2 = createdate( year( today ), month( today ), daysinmonth( today )) />
			
			
			
			<!--- reports css --->		
			<link href="./css/pages/reports.css" rel="stylesheet">

			
			
			<!--- // begin reports page --->			
			<div class="main">

				<div class="container">				

					<div class="row">
					
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">
									<i class="icon-globe"></i>
									<h3>Example Summary Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								
								<div class="widget-content">						
									
									
									
										<!--- // report filter --->									
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												
												<form class="form-inline" name="filterresults" method="post">																				
													
													<input type="text" name="sdate" style="margin-left:5px;" class="input-medium" placeholder="Select Start Date Filter" id="datepicker-inline4" value="<cfif isdefined( "url.sdate" )>#dateformat( url.sdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="edate" style="margin-left:5px;" class="input-medium" placeholder="Select End Date Filter" id="datepicker-inline5" value="<cfif isdefined( "url.edate" )>#dateformat( url.edate, 'mm/dd/yyyy' )#</cfif>">											
													
																										
													<!-- -// start with selecting the lead source --->
													<select name="leadsource" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Select Lead Source</option>
														<cfloop query="leadsources">
															<option value="#leadsourceid#"<cfif isdefined( "form.leadsource" ) and form.leadsource eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
														</cfloop>												
													</select>								
													<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Select Counselor</option>
															<cfloop query="reportroles">
																<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
															</cfloop>												
													</select>													
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
													<br />
													<a style="margin-left:5px;margin-top:5px;" title="Year Over Year" class="btn btn-mini btn-secondary" href="#application.root#?event=#url.event#&sdate=#lastyear#&edate=#today#">YoY</a>
													<a style="margin-top:5px;" title="Month to Date" class="btn btn-mini btn-secondary" href="#application.root#?event=#url.event#&sdate=#mtd1#&edate=#mtd2#">MTD</a>
													<a style="margin-top:5px;" href="javascript:;" title="Current Quarter" class="btn btn-mini btn-secondary">Current Qtr</a>
													<a style="margin-top:5px;" href="javascript:;" title="Last Quarter" class="btn btn-mini btn-secondary">Last Qtr</a>
													<button style="margin-top:5px;" type="reset" name="resetthisform"><i class="icon-ok"></i> Reset</button>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
									
										
										
								</div><!-- / .widget-content -->
					
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->

					</div><!-- / .row -->
							
					<div style="margin-top:300px;"></div>				
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->