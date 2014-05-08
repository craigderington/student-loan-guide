


		<!--- // get our data access components --->
		<cfinvoke component="apis.com.system.librarygateway" method="getformslist" returnvariable="formslist">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
			

			
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Forms Library</h3>						
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">						
									
									<cfdump var="#formslist#" label="Forms List">
									

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->