

			<cfparam name="mycomp" default="">
			<cfset mycomp = createobject( "component", "apis.com.admin.companyadmingateway" ) />
			
			<link rel="stylesheet" href="../css/tablesorter/style.css" type="text/css" />	
			

			<cfparam name="mystr" default="">
			<cfset mystr = "e0cb04dba346fb43167d1e416103fafb29b40ce2" />
			<cfset this.name =  GetDirectoryFromPath( GetCurrentTemplatePath() )/>
			
			
			<!--- // include the tinymce js path 
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
			
			
			
			<!--- // initialize tinymce --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "cd1",
					plugins: ["code, table"],
					paste_as_text: true,
					width: 840,
					height: 400,
					toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
					font_size_style_values: ["10px,12px,13px,14px,16px,18px,20px"],					
				 });
			</script>--->
			
			
			
			
	
			<div class="container">			
				<div class="row">					
					<div class="span9">
						<div class="widget stacked">							
							<div class="widget-header">		
								<i class="icon-book"></i>							
								<h3>Go With Vanco Encryption</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">								
								
								
								<cfset thisKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />
								<cfset nvpvar = "This is the text I want to encrypt." />
								
								<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
								<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">							
									<cfinvokeargument name="theKey" value="#thiskey#" />
									<cfinvokeargument name="nvpvar" value="#nvpvar#">					
								</cfinvoke>
								
								<cfoutput>

									
									
									
									#thiskey# <br />
									#nvpvar#
		
		
		
								
								</cfoutput>			
								
								
								
								
								
								
								
								
								
								
							
								
								
								
								
								
								
								
								
								
								
								
								
							
							
								
								
							</div>
						
						</div><!-- /.widget -->
					</div><!-- /.span9 -->


					<div class="span3">
						<div class="widget stacked">							
							<div class="widget-header">		
								<i class="icon-sitemap"></i>							
								<h3>Solution Details</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">							
								The student loan debt that this solution was selected along with debt balance, payments, fees, et al.
							</div>
						
						</div><!-- /.widget -->
						
						<br />
						
						<div class="widget stacked">							
							<div class="widget-header">		
								<i class="icon-tasks"></i>							
								<h3>Follow Up Tasks</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">							
								<ul>								
									<li>Create client follow up tasks</li>
									<li>Task 1</li>
									<li>Task 2</li>
									<li>Task 3</li>								
								</ul>
							</div>
						
						</div><!-- /.widget -->
						
						<br />
						
						<div class="widget stacked">							
							<div class="widget-header">		
								<i class="icon-check"></i>							
								<h3>Other Solutions</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">							
								Other debt solutions requiring narrative input by specialist
							</div>
						
						</div><!-- /.widget -->
						
						
						
						
						
					</div>
						
						
				</div><!-- /. row -->						
				
				
				<div class="row">
				
					<div class="span12">
			
							<a href="javascript:;" rel="popover" data-content="This is the data content and is full of additional information about the selected record.  It can be dynamic data base don the actual record." data-original-title="<strong>THIS IS THE TITLE!</strong>" ><i class="icon-info-sign"></i></a>
							
							

							<form name="testform" action="" method="post">
							
								<select name="thisselect" class="input-large">
								
									<option value="1" title="This is a title and should pop up over tooltip">Option Title 1</option>
								
								</select>
							
							</form>
							
							
							<form id="upload-documents" class="form-horizontal" method="post" action="#application.root#?event=page.nslds.upload" enctype="multipart/form-data">
											<fieldset>
																
												<div class="control-group">
													<label class="control-label" for="fileuploadpath">Browse for File</label>
														<div class="controls">
															<input type="file" name="fileuploadpath" class="input-large" id="fileuploadpath">
														</div> <!-- /controls -->	
												</div> <!-- /control-group -->																																				
																
												<br />
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary msgbox-info" name="savelead"><i class="icon-upload-alt"></i> Process NSLDS File</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.worksheet'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again." />
													<!---
													<input name="validate_file" type="hidden" value="document|txt|The NSLDS text file must be in the proper file format.  Please check your file and try again..." />
													--->
												</div> <!-- /form-actions -->
											</fieldset>
							</form>
							
							
							
							<!---
							<br /><br />
							<a href="javascript:;" class="btn btn-large btn-info msgbox-alert">Alert Message</a>
							<a href="javascript:;" class="btn btn-large btn-info msgbox-info">Information Message</a>
							<a href="javascript:;" class="btn btn-large btn-info msgbox-error">Error Message</a>
							<a href="javascript:;" class="btn btn-large btn-info msgbox-confirm">Confirm Message</a>
							<a href="javascript:;" class="btn btn-large btn-info msgbox-prompt">Prompt Message</a>
							--->
					
					
							
					
					
					</div>					
					
					<div style="margin-top:300px;"></div>
					
				</div><!-- /.row -->
				
				
				
				
				
			</div><!-- /.container -->
			
			<!--- // pop the modal --->
			<cfif structkeyexists( form, "__authtoken" ) >
				<!--- // this is a modal --->
				<div class="modal" style="display: block;margin-top:60px;">
					<div class="modal-header">
						<h3>Modal header</h3>
					</div>
					
					<div class="modal-body">
						<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
					</div>
					  
					<div class="modal-footer">
						<a href="javascript:;" class="btn" data-dismiss="modal">Close</a>
						<a href="javascript:;" class="btn btn-primary">Save changes</a>
					</div>
				</div>
			</cfif>
			
			
			
			
											