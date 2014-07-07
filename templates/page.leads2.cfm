
		
		
		<!--- close the client record and destroy session vars --->
		<cfif structkeyexists(session, "leadid")>				
			<cfparam name="tempX" default="">					
			<cfset tempX = structdelete(session, "leadid")>			
			<cfif structkeyexists(session, "leadconv")>
				<cfparam name="tempZ" default="">					
				<cfset tempZ = structdelete(session, "leadconv")>	
			</cfif>			
			<cflocation url="#application.root#?event=page.leads" addtoken="no">			
		</cfif>	
		
		<!--- include our data access components --->
		<cfinvoke component="apis.com.leads.leadgateway" method="getmleadlist" returnvariable="mleadlist">			
			<cfinvokeargument name="companyid" value="#session.companyid#">
			<cfinvokeargument name="userid" value="#session.userid#">
			<cfinvokeargument name="thisdate" value="#dateformat(now(), 'MM/DD/YYYY')#">			
		</cfinvoke>
		
		<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
			<cfinvokeargument name="companyid" value="#session.companyid#">				
		</cfinvoke>
		
		<cfinvoke component="apis.com.reports.reportgateway" method="getcounselorlist" returnvariable="counselorlist">
			<cfinvokeargument name="companyid" value="#session.companyid#">			
		</cfinvoke>
		
		<!--- // redirect if lead list is empty --->
		<cfif not structkeyexists( form, "filtermyresults" ) and mleadlist.recordcount eq 0>
			<cflocation url="#application.root#?event=page.lead.new" addtoken="no">
		</cfif>
		 
		
		<!--- // additonal stylesheet for large support buttons --->
		<link href="./js/plugins/faq/faq.css" rel="stylesheet">		

		<!--- // leads --->
		<div class="main">

			<div class="container">

				<div class="row">
      	
					<div class="span12">	
						
						<div class="widget stacked">
							
							<cfoutput>	
								<div class="widget-header">
									<i class="icon-globe"></i>
									<h3>New Program Enrollment Inquiries for  #session.companyname#</h3>
								</div> <!-- /widget-header -->
							</cfoutput>
							
							
							
							<div class="widget-content">			
										
										<!--- // data grid  filter	--->							
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												<form class="form-inline" name="filterresults" method="post">																				
													
													<select name="leadsource" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Select Inquiry Source</option>
															<cfloop query="leadsources">
																<option value="#leadsourceid#"<cfif isdefined( "form.leadsource" ) and form.leadsource eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
															</cfloop>												
													</select>
													<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin ") or isuserinrole( "sls" )>
														<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Select Counselors</option>
															<cfloop query="counselorlist">
																<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq counselorlist.userid>selected</cfif>>#firstname# #lastname#</option>
															</cfloop>												
														</select>
													</cfif>
													<input type="text" name="filterbyname" style="margin-left:5px;" class="input-medium" placeholder="Filter By Name" id="filterbyname" value="<cfif isdefined( "form.filterbyname" )>#trim( form.filterbyname )#</cfif>" onchange="javascript:this.form.submit();" />
													<input type="text" name="startleaddate" style="margin-left:5px;" class="input-small" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startleaddate" )>#dateformat( form.startleaddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="endleaddate" style="margin-left:5px;" class="input-small" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.endleaddate" )>#dateformat( form.endleaddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:3px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:3px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->			
									
										<cfif mleadlist.recordcount gt 0>


												<!--- activity log pagination --->
												<cfparam name="startrow" default="1">
												<cfparam name="displayrows" default="10">
												<cfparam name="torow" default="0">												
												
												<cfset torow = startrow + ( displayrows - 1 ) />
												<cfif torow gt mleadlist.recordcount>
													<cfset torow = mleadlist.recordcount />
												</cfif>												
												
												<cfset next = startrow + displayrows>
												<cfset prev = startrow - displayrows>

												
												<cfoutput>
													<h5><i style="margin-right:5px;" class="icon-th-large"></i> Total New Inquiry Records: #mleadlist.recordcount# | Displaying #startrow# to #torow#      <span class="pull-right"><cfif prev gte 1><a style="margin-bottom:5px;" href="#application.root#?event=#url.event#&startrow=#prev#" class="btn btn-medium btn-secondary"><i class="icon-circle-arrow-left"></i> Previous #displayrows# Records</a></cfif><cfif next lte mleadlist.recordcount><a style="margin-bottom:5px;margin-left:5px;" class="btn btn-medium btn-default" href="#application.root#?event=#url.event#&startrow=#next#">Next <cfif ( mleadlist.recordcount - next ) lt displayrows>#evaluate(( mleadlist.recordcount - next ) + 1 )#<cfelse>#displayrows#</cfif> Records <i class="icon-circle-arrow-right"></i></a></cfif>  <a href="#application.root#?event=page.lead.new" style="margin-left:5px;margin-bottom:5px;" class="btn btn-medium btn-primary"><i class="icon-plus"></i> Create New Inquiry</a></span></h5>
												</cfoutput>
											
												
												<!--- // show data grid --->
												<table id="tablesorter" class="table table-bordered table-striped table-highlight tablesorter">
													<thead>
														<tr>
															<th width="5%">Actions</th>
															<th>Inquiry Source</th>
															<th>Name/ID</th>
															<th>Contact</th>
															<th>Email</th>									
															<th>Last Note/Date</th>
															<th>Lead Age</th>
															
														</tr>
													</thead>
													<tbody>
														<cfoutput query="mleadlist" startrow="#startrow#" maxrows="#displayrows#">
															<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
																<cfinvokeargument name="phonenumber" value="#leadphonenumber#">
															</cfinvoke>													
																<tr>
																	<td class="actions">
																		<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>						
																	</td>
																	<td>#leadsource#</td>													
																	<td>#leadfirst# #leadlast# (#leadid#)</td>
																	<td><cfif leadphonetype is not ""><span class="label label-info">#leadphonetype#</span>&nbsp;</cfif>#phonenumber#</td>														
																	<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.email" style="margin-left:7px;"><i style="margin-right:3px;" class="icon-envelope"></i></a> #leademail#</td>
																	<td><cfif lastnotedate is not "">#dateformat( lastnotedate, "mm/dd/yyyy" )# <cfif lastnotetext is not "">&nbsp;&nbsp;<a href="javascript:;" rel="popover" data-content="#urldecode( lastnotetext )#" data-original-title="#leadfirst# #leadlast#'s Last Note"><i class="btn-icon-only icon-paper-clip"></i></a></cfif><cfelse>No Notes Entered</cfif></td>
																	<td><cfif leadage is not ""><span class="label label-<cfif leadage lte 10>success<cfelseif leadage gt 10 and leadage lte 30>inverse<cfelseif leadage gt 30 and leadage lte 60>warning<cfelseif leadage gt 60>important<cfelse>info</cfif>">#leadage#<cfelse>Unknown</cfif>
																</tr>
														</cfoutput>												
													</tbody>
												</table>
												<p class="tip">
													<span class="label label-info">TIP!</span> &nbsp; Click the column headers to sort the data.  You can sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
												</p>
											<cfelse>
											
												<h5><i class="icon-th-large"></i> No Records Found</h5>
												<div class="alert alert-block alert-error">
													<h5><strong>Sorry</strong>, the report can not find any clients matching the report input filter...</h5>
													<p><i class="icon-warning-sign"></i> That's OK!  The filter is most likely working correctly, however, no database records match your input filter. <br />  Please use the button below to reset the filters and restore the default list.</p>
													<p>&nbsp;</p>
													<cfoutput>
													<p><a href="#application.root#?event=#url.event#" class="btn btn-small btn-secondary"><i class="icon-retweet"></i> Reset Filter</a></p>
													</cfoutput>											
												</div>
											
											</cfif>
								
									
								
								
								</div> <!-- /widget-content -->
								
							
						</div> <!-- /widget -->					
      	
					</div><!-- / .span12 -->
      	
				</div> <!-- /row -->
				
				<cfif mleadlist.recordcount lt 10>
					<div style="margin-top:250px;"></div>
				<cfelse>
					<div style="margin-top:100px;"></div>
				</cfif>
				
			</div> <!-- /container -->
	    
		</div> <!-- /main -->