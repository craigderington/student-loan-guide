

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
								<h3>SLA | Testing Dev Sandbox Event Page</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">

								<H4>CFSwitch</h4>
								<cfparam name="thispaytype" default="dc">
								<cfparam name="mypaytype" default="">
									<!--- // output readable payment type --->
									<cfswitch expression="#thispaytype#">															
																		<cfcase value = "ach">
																			<cfset mypaytype = "ACH" />
																		</cfcase>
																		<cfcase value = "cc">
																			<cfset mypaytype = "Credit Card" />
																		</cfcase>
																		<cfcase value = "dc">
																			<cfset mypaytype = "Debit Card" />
																		</cfcase>
																		<cfcase value = "csh">
																			<cfset mypaytype = "Cash" />
																		</cfcase>
																		<cfcase value = "chk">
																			<cfset mypaytype = "Check" />
																		</cfcase>
																		<cfcase value = "mo">
																			<cfset mypaytype = "Money Order" />
																		</cfcase>																																				
																	</cfswitch>

									
								
								
								<cfset thisKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />
								<cfset nvpvar = "This is the text I want to encrypt." />
								
								<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
								<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">							
									<cfinvokeargument name="theKey" value="#thiskey#" />
									<cfinvokeargument name="nvpvar" value="#nvpvar#">					
								</cfinvoke>
								
								<cfoutput>

									<p>Case Value: #mypaytype#</p>
									
									
									#thiskey# <br />
									#nvpvar#  <br />
		
									<!---
									
									<cfparam name="templatepath" default="">
									<cfparam name="lead.email" default="craig@efiscal.net">
									<cfparam name="company.email" default="info@efiscal.net">
									<cfparam name="company.name" default="eFiscal Networks, LLC.">
									<cfset templatepath = "../library/company/efiscal/client-login-email-template.cfm" />
									
									
									<!--- // 12-29-2014 // modify to allow for dynamic email templates --->					
									<cfif isvalid( "email", lead.email ) and isvalid( "email", company.email )>							
										<cfmail from="#company.email# (#company.name#)" to="#lead.email#" subject="Student Loan Counseling Portal Available" type="HTML">																			
											<!--- // include the dynamic body // client-login-email-template.cfm in company library path --->
											<cfinclude template="#templatepath#">																
										</cfmail>
										<cfset msg = "Client Portal Login Email sent successfully..." />
									</cfif>
									
									
									<cfoutput>
									   Template Path: #templatepath#									   
									   <br />
									   
									    <cfif isdefined("msg")>
										#msg#
									   </cfif>
									  
									</cfoutput>
									
									--->
									
									
									
									
									
									<h4><i class="icon-list-alt"></i> Lists<h4>
									
									<cfparam name="tree1" default="">
									<cfset tree1 = listappend( tree1, "Disability" ) />
									<cfset tree1 = listappend( tree1, "9/11" ) />
									<cfset tree1 = listappend( tree1, "Ability to Benefit" ) />
									
									<p style="padding:10px;">#tree1#</p>
								
								</cfoutput>	


								<h3>ArrayNew Example</h3>
								
								<!--- Create an array. --->
								<cfset thislist = "Ability to Benefit, Unpaid Refund, Closed School" />
								<cfset mynewarr = listtoarray( thislist ) />
								
								<cfdump var="#mynewarr#" label="thisNewArray">
								
								
								<!--- Create a structure and set its contents. --->
								<cfset tree1=structnew()>

								<cfset subcat1c = StructInsert(tree1, "Cancellation", "Ability to Benefit,Unpaid Refund,Closed School")>
								<cfset subcat1f = StructInsert(tree1, "Forgiveness", "Teacher Loan")>
								<cfset subcat1r = StructInsert(tree1, "Repayment Plan", "Consolidation,Non-Consolidation")>

								<!--- Build a table to display the contents --->
								<cfoutput>
								<table cellpadding="2" cellspacing="2">
									<tr>
										<td><b>Option</b></td>
										<td><b>Sub Category</b></td>
									</tr>
									<!--- Use cfloop to loop through the departments structure. 
									The item attribute specifies a name for the structure key. --->
									<cfloop collection=#tree1# item="option">
										<tr>
											<td>#option#</td>
											<td>#tree1[option]#</td>
										</tr>
									</cfloop>
								</table>
								</cfoutput>

								
								
								<!--- Is it an array? 
								<cfoutput>
									<!---p>Is this an array? #IsArray(MyNewArray)#</p>
									<p>It has #ArrayLen(MyNewArray)# elements.</p>
									<p>Contents: #ArrayToList(MyNewArray)#</p>
								 The array has expanded dynamically to six elements with the use of ArraySet,
									even though we only set three values. --->
								</cfoutput>--->
								
								
								<cfoutput>
									
									<cfquery datasource="#application.dsn#" name="mmisolutiondetail">
										select *
										from mmisolutiondetail
										where mmisolutionid = 98779
									</cfquery>
								
								
									<cfloop query="mmisolutiondetail">					
										
										<cfquery datasource="#application.dsn#" name="showplan">
											select ap.optiontree, ap.optiondescr, ap.optionsubcat, ap.actionplanheader, ap.actionplanbodya
											  from actionplan ap
											 where ap.optiondescr IN(<cfqueryparam value="#trim( mmisolutiondetail.mmisolutionoption )#" cfsqltype="cf_sql_varchar" />)
											   and ap.optionsubcat IN(<cfqueryparam value="#trim( mmisolutiondetail.mmisolutionsubcat )#" cfsqltype="cf_sql_varchar" list="yes" />)								   
											   and ap.optiontree LIKE <cfqueryparam value="%#mmisolutiondetail.mmisolutiontree#%" cfsqltype="cf_sql_varchar" />								   
										  order by ap.actionplanid asc					
										</cfquery>
									
											<!--- // now loop over the action plan items and produce output --->
											<!--- // this is a nested loop --->
													
												<h3 style="margin-top:5px;font-family:Verdana;font-weight:bold;font-size:16px;"><strong>Loan Type: #ucase( mmisolutiondetail.mmisolutiontree )#</strong></h3><br />
												
												
													
												<cfloop query="showplan">																									
													<h4 style="margin-top:25px;font-family:Verdana;font-weight:bold;font-size:14px;"><strong>#optiondescr# #optionsubcat#</strong></h4>
												
													<p style="font-family:Verdana;font-weight:bold;font-size:14px;margin-top:10px;">Steps to Implement Solution</p>
													<p style="font-family:Verdana;font-weight:bold;font-size:12px;">#urldecode( showplan.actionplanbodya )#</p>							
												</cfloop>
												
												<!---
												<cfdump var="#showplan#" label="Plan Query">
												--->

									</cfloop>
									
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
			
			
			
			
											