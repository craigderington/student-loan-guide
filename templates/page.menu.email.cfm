
		
		
		<!--- // get our data access components --->
		<cfinvoke component="apis.com.messages.messagegateway" method="getmessages" returnvariable="msglist">
		
		
		
		
		
		
		<!--- // manage email menu library --->
		
		

		<div class="main">	
				
			<div class="container">
					
				<div class="row">
			
					<div class="span12">
						
						<cfif structkeyexists( url, "msg" )>						
							<div class="row">
								<div class="span12">
									<cfif trim( url.msg ) is "saved">
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>Success!</strong>  The library email message details were successfully updated...
										</div>
									<cfelseif trim( url.msg ) is "added">
										<div class="alert">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>Success!</strong>  The new library email message was successfully added to the database...
										</div>
									<cfelseif trim( url.msg ) is "deleted">
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>Success!</strong>  The library email message was successfully deleted from the system...
										</div>
									</cfif>
								</div>								
							</div>							
						</cfif>			

						
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-book"></i>							
								<h3>Manage Email Library</h3>				
							</div> <!-- //.widget-header -->
								
							<div class="widget-content">						
																		
								
								<cfif msglist.recordcount eq 0>
								
									<div class="alert">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<i class-"icon-warning-sign"></i>  There are no email messages in the library.  Please <a href="index.cfm?event=page.menu.email.add">click here</a> to add a new email message.
									</div>
								
								<cfelse>
									
									<cfoutput>
										<h5><strong>Showing #msglist.recordcount# Record<cfif msglist.recordcount gt 1>s</cfif></strong> <a href="#application.root#?event=#url.event#.add" class="btn btn-small btn-tertiary" style="float:right;"><i class="icon-envelope"></i> Add Message</a></h5>
									</cfoutput>
									
									<table class="table table-bordered table-striped table-highlight">
										<thead>
											<tr>
												<th width="12%">Actions</th>
												<th width="20%">Message Name</th>
												<th>Message Text</th>											
												<th>Status</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="msglist">
											<tr>
												<td class="actions">											
													<a href="javascript:void(0);" class="btn btn-mini btn-warning">
														<i class="btn-icon-only icon-ok"></i>										
													</a>
													<cfif isuserinrole("admin")>		
													<a href="#application.root#?event=#url.event#.edit&msgid=#msgid#" class="btn btn-mini">
														<i class="btn-icon-only icon-pencil"></i>										
													</a>
															
													<a href="#application.root#?event=#url.event#.delete&msgid=#msgid#" class="btn btn-mini btn-inverse">
														<i class="btn-icon-only icon-trash"></i>										
													</a>
													</cfif>
												</td>
												<td>#msgname#<cfif trim( msgtype ) is "text"><span class="label label-success" style="float:right;"><small>Text</small></span></cfif></td>
												<td>#urldecode(msgtext)#</td>											
												<td><cfif active eq 1><span class="label label-inverse">ACTIVE</span><cfelse><span class="label label-important">INACTIVE</span></cfif></td>
											</tr>
											</cfoutput>	
										</tbody>
									</table>
								
								</cfif>	

								<div class="clear"></div>
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->			
				
				<cfif msglist.recordcount lt 5>
				<div style="height:400px;"></div>			
				<cfelse>
				<div style="height:100px;"></div>	
				</cfif>
			
			
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->