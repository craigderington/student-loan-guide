


			<cfsilent>
 
				<!---
					Check to see if the error object exists. Even though
					we have landed on this page, it is possible that
					someone called it directly without throwing an erorr.
					The error object only exists if an error was caught.
				--->
				<cfif StructKeyExists( VARIABLES, "Error" )>
			 
					<!---
						Mail out the error data (and whatever other scopes
						you would like to see at the time of the error). When
						you CFDump out the objects, make them Secure AND
						also be sure to use a TOP attribute when appropriate
						so that the CFDump doesn't recurse forever.
					--->
					<cfmail
						to="craig@efiscal.net"
						from="system@efiscal.net"
						subject="Web Site Error"
						type="html">
			 
						<p>
							An error occurred at
							#DateFormat( Now(), "mmm d, yyyy" )# at
							#TimeFormat( Now(), "hh:mm TT" )#
						</p>
			 
						<h3>
							Error
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( VARIABLES.Error )#"
							label="Error object."
							/>
			 
						<h3>
							CGI
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( CGI )#"
							label="CGI object"
							/>
			 
						<h3>
							REQUEST
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( REQUEST )#"
							label="REQUEST object"
							top="5"
							/>
			 
						<h3>
							FORM
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( FORM )#"
							label="FORM object"
							top="5"
							/>
			 
						<h3>
							URL
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( URL )#"
							label="URL object"
							top="5"
							/>
			 
						<h3>
							SESSION
						</h3>
			 
						<cfdump
							var="#MakeStructSecure( SESSION )#"
							label="SESSION object"
							top="5"
							/>
			 
					</cfmail>
			 
				</cfif>			 
			 
				<!---
					When setting the header information, be sure to put
					it in a CFTry / CFCatch. We can only send header
					information if the site has NOT already been flushed
					to the browser. Also set a flag so that we know if
					information has been committed.
				--->
				<cfset REQUEST.RequestCommitted = false />
			 
				<cftry>
					<!--- Set the status code to internal server error. --->
					<cfheader
						statuscode="500"
						statustext="Internal Server Error"
						/>
			 
					<!--- Set the content type. --->
					<cfcontent
						type="text/html"
						reset="true"
						/>
			 
					<!--- Catch any errors. --->
					<cfcatch>
			 
						<!---
							There was an error so flag the request as
							already being committed.
						--->
						<cfset REQUEST.RequestCommitted = true />
			 
					</cfcatch>
				</cftry>
			 
			</cfsilent>
			 
			<!---
				Check to see if the request has been committed. If it
				has, then it means that content has already been committed
				to the browser. In that case, we are gonna want to refresh
				the screen, unless we came from a refresh, in which case
				just let the page run.
			--->
			
			<cfif (
				StructKeyExists( VARIABLES, "Error" ) AND
				REQUEST.RequestCommitted AND
				( NOT StructKeyExists( URL, "norefresh" ) )
				)>
			 
				<script type="text/javascript">
			 
					window.location.href = "cferror.cfm?norefresh=true";
			 
				</script>
			 
				<!--- Exit out of the template. --->
				<cfexit />
			 
			</cfif>
			 
			 
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html>
			<head>
				<title>An Error Occurred</title>
			</head>
			<body>
			 
				<h1>
					Opps.  500 | Internal Server Error
				</h1>
			 
				<p>
					
				</p>
			 
			</body>
			</html>