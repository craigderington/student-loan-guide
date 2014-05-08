


		<!doctype html>
		<html lang="en">
			<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
			<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
			<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
			<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
			<head>
				<title>
					<cfif isuserloggedin()>
						<cfif structkeyexists( session, "companyname" )>
							<cfoutput>#session.companyname#</cfoutput>
						<cfelse>
							<cfoutput>#application.title#</cfoutput>
						</cfif>
					<cfelse>
						<cfoutput>#application.title#</cfoutput>
					</cfif>				
				</title>				
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
				<meta name="apple-mobile-web-app-capable" content="yes"> 				
				
				<!--- // stylesheets --->
				<link href="./css/bootstrap.min.css" rel="stylesheet" type="text/css" />
				<link href="./css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
				<link href="./css/font-awesome.min.css" rel="stylesheet">
				<link href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" rel="stylesheet">				
				<link href="./css/ui-lightness/jquery-ui-1.10.0.custom.min.css" rel="stylesheet">				
				<link href="./css/base-admin-2.css" rel="stylesheet">
				<link href="./css/base-admin-2-responsive.css" rel="stylesheet">
				<link href="./css/pages/dashboard.css" rel="stylesheet">				
				<link href="./css/custom.css" rel="stylesheet">
				<link href="./css/pages/reports.css" rel="stylesheet">				
				
				<!--- // shortcut icon --->
				<link rel="shortcut icon" href="http://www.studentloanadvisoronline.com/favicon.ico?v=2" type="image/x-icon" />
				<link rel="icon" href="http://www.studentloanadvisoronline.com/favicon.ico?v=2" type="image/x-icon">

				<!--- // make sure that none of our dynamic pages are cached by the users browser --->
				<cfheader name="cache-control" value="no-cache,no-store,must-revalidate" >
				<cfheader name="pragma" value="no-cache" >
				<cfheader name="expires" value="#getHttpTimeString( Now() )#" >
				
				<!--- // also enure that non-dynamic pages are not cached by the users browser --->
				<META HTTP-EQUIV="expires" CONTENT="-1">
				<META HTTP-EQUIV="pragma" CONTENT="no-cache">
				<META HTTP-EQUIV="cache-control" CONTENT="no-cache,no-store,must-revalidate">
			
			</head>		
			
				<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
				<!--[if lt IE 9]>
				  <script src="js/html5.js"></script>
				<![endif]-->
				
				<!--- // used to debug/track cfif and cftoken session variables 
				<cfinclude template="secchk.cfm">
				--->
				
				
				
					<!--- include the top-bar header all users --->
					<cfinclude template="top-bar-nav.cfm">

				<cfif isuserloggedin()>
					
					<!--- include the sub-header based on the users system role --->
					
					<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
						<cfinclude template="sub-nav-header.cfm">				
					<cfelseif isuserinrole( "counselor" ) or isuserinrole( "enrollment" )>					
						<cfinclude template="sub-nav-header-cn.cfm">				
					<cfelseif isuserinrole( "intake" ) or isuserinrole( "sls" )>				
						<cfinclude template="sub-nav-header-sls.cfm">					
					<cfelseif isuserinrole( "bclient" )>
						<cfinclude template="sub-nav-client-header.cfm">									
					</cfif>
				
				</cfif>