


			<!--- // get our instruction categories data --->
			<cfinvoke component="apis.com.portal.portalgateway" method="getportalcategories" returnvariable="instructcategories">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			

			
					<cfif instructcategories.recordcount gt 0>				
					
						<ul class="nav nav-tabs nav-stacked">
							<cfoutput query="instructcategories">
								<li <cfif structkeyexists( url, "icat" )><cfif url.icat eq instructcategory>class="active"</cfif><cfelse><cfif instructcategories.currentrow eq 1>class="active"</cfif></cfif> >
									<a href="#application.root#?event=page.portal.instructions&icat=#instructcategory#">
										<i class="icon-circle"></i>
											#instructcategory#
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>												
							</cfoutput>						
						</ul>
					
					<cfelse>
				
						<small><i class="icon-exclamation-sign"></i> No Instruction Categories Defined.</small>
				
					</cfif>

			
				