


		<cfcomponent displayname="nsldsgateway">
			
			<cffunction name="init" access="public" output="false" returntype="nsldsgateway" hint="Returns an initialized nslds gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="getuploadsbyid" access="public" returntype="query" output="false" hint="I get the list of NSLDS text file uploads by upload ID.">
				<cfargument name="leadid" default="#session.leadid#" type="numeric">				
				<cfset var muploadbyid = "" />
				<cfquery datasource="#application.dsn#" name="muploadbyid">
					select nsl.nsltxtid, nsl.leadid, nsl.nsltxtuuid, nsl.nsltxtdate, nsl.nsltxtby, u.firstname, u.lastname
					  from nsltxt nsl, users u
					 where nsl.nsltxtby = u.userid
					   and nsl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />					   				   
				</cfquery>
				<cfreturn muploadbyid >
			</cffunction>
			
			<cffunction name="getloantypes" access="public" returntype="query" output="false" hint="I get the list of NSLDS loan types">
				<cfargument name="leadid" default="#session.leadid#" type="numeric">
				<cfargument name="nsldsid" type="numeric" required="yes" default="#session.nslds#">
				<cfset var loantypes = "" />
				<cfquery datasource="#application.dsn#" name="loantypes">
					select distinct(n.datacontent)
					  from nsltxtdata n, nsltxt nsl
					 where n.nsltxtid = nsl.nsltxtid
					   and nsl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and n.datalabel = <cfqueryparam value="Loan Type" cfsqltype="cf_sql_varchar" />
                       and n.nsltxtid = <cfqueryparam value="#arguments.nsldsid#" cfsqltype="cf_sql_integer" />					   
				</cfquery>
				<cfreturn loantypes >
			</cffunction>
		
			
			<cffunction name="getnsldslist" access="public" returntype="query" output="false" hint="I get the list of NSLDS records from the import file">
				<cfargument name="leadid" default="#session.leadid#" type="numeric">				
				<cfset var nsldslist = "" />
				<cfquery datasource="#application.dsn#" name="nsldslist">
					select nslid, nsluuid, leadid, nslloantype, nslschool, nslloandate, nslloanbalance,
					       nslloanintrate, nslintbalance, nslloanstatus, nslcurrentpay, nslservicer, converted,
						   nslopeid, nslintratetype, nslservicertype, companyname, companyadd1, companyadd2,
						   companycity, companystate, companyzip, companyphone, companyphoneext, companyemail,
						   companyweb, nslrepaybegindate, nslloanstatuscode, nslloanstatusdate
					  from nslds
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   <cfif structkeyexists( form, "filtermyresults" )>
							  <cfif structkeyexists( form, "togglezerobal" )>						   
								and nslloanbalance <> <cfqueryparam value="0.00" cfsqltype="cf_sql_float" />
							  </cfif>
							  <cfif structkeyexists( form, "loantypes" ) and form.loantypes is not "">
							    and nslloantype = <cfqueryparam value="#trim( form.loantypes )#" cfsqltype="cf_sql_varchar" />
							  </cfif>
							  <cfif structkeyexists( form, "loandates" ) and form.loandates is not "">
								and nslloandate <= <cfqueryparam value="#form.loandates#" cfsqltype="cf_sql_date" />
							  </cfif>
						   </cfif>
				  order by nslid asc 
				</cfquery>
				<cfreturn nsldslist>			
			</cffunction>	
		
		</cfcomponent>