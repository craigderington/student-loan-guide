




			<!--- company settings // manage menu UI 
			outcomes and contact methods --->
			
			
			<div class="main">
			
				<div class="container">
				
					<div class="row">
					
						<div class="span12">
						
							<div class="widget stacked">
								
								<div class="widget-header">
									<i class="icon-cogs"></i>
									<h3>System Menus</h3>
								</div>
								
								<div class="widget-content">
									<cfoutput>
										<h5 style="margin-bottom:15px;"><i class="icon-columns"></i> Configure and Customize Your System Menus <span class="pull-right"><a href="#application.root#?event=page.menu" class="btn btn-primary btn-mini"><i class="icon-columns"></i> Menu Data Home</a><a href="#application.root#?event=page.admin" style="margin-left:5px;" class="btn btn-tertiary btn-mini"><i class="icon-home"></i> Admin Home</a></span></h5>
									</cfoutput>
									
									<div class="span5">									
										<cfinclude template="page.settings.outcomes.cfm">										
									</div>
									
									<div class="span6">									
										<cfinclude template="page.settings.contactmethods.cfm">									
									</div>						
									
									
								</div>
								
							</div>
						
						</div>
					
					</div>
					<div style="margin-top:300px;"></div>
				</div>			
			
			</div>
			
			