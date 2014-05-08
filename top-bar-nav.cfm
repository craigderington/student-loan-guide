




				<cfoutput>
				<div class="navbar navbar-inverse navbar-fixed-top">
	
					<div class="navbar-inner">
						
						<div class="container">
							
							<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
								<i class="icon-cog"></i>
							</a>
							
							<cfif isuserloggedin()>								
								<cfif structkeyexists( session, "companyname" ) and session.companyname is not "">																		
									<cfif isuserinrole( "bClient" )>
										<a class="brand" href="#application.root#?event=page.portal.home">
											#session.companyname# <sup style="color:##F90;">Beta 1</sup>							
										</a>
									<cfelse>									
										<a class="brand" href="#application.root#?event=page.index">
											#session.companyname# <sup style="color:##F90;">Beta 1</sup>							
										</a>
									</cfif>									
								<cfelse>								
									<a class="brand" href="#application.root#?event=page.index">
										#application.title# <sup style="color:##F90;">Beta 1</sup>							
									</a>								
								</cfif>								
							<cfelse>							
								<a class="brand" href="#application.root#?event=page.index">
									#application.title# <sup style="color:##F90;">Beta 1</sup>							
								</a>							
							</cfif>
							
							<div class="nav-collapse collapse">
								<ul class="nav pull-right">
									<!--- // settings --->
									<cfif isuserloggedin() AND isuserinrole( "admin" )>
										<li class="dropdown">
											
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-cog"></i>
												Settings
												<b class="caret"></b>
											</a>
											
											<ul class="dropdown-menu">
												<li><a tabindex="-1" href="#application.root#?event=page.admin"><i class="icon-cogs"></i> Administration</a></li>
												<li><a tabindex="-1" href="#application.root#?event=page.users"><i class="icon-user"></i> User Admin</a></li>										
												<li><a tabindex="-1" href="#application.root#?event=page.menu"><i class="icon-reorder"></i> Menu Data</a></li>
												<li class="divider"></li>
												<li><a tabindex="-1" href="#application.root#?event=page.manual"><i class="icon-book"></i> User Manual</a></li>											
											</ul>
											
										</li>
									<cfelseif isuserloggedin() AND isuserinrole( "co-admin" )>
										<li class="dropdown">
											
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-cog"></i>
												Settings
												<b class="caret"></b>
											</a>
											
											<ul class="dropdown-menu">												
												<li><a tabindex="-1" href="#application.root#?event=page.admin"><i class="icon-dashboard"></i> Administration</a></li>
												<li><a tabindex="-1" href="#application.root#?event=page.users"><i class="icon-user"></i> User Admin</a></li>
												<li><a tabindex="-1" href="#application.root#?event=page.depts"><i class="icon-building"></i> Department Admin</a></li>
												<li><a tabindex="-1" href="#application.root#?event=page.settings"><i class="icon-cogs"></i> Settings</a></li>
																						
											</ul>
											
										</li>					
									</cfif>
									<!--- // end settings --->
									
									<li class="dropdown">
										
										<cfif isuserloggedin()>
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-user"></i> 
												#GetAuthUser()#
												<b class="caret"></b>
											</a>
										
											<ul class="dropdown-menu">
												<li><a href="#application.root#?event=page.profile"><i class="icon-briefcase"></i> My Profile</a></li>
													
											<cfif not isuserinrole( "bclient" )>													
												<li><a href="#application.root#?event=page.taskmanager"><i class="icon-tasks"></i> My Tasks</a></li>
												<li><a href="#application.root#?event=page.reminders"><i class="icon-time"></i> My Reminders</a></li>
												<li class="divider"></li>
											</cfif>										
											
																														
											<li><a href="#application.root#?event=page.logout"><i class="icon-off"></i> Logout</a></li>
												
											</ul>
										</cfif>
									</li>
								</ul>
								
								<!--- // search clients --->
								<cfif isuserloggedin() and not isuserinrole( "bclient" )>
									<form class="navbar-search pull-right" name="search" method="post" action="#application.root#?event=page.search">
										<input type="text" class="search-query" name="search" placeholder="Search Leads/Clients">
									</form>
								</cfif>

							</div><!---/ .nav-collapse --->	
					
						</div> <!-- / .container -->
						
					</div> <!-- / .navbar-inner -->
					
				</div> <!-- / .navbar -->
				</cfoutput>