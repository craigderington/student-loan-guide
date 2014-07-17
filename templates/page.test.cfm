

			<cfparam name="mycomp" default="">
			<cfset mycomp = createobject( "component", "apis.com.admin.companyadmingateway" ) />
			
			<link rel="stylesheet" href="../css/tablesorter/style.css" type="text/css" />
			
			
			
			
			
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
								<h3>Tiny MCE</h3>						
							</div> <!-- //.widget-header -->
							
							<div class="widget-content">
								
								<!--- // 
								<cfquery datasource="#application.dsn#" name="getclientswithplans">
									select distinct(i.implementid), l.leadid, i.solutionid
									  from leads l, implement i, solution s
									 where l.leadid = i.leadid
									   and l.leadid = s.leadid
									   and l.companyid = 446
									   and s.solutioncompleted = 1
								</cfquery>
								
								<cfoutput query="getclientswithplans">	
									
									<cfquery datasource="#application.dsn#" name="thisdata">
										select *
										from implementation i, leads l
										where i.leadid = l.leadid
										and i.solutionid in(<cfqueryparam value="#solutionid#" cfsqltype="cf_sql_integer" list="yes" />)
										
									</cfquery>
								
								</cfoutput>	
								
								--->
								
								<cfoutput>

									<!-- // default param -->
									<cfparam name="docsourceprefix" default="">
									<cfparam name="sourcedocpath" default="">
									<cfparam name="docsourcecompany" default="">
									<cfparam name="docsourcedocument" default="">
									<cfparam name="docsource" default="">
									
									<!--- // source pdf document --->
									
									
									<cfset docsourceprefix = "D:\WWW\studentloanadvisoronline.com\library\company\" />
									<cfset sourcedocpath = "/efiscal/efiscal-enrollment-agreement.pdf" />
									<cfset docsourcecompany = listfirst( sourcedocpath, "/" ) />
									<cfset docsourcedocument = listlast( sourcedocpath, "/" ) />
									
									
									<cfset docsource = docsourceprefix & docsourcecompany & "\" & docsourcedocument />
									
									#sourcedocpath#<br />
									#docsource#
									
								
								</cfoutput>
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								<cfparam name="mycode" default="">
								<cfset mycode = "DN" />
								
								<!---
								<cfinvoke component="apis.com.trees.statuscodes" method="getcodelist" returnvariable="codelist">			
									<cfinvokeargument name="scode" value="#mycode#" >
								</cfinvoke>
								--->
								
								<cfscript>
									// create object
									mycodelist = createobject( "component", "apis.com.system.statuscodes" ).getcodelist( mycode );														
								</cfscript>
						
								<cfif listcontainsnocase( mycodelist, mycode, "," ) eq 0>
									<cfoutput>
										#mycodelist#
									</cfoutput>
								</cfif>
								
								
								<h5>Please enter a detailed explantion narrative for this solution.  You should include a description as to why this solution was chosen.</h5>
								
								<!-- Place this in the body of the page content 
								<form name="mytextareaform" action="" method="post">
									<textarea id="cd1"></textarea>
								
								
									<br />
									
									<div class="form-actions">
									
										<a href="javascript:;" class="btn btn-secondary"><i class="icon-save"></i> Save Content</a>&nbsp;&nbsp;<a href="javascript:;" class="btn btn-primary"><i class="icon-repeat"></i> Cancel</a>
									
									</div>
								
								
								</form>
								
								<cfdump var="#mycomp#" label="Company List">
								--->
								<!---
								
								<script type="application/javascript">
									var myCountdown2 = new Countdown({
										time: 300, 
										width:100, 
										height:50, 
										rangeHi:"minute"	// <- no comma on last item!
									});

								</script>
								
								
								<br /><br />
								
								
								<script type="application/javascript">
									var test = new Countdown({time:15});
								</script>
								--->
								
								
								<cfoutput>
								http<cfif cgi.HTTPS EQ 'On'>s</cfif>://#cgi.server_name##cgi.path_info#<cfif cgi.query_string NEQ ''>?#cgi.query_string#</cfif>
								</cfoutput>
								
								<cfdump var="#cgi#" label="My CGI Vars">
								
								
								
								
								
								<table id="tablesorter" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
									<thead>
										<tr>
											<th>First Name</th>
											<th>Last Name</th>
											<th>Age</th>
											<th>Total</th>
											<th>Discount</th>
											<th>Difference</th>
											<th>Date</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>Peter</td>
											<td>Parker</td>
											<td>28</td>
											<td>$9.99</td>
											<td>20.9%</td>
											<td>+12.1</td>
											<td>Jul 6, 2006 8:14 AM</td>
										</tr>
										<tr>
											<td>John</td>
											<td>Hood</td>
											<td>33</td>
											<td>$19.99</td>
											<td>25%</td>
											<td>+12</td>
											<td>Dec 10, 2002 5:14 AM</td>
										</tr>
										<tr>
											<td>Clark</td>
											<td>Kent</td>
											<td>18</td>
											<td>$15.89</td>
											<td>44%</td>
											<td>-26</td>
											<td>Jan 12, 2003 11:14 AM</td>
										</tr>
										<tr>
											<td>Bruce</td>
											<td>Almighty</td>
											<td>45</td>
											<td>$153.19</td>
											<td>44.7%</td>
											<td>+77</td>
											<td>Jan 18, 2001 9:12 AM</td>
										</tr>
										<tr>
											<td>Bruce</td>
											<td>Evans</td>
											<td>22</td>
											<td>$13.19</td>
											<td>11%</td>
											<td>-100.9</td>
											<td>Jan 18, 2007 9:12 AM</td>
										</tr>
										<tr>
											<td>Bruce</td>
											<td>Evans</td>
											<td>22</td>
											<td>$13.19</td>
											<td>11%</td>
											<td>0</td>
											<td>Jan 18, 2007 9:12 AM</td>
										</tr>
									</tbody>
								</table>
								
								<p class="tip">
									<em>TIP!</em> Sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
								</p>	
								
								
								
								
								
								
								
								<!---
								<cfquery datasource="#application.dsn#" name="manual">
									select actionplanheader, actionplanbodya
									  from actionplan
									 where optiontree = <cfqueryparam value="Advisory" cfsqltype="cf_sql_varchar" />
									   and optiondescr = <cfqueryparam value="Manual" cfsqltype="cf_sql_varchar" />
									order by actionplanid asc
								</cfquery>
							
							
								<div style="padding:25px;margin-top:50px;>
								
									<cfoutput query="manual">							
										<h5><strong>#actionplanheader#</strong></h5><br />
										#actionplanbodya#</font><br /><br /><br />						
									</cfoutput>
					
								</div>
								--->
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
	
	
	
	