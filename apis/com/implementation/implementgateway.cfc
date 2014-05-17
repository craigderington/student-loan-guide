


		<cfcomponent displayname="implementgateway">
			
			<cffunction name="init" access="public" output="false" returntype="companyadmingateway" hint="I create an initialized company gateway object.">
				<cfreturn this >
			</cffunction>
			
			<cffunction name="getsolutiongroupbyservicer" access="public" output="false" hint="I get the list of completed solutions grouped for implementation.">
				<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
				<cfset var solutiongroupbyservicer = "" />
				<cfquery datasource="#application.dsn#" name="solutiongroupbyservicer">
					  select sl.solutionoptiontree, sl.solutionoption, sl.solutionsubcat, slw.servicerid, 
					         slw.servname as nslservicer, s.servname, count(*) as totalsolutions
						from solution sl, slworksheet slw, servicers s
					   where sl.solutionworksheetid = slw.worksheetid
						 and slw.servicerid = s.servid
						 and sl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						 and sl.solutioncompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						 and sl.solutioncompdate is not null
						 and sl.solutionplancreated = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				    group by sl.solutionoptiontree, sl.solutionoption, sl.solutionsubcat, slw.servicerid, s.servname, slw.servname
				    order by solutionoption asc
				</cfquery>
				<cfreturn solutiongroupbyservicer>
			</cffunction>
			
			<cffunction name="getsolutionlistbyid" access="public" output="false" hint="I get the list of solutions by solution id in order to group the implementation plans">
				<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
				<cfargument name="solutionsubcat" type="string" required="yes" default="none">
				<cfargument name="solutionoption" type="string" required="yes" default="none">
				<cfargument name="servid" type="numeric" required="yes" default="-1">
				<cfargument name="srvname" type="string" required="yes" default="None">
				
				<cfset var solutionlistbyid = "" />
				<cfquery datasource="#application.dsn#" name="solutionlistbyid">
					  select solutionid, solutionuuid
						from solution s, slworksheet sl, servicers srv
					   where s.solutionworksheetid = sl.worksheetid
						 and sl.servicerid = srv.servid
						 and s.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						 and s.solutioncompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						 and s.solutioncompdate is not null
						 and s.solutionplancreated = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						 and s.solutionoption = <cfqueryparam value="#arguments.solutionoption#" cfsqltype="cf_sql_varchar" />
						 and s.solutionsubcat = <cfqueryparam value="#arguments.solutionsubcat#" cfsqltype="cf_sql_varchar" />						 
						 
						<cfif arguments.servid neq -1>
							and srv.servname = <cfqueryparam value="#arguments.srvname#" cfsqltype="cf_sql_varchar" />
						<cfelse>
							and sl.servname = <cfqueryparam value="#arguments.srvname#" cfsqltype="cf_sql_varchar" />
						</cfif>
											 
				</cfquery>
				<cfreturn solutionlistbyid>
				
			</cffunction>

			
			<cffunction name="getimplementplans" access="public" output="false" hint="I get the list of implementation plans.">
				<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
				<cfset var impplans = "" />
				<cfquery datasource="#application.dsn#" name="impplans">
					select i.implementid, i.solutionid, i.leadid, i.solutionoption, i.solutionsubcat, 
					       i.impstartdate, i.impenddate, i.impcompleted, i.planuuid
					  from implement i
					 where i.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />					   
				</cfquery>
				<cfreturn impplans >
			</cffunction>
			
			
			<cffunction name="getplansteps" access="public" output="false" hint="I get the list of implementation plan master steps.">				
				<cfargument name="impid" type="numeric" required="yes">
				<cfset var plansteps = "" />
				<cfquery datasource="#application.dsn#" name="plansteps">
					select i.implementid, i.impstartdate, i.planuuid, lis.leadimpplanuuid,
					       lis.leadimpplanid, lis.msimpstepid, lis.stepassigndate, lis.stepcompdate, lis.stepcompbyuser, lis.stepnote,
						   mis.msimpcat, mis.msimptype, mis.msimpstepcat, mis.msimpstepstat, mis.msimpstepnum, mis.msimpsteptask,
						   lis.stepstatus
					  from implement i, leadimplementsteps lis, masterstepsimpl mis
					 where i.implementid = lis.implementid
					   and lis.msimpstepid = mis.msimpstepid
					   and i.implementid = <cfqueryparam value="#arguments.impid#" cfsqltype="cf_sql_integer" />
					 order by mis.msimpstepnum asc
				</cfquery>
				<cfreturn plansteps >
			</cffunction>
			
			<cffunction name="getimplementedsolutions" access="public" output="false" hint="I get the list of solutions for each grouped implementation plan.">
				<cfargument name="solutionid" type="any" required="yes" default="none">
				<cfset var implementedsolutions = "" />
				<cfquery datasource="#application.dsn#" name="implementedsolutions">
					select s.*, slw.servicerid, slw.servname as nslservicer, srv.servname, slw.attendingschool, lc.codedescr
                      from solution s, slworksheet slw, servicers srv, loancodes lc
                     where s.solutionworksheetid = slw.worksheetid
                       and slw.servicerid = srv.servid
                       and slw.loancodeid = lc.loancodeid
                       and s.solutionid in( <cfqueryparam value="#arguments.solutionid#" cfsqltype="cf_sql_integer" list="yes" /> )
                  order by s.solutioncompdate asc
				</cfquery>
				<cfreturn implementedsolutions >
			</cffunction>
			
			<cffunction name="getreasonlist" access="public" output="false" hint="I get the list of reasons for the TG and WO implementation plans.">			
				<cfset var reasonlist = "" />					
					<cfquery datasource="#application.dsn#" name="reasonlist">
						select distinct( ms.msimpstepreason ) as myreason
						  from masterstepsimpl ms
						 where ms.msimpstepreason is not null
						 order by myreason asc
					</cfquery>					
					<cfreturn reasonlist >
			</cffunction>
			
			
			<cffunction name="getplannotes" access="public" output="false" hint="I get the list of implementation plan master steps.">				
				<cfargument name="planid" type="uuid" required="yes" default="">
				<cfset var notesdetail = "" />					
					<cfquery datasource="#application.dsn#" name="notesdetail">
						select planuuid, plannotes
						  from implement
						 where planuuid = <cfqueryparam value="#arguments.planid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>					
					<cfreturn notesdetail >
			</cffunction>
			
			
			
			<cffunction name="getreferences" access="public" output="false" hint="I get the list of references for implementation.">				
				<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
				<cfset var referenceslist = "" />					
					<cfquery datasource="#application.dsn#" name="referenceslist">
						select referenceid, leadid, reffirstname, reflastname, refaddress1, refaddress2, refcity, refstate,
							   refzip, refphone1, refemail, refrelation
						  from leadreferences
						 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					  order by referenceid asc	 
					</cfquery>					
					<cfreturn referenceslist >
			</cffunction>
			
			
			<cffunction name="getreferencedetail" access="public" output="false" hint="I get the reference details for implementation.">				
				<cfargument name="referenceid" type="numeric" required="yes" default="#url.refid#">
				<cfset var referencedetail = "" />					
					<cfquery datasource="#application.dsn#" name="referencedetail">
						select referenceid, leadid, reffirstname, reflastname, refaddress1, refaddress2, refcity, refstate,
							   refzip, refphone1, refemail, refrelation
						  from leadreferences
						 where referenceid = <cfqueryparam value="#arguments.referenceid#" cfsqltype="cf_sql_integer" />
					</cfquery>					
					<cfreturn referencedetail >
			</cffunction>
			
			
		
		</cfcomponent>