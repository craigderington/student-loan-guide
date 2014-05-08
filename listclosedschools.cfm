

		<html>
			<title>Department of Education List of Closed Schools</title>
				
				<head>
				
					<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
					<link href="css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
					<link href="css/font-awesome.min.css" rel="stylesheet">
					
				
				</head>
				
				
				
			
			
			<body>
			
				<cfif not structkeyexists( form, "getclosedschools" ) >
					<form name="closedschools" method="post" action="listclosedschools.cfm">
					
						<fieldset style="border:1px solid #f2f2f2;padding:25px;margin-top:25px;">
						
							<div class="alert alert-info">								
								<strong><i class="icon-check"></i> IMPORTANT!</strong> Enter the name of the school you believe has closed.  Please make sure to spell the name as correctly as possible.
							</div>
							
							<input type="text" name="school" class="span4" placeholder="Search by School Name">
							
							<button type="submit" class="btn btn-secondary" name="getclosedschools"><i class="icon-search"></i> Search Closed Schools</button>
							<a href="javascript:window.self.close();" style="margin-left: 7px;" class="btn btn-secondary"><i class="icon-remove"></i> Close Window</a>
						
						
						</fieldset>
				
					</form>
				</cfif>
			
				<cfif structkeyexists( form, "getclosedschools" ) >
					
					<cfif structkeyexists( form, "school" ) and form.school is not "" >				
					
						<cfparam name="searchphrase" default="">
						<cfset searchphrase = #form.school# />
							<cfquery datasource="#application.dsn#" name="closedschools">
								select closedschoolid, closeddate, opeid, schoolname, location, address,
									   city, state, zipcode, country
								  from closedschools
								 where schoolname LIKE <cfqueryparam value="%#searchphrase#%" cfsqltype="cf_sql_varchar" />
							  order by schoolname asc
							</cfquery>

					
								<cfif closedschools.recordcount gt 0>
								
									<div style="margin-top:25px;margin-bottom:50px;">
									
										<table class="table table-bordered table-striped">
											<thead>
												<tr style="font-size:10px;">
													<th width="25%">School Name</th>
														<th>Location</th>
														<th>City, State, Zip</th>
														<th>OPEID</th>
														<th>Date Closed</th>
													</tr>
												</thead>
											<tbody>
												<cfoutput query="closedschools">
												<tr style="font-size:10px;">
													<td class="actions">#schoolname#</td>												
													<td>#location#</td>
													<td>#city#, #state#, #zipcode# #country#</td>
													<td>#opeid#</td>
													<td><span class="label label-inverse">#dateformat( closeddate, "mm/dd/yyyy" )#</span></td>
												</tr>
												</cfoutput>
											</tbody>
										</table>
										
										<a href="listclosedschools.cfm" class="btn btn-secondary btn-mini"><i class="icon-search"></i> Search Again</a><a href="javascript:window.self.close();" style="margin-left: 7px;" class="btn btn-secondary btn-mini"><i class="icon-remove"></i> Close Window</a>
									
									</div>
								
								<cfelse>
								
									<div style="margin-top:25px;">
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> NO SCHOOLS FOUND MATCHING QUERY!</strong> Sorry, no schools found in the closed school list matching your input.  Please try your query again...
										</div>
									</div>
									
									<a href="javascript:history.back(-1);" class="btn btn-secondary btn-mini"><i class="icon-search"></i> Search Again</a><a href="javascript:window.self.close();" style="margin-left: 7px;" class="btn btn-secondary btn-mini"><i class="icon-remove"></i> Close Window</a>
								
								</cfif>
						
						<cfelse>
				
							<div style="margin-top:25px;">
								<div class="alert alert-error">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-warning-sign"></i> USER INPUT REQUIRED!</strong> Sorry, you must enter the name of the school you wish to search for...
								</div>
							</div>
							
							<a href="javascript:history.back(-1);" class="btn btn-secondary btn-mini"><i class="icon-search"></i> Search Again</a><a href="javascript:window.self.close();" style="margin-left: 7px;" class="btn btn-secondary btn-mini"><i class="icon-remove"></i> Close Window</a>
				
						</cfif>
				
				</cfif>
			
			
			</body>
			
		
		
		
		</html>