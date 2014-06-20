		
		
		<!doctype html>
		<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
		<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
		<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
		<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->		
		
			
		<html lang="en">
			  
			  <head>
				<meta charset="utf-8">
				<title><cfoutput>#application.title#</cfoutput></title>
				<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
				<meta name="apple-mobile-web-app-capable" content="yes"> 				
				<link href="./css/bootstrap.min.css" rel="stylesheet" type="text/css" />
				<link href="./css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
				<link href="./css/font-awesome.min.css" rel="stylesheet">
				<link href="//fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">				
				<link href="./css/ui-lightness/jquery-ui-1.10.0.custom.min.css" rel="stylesheet">				
				<link href="./css/base-admin-2.css" rel="stylesheet">
				<link href="./css/base-admin-2-responsive.css" rel="stylesheet">				
				<link href="./css/pages/signin.css" rel="stylesheet" type="text/css">
				<link href="./css/custom.css" rel="stylesheet">

				<script type="text/javascript">
					$( document ).ready(function() {
					  $( "#login" ).focus();
					});
				</script>
			
			</head>

			<body class="login">
	
				<div class="navbar navbar-inverse navbar-fixed-top">
				
					<div class="navbar-inner">
						
						<div class="container">
							
							<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
								<i class="icon-cog"></i>
							</a>
							
							<a class="brand" href="./index.cfm">
								Student Loan Advisor Online <sup style="color:#F90;">Beta 1</sup>				
							</a>		
							
							<div class="nav-collapse">
								<ul class="nav pull-right">
									
									<li class="">						
										<a href="./signup.cfm" class="">
											Create an Account
										</a>
										
									</li>
									
									<li class="">						
										<a href="./index.cfm" class="">
											<i class="icon-chevron-left"></i>
											Back to Homepage
										</a>
										
									</li>
								</ul>
								
							</div><!--/.nav-collapse -->	
					
						</div> <!-- /container -->
						
					</div> <!-- /navbar-inner -->
				
				</div> <!-- /navbar -->



				<div class="account-container stacked">
				
					<cfif isdefined( "REQUEST.badlogin" )>
						<div class="alert alert-block alert-error fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
								<h4 class="alert-heading"><i class="icon-warning-sign"></i> Login Failed!</h4>
									<p>Sorry, your login credentials have failed.  Either your username and password was entered incorrectly.  Please try again...</p>
									
						</div>
					<cfelseif isdefined( "url.killopensess" ) and url.killopensess eq 1>
						<div class="alert alert-block alert-error fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
								<h4 class="alert-heading"><i class="icon-warning-sign"></i> OPEN SESSION DETECTED</h4>
									<p style="margin-top:5px;">Sorry for the inconvenience, but the system has detected an open login session for the username entered.</p>
									<p>This is a result of a previous login session for which the user was not logged out.</p>
									<p><strong>For security purposes</strong>, we require you to provide your login again in order for the system to force <strong>log out</strong> your previously open session and log you in again.</p>  
									<p>Please enter your login again to continue... </p>
									<p><strong>To prevent seeing this message again</strong>, please remember to use the system <strong>Log Out</strong> function in the program header.</p>
									
						</div>
					<cfelseif isdefined( "url.logout" ) and url.logout eq 1>
						<div class="alert alert-block alert-info fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
								<h4 class="alert-heading"><i class="icon-check"></i> THANK YOU!</h4>
									<p>Your logout request was processed successfully.  To continue, please login again or close this window.</p>
									
						</div>
					</cfif>
					
					<div class="content clearfix">
						
						<cfoutput>
						<form action="https://www.studentloanadvisoronline.com/#application.root#?event=page.index" method="post" name="loginform">
						
							<h1>Sign In</h1>		
							
							<div class="login-fields">
								
								<p>Sign in using your registered account:</p>
								
								<div class="field">
									<label for="username">Username:</label>
									<input type="text" id="username" name="j_username" placeholder="Email Address" id="login" class="login username-field" autocomplete="off" />
									<input type="hidden" name="login" value="" />
								</div> <!-- /field -->
								
								<div class="field">
									<label for="password">Password:</label>
									<input type="password" id="password" name="j_password" placeholder="Password" class="login password-field"/>
								</div> <!-- /password -->
								
							</div> <!-- /login-fields -->
							
							<div class="login-actions">
								
								<span class="login-checkbox">
									<input id="Field" name="Field" type="checkbox" class="field login-checkbox" value="First Choice" tabindex="4" checked />
									<label class="choice" for="Field">Keep me signed in</label>
								</span>
													
								<button class="button btn btn-warning btn-large">Sign In</button>
								
							</div> <!-- .actions -->				
							
							
						</form>
						</cfoutput>
					</div> <!-- /content -->
					
				</div> <!-- /account-container -->

				
				<!-- Text Under Box -->
				<cfoutput>
					<div class="login-extra">
						<!---Don't have an account? <a href="./signup.html">Sign Up</a><br/>--->
						Forgot Your <a href="#application.root#?event=forgot.password">Password</a>&nbsp;&nbsp; Register <a href="#application.root#?event=page.register">New User</a><br />
						&copy; #Year(Now())#&nbsp;&nbsp;#application.developer#&nbsp;&nbsp;All Rights Reserved.<br />#application.title#&nbsp;&nbsp;#application.softver#<br />
					</div> <!-- /login-extra -->
				</cfoutput>



				<!-- JS placed at the end of the document so the pages load faster -->
				
				<script src="./js/libs/jquery-1.8.3.min.js"></script>
				<script src="./js/libs/jquery-ui-1.10.0.custom.min.js"></script>
				<script src="./js/libs/bootstrap.min.js"></script>
				<script src="./js/Application.js"></script>			


				
			</body>
		
		</html>
