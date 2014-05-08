	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			
			<cfparam name="today" default="">
			<cfset today = createodbcdatetime( now() ) />
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">				
							
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-pencil"></i>							
										<h3>Student Loan Program Enrollment Documents | Electronic Signature for #leaddetail.leadfirst# #leaddetail.leadlast# | Step 2</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">

									<div class="tab-content">
												
										<div class="tab-pane active" id="tab1">											
											
											<div class="span5" style="margin-top:25px;">													
												<iframe name="enrollagreement" src="../docs/sla-client-agreement.pdf" width="400" height="450" align="left" seamless></iframe>												
											</div>
												
												
											<div class="span6" style="margin-left:10px;margin-top:25px;padding:5px;">
												
												<div class="well">													
													
													<cfoutput>
													<h4><i class="icon-money"></i> Fee Disclosures</h4>										
													<p style="color:##ff0000;"></p>
													<br>
														
														<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#3">
															<fieldset>													

																<textarea>
																	Fee Fisclosure:
																	
																	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet urna ac urna convallis euismod eu et purus. Phasellus egestas imperdiet nulla ut tristique. Mauris ac vestibulum est. Phasellus tincidunt, lorem vel ullamcorper laoreet, urna nisl rutrum magna, eu consectetur mi enim ac massa. Nam fringilla fringilla diam, ut cursus libero. Ut in augue a elit rutrum interdum quis vel velit. Aenean semper nibh magna, et mollis justo congue quis. Ut eu sapien nisi. In hac habitasse platea dictumst.

Donec tincidunt, tortor ac interdum posuere, felis mauris mollis ligula, sed fermentum libero orci a nulla. Suspendisse porta mauris vel orci feugiat adipiscing. Proin gravida tellus hendrerit, tincidunt lacus pretium, iaculis ligula. Proin ultricies mauris auctor velit tristique, sit amet cursus enim gravida. Vestibulum scelerisque pharetra nulla, quis bibendum purus feugiat at. Quisque malesuada, purus nec ornare lacinia, sem nisl venenatis lorem, eu dignissim ante eros vitae sapien. Vestibulum enim leo, iaculis sed sodales nec, porta et libero. Integer quis ultrices libero. Donec nisl tellus, cursus vel fringilla ut, aliquet eu metus. Praesent tempor mi quis orci ullamcorper, non viverra tellus euismod. Nunc dignissim porttitor tortor, in suscipit lectus lobortis sit amet. Nullam volutpat lorem non fermentum bibendum.

Quisque ultrices rutrum sem. Mauris congue nulla ac risus dictum fermentum. Maecenas sit amet porttitor sapien. Curabitur nunc lacus, auctor ut congue non, auctor sed neque. Ut quis tempus ante. Nam eleifend enim quis libero rutrum, et auctor arcu accumsan. Sed malesuada sollicitudin arcu sit amet cursus. In elementum tincidunt leo. Vivamus in cursus arcu, accumsan consequat nunc. Donec lacus metus, rutrum a adipiscing vel, placerat vitae erat. Donec fringilla massa magna, id gravida neque porttitor lobortis. Donec vel urna tristique, pretium leo at, luctus ante.

Fusce ullamcorper tristique tellus a gravida. Donec dignissim tincidunt lectus id dictum. Vivamus imperdiet rutrum interdum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis fringilla tortor id aliquam cursus. Aenean ornare, felis a blandit molestie, enim orci porta orci, vitae congue augue nunc in orci. Sed lacinia erat mi, ornare aliquet neque vestibulum at. Donec eu nulla dui. Suspendisse auctor risus sed ligula tempor, vel fringilla lectus sagittis. Maecenas faucibus lacus nec varius viverra. In molestie lobortis metus, ut congue sem tincidunt ac. Praesent ac elit ac tortor dapibus eleifend quis et nibh. Etiam turpis sem, pulvinar non lectus vitae, mollis vulputate libero.

Fusce viverra nulla nulla, facilisis pharetra neque suscipit in. Etiam elementum lacus sed rhoncus placerat. Fusce feugiat placerat lacus sed ullamcorper. Morbi volutpat, erat nec luctus sodales, massa ante faucibus nisi, a blandit est urna pharetra massa. Aenean vitae ipsum mauris. Sed blandit euismod vehicula. Morbi ac ultrices ante. Donec luctus molestie diam at tincidunt. Curabitur at justo at urna aliquam sodales facilisis ac enim. Maecenas odio turpis, elementum eu tempor in, rhoncus in nunc. Suspendisse sollicitudin metus ut fringilla dapibus.
																</textarea>
																
																<br />											
																
																<div class="form-actions">													
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.portal.home'"><i class="icon-remove-sign"></i> Cancel</a>
																	<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-circle-arrow-right"></i> Continue </button>											
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																	<input type="hidden" name="__authToken" value="#randout#" />								
																	
																</div> <!-- /form-actions -->
																
															</fieldset>
														</form>
														</cfoutput>		
													</div>
												</div>
											
											
											
											
											
										</div> <!-- / .tab1 -->										 
											
									</div> <!-- / .tab-content -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:335px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		