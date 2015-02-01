


			<cfparam name="tree1" default="false">
			<cfparam name="tree2" default="false">
			<cfparam name="tree3" default="false">
			<cfparam name="tree4" default="false">
			<cfparam name="tree5" default="false">
			<cfparam name="tree6" default="false">
			<cfparam name="thissolutionid" default="0">


			<cfif structkeyexists( form, "create-action-plan" )>

				<cfif isdefined( "form.__authToken" )>
					
					<cfset msol = structnew() />
					<cfset msol.today = now() />
					<cfset msol.leadid = session.leadid />
					<cfset msol.soluuid = #createuuid()# />
					<cfset msol.userid = session.userid />
					<cfset msol.narrative = urlencodedformat( form.solutiontext ) />
					<cfset msol.comp = 1 />
					
					<cfquery datasource="#application.dsn#" name="addsolution">
						insert into mmisolutions(leadid, mmisolutionuuid, mmisolutiondate, mmisolutionuserid, mmisolutionnarrative, mmisolutioncompleted)
							values(
									<cfqueryparam value="#msol.leadid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#msol.soluuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
									<cfqueryparam value="#msol.today#" cfsqltype="cf_sql_timestamp" />,
									<cfqueryparam value="#msol.userid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#msol.narrative#" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="1" cfsqltype="cf_sql_bit" />							
							      ); select @@identity as newsolutionid
					</cfquery>
					
					<cfset thissolutionid = addsolution.newsolutionid />					
					<cfset session.planid = msol.soluuid />
					
					<!--- now format our tree 1 structure for insert --->
					<cfif isdefined( "form.tree1" ) and form.tree1 eq 1>						
						<cfset tree1 = structnew() />
						<cfif isdefined( "form.subcat1c" ) and isdefined( "form.subcat1clist" )>
							<cfset subcat1c = structinsert( tree1, "Cancellation", trim( form.subcat1clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat1f" ) and isdefined( "form.subcat1flist" )>
							<cfset subcat1f = structinsert( tree1, "Forgiveness", trim( form.subcat1flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat1d" ) and isdefined( "form.subcat1dlist" )>
							<cfset subcat1d = structinsert( tree1, "Default Intervention", trim( form.subcat1dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat1r" ) and isdefined( "form.subcat1rlist" )>
							<cfset subcat1r = structinsert( tree1, "Repayment Plan", trim( form.subcat1rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat1p" ) and isdefined( "form.subcat1plist" )>
							<cfset subcat1p = structinsert( tree1, "Postponement", trim( form.subcat1plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat1o" ) and isdefined( "form.subcat1olist" )>
							<cfset subcat1o = structinsert( tree1, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat1b" ) and isdefined( "form.subcat1blist" )>
							<cfset subcat1b = structinsert( tree1, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree1#" item="option">
							<cfquery datasource="#application.dsn#" name="tree1solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="Direct Loans" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree1[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					
					
					<!--- now format our tree 2 structure for insert --->
					<cfif isdefined( "form.tree2" ) and form.tree2 eq 2>						
						<cfset tree2 = structnew() />
						<cfif isdefined( "form.subcat2c" ) and isdefined( "form.subcat2clist" )>
							<cfset subcat2c = structinsert( tree2, "Cancellation", trim( form.subcat2clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat2f" ) and isdefined( "form.subcat2flist" )>
							<cfset subcat2f = structinsert( tree2, "Forgiveness", trim( form.subcat2flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat2d" ) and isdefined( "form.subcat2dlist" )>
							<cfset subcat2d = structinsert( tree2, "Default Intervention", trim( form.subcat2dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat2r" ) and isdefined( "form.subcat2rlist" )>
							<cfset subcat2r = structinsert( tree2, "Repayment Plan", trim( form.subcat2rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat2p" ) and isdefined( "form.subcat2plist" )>
							<cfset subcat2p = structinsert( tree2, "Postponement", trim( form.subcat2plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat2o" ) and isdefined( "form.subcat2olist" )>
							<cfset subcat2o = structinsert( tree2, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat2b" ) and isdefined( "form.subcat2blist" )>
							<cfset subcat2b = structinsert( tree2, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree2#" item="option">
							<cfquery datasource="#application.dsn#" name="tree2solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="FFEL" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree2[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					
					
					<!--- now format our tree 3 structure for insert --->
					<cfif isdefined( "form.tree3" ) and form.tree3 eq 3>						
						<cfset tree3 = structnew() />
						<cfif isdefined( "form.subcat3c" ) and isdefined( "form.subcat3clist" )>
							<cfset subcat3c = structinsert( tree3, "Cancellation", trim( form.subcat3clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat3f" ) and isdefined( "form.subcat3flist" )>
							<cfset subcat3f = structinsert( tree3, "Forgiveness", trim( form.subcat3flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat3d" ) and isdefined( "form.subcat3dlist" )>
							<cfset subcat3d = structinsert( tree3, "Default Intervention", trim( form.subcat3dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat3r" ) and isdefined( "form.subcat3rlist" )>
							<cfset subcat3r = structinsert( tree3, "Repayment Plan", trim( form.subcat3rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat3p" ) and isdefined( "form.subcat3plist" )>
							<cfset subcat3p = structinsert( tree3, "Postponement", trim( form.subcat3plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat3o" ) and isdefined( "form.subcat3olist" )>
							<cfset subcat3o = structinsert( tree3, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat3b" ) and isdefined( "form.subcat3blist" )>
							<cfset subcat3b = structinsert( tree3, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree3#" item="option">
							<cfquery datasource="#application.dsn#" name="tree3solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="Perkins" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree3[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					<!--- now format our tree 4 structure for insert --->
					<cfif isdefined( "form.tree4" ) and form.tree4 eq 4>						
						<cfset tree4 = structnew() />
						<cfif isdefined( "form.subcat4c" ) and isdefined( "form.subcat4clist" )>
							<cfset subcat4c = structinsert( tree4, "Cancellation", trim( form.subcat4clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat4f" ) and isdefined( "form.subcat4flist" )>
							<cfset subcat4f = structinsert( tree4, "Forgiveness", trim( form.subcat4flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat4d" ) and isdefined( "form.subcat4dlist" )>
							<cfset subcat4d = structinsert( tree4, "Default Intervention", trim( form.subcat4dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat4r" ) and isdefined( "form.subcat4rlist" )>
							<cfset subcat4r = structinsert( tree4, "Repayment Plan", trim( form.subcat4rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat4p" ) and isdefined( "form.subcat4plist" )>
							<cfset subcat4p = structinsert( tree4, "Postponement", trim( form.subcat4plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat4o" ) and isdefined( "form.subcat4olist" )>
							<cfset subcat4o = structinsert( tree4, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat4b" ) and isdefined( "form.subcat4blist" )>
							<cfset subcat4b = structinsert( tree4, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree4#" item="option">
							<cfquery datasource="#application.dsn#" name="tree4solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="Direct Consolidation" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree4[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					
					<!--- now format our tree 5 structure for insert --->
					<cfif isdefined( "form.tree5" ) and form.tree5 eq 5>						
						<cfset tree5 = structnew() />
						<cfif isdefined( "form.subcat5c" ) and isdefined( "form.subcat5clist" )>
							<cfset subcat5c = structinsert( tree5, "Cancellation", trim( form.subcat5clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat5f" ) and isdefined( "form.subcat5flist" )>
							<cfset subcat5f = structinsert( tree5, "Forgiveness", trim( form.subcat5flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat5d" ) and isdefined( "form.subcat5dlist" )>
							<cfset subcat5d = structinsert( tree5, "Default Intervention", trim( form.subcat5dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat5r" ) and isdefined( "form.subcat5rlist" )>
							<cfset subcat5r = structinsert( tree5, "Repayment Plan", trim( form.subcat5rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat5p" ) and isdefined( "form.subcat5plist" )>
							<cfset subcat5p = structinsert( tree5, "Postponement", trim( form.subcat5plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat5o" ) and isdefined( "form.subcat5olist" )>
							<cfset subcat5o = structinsert( tree5, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat5b" ) and isdefined( "form.subcat5blist" )>
							<cfset subcat5b = structinsert( tree5, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree5#" item="option">
							<cfquery datasource="#application.dsn#" name="tree5solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="Health Professional" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree5[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					
					
					<!--- now format our tree 6 structure for insert --->
					<cfif isdefined( "form.tree6" ) and form.tree6 eq 6>						
						<cfset tree6 = structnew() />
						<cfif isdefined( "form.subcat6c" ) and isdefined( "form.subcat6clist" )>
							<cfset subcat6c = structinsert( tree6, "Cancellation", trim( form.subcat6clist )) />								
						</cfif>
							
						<cfif isdefined( "form.subcat6f" ) and isdefined( "form.subcat6flist" )>
							<cfset subcat6f = structinsert( tree6, "Forgiveness", trim( form.subcat6flist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat6d" ) and isdefined( "form.subcat6dlist" )>
							<cfset subcat6d = structinsert( tree6, "Default Intervention", trim( form.subcat6dlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat6r" ) and isdefined( "form.subcat6rlist" )>
							<cfset subcat6r = structinsert( tree6, "Repayment Plan", trim( form.subcat6rlist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat6p" ) and isdefined( "form.subcat6plist" )>
							<cfset subcat6p = structinsert( tree6, "Postponement", trim( form.subcat6plist )) />
						</cfif>
						
						<cfif isdefined( "form.subcat6o" ) and isdefined( "form.subcat6olist" )>
							<cfset subcat6o = structinsert( tree6, "Offer in Compromise", "" ) />
						</cfif>
						
						<cfif isdefined( "form.subcat6b" ) and isdefined( "form.subcat6blist" )>
							<cfset subcat6b = structinsert( tree6, "Bankruptcy", "" ) />
						</cfif>

						<cfloop collection="#tree6#" item="option">
							<cfquery datasource="#application.dsn#" name="tree6solutiondetail">
								insert into mmisolutiondetail(mmisolutionid, mmisolutiontree, mmisolutionoption, mmisolutionsubcat)
									values(
											<cfqueryparam value="#thissolutionid#" cfsqltype="cf_sql_integer" />,
											<cfqueryparam value="Parent PLUS" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#option#" cfsqltype="cf_sql_varchar" />,
											<cfqueryparam value="#tree6[option]#" cfsqltype="cf_sql_varchar" />									
										   );
							</cfquery>						
						</cfloop>				
					</cfif>
					
					<!-- now that we are finished creating all of our necessary 
					     mmi solution records, 
					     redirect to the page to allow the user to print the 
						 action plan --->
						 
					<cflocation url="#application.root#?event=page.mmi.solution.final" addtoken="no">	
					
				
				</cfif><!-- / .auth-token -->
				
			</cfif><!-- / .create-action-plan -->