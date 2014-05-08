	
		
		<!--- close the client record and destroy session vars --->
		<cfif structkeyexists(session, "leadid")>				
			<cfparam name="tempX" default="">					
			<cfset tempX = structdelete(session, "leadid")>
			
			<cfif structkeyexists(session, "leadconv")>
				<cfparam name="tempZ" default="">					
				<cfset tempZ = structdelete(session, "leadconv")>	
			</cfif>
			
			<cflocation url="#application.root#?event=page.clients" addtoken="no">
			
		</cfif>

		
		<!--- // get our data components --->
		<cfinvoke component="apis.com.clients.clientgateway" method="getclientlist" returnvariable="clientlist">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
		
		<cfif clientlist.recordcount eq 0>
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
					
							<div class="widget-header">
								<i class="icon-user"></i>
								<h3>Client Database</h3>
							</div> <!-- /widget-header -->
				
							<div class="widget-content">
					
								<h3>Search Clients</h3>
									<div class="faq-container">
										<cfoutput>
										<form class="faq-search" action="#application.root#?event=page.search.clients" method="post">
											<input type="text" name="search" placeholder="Search by Client Name or ID" class="input-xlarge span4" style="padding:20px;" onChange="javascript:this.form.submit();">
										</form>
										</cfoutput>
									</div>													
					
							</div> <!-- /widget-content -->
					
						</div> <!-- /widget -->
						
						<div class="widget stacked widget-box">
							
							<div class="widget-header">	
								<h3>Client List <cfif clientlist.recordcount gt 0><cfoutput> | Found #clientlist.recordcount# client<cfif clientlist.recordcount gt 1>s</cfif></cfoutput></cfif></h3>			
							</div> <!-- /widget-header -->
							
							<div class="widget-content">
								
								<cfif clientlist.recordcount GT 0>
									<cfparam name="url.startRow" default="1" >
									<cfparam name="url.rowsPerPage" default="10" >
									<cfparam name="currentPage" default="1" >
									<cfparam name="totalPages" default="0" >
									
									<table id="myTable" class="table table-bordered table-striped table-highlight tablesorter">
										<thead>
											<tr>
												<th width="5%">Actions</th>										
												<th>Client Name</th>
												<th>Phone</th>
												<th>Email</th>
												<th>Enroll Date</th>
												<th>Specialist</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="clientlist" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
												<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
													<cfinvokeargument name="phonenumber" value="#clientlist.leadphonenumber#">
												</cfinvoke>
													<tr>
														<td class="actions">													
															<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
																<i class="btn-icon-only icon-ok"></i>										
															</a>		
														</td>											
														<td>#leadfirst# #leadlast# (#leadid#)</td>
														<td><cfif phonenumber is not "">#phonenumber# (#leadphonetype#)<cfelse>Not Defined</cfif></td>
														<td>#leademail#</td>
														<td><cfif slenrollreturndate is not ""><span class="label label-inverse">#dateformat(slenrollreturndate, "mm/dd/yyyy")#</span><cfelse><span class="label label-important">Not Defined</span></cfif></td>
														<td>#firstname# #lastname#</td>												
													</tr>
											</cfoutput>
										</tbody>								
									</table>
									
										<!--- // 7-26-2013 // new pagination ++ page number links --->
													
											<cfset totalRecords = clientlist.recordcount >
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
										<strong>Sorry,</strong> there are no records to show in the list.  Please begin by creating a new inquiry...
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
								</cfoutput>
					
							</div> <!-- /widget-content -->
					
						</div> <!-- /widget -->
						
						
						
						<div class="widget stacked widget-box">
							
							<div class="widget-header">	
								<h3>Recent Client Activity</h3>			
							</div> <!-- /widget-header -->
							
							<div class="widget-content">
								
								<ul class="news-items">
									<cfoutput query="logrecent" maxrows="7">		
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
				
				<div style="margin-top:100px;"></div>

			</div> <!-- /container -->
	    
		</div> <!-- /main -->