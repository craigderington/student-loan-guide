


		<!--- // 8-1-2013 // document component --->
		<cfcomponent displayname="documentgateway">
		
			<cffunction name="init" access="public" output="false" returntype="documentgateway" hint="Returns an initialized document gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="getdoccats" access="remote" returntype="query" output="false" hint="I get the document categories.">
				<cfset var doccats = "">				
				<cfquery datasource="#application.dsn#" name="doccats">
					select doccatid, doccat
					  from doccategory
					 where doccatid <> <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
				  order by doccat asc
				</cfquery>				
				<cfreturn doccats >			
			</cffunction>
		
			<cffunction name="getdocuments" access="remote" returntype="query" output="false" hint="I get the list of client documents.">				
				<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
				<cfset var doclist = "">				
				<cfquery datasource="#application.dsn#" name="doclist">
					select d.docsid, d.docuuid, d.leadid, d.docname, d.docfileext, d.docpath, d.docdate, d.docuploaddate,
					       d.doctype, d.uploadedby, d.docactive, u.firstname, u.lastname, u.role, dc.doccat, dc.doccatid
					  from documents d, doccategory dc, users u
					 where d.doccatid = dc.doccatid
					   and d.uploadedby = u.userid
					   and d.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and d.docactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				  order by d.docdate desc, d.docname asc
				</cfquery>				
				<cfreturn doclist >			
			</cffunction>

			
		
		</cfcomponent>