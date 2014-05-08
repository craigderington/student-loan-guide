


			<!--- // get our data access objects --->

			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			
			<cfparam name="mhome" default="">
			<!--- // process the welcome home and redirect to checklist --->
			<cfif structkeyexists( form, "savewelcomehome" )>
				
				<cfif isdefined( "form.chkhome" )>
					<cfset mhome = 0 />
				<cfelse>
					<cfset mhome = 1 />
				</cfif>
					
				<!--- // update the welcome home flag --->
				<cfquery datasource="#application.dsn#" name="savewelcomehome">
					update leads
					   set leadwelcomehome = <cfqueryparam value="#mhome#" cfsqltype="cf_sql_bit" />
					 where leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<!--- // set the welcome home session to 1 so we don't show it any more during the current login session --->
				<cfset session.welcomehomesess = 1 />
				<cflocation url="#application.root#?event=page.portal.home" addtoken="no">				
				
			</cfif>



			<!--- client portal welcome page --->			
			<div class="main">	
				
				<div class="container">
					
					
					<!--- // this is a modal --->
					
					<cfoutput>
						<div class="modal" style="display: block;margin-top:60px;">
							<div class="modal-header">
								<h3>Welcome, #leaddetail.leadfirst#</h3>
							</div>
							
							<div class="modal-body">
								<p>Welcome to your Student Loan Advisor Client Portal. The portal allows you to E-sign your enrollment docs, update your contact information, upload student loan and personal information, view student loan solution packet, download forms needed to implement solutions and track progress on your file.  Before you can proceed, please see the instructions on how to e-sign your enrollment documents and payment form.  Once you have completed these steps, you will be able to have full access to the portal and be on your way to discovering the solutions for your student loan debt!</p>
							</div>
							  
							<div class="modal-footer">							
								<form class="form-inline" method="post" action="#cgi.script_name#?event=#url.event#">																				
									<label class="checkbox" style="margin-right:200px;">
										<input name="chkhome" type="checkbox" value="1" checked> Show Welcome Page
									</label>											
									<button type="submit" name="savewelcomehome" class="btn btn-primary btn-large"><i class="icon-circle-arrow-right"></i> Continue</button>										
								</form>						
							</div>
						</div>
						</cfoutput>
						<div style="height:700px;"></div>
				
				</div><!-- / .container -->
				
			</div><!-- / .main -->
					
					
						
				
							
					

					
					
					
			
			
			
		