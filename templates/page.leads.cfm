
		
		
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
		<cfinvoke component="apis.com.leads.leadgateway" method="leadsbyage" returnvariable="leadslist">			
			<cfinvokeargument name="companyid" value="#session.companyid#">
			<cfinvokeargument name="userid" value="#session.userid#">
			<cfinvokeargument name="today" value="#dateformat(now(), 'MM/DD/YYYY')#">			
		</cfinvoke>
		
		
		<!--- // redirect is lead listis empty --->
		<cfif leadslist.recordcount eq 0>
			<cflocation url="#application.root#?event=page.lead.new" addtoken="no">
		</cfif>
		
		<!--- include our data components --->
		<cfinvoke component="apis.com.leads.leadgateway" method="getrecentactivity" returnvariable="logrecent">			
			<cfinvokeargument name="userid" value="#session.userid#">
		</cfinvoke>		
		
		<!--- // additonal stylesheet for large support buttons --->
		<link href="./js/plugins/faq/faq.css" rel="stylesheet">		

		<!--- // leads --->
		<div class="main">

			<div class="container">

				<div class="row">
      	
					<div class="span8">
      		
						<div class="widget stacked">
					
							<cfif structkeyexists( url, "cfid" ) and structkeyexists( url, "cftoken" )>
								<div class="alert alert-error">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-warning-sign"></i> SYSTEM ERROR!</strong>  
									<p>Sorry, a system error has occured.  In order to view this information, you must have a lead or client selected.  Please select a record below to continue...</p>
								</div>
							</cfif>
							
							<div class="widget-header">
								<i class="icon-user"></i>
								<h3>Inquiries</h3>
							</div> <!-- /widget-header -->
				
							<div class="widget-content">
					
								<h3>Search Inquiries</h3>
									<div class="faq-container">
										<cfoutput>
										<form class="faq-search" name="leadsearch" method="post" action="#application.root#?event=page.search">
											<input type="text" name="search" placeholder="Search by Name or ID" class="input-xlarge span4" style="padding:20px;" onChange="javascript:this.form.submit();">
										</form>
										</cfoutput>
									</div>													
					
							</div> <!-- /widget-content -->
					
						</div> <!-- /widget -->
						
						<div class="widget stacked widget-box">
							
							<div class="widget-header">	
								<h3>Inquiries by Age <cfif leadslist.recordcount gt 0><cfoutput> | Found #leadslist.recordcount# active lead<cfif leadslist.recordcount gt 1>s</cfif></cfoutput></cfif></h3>			
							</div> <!-- /widget-header -->
							
							<div class="widget-content">
								<cfif leadslist.recordcount GT 0>
									<cfparam name="url.startRow" default="1" >
									<cfparam name="url.rowsPerPage" default="10" >
									<cfparam name="currentPage" default="1" >
									<cfparam name="totalPages" default="0" >
									
									
									<table id="myTable" class="table table-bordered table-striped table-highlight tablesorter">
										<thead>
											<tr>
												<th width="5%">Actions</th>												
												<th>Lead Source</th>
												<th>Inquiry Name</th>
												<th>Phone</th>
												<th>Email</th>
												<th>Age</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="leadslist" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
												<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
													<cfinvokeargument name="phonenumber" value="#leadphonenumber#">
												</cfinvoke>
													<tr>
														<td class="actions">													
															<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
																<i class="btn-icon-only icon-ok"></i>										
															</a>		
														</td>											
														<td>#leadsource#</td>
														<td>#leadfirst# #leadlast# (#leadid#)</td>
														<td><cfif leadphonenumber is not "">#phonenumber# (#leadphonetype#)<cfelse>Not Defined</cfif></td>
														<td>#leademail#</td>
														<td><span class="label label-success">#datediff( "d", leaddate, now() )#</span></td>												
													</tr>
											</cfoutput>
										</tbody>								
									</table>
									
										<!--- // 7-26-2013 // new pagination ++ page number links --->
													
											<cfset totalRecords = leadslist.recordcount >
											<cfset totalPages = totalRecords / rowsPerPage >
											<cfset endRow = (startRow + rowsPerPage) - 1 >													

												<!--- If the endrow is greater than the total, set the end row to to total --->
												<cfif endRow GT totalRecords>
													<cfset endRow = totalRecords>
												</cfif>

												<!--- Add an extra page if you have leftovers --->
												<cfif (totalRecords MOD rowsPerPage) GT 0 >
													<cfset totalPages = totalPages + 1 >
												</cfif>

												<!--- Display all of the pages --->
												<cfif totalPages gte 2>
													<div class="pagination">
														<ul>
														<cfloop from="1" to="#totalPages#" index="i">
															<cfset startRow = ((i - 1) * rowsPerPage) + 1>
																<cfif currentPage neq i>
																	<cfoutput><li><a href="#cgi.script_name#?event=#url.event#&startRow=#startRow#&currentPage=#i#">#i#</a></li></cfoutput>
																<cfelse>
																	<cfoutput><li class="active"><a href="javascript:;">#i#</a></li></cfoutput>
																</cfif>													
														</cfloop>
														</ul>
													</div>
												</cfif>
									
									
									
									
								<cfelse>
																			
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong>Sorry,</strong> there are no records to show.  Please begin by creating a new inquiry...
									</div>
								</cfif>
								
							</div> <!-- /widget-content -->
							
						</div> <!-- /widget -->
			
					</div> <!-- /span8 -->
	    
	    
	    
					<div class="span4">
					
						<div class="widget widget-plain">
				
							<div class="widget-content">
								<cfoutput>
									<a href="#application.root#?event=page.lead.new" class="btn btn-large btn-primary btn-support-ask">Create New Inquiry</a>					
									<a href="#application.root#?event=page.taskmanager" class="btn btn-large btn-secondary btn-support-ask">View Tasks</a>
									<a href="#application.root#?event=page.lead.actions" class="btn btn-large btn-tertiary btn-support-ask">View Interactions</a>								
								</cfoutput>
							</div> <!-- /widget-content -->
					
						</div> <!-- /widget -->
						
						
						
						<div class="widget stacked widget-box">
							
							<div class="widget-header">	
								<h3>Recent Activity</h3>			
							</div> <!-- /widget-header -->
							
							<div class="widget-content">
								
								<ul class="news-items">
									<cfoutput query="logrecent" maxrows="5">		
									<li>
										<div class="news-item-detail">										
											<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="news-item-title">#leadfirst# #leadlast#</a>
											<p class="news-item-preview">#activity#</p>
										</div>
												
										<div class="news-item-date">
											<span class="news-item-day">#datepart("d", recentdate)#</span>
											<span class="news-item-month">#MonthAsString(month(recentdate))#</span>
										</div>
									</li>
									</cfoutput>
								</ul>
								
							</div> <!-- /widget-content -->
							
						</div> <!-- /widget -->
						
					</div> <!-- /span4 -->
      	
					
      	
				</div> <!-- /row -->
				<cfif leadslist.recordcount lt 10>
					<div style="margin-top:250px;"></div>
				<cfelse>
					<div style="margin-top:100px;"></div>
				</cfif>

			</div> <!-- /container -->
	    
		</div> <!-- /main -->