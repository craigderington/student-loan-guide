	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.portal.portalgateway" method="getportalinstructions" returnvariable="portalinstructcontent">
				<cfif structkeyexists( url, "icat" )>
					<cfinvokeargument name="icat" value="#url.icat#">
				<cfelse>
					<cfinvokeargument name="icat" value="1">
				</cfif>
			</cfinvoke>
			
			<!--- // a few vars --->
			
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
										<i class="icon-cog"></i>							
										<h3>#leaddetail.leadfirst#, here are your Student Loan Advisor Online Portal Instructions</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">

									<!--- // sidebar navigation --->									
									<div class="span3">					
										<cfinclude template="page.portal.sidebar.cfm">			
									</div> <!-- /.span3 -->
			
									
									<div class="span8">
										<cfoutput>										
										<h3 style="margin-bottom:5px;"><i class="icon-book"></i> #portalinstructcontent.instructcategory#</h3>
										
											#urldecode( portalinstructcontent.instructtext )#
										
										</cfoutput>
									</div>
				
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:350px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		