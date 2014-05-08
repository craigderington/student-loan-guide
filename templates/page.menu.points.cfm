
		
		<cfinvoke component="apis.com.system.pointsgateway" method="getpoints" returnvariable="pointslist">
		
		
		
		
		<!--- // delete the clarifying point // check on query string variable --->
		<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletepoint" >		
			<cfif structkeyexists( url, "pid" ) and isvalid( "uuid", url.pid ) >			
				<cfparam name="pid" default="">
				<cfset pid = #url.pid# />			
				<!-- // get the point primary key id --->
				<cfquery datasource="#application.dsn#" name="getpoint">
					select pointid
					  from clarifyingpoints
					 where pointuuid = <cfqueryparam value="#pid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>				
				<!--- // delete the point and redirect --->
				<cfquery datasource="#application.dsn#" name="killpoint">			
					delete
					  from clarifyingpoints
					 where pointid = <cfqueryparam value="#getpoint.pointid#" cfsqltype="cf_sql_integer" />				
				</cfquery>				
				<cflocation url="#application.root#?event=page.menu.points&msg=deleted&filter=true" addtoken="no" >			
			</cfif>		
		</cfif>
		
		
		
		<!--- // manage clarifying points library --->
		

		<div class="main">	
				
			<div class="container">
					
				<div class="row">
			
					<div class="span12">
						
						<cfif structkeyexists(url, "msg")>						
							<div class="row">
								<div class="span12">
									<cfif url.msg is "saved">
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<i class="icon-check"></i> <strong>Success!</strong>  The option tree sub category clarifying point was successfully updated...
										</div>
									<cfelseif url.msg is "added">
										<div class="alert alert-notice">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<i class="icon-check"></i> <strong>Success!</strong>  The new option tree sub category clarifying point was successfully added to the database...
										</div>
									<cfelseif url.msg is "deleted">
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<i class="icon-check"></i> <strong>Success!</strong>  The option tree sub category clarifying point was successfully deleted from the system...
										</div>
									</cfif>
								</div>								
							</div>							
						</cfif>			

						
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-book"></i>							
								<h3>Manage Option Tree Sub Category Clarifying Points</h3>				
							</div> <!-- //.widget-header -->
								
							<div class="widget-content">						
																		
								
								<cfif pointslist.recordcount eq 0>
								
									<div class="alert alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<i class-"icon-warning-sign"></i>  Sorry, no option tree clarifying points match your filter input.  Please <a href="javascript:history.back(-1);">click here</a> to go back.
									</div>
									
									<a href="javascript:history.back(-1);" class="btn btn-secondary btn-mini" style="margin-top:10px;"><i class="icon-circle-arrow-left"></i> Go Back</a> 
									
									
								<cfelse>
									
									<cfoutput>
										<h5><strong>#pointslist.recordcount# Record<cfif pointslist.recordcount gt 1>s</cfif> Found</strong> <cfif not structkeyexists( url, "filter" )><a href="#application.root#?event=page.menu.points&filter=true">Filter List</a><cfelse><a href="#application.root#?event=page.menu.points">Hide Filter</a></cfif> <a href="#application.root#?event=page.menu.point.add" class="btn btn-small btn-secondary" style="float:right;"><i class="icon-envelope"></i> Add New Point</a></h5>
									</cfoutput>
									
									<!--- // define vars for pagination --->
									<cfparam name="url.startRow" default="1" >
									<cfparam name="url.rowsPerPage" default="10" >										
									<cfparam name="currentPage" default="1" >
									<cfparam name="totalPages" default="0" >
									
									<cfif structkeyexists( form, "pointtype") or structkeyexists( form, "pointtitle" ) >
										<cfset url.rowsPerPage = 30 />
									<cfelse>
										<cfset url.rowsPerPage = 10 />
									</cfif>
									
									
									<cfif structkeyexists( url, "filter" )>
										<cfinvoke component="apis.com.system.pointsgateway" method="getpointfiltertype" returnvariable="pointfiltertype">
										<cfoutput>
										<div class="well" style="padding: 10px; margin-top: 5px;">
											<form name="filter-struct" method="post" action="#cgi.script_name#?event=#url.event#&filter=true">
												<div class="clearfix">
													<div class="inputs">
														<div class="inline-inputs">										
															<select name="pointtype" id="pointtype" class="large" onChange="javascript:this.form.submit();">
																<option value="">Filter By Type</option>
																<cfloop query="pointfiltertype">
																<option value="#pointtype#"<cfif isdefined( "form.pointtype" ) and form.pointtype EQ pointtype>selected</cfif>>#pointtype#</option>
																</cfloop>
															</select>&nbsp;&nbsp;																				
															<input type="text" name="pointtitle" placeholder="Search by Title" class="large" title="Search by Title" onBlur="javascript:this.form.submit();" <cfif isdefined( "form.pointtitle" )>value="#form.pointtitle#"</cfif> />
															<cfif isdefined( "form.pointtype" ) or isdefined( "form.pointitle" ) >
															<input type="button" class="btn btn-medium btn-inverse" style="margin-top: -8px" name="cancelFilter" value="Clear Filter" onClick="location.href='#cgi.script_name#?event=#url.event#'">
															</cfif>
															<span class="help-block">Use the available filters above to refine your search parameters...</span>
														</div>
													</div>
												</div>						
											</form>					
										</div><!-- // form well -->
										</cfoutput>
									</cfif>
									
									
									<table class="table table-bordered table-striped table-highlight">
										<thead>
											<tr>
												<th width="12%">Actions</th>
												<th>Title</th>
												<th>Type</th>	
												<th>Applies To Category</th>																							
												<th>Status</th>
												<th>Sort Order</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="pointslist" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
											<tr>
												<td class="actions">												
													<cfif isuserinrole("admin")>		
													<a href="#application.root#?event=page.menu.point.edit&pid=#pointid#" class="btn btn-small btn-primary">
														<i class="btn-icon-only icon-pencil"></i>										
													</a>
															
													<a href="#application.root#?event=page.menu.points&fuseaction=deletepoint&pid=#pointuuid#" onclick="return confirmDelete();" class="btn btn-small btn-inverse">
														<i class="btn-icon-only icon-trash"></i>										
													</a>
													</cfif>
												</td>
												<td>#title# <cfif redflag eq 1><span style="margin-left:5px;" class="label label-important"><small>RED FLAG POINT</small></span></cfif></td>
												<td><cfif len(pointtype) GT 20>#left(pointtype, 20)#...<cfelse>#pointtype#</cfif></td>
												<td>#optiontree#</td>																						
												<td><cfif active eq 1><span class="label label-inverse">ACTIVE</span><cfelse><span class="label label-important">INACTIVE</span></cfif></td>
												<td><span class="badge badge-info">#pointorder#</span></td>
											</tr>
											</cfoutput>	
										</tbody>
									</table>
									<br />
									<!--- // 9-20-2013 // new pagination ++ page number links --->
													
										<cfset totalRecords = pointslist.recordcount >
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
									
									
									
								
								</cfif>	

								<div class="clear"></div>
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->			
				
				<cfif pointslist.recordcount lt 5>
				<div style="height:400px;"></div>			
				<cfelse>
				<div style="height:100px;"></div>	
				</cfif>
			
			
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->
		
		
		
		<!--- ****************************************************************************** --->
		<!--- ********************** JAVASCRIPT - CONFIRM SUBMIT *************************** --->
		<!--- ****************************************************************************** --->

		<script LANGUAGE="JavaScript">
			<!--
			// *** CLD - 2007-08-06 - Alert Confirm Delete
			function confirmDelete()
			{
			var agree=confirm("Are you sure you want to delete this clarifying point?");
			if (agree)
				return true ;
			else
				return false ;
			}
			// -->
		</script>

		
		
		
		
		
		
		
		
		
		
		