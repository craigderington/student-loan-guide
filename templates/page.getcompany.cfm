


			<!--- // get the company id from the query string param and edit either users or departments --->
			
			<cfif structkeyexists( url, "compid" ) and structkeyexists( url, "manage" )>
			
				<cfparam name="thisredir" default="">
				<cfparam name="thispage" default="">
				<cfparam name="thiscomp" default="">
				<cfparam name="oldcompid" default="">
				
				<cfset oldcompid = #session.companyid# />
				<cfset thisredir = #url.manage# />
				<cfset thiscomp = #url.compid# />
				
				<cfif trim( thisredir ) is "users">
					<cfset thispage = "page.users">
				<cfelseif trim( thisredir ) is "depts">
					<cfset thispage = "page.depts">
				<cfelse>
					<cfset thispage = "page.users">
				</cfif>
				
				<cfset session.primarycompanyid = #oldcompid# />
				<cfset session.companyid = #thiscomp# />
				
				<cflocation url="#application.root#?event=#thispage#" addtoken="no">
				
			<cfelse>
			
				<cflocation url="#application.root#?event=page.index" addtoken="no">			
			
			</cfif>