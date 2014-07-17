



			<!--- call the function to send the user reminders --->
			<cfinvoke component="apis.com.tasks.remindergateway" method="senduserreminders" returnvariable="reminderinfo">
				<cfinvokeargument name="thisdate" value="#now()#">
			</cfinvoke>
			
			
			<cfdump var="#reminderinfo#" label="Reminder Information">
			
			<cfset today = now() />
			
			<cfoutput>
				#today#
			
			
				<br />
			
			
			
			
				<cfset thisdatetime = now() />
				<cfset timedelta = dateadd( "n", 30, thisdatetime ) />
			
				#thisdatetime#<br />
				#timedelta#
			
			
			
			
			</cfoutput>
			
			
			