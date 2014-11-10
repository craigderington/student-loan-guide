		
		
		
				
				
				
				<!--- // define and scope response variable --->
				<cfparam name="vancoresponse" default="">	
				<cfset nvpvar = "h_qb3rgkYTn0I2gI0syjs4Tt55Lmq8OawONAFkPgt2IZ4hSfj2z05fJSdwssDS09KTohAMmnZCvinv-Tp-WSDQr5ZQs-x9hHyz6lCgjlGUOy5HsNKhWFGrjK-HgC2HqAghCOZuumlOxvvBulq5MR3yHi5EFPET7N_aTXkGDJ1e39NLRRSHbd_X0YS--exEa9DDJPO1pLtS0SzA69Fj_7IHvQQc4k1ypBeeNAA9a5Tm9Jweux73azzQJ3boNMkzO9oV7MTs5FfOu2b-8X70eWCboXCPoX-XpsHk6SSnJWW8jqicESMLun6EAc8KIYo_KOOCw_TYOZrbZS4avxAFG7QW9T2fXniJkNV4wR1HM3T1nZZSK4V4EppyxUo5k2PjzGre6vxXT2pP7hzlqvhY31jItFrjK8LZ9WCLGOK5p0y2M48EaUX7SQNsRy7TGkUUz0SeaDLQT_RsR2qtl7VawRAAVSRcanIVv5p0-ef-scb4ZTbhFKbenjo5UpxXnp91Ce8w0ZzSz4KyuyCtFLQITjdm6XWDHPA89UFQnOFEXpBZ10j-97y0pTxsDrBQrWE5rZDEh0bjhubXe7IefO0czhAB2O0YiAy2-2Li8R3l_tGY3xeAqY8vG5YgDwtIu8pSeB3ZYo4ZZg4RKdV516RhVY0gdWABwCtwValAKEyeDhKKAvo6F2pLxesIYmnnYAx4vU3W8OBn9Qc7ge3Lhbdf06-QEhu_Ul9zUryxsKr5p3hRY=" />
				
				<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
					<cfinvokeargument name="requesttype" value="efttransparentredirect">
				</cfinvoke>			

				<!--- // call the decryption component to decrypt the vanco response --->				
				<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">				
					<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
					<cfinvokeargument name="nvpvar" value="#nvpvar#">					
				</cfinvoke>
									
				<!--- // some variables we'll need for the next step --->			
				<cfset vancoresponse = thisdecryptedmessage />			
				<cfset thisarr = listtoarray( vancoresponse, "&", false, true ) />			
				<cfset thistransuuid = "D10552EF-E3D9-EA85-4ECDF2073C09FC24" <!---#createuuid()#--->  />
				<cfset thisleadid = session.leadid />
				<cfset today = now() />
				
				 
				
				<cfloop array="#thisarr#" index="j">
					<cfset item = listfirst( j, "=" ) />
					<cfset thisitemvalue = listlast( j, "=" ) /> 					
					<!--- // save the decrypted vanco data so we can use it in our application  
					<cfquery datasource="#application.dsn#" name="savevancodecryptdata">
						insert into vancodecryptdata(vancouuid, leadid, vancolabel, vancovalue)
							values(
									<cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
									<cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#item#" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="#trim( thisitemvalue )#" cfsqltype="cf_sql_varchar" maxlength="250" />							
								   );
					</cfquery>		
					--->
					<!--- // for testing --->
					<cfoutput>
						#item# :: #thisitemvalue# <br />	
					</cfoutput>
					
					
					
					
				</cfloop>
				
				