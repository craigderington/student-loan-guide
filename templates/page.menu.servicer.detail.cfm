
				
				

			<!--- // loan servicer detail --->
			<cfinvoke component="apis.com.system.servicers" method="getservicer" returnvariable="srvdetail">
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
				<cfinvokeargument name="phonenumber" value="#srvdetail.servphone#">				
			</cfinvoke>
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber2" returnvariable="phonenumber2">
				<cfinvokeargument name="phonenumber2" value="#srvdetail.servfax#">				
			</cfinvoke>
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatofficenumber" returnvariable="officenumber">
				<cfinvokeargument name="officenumber" value="#srvdetail.servphone2#">				
			</cfinvoke>
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatfaxnumber" returnvariable="faxnumber">
				<cfinvokeargument name="faxnumber" value="#srvdetail.servfax2#">				
			</cfinvoke>
				
				
					
			
			<div class="main">

				<div class="container">

					<div class="row">
					
						<div class="span8">      		
						
							<div class="widget stacked ">
								
								<cfoutput>
								<div class="widget-header">
									<i class="icon-user"></i>
									<h3>#srvdetail.servname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								
								<div class="widget-content">
									
									
									
									<div class="tabbable">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#profile" data-toggle="tab">Profile</a>
											</li>
											<li><a href="#stats" data-toggle="tab">Stats</a></li>
										</ul>
									
									<br>
										
										<div class="tab-content">
											
											<cfoutput>
											<div class="tab-pane active" id="profile">
											
												<fieldset>
													
													<table width="100%" name="mytable" cellspacing="0" cellpadding="15">
													
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Type:</td>
															<td>#srvdetail.servtype#</td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Name:</td>
															<td>#srvdetail.servname#</td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;vertical-align:top;">Address:</td>
															<td>#srvdetail.servadd1#  <cfif srvdetail.servadd2 is not ""><br />#srvdetail.servadd2#</cfif></td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">City, State, Zip:</td>
															<td>#srvdetail.servcity#, #srvdetail.servstate#  #srvdetail.servzip#</td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Phone:</td>
															<td>#phonenumber# <cfif srvdetail.servphone2 is not ""> &nbsp;&nbsp; Alternate: #officenumber#</cfif></td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Fax:</td>
															<td>#phonenumber2# <cfif srvdetail.servfax2 is not ""> &nbsp;&nbsp; Alternate: #faxnumber#</cfif></td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Email:</td>
															<td>#srvdetail.servemail#</td>														
														</tr>
														
														<tr>														
															<td width="25%" style="font-weight:bold;">Servicer Status:</td>
															<td><cfif srvdetail.servactive eq 1><span class="label label-success" style="padding:7px;">ACTIVE</span><cfelse><span class="label label-important" style="padding:7px;">INACTIVE</span></cfif></td>														
														</tr>
													
													</table>													
													
														
														<br />													
														
													
													
													
													<div class="form-actions">
														<button type="submit" class="btn btn-secondary" onClick="location.href='index.cfm?event=page.menu.servicers'"><i class="icon-exchange"></i> Return to List</button> 
														<cfif isuserinrole("admin")>
														<button style="margin-left:5px;" class="btn btn-primary" onClick="location.href='index.cfm?event=page.menu.servicer.edit&srvid=#srvdetail.servid#'"><i class="icon-edit"></i> Edit Servicer</button>
														</cfif>
													</div> <!-- /form-actions -->
												
												
												
												
												</fieldset>
											
											</div>
											</cfoutput>
											
											<div class="tab-pane" id="stats">
												
													<fieldset>												
														
														<div class="control-group">
															<label class="control-label" for="accounttype">Loan Servicer Statistics</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="accounttype" value="option1" checked="checked" id="accounttype">
																	POP3
																</label>
																<label class="radio">
																	<input type="radio" name="accounttype" value="option2">
																	IMAP
																</label>
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="accountusername">Account Username</label>
															<div class="controls">
																<input type="text" class="input-large" id="accountusername" value="rod.howard@example.com">
																<p class="help-block">Leave blank to use your profile email address.</p>
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="emailserver">Email Server</label>
															<div class="controls">
																<input type="text" class="input-large" id="emailserver" value="mail.example.com">
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="accountpassword">Password</label>
															<div class="controls">
																<input type="text" class="input-large" id="accountpassword" value="password">
															</div>
														</div>											
														
														<div class="control-group">
															<label class="control-label" for="accountadvanced">Advanced Settings</label>
															<div class="controls">
																<label class="checkbox">
																	<input type="checkbox" name="accountadvanced" value="option1" checked="checked" id="accountadvanced">
																	User encrypted connection when accessing this server
																</label>
																<label class="checkbox">
																	<input type="checkbox" name="accounttype" value="option2">
																	Download all message on connection
																</label>
															</div>
														</div>

														
														<br />													
														
													</fieldset>
												
											</div>
											
										</div>
									  
									  
									</div>			
									
									
								</div> <!-- /widget-content -->
									
							</div> <!-- /widget -->
							
						</div> <!-- /span8 -->
					
					
						<div class="span4">						
							
							<div class="widget stacked widget-box">
								
								<cfoutput>
								<div class="widget-header">
									<h3>Additional Information</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								
								<div class="widget-content">									
										
									<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
																		
									<p> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
									
								</div> <!-- /widget-content -->
								
							</div> <!-- /widget-box -->
												
						</div> <!-- /span4 -->
						
					</div> <!-- /row -->

				</div> <!-- /container -->
				
			</div> <!-- /main -->