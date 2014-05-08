


			<!--- capture nslds uuid from the query string and start nslds session, then redirect to the appropriate page --->
			
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "doanalysis">				
				
				<cfif structkeyexists( url, "nsldsid" ) and isvalid( "uuid", url.nsldsid )>
				
					<!--- // define some vars --->
					<cfparam name="nsldsid" default="">
					<cfparam name="today" default="">						
					<cfset nsldsid = #url.nsldsid# />		
						
					<cfquery datasource="#application.dsn#" name="getnslds">
						select nsl.nsltxtid, nsl.leadid, nsl.nsltxtuuid, nsl.nsltxtdate, nsl.nsltxtby
						  from nsltxt nsl
						 where nsltxtuuid = <cfqueryparam value="#nsldsid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
						
						
					<cfset session.nslds = getnslds.nsltxtid />									
								
					<!--- // redirect to the nslds results page --->						
					<cflocation url="#application.root#?event=page.nslds.results" addtoken="no">					
				
				
				<cfelse>
					
					<!--- // throw error if the lead id is not numeric or an empty string --->
					<script>
						alert('Sorry, there was a problem starting the NSLDS session.  The ID is malformed.  Please try again!');
						self-location="javascript:history.back(-1);"
					</script>
					
				</cfif>
			
			
			
			<cfelse>
				
				<!--- // if the fuseaction is not defined - redirect to index.cfm --->
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="no">
			
			</cfif>