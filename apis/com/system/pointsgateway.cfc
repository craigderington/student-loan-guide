

	<cfcomponent displayname="clarifyingpoints">
	
		<cffunction name="init" access="public" output="false" returntype="clarifyingpoints" hint="Returns an initialized CP system menu function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getpoints" access="remote" output="false" hint="I get the list of clarifying points for the option trees.">			
			<cfquery datasource="#application.dsn#" name="pointslist">
				select pointid, pointuuid, optiontree, pointtype, title, pointtext, active, pointorder, redflag
				  from clarifyingpoints
				 where active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				       
				<cfif structkeyexists( form, "pointtype" ) and form.pointtype is not "">
					and pointtype like <cfqueryparam value="%#form.pointtype#%" cfsqltype="cf_sql_varchar" />
				</cfif>
					   
				<cfif structkeyexists( form, "pointtitle" ) and form.pointtitle is not "" and trim( form.pointtitle ) is not "Search by Title">
					and title like <cfqueryparam value="%#form.pointtitle#%" cfsqltype="cf_sql_varchar" />
				</cfif>
					   
			  order by pointid asc
			</cfquery>
			<cfreturn pointslist>
		</cffunction>
		
		<cffunction name="getpoint" access="remote" output="false" hint="I get the clarifying point detail for the selected record.">			
			<cfargument name="pid" required="yes" type="numeric" default="#url.pid#">
			<cfset var pointdetail = "" />
			<cfquery datasource="#application.dsn#" name="pointdetail">
				select pointid, pointuuid, optiontree, pointtype, title, pointtext, active, pointorder, redflag
				  from clarifyingpoints			 
			     where pointid = <cfqueryparam value="#arguments.pid#" cfsqltype="cf_sql_integer" /> 
			</cfquery>
			<cfreturn pointdetail>
		</cffunction>
		
		
		<cffunction name="getpointfiltertype" access="remote" output="false" hint="I get the list of filters for the clarifying points.">
			<cfset var pointfiltertype = "">
			<cfquery datasource="#application.dsn#" name="pointfiltertype">
				select distinct(pointtype)
				  from clarifyingpoints				 
			    order by pointtype asc
			</cfquery>
			<cfreturn pointfiltertype >
		</cffunction>		
		
		<cffunction name="gettree" access="remote" output="false" hint="I get the tree options and clarifying points.">
			
			<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
			<cfargument name="treename" type="any" required="yes" default="Perkins">
			
				<!--- // get the tree number and name from the URL and invoke the correct option tree component --->
				<cfif trim( arguments.treename ) is "direct">
				
					<cfinvoke component="optiontree1" method="getoptiontree1" returnvariable="optiontree1">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>					
					
					<cfset tree1num = 1 />
					<cfset tree1name = "Direct Loan" />					
					
				
				<!--- // sub category 2 - FFEL loans --->
				<cfelseif trim( arguments.treename ) is "ffel">
				
					<cfinvoke component="optiontree2" method="getoptiontree2" returnvariable="optiontree2">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 2 />
					<cfset treename = "FFEL Loans" />
					
				
				<cfelseif trim( arguments.treename ) is "perkins">
				
					<cfinvoke component="optiontree3" method="getoptiontree3" returnvariable="optiontree3">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 3 />
					<cfset treename = "Perkins/Needs Based Loan" />
				
				<cfelseif trim( arguments.treename ) is "directconsol">
				
					<cfinvoke component="optiontree4" method="getoptiontree4" returnvariable="optiontree4">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 4 />
					<cfset treename = "Direct Consolidation Loan" />
				
				<cfelseif trim( arguments.treename ) is "healthpro">
				
					<cfinvoke component="optiontree5" method="getoptiontree5" returnvariable="optiontree5">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 5 />
					<cfset treename = "Health Professional Loan" />
				
				<cfelseif trim( arguments.treename ) is "parentplus">
				
					<cfinvoke component="optiontree6" method="getoptiontree6" returnvariable="optiontree6">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 6 />
					<cfset treename = "Parent PLUS Loan" />
				
				<cfelseif trim( arguments.treename ) is "private">
				
					<cfinvoke component="optiontree7" method="getoptiontree7" returnvariable="optiontree7">
						<cfinvokeargument name="leadid" value="#arguments.leadid#">
					</cfinvoke>
					
					<cfset treenum = 7 />
					<cfset treename = "Private Loan" />
			
				</cfif>
				
				
				<!--- // create our new structure and return out --->
				<cfset treeoptions = structnew() />				
				<cfset treenum = structinsert( treeoptions, "treenumber", "#treenumber#" ) />
				<cfset treename = structinsert( treeoptions, "treetype", "#treename#" ) />

		</cffunction>
		
	
	</cfcomponent>