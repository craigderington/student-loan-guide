


		<!--- // task automation --->
		<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
			<cfinvokeargument name="leadid" value="#session.leadid#">
			<cfinvokeargument name="taskref" value="coninfo">
		</cfinvoke>