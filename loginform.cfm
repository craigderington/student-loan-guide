

		<!--- Include the header --->
		<cfinclude template="header.cfm">


			<style type="text/css">

				  /* Sticky footer styles
				  -------------------------------------------------- */
					
				  html,
				  body {
					height: 90%;
					/* The html and body elements cannot have any padding or margin. */
				  }
				  
				  /* Wrapper for page content to push down footer */
				  #wrap {
					min-height: 100%;
					height: auto !important;
					height: 100%;
					/* Negative indent footer by it's height */
					margin: 0 auto -100px;
				  }

				  /* Set the fixed height of the footer here */
				  #push,
				  #footer {
					height: 100px;
				  }
				  #footer {
					background-color: #f5f5f5;
				  }

				  /* Lastly, apply responsive CSS fixes as necessary */
				  @media (max-width: 767px) {
					#footer {
					  margin-left: -20px;
					  margin-right: -20px;
					  padding-left: 20px;
					  padding-right: 20px;
					}
				  }
			</style>

				
			
			<cfif structkeyexists(url, "event") and url.event is "page.logout">
				<div class="container" style="margin-top:20px;">
					<div class="alert alert-success">
						<a class="close" href="#" data-dismiss="alert">&times;</a>
						<strong>THANK YOU!</strong> Your logout was successful, to continue, you must log back in...
					</div>
				</div>
			</cfif>		
			
			
				<div id="wrap">
					<div class="container">	
						<cfif NOT structkeyexists(url, "event")>
							<div class="alert alert-info" style="margin-top:20px;">
								<a class="close" href="#" data-dismiss="alert">&times;</a>
								<strong>Login required!  Please enter your login credentials to continue...</strong>
							</div>
						</cfif>
						<cfif structkeyexists(url, "event") and url.event is not "page.logout">
							<div class="alert alert-info" style="margin-top:20px;">
								<a class="close" href="#" data-dismiss="alert">&times;</a>
								<strong>Login required!  Please enter your login credentials to continue...</strong>
							</div>
						</cfif>
								
						<cfoutput>
							<form action="#application.root#" method="post" name="loginform" style="margin-top: 15px;">
								<div class="clearfix">
									<label><b>Username:</b></label>
										<div class="input">							
											<input type="text" size="10" name="j_username" class="span2" style="padding: 7px;" autocomplete="off">							
										</div>
								</div>
								<div class="clearfix">
									<label><b>Password:</b></label>
										<div class="input">
											<input type="password" size="10" name="j_password" id="password" class="span2" style="padding: 7px;">
											<input type="hidden" name="login" value="">
										</div>
								</div>
												
									
								<div class="form-actions" style="margin-top:50px;">
									<button type="submit" name="login" class="btn btn-primary">Login</button>
								</div>
							</form>
						</cfoutput>
					</div>	
					<div id="push"></div>							
				</div>		
				
				<!--- // Begin Footer --->  
				<div id="footer">					
					<cfoutput>	
					<footer class="footer" >
						<div class="container">
							<p>Designed and built with all the love in the world by <a href="##">@craigderington</a>.</p>
							<p>Code licensed under <a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">Apache License v2.0</a>, documentation under <a href="http://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>.</p>
							<p><a href="http://glyphicons.com">Glyphicons Free</a> licensed under <a href="http://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>.</p>
								<ul class="footer-links">								
									<li class="muted">#application.title# #application.softver#  <br />&copy; #Year(Now())#.  All Rights Reserved.<br />
									Bootstrap #application.bootver#</li>									
								</ul>
						</div>
					</footer>
					</cfoutput>					
				</div>
				<!--- // End Footer --->
				
				
				
				
				<!-- Javascript -- placed at the end of the document so the pages load faster -->
				<script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
				<script src="assets/js/jquery-1.9.1.js"></script>			
				<script src="assets/js/bootstrap-alert.js"></script>			
				<script src="assets/js/application.js"></script>