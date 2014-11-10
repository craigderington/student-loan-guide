


			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>	
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
				<cfinvokeargument name="phonenumber" value="#compdetails.phone#">
			</cfinvoke>
			
			
			
			
			
			
			
			
			
			<div class="main">
			
				<div class="container">					
					
					<div class="row">
					
						<div class="span12">							
							
							<div class="widget stacked">
							
								<cfoutput>
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>System Settings for #compdetails.companyname#</h3>
									</div>
								</cfoutput>
								
								<div class="widget-content">							
									
									<cfoutput>
										<ul class="nav nav-tabs">
											<li class="active"><a href="#application.root#?event=#url.event#">Company Summary</a></li>
											<li><a href="#application.root#?event=page.settings.api">API Key</a></li>
											<li><a href="#application.root#?event=page.settings.welcomemessage">Welcome Message</a></li>
											<li><a href="#application.root#?event=page.settings.webservices">Webservices</a></li>										
											<li><a href="#application.root#?event=page.settings.docs">Source Documents</a></li>
											<li><a href="#application.root#?event=page.settings.other">Other Settings</a></li>
																											
										</ul>
									</cfoutput>
									
									<div class="span6">										
												
										<cfoutput>
											<h5>#compdetails.companyname#  <cfif compdetails.active eq 1><span style="margin-left:20px;padding:10px:" class="label label-info">Active</span></cfif></h5>
											<h5>#compdetails.dba#</h5>
											<h5>#compdetails.address1#</h5>
											<h5>#compdetails.city#, #compdetails.state#  #compdetails.zip#</h5>
											<h5 style="margin-top:20px;"><i class="icon-phone"></i> #phonenumber#</h5>
											<h5><i class="icon-fax"></i> #compdetails.fax#</h5>
											<h5><i class="icon-envelope"></i> #compdetails.email#</h5>											
										</cfoutput>
												
									
									
									</div>		
											
									<div class="span4">									
												
										<cfoutput>
											<h5><img src="#compdetails.complogo#"></h5>				
											<h5><a style="margin-left:225px;" href="javascript:;" onclick="javascript:window.open('templates/page.companylogo.cfm?compid=#session.companyid#','','scollbars=yes,location=no,width=800,height=640');"><small>Change Logo</small></a></h5>
											<h5>&nbsp;</h5>
											<h5>&nbsp;</h5>
											<h5>&nbsp;</h5>
											<h5>&nbsp;</h5>
											<h5>&nbsp;</h5>
										</cfoutput>	
										
									</div>
									
								
									<!---
									<div class="row" style="margin-top:100px;">
									
										<div class="span11" style="margin-top:-50px;">									
											
											
											
										</div>	
									</div>									
									--->
									
								</div><!-- / .widget-content -->
								
								
								
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->					
					
					
				</div>
			
			</div><!-- / .main -->
			
			
			
			