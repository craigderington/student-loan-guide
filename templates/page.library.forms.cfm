


		<!--- // get our data access components --->
		<cfinvoke component="apis.com.system.librarygateway" method="getformslist" returnvariable="formslist">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
		
		
		
		
			<!--- // delete document function --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "killform" >
				
				<cfparam name="formid" default="">
				<cfparam name="today" default="">
				<cfset formid = #url.formid# />
				<cfset today = #CreateODBCDateTime( Now() )# />
				
					<cfif structkeyexists( url, "formid" ) and url.formid is not "" and isvalid( "uuid", url.formid ) >
						
						<!--- // get the record to log the activity --->						
						<cfquery datasource="#application.dsn#" name="getform">
							select l.libraryid, l.libuuid, l.docname, l.docpath 
							  from library l
							 where l.libuuid = <cfqueryparam value="#formid#" cfsqltype="cf_sql_varchar" maxlength="35" />
						</cfquery>
						
						<!--- // delete the document --->						
						<cfquery datasource="#application.dsn#" name="killform">
							delete
							  from library
							 where libraryid = <cfqueryparam value="#getform.libraryid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!--- // delete the file form the server path --->
						<cffile action="delete" file="#ExpandPath('library\forms')#\#getform.docpath#">					
						
						
						<!--- // log the activity --->
						<cfquery datasource="#application.dsn#" name="logact">
							insert into activity(leadid, userid, activitydate, activitytype, activity)
								values (
										<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="#session.username# deleted library form #getform.docname# from the system library." cfsqltype="cf_sql_varchar" />
										);
						</cfquery>																					
											
						<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">					
					
					<cfelse>
						
						<cfoutput>
							<script>
								alert("There was a problem with the database operation on the selected record and the operation was aborted...  Please try again.");
								self.location="#application.root#?event=#url.event#&msg=error"
							</script>
						</cfoutput>
						
					</cfif>
			
			</cfif>
			<!--- // end delete document function --->
			

			
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							
							
							<!--- system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">														
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> UPLOAD SUCCESS!</strong>  The new library form was successfully uploaded to the system library.  Please select a new file or upload another form to continue...
								</div>							
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">														
								<div class="alert alert-notice">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> DELETE SUCCESS!</strong>  The selected form was successfully deleted fromthe system library.  Please select a new file or upload another form to continue...
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "error">														
								<div class="alert alert-error">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-warning-sign"></i> SYSTEM ERROR!</strong>  Sorry, there was an internal error and the form could not be deleted.  Please select a new file or upload another form to continue...
								</div>
							</cfif>
							
							
							
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>#session.companyname# Forms Library | Found #formslist.recordcount# forms</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								
								<div class="widget-content">						
									
									<cfoutput>									
									<div style="float:right;margin-top:-15px;margin-bottom:5px;"><cfif isuserinrole( "admin" )><a href="#application.root#?event=page.library.forms.upload" class="btn btn-mini btn-secondary"><i class="icon-upload-alt"></i> Upload Form</a></cfif></div>
									</cfoutput>
									
									<cfif formslist.recordcount gt 0>
									
										<table class="table table-bordered table-highlight">
											<thead>
												<tr>
													<cfif isuserinrole( "admin" )>
													<th width="10%">Actions</th>
													<cfelse>
													<th width="5%">Actions</th>
													</cfif>
													<th width="30%">Document Name</th>
													<th>Description</th>
													<th>Date</th>												
												</tr>
											</thead>
											<tbody>
												<cfoutput query="formslist" group="doccat">
												<tr style="background-color:##f2f2f2;">
													<td colspan="4"><strong>#doccat#</strong></td>
												</tr>											
													<cfoutput>
													<tr>												
														<td>
															<a href="library/forms/#docpath#" class="btn btn-mini btn-warning" target="_blank">
																<i class="btn-icon-only icon-ok"></i>										
															</a>
															<cfif isuserinrole( "admin" )>	
																<a href="#application.root#?event=#url.event#&fuseaction=killform&formid=#libuuid#" class="btn btn-mini btn-default" onclick="return confirmdelete();">
																	<i class="btn-icon-only icon-trash"></i>										
																</a>
															</cfif>
														</td>
														<td>#docname#</td>
														<td>#docdescr#</td>
														<td>#dateformat( docdate, "mm/dd/yyyy" )#</td>												
													</tr>
													</cfoutput>
												</cfoutput>
											</tbody>
										</table>
									
									<cfelse>
									
										<div class="alert alert-error" style="margin-top:30px;">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i> NO FORM RECORDS FOUND!</strong>  Sorry, no library form records were found in the database.  Please select the upload form button to continue...
										</div>
									
									</cfif>

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					
					<cfif formslist.recordcount lt 5>
					<div style="height:350px;"></div>			
					<cfelse>
					<div style="height:200px;"></div>
					</cfif>
						
						
						<script LANGUAGE="JavaScript">
							<!--
							// *** CLD - 2007-08-06 - Alert Confirm Delete
							function confirmdelete()
							{
							var agree=confirm("Are you sure you want to delete this library document?");
							if (agree)
								return true ;
							else
								return false ;
							}
							// -->
						</script>
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->
			
			
			
			