

		<cfcomponent displayname="clarifyingpoints">
		
			<cffunction name="init" access="public" output="false" returntype="clarifyingpoints" hint="Returns an initialized CP function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
		
			<cffunction name="getdeathlist" access="remote" output="false" hint="I get the list of death clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Death" type="any" required="yes">				
				<cfset var deathlist = "" />
				<cfquery datasource="#application.dsn#" name="deathlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn deathlist >
			</cffunction>
			
			
			<cffunction name="getunpaidlist" access="remote" output="false" hint="I get the list of unpaid refund clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Unpaid Refund" type="any" required="yes">				
				<cfset var unpaidlist = "" />
				<cfquery datasource="#application.dsn#" name="unpaidlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn unpaidlist >
			</cffunction>
			
			<cffunction name="getschoollist" access="remote" output="false" hint="I get the list of closed school clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Closed School" type="any" required="yes">				
				<cfset var schoollist = "" />
				<cfquery datasource="#application.dsn#" name="schoollist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn schoollist >
			</cffunction>
			
			<cffunction name="getnine11list" access="remote" output="false" hint="I get the list of 9/11 clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="9/11" type="any" required="yes">				
				<cfset var nine11list = "" />
				<cfquery datasource="#application.dsn#" name="nine11list">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn nine11list >
			</cffunction>
			
			<cffunction name="getatblist" access="remote" output="false" hint="I get the list of ability to benefit clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Ability to Benefit" type="any" required="yes">				
				<cfset var atblist = "" />
				<cfquery datasource="#application.dsn#" name="atblist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn atblist >
			</cffunction>
			
			<cffunction name="getcertlist" access="remote" output="false" hint="I get the list of false certification clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="False Certification" type="any" required="yes">				
				<cfset var certlist = "" />
				<cfquery datasource="#application.dsn#" name="certlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn certlist >
			</cffunction>
			
			<cffunction name="getdisablelist" access="remote" output="false" hint="I get the list of disability clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Disability" type="any" required="yes">				
				<cfset var disablelist = "" />
				<cfquery datasource="#application.dsn#" name="disablelist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn disablelist >
			</cffunction>
			
			<cffunction name="getpslist" access="remote" output="false" hint="I get the list of public service loan forgiveness clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Public Service Loan Forgiveness" type="any" required="yes">				
				<cfset var pslist = "" />
				<cfquery datasource="#application.dsn#" name="pslist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn pslist >
			</cffunction>
			
			
			<cffunction name="getteachlist" access="remote" output="false" hint="I get the list of teacher loan forgiveness clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Teacher Loan Forgiveness" type="any" required="yes">				
				<cfset var teachlist = "" />
				<cfquery datasource="#application.dsn#" name="teachlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn teachlist >
			</cffunction>
			
			<cffunction name="getrehablist" access="remote" output="false" hint="I get the list of rehabilitation clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Rehabilitation" type="any" required="yes">				
				<cfset var rehablist = "" />
				<cfquery datasource="#application.dsn#" name="rehablist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn rehablist >
			</cffunction>
			
			<cffunction name="getconsollist" access="remote" output="false" hint="I get the list of consolidation clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Consolidation" type="any" required="yes">				
				<cfset var consollist = "" />
				<cfquery datasource="#application.dsn#" name="consollist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn consollist >
			</cffunction>
			
			<cffunction name="getwglist" access="remote" output="false" hint="I get the list of wage garnishment clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Wage Garnishment" type="any" required="yes">				
				<cfset var wglist = "" />
				<cfquery datasource="#application.dsn#" name="wglist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn wglist >
			</cffunction>
			
			<cffunction name="gettolist" access="remote" output="false" hint="I get the list of tax offset clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Tax Offset" type="any" required="yes">				
				<cfset var tolist = "" />
				<cfquery datasource="#application.dsn#" name="tolist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn tolist >
			</cffunction>
			
			<cffunction name="getdeferlist" access="remote" output="false" hint="I get the list of deferment clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Deferment" type="any" required="yes">				
				<cfset var deferlist = "" />
				<cfquery datasource="#application.dsn#" name="deferlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn deferlist >
			</cffunction>
			
			<cffunction name="getforbearlist" access="remote" output="false" hint="I get the list of forbearance clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Forbearance" type="any" required="yes">				
				<cfset var forbearlist = "" />
				<cfquery datasource="#application.dsn#" name="forbearlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn forbearlist >
			</cffunction>
			
			
			<cffunction name="getfinhardlist" access="remote" output="false" hint="I get the list of financial hardship forbearance clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Financial Hardship Forbearance" type="any" required="yes">				
				<cfset var finhardlist = "" />
				<cfquery datasource="#application.dsn#" name="finhardlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn finhardlist >
			</cffunction>
			
			<cffunction name="getoiclist" access="remote" output="false" hint="I get the list of offer in compromise clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Offer in Compromise" type="any" required="yes">				
				<cfset var oiclist = "" />
				<cfquery datasource="#application.dsn#" name="oiclist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn oiclist >
			</cffunction>
			
			<cffunction name="getbklist" access="remote" output="false" hint="I get the list of bankruptcy clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Bankruptcy" type="any" required="yes">				
				<cfset var bklist = "" />
				<cfquery datasource="#application.dsn#" name="bklist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn bklist >
			</cffunction>
			
			
			<cffunction name="getmxlist" access="remote" output="false" hint="I get the list of mixed use clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Mixed Use Loan" type="any" required="yes">				
				<cfset var mxlist = "" />
				<cfquery datasource="#application.dsn#" name="mxlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn mxlist >
			</cffunction>
			
			
			<cffunction name="gettheftlist" access="remote" output="false" hint="I get the list of ID theft clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="ID Theft" type="any" required="yes">				
				<cfset var theftlist = "" />
				<cfquery datasource="#application.dsn#" name="theftlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn theftlist >
			</cffunction>
			
			<cffunction name="getstatlist" access="remote" output="false" hint="I get the list of statute of limitations clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Statue of Limitations on Collections" type="any" required="yes">				
				<cfset var statlist = "" />
				<cfquery datasource="#application.dsn#" name="statlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn statlist >
			</cffunction>
			
			
			<cffunction name="getvalidatelist" access="remote" output="false" hint="I get the list of validation of debt clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Validation" type="any" required="yes">				
				<cfset var validatelist = "" />
				<cfquery datasource="#application.dsn#" name="validatelist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn validatelist >
			</cffunction>
			
			
			<cffunction name="getpostlist" access="remote" output="false" hint="I get the list of postponement clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Postponement" type="any" required="yes">				
				<cfset var postlist = "" />
				<cfquery datasource="#application.dsn#" name="postlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn postlist >
			</cffunction>
			
			
			<cffunction name="getoclist" access="remote" output="false" hint="I get the list of occupational cancellation clarifying points.">
				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Occupational Cancellation" type="any" required="yes">
				
				<cfset var oclist = "" />
				<cfquery datasource="#application.dsn#" name="oclist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn oclist >
			</cffunction>
			
			<cffunction name="getrepayconsollist" access="remote" output="false" hint="I get the list of repayment consolidation clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Consolidated Repayment" type="any" required="yes">				
				<cfset var repayconsollist = "" />
				<cfquery datasource="#application.dsn#" name="repayconsollist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn repayconsollist >
			</cffunction>
			
			
			<cffunction name="getrepaynonconsollist" access="remote" output="false" hint="I get the list of repayment non-consolidation clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Non-Consolidated Repayment" type="any" required="yes">				
				<cfset var repaynonconsollist = "" />
				<cfquery datasource="#application.dsn#" name="repaynonconsollist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn repaynonconsollist >
			</cffunction>
			
			
			<cffunction name="getextlist" access="remote" output="false" hint="I get the list of repayment extension clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Extensions" type="any" required="yes">				
				<cfset var extlist = "" />
				<cfquery datasource="#application.dsn#" name="extlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn extlist >
			</cffunction>
			
			<cffunction name="gethardshiplist" access="remote" output="false" hint="I get the list of repayment hardship clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Hardship Eligibility" type="any" required="yes">				
				<cfset var hardshiplist = "" />
				<cfquery datasource="#application.dsn#" name="hardshiplist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn hardshiplist >
			</cffunction>
			
			
			<cffunction name="getmodlist" access="remote" output="false" hint="I get the list of repayment modifications clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Modifications" type="any" required="yes">				
				<cfset var modlist = "" />
				<cfquery datasource="#application.dsn#" name="modlist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn modlist >
			</cffunction>		
			
			
			<cffunction name="getlegallist" access="remote" output="false" hint="I get the list of legal age clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="Legal Age" type="any" required="yes">				
				<cfset var legallist = "" />
				<cfquery datasource="#application.dsn#" name="legallist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn legallist >
			</cffunction>
			
			
			<cffunction name="getftclist" access="remote" output="false" hint="I get the list of FTC Holder Rule clarifying points.">				
				<cfargument name="treenum" default="1" type="any" required="yes">
				<cfargument name="branchname" default="FTC Holder Rule" type="any" required="yes">				
				<cfset var ftclist = "" />
				<cfquery datasource="#application.dsn#" name="ftclist">
					select title, pointtext
					  from clarifyingpoints
					 where optiontree like <cfqueryparam value="%#arguments.treenum#%" cfsqltype="cf_sql_varchar" />
				       and pointtype = <cfqueryparam value="#arguments.branchname#" cfsqltype="cf_sql_varchar" />
				  order by pointorder asc
				</cfquery>
				<cfreturn ftclist >
			</cffunction>
		
		
		</cfcomponent>