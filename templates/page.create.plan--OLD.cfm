


			<!--- // get our data access components --->		
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.solutions.solutiongateway" method="getcompletedsolutions" returnvariable="completedsolutions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
				<cfinvokeargument name="solcomp" value="1">
			</cfinvoke>
			
			<!--- // set a few params --->
			<cfparam name="today" default="">
			<cfparam name="statuscode" default="">
			<cfset today = now() />			
			
			
			<!--- // loop over the completed solutions and create an implementation plan --->
			<cfloop query="completedsolutions">

				<!--- // create implementation plan --->
				<cfquery datasource="#application.dsn#" name="createplan">
					insert into implement(solutionid, impstartdate, impcompleted)
						values(
							   <cfqueryparam value="#completedsolutions.solutionid#" cfsqltype="cf_sql_integer" />,
							   <cfqueryparam value="#completedsolutions.solutiondate#" cfsqltype="cf_sql_date" />,
							   <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
							  ); select @@identity as newimpid
				</cfquery>
							
				<!--- // set the values for the status code --->
				<cfif statuscodeid eq 121 or statuscodeid eq 122 or statuscodeid eq 124 or statuscodeid eq 125 or statuscodeid eq 126 or statuscodeid eq 127 or statuscodeid eq 128 >
					<cfset statuscode = "C" />
				<cfelse>
					<cfset statuscode = "D" />
				</cfif>
				
				<!--- // get the implementation steps --->
				<cfquery datasource="#application.dsn#" name="getsteps">
					select msimpstepid, msimpcat, msimptype, msimpstepcat, msimpstepstat
					  from masterstepsimpl
					 where msimpcat like <cfqueryparam value="%#completedsolutions.solutionoptiontree#%" cfsqltype="cf_sql_varchar" />
					   and msimptype like <cfqueryparam value="#trim( solutionoption )#" cfsqltype="cf_sql_varchar" />
					   and msimpstepcat like <cfqueryparam value="#trim( solutionsubcat )#" cfsqltype="cf_sql_varchar" />
					   and msimpstepstat = <cfqueryparam value="#trim( statuscode )#" cfsqltype="cf_sql_char" />
				  order by msimpstepid asc
				</cfquery>
				
					
					<!--- // nested loop // loop the implementation steps for the plan --->
					<cfloop query="getsteps">				
						<!--- // add the implementation steps --->				
						<cfquery datasource="#application.dsn#" name="addimplsteps">
							insert into leadimplementsteps(leadimpplanuuid, implementid, msimpstepid, stepassigndate)
								values(
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#createplan.newimpid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#getsteps.msimpstepid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#createodbcdatetime( today )#" cfsqltype="cf_sql_timestamp" />									   
									  );
						</cfquery>					
						
					</cfloop>
					
					
					<!--- // update the solution to set the flag for implementation plan created --->
					<cfquery datasource="#application.dsn#" name="saveplans">
						update solution
						   set solutionplancreated = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						 where solutionid = <cfqueryparam value="#completedsolutions.solutionid#" cfsqltype="cf_sql_integer" />
					</cfquery>
			
			
			</cfloop>	
			
			
			<!--- // update our lead and flag as implementation client --->
			<cfquery datasource="#application.dsn#" name="setclientimp">
				update leads
				   set leadimp = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				 where leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset session.leadimp = 1 />
			
			<cflocation url="#application.root#?event=page.solution.implement" addtoken="no">