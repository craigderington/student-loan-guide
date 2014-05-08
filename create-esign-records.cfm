



		<cfquery datasource="#application.dsn#" name="mrecords1">
			select *
				from leads
				where leadconv <> 1				
		</cfquery>
		
		<cfloop query="mrecords1">
			<cfset thisuuid = #createuuid()# />
			<cfquery datasource="#application.dsn#" name="insertthis">
				insert into esign(esuuid, leadid, esdatestamp, escompleted)
					values(
							<cfqueryparam value="#thisuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
							<cfqueryparam value="#mrecords1.leadid#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#mrecords1.leaddate#" cfsqltype="cf_sql_date" />,
							<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						   );
			</cfquery>
		</cfloop>
		
		<cfoutput>
			#mrecords1.recordcount# records updated
		</cfoutput>