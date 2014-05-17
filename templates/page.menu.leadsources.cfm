


			<!-- get our data access components --->
			<cfinvoke component="apis.com.admin.leadsourcegateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!---<cfdump var="#leadsources#" label="My Lead Sources">--->
			
			
			<!--- // process the forms and quert string action --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editsource">
			
				<cfif structkeyexists( url, "srcid" ) and isvalid( "integer", url.srcid ) >
					
					<cfset leadsrc = structnew() />
					<cfparam name="srcid" default="#url.srcid#">				
					<cfparam name="broadcastmsg" default="">
					
					<cfif srcid eq 0>					
						
						<cfquery datasource="#application.dsn#" name="addsource">
							insert into leadsource(companyid, leadsource, active)
								values(
										<cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value=" " cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit" />								
									   );						
						</cfquery>
						
						<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="yes"	>
					
					<cfelse>
					
						<cfset leadsrc.sourcename = trim( form.leadsource ) />
						<cfset leadsrc.companyid = form.comid />
						<cfset leadsrc.lsid = form.lsid />
						
						<cfif leadsrc.sourcename is "">
							<cfset leadsrc.sourcename = "Undefined" />
						</cfif>
						
						<cfquery datasource="#application.dsn#" name="editsource">
							update leadsource
							   set leadsource = <cfqueryparam value="#leadsrc.sourcename#" cfsqltype="cf_sql_varchar" />,
								   active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />								
							 where leadsourceid = <cfqueryparam value="#leadsrc.lsid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="yes"	>			
					
					</cfif>
					
				</cfif>
				
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<div class="main">
			
				<div class="container">
				
					<div class="row">
						
						<div class="span12">
						
							<!--- // show system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">
								
								<div class="alert alert-block alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-check"></i>SYSTEM MESSAGE</h5>
									<p>The lead source record was successfully saved...</p>
								</div>
							
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">
								<div class="alert alert-block alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h5><i style="font-weight:bold;" class="icon-check"></i>SYSTEM MESSAGE</h5>
									<p>A new record has been added.  Please enter the lead source name and click Save!</p>
								</div>
							</cfif>
						
							<div class="widget stacked">
								
								<!-- // widget header content -->
								<cfoutput>
									<div class="widget-header">
										<i class="icon-exchange"></i>
										<h3>#session.companyname# | Manage Lead Sources | #leadsources.recordcount# leadsource record<cfif leadsources.recordcount gt 1>s</cfif> found...</h3>
										
									
									</div><!-- / .widget-header -->
								</cfoutput>
								
								<cfoutput>
								<div class="widget-content">
								
									<cfif leadsources.recordcount eq 0>
									
										
										<div class="alert alert-block alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<h3><i style="font-weight:bold;" class="icon-check"></i>SUCCESS!</h3>
											<p><a href="#application.root#?event=#url.event#&fuseaction=editsource&srcid=0" class="btn btn-default btn-medium"><i class="icon-plus"></i> Add Lead Source</a></p>
										</div>
									
									
									
									<cfelse>								
									
											
											<h4><a href="#application.root#?event=#url.event#&fuseaction=editsource&srcid=0" class="btn btn-default btn-small"><i class="icon-plus"></i> Add Lead Source</a><a href="#application.root#?event=page.admin" style="margin-left:5px;" class="btn btn-tertiary btn-small"><i class="icon-home"></i> Admin Home</a></h4>
										
											
											<table class="table tablesorter table-bordered table-striped table-highlight">
												<thead>
													<tr>														
														<th>Edit Lead Source</th>
														<th>Status</th>
														<th class="action">Delete</th>
													</tr>
												</thead>
												<tbody>
													<cfloop query="leadsources">														
														<tr>
															<form name="edit-leadsource-inline" class="form-inline" action="#cgi.script_name#?event=#url.event#&fuseaction=editsource&srcid=#leadsourceid#" method="post">
																<td><input type="text" name="leadsource" class="input-large" value="#trim( leadsource )#" <cfif trim( leadsource ) is "">placeholder="Enter Source Name"</cfif> /> <button style="margin-left:7px;margin-top:-10px;" type="submit" class="btn btn-small btn-secondary" name="savelead"><i class="icon-save"></i> Save</button></td>																									
																<td><cfif active eq 1><span class="label label-success">Active</span><cfelse><span class="label label-important">Inactive</span></cfif></td>															
																<input name="lsid" type="hidden" value="#leadsourceid#" />
																<input name="comid" type="hidden" value="#session.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<td class="actions">
																	
																	<a href="#application.root#?event=#url.event#" class="btn btn-mini btn-secondary">
																		<i class="btn-icon-only icon-trash"></i>										
																	</a>
																
																</td>
															</form>
														</tr>														
													</cfloop>
												</tbody>
											</table>						
											
											<br />
											
											<!--
											<p class="tip">
												<span class="label label-info">TIP!</span> &nbsp; Click the column headers to sort the data.  You can sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
											</p>
											--->
									
									
									</cfif>
								
								
								
								
								</div><!-- / .widget-content -->
								</cfoutput>
							</div><!-- / .widget -->
						
						
						
						
						</div><!-- / .span12 -->
						
					</div><!-- / .row -->
					
				</div><!-- / . container -->
			
			</div><!-- / .main -->
			
			