

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			
			
			<!--- // begin client budget expense group form processing --->
			
			
			<!--- // group 1 - home and shelter --->
			<cfif structkeyexists( form, "saveexphome" )>
			
				<cfset home = structnew() />
				<cfset home.budgetid = #trim( form.budgetuuid )# />
				<cfset home.ownrent = trim( form.ownrent ) />
				<cfset home.mtgrent = rereplace( form.mtgrent, "[\$,]", "", "all" ) />
				<cfset home.mortgage2 = rereplace( form.mortgage2, "[\$,]", "", "all" ) />
				<cfset home.mortgage3 = rereplace( form.mortgage3, "[\$,]", "", "all" ) />
				<cfset home.estatetax = rereplace( form.estatetax, "[\$,]", "", "all" ) />
				<cfset home.hoacondo = rereplace( form.hoacondo, "[\$,]", "", "all" ) />
				<cfset home.homeins = rereplace( form.homeins, "[\$,]", "", "all" ) />
				
				<!--- // set total for this exp group --->
				<cfset home.hometotal = home.mtgrent + home.mortgage2 + home.mortgage3 + home.estatetax + home.hoacondo + home.homeins />
				<cfset home.hometotal = rereplace( home.hometotal, "[\$,]", "", "all" ) />
				
				
				<!--- // update the budget expense group --->
				<cfquery datasource="#application.dsn#" name="homegroup">
					update budget
					   set ownorrent = <cfqueryparam value="#home.ownrent#" cfsqltype="cf_sql_varchar" />,
					       mortgage1 = <cfqueryparam value="#home.mtgrent#" cfsqltype="cf_sql_float" />,
						   mortgage2 = <cfqueryparam value="#home.mortgage2#" cfsqltype="cf_sql_float" />,
						   mortgage3 = <cfqueryparam value="#home.mortgage3#" cfsqltype="cf_sql_float" />,
						   realestatetax = <cfqueryparam value="#home.estatetax#" cfsqltype="cf_sql_float" />,
						   hoacondodues = <cfqueryparam value="#home.hoacondo#" cfsqltype="cf_sql_float" />,
						   homerentinsurance = <cfqueryparam value="#home.homeins#" cfsqltype="cf_sql_float" />,
						   sheltertotal = <cfqueryparam value="#home.hometotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#home.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				
				
				<!--- // redirect user to next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=auto" addtoken="no" />		
				
				
			<!--- // group 2 - automobile expenses --->
			<cfelseif structkeyexists( form, "saveexpauto" )>
			
				<cfset auto = structnew() />
				<cfset auto.budgetid = trim( form.budgetuuid ) />
				<cfset auto.car1 = rereplace( form.auto1, "[\$,]", "", "all" ) />
				<cfset auto.car2 = rereplace( form.auto2, "[\$,]", "", "all" ) />
				<cfset auto.car3 = rereplace( form.auto3, "[\$,]", "", "all" ) />
				<cfset auto.car4 = rereplace( form.auto4, "[\$,]", "", "all" ) />
				
				<!--- // set the total for auto expenses --->
				<cfset auto.autototal = auto.car1 + auto.car2 + auto.car3 + auto.car4 />
				<cfset auto.autototal = rereplace( auto.autototal, "[\$,]", "", "all" ) />
				
				
				<!--- // update the budget expense group --->
				<cfquery datasource="#application.dsn#" name="autogroup">
					update budget
					   set auto1 = <cfqueryparam value="#auto.car1#" cfsqltype="cf_sql_float" />,
					       auto2 = <cfqueryparam value="#auto.car2#" cfsqltype="cf_sql_float" />,
						   auto3 = <cfqueryparam value="#auto.car3#" cfsqltype="cf_sql_float" />,
						   auto4 = <cfqueryparam value="#auto.car4#" cfsqltype="cf_sql_float" />,
						   autototal = <cfqueryparam value="#auto.autototal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#auto.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=util" addtoken="no" />			
				
				
			<!--- // group 3 - utility group expenses --->
			<cfelseif structkeyexists( form, "saveexputil" )>
			
				<cfset util = structnew() />
				<cfset util.budgetid = trim( form.budgetuuid ) />
				<cfset util.power = rereplace( form.power, "[\$,]", "", "all" ) />
				<cfset util.water = rereplace( form.water, "[\$,]", "", "all" ) />
				<cfset util.trash = rereplace( form.trash, "[\$,]", "", "all" ) />
				<cfset util.gas = rereplace( form.gas, "[\$,]", "", "all" ) />
				<cfset util.cable = rereplace( form.cable, "[\$,]", "", "all" ) />
				<cfset util.internet = rereplace( form.internet, "[\$,]", "", "all" ) />
				<cfset util.phone = rereplace( form.phone, "[\$,]", "", "all" ) />
				<cfset util.cellphone = rereplace( form.cellphone, "[\$,]", "", "all" ) />
				
				<!--- set the utility group total --->
				<cfset util.utiltotal = util.power + util.water + util.trash + util.gas + util.cable + util.internet + util.phone + util.cellphone />
				<cfset util.utiltotal = rereplace( util.utiltotal, "[\$,]", "", "all" ) />
				
				<!--- // update the budget expense group --->
				<cfquery datasource="#application.dsn#" name="utilitygroup">
					update budget
					   set water = <cfqueryparam value="#util.water#" cfsqltype="cf_sql_float" />,
					       electric = <cfqueryparam value="#util.power#" cfsqltype="cf_sql_float" />,
						   trash = <cfqueryparam value="#util.trash#" cfsqltype="cf_sql_float" />,
						   gas = <cfqueryparam value="#util.gas#" cfsqltype="cf_sql_float" />,
						   cable = <cfqueryparam value="#util.cable#" cfsqltype="cf_sql_float" />,
						   internet = <cfqueryparam value="#util.internet#" cfsqltype="cf_sql_float" />,
						   phone = <cfqueryparam value="#util.phone#" cfsqltype="cf_sql_float" />,
						   cellular = <cfqueryparam value="#util.cellphone#" cfsqltype="cf_sql_float" />,
						   utilitytotal = <cfqueryparam value="#util.utiltotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#util.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=trans" addtoken="no" />
				
			<!--- // transportation group expenses --->
			<cfelseif structkeyexists( form, "saveexptrans" )>			
			
				<cfset trans = structnew() />
				<cfset trans.budgetid = trim( form.budgetuuid ) />
				<cfset trans.gas = rereplace( form.gasoline, "[\$,]", "", "all" ) />
				<cfset trans.tolls = rereplace( form.tolls, "[\$,]", "", "all" ) />
				<cfset trans.repairs = rereplace( form.carrepair, "[\$,]", "", "all" ) />
				<cfset trans.tags = rereplace( form.tags, "[\$,]", "", "all" ) />
				<cfset trans.publictrans = rereplace( form.publictrans, "[\$,]", "", "all" ) />
				
				<!--- // set the total for the transportation group --->
				<cfset trans.transtotal = trans.gas + trans.tolls + trans.repairs + trans.tags + trans.publictrans />
				<cfset trans.transtotal = rereplace( trans.transtotal, "[\$,]", "", "all" ) />
				
				
				<!--- // update the budget expense group --->
				<cfquery datasource="#application.dsn#" name="transgroup">
					update budget
					   set gasoline = <cfqueryparam value="#trans.gas#" cfsqltype="cf_sql_float" />,
					       tolls = <cfqueryparam value="#trans.tolls#" cfsqltype="cf_sql_float" />,
						   autorepairs = <cfqueryparam value="#trans.repairs#" cfsqltype="cf_sql_float" />,
						   autotags = <cfqueryparam value="#trans.tags#" cfsqltype="cf_sql_float" />,
						   publictrans = <cfqueryparam value="#trans.publictrans#" cfsqltype="cf_sql_float" />,
						   transtotal = <cfqueryparam value="#trans.transtotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#trans.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=groc" addtoken="no" />				
				
			
			<!--- // groceries and dining group expenses --->
			<cfelseif structkeyexists( form, "saveexpgroc" )>			
			
				<cfset groc = structnew() />
				<cfset groc.budgetid = trim( form.budgetuuid ) />
				<cfset groc.food = rereplace( form.food, "[\$,]", "", "all" ) />
				<cfset groc.supply = rereplace( form.homesupply, "[\$,]", "", "all" ) />
				<cfset groc.mealsent = rereplace( form.mealsout, "[\$,]", "", "all" ) />
				<cfset groc.mealsnonent = rereplace( form.mealsent, "[\$,]", "", "all" ) />
				<cfset groc.schoollunch = rereplace( form.schoollunch, "[\$,]", "", "all" ) />
				<cfset groc.tobacco = rereplace( form.tobacco, "[\$,]", "", "all" ) />
				
				<!--- // set the total for grocieries and dining --->
				<cfset groc.foodtotal = groc.food + groc.supply + groc.mealsent + groc.mealsnonent + groc.schoollunch + groc.tobacco />
				<cfset groc.foodtotal = rereplace( groc.foodtotal, "[\$,]", "", "all" ) />
				
				<!--- // update the expense group --->
				<cfquery datasource="#application.dsn#" name="grocgroup">
					update budget
					   set homesupply = <cfqueryparam value="#groc.supply#" cfsqltype="cf_sql_float" />,
					       tobacco = <cfqueryparam value="#groc.tobacco#" cfsqltype="cf_sql_float" />,
						   groceries = <cfqueryparam value="#groc.food#" cfsqltype="cf_sql_float" />,
						   mealsoutnonent = <cfqueryparam value="#groc.mealsnonent#" cfsqltype="cf_sql_float" />,
						   mealsoutent = <cfqueryparam value="#groc.mealsent#" cfsqltype="cf_sql_float" />,
						   schoollunch = <cfqueryparam value="#groc.schoollunch#" cfsqltype="cf_sql_float" />,
						   foodtotal = <cfqueryparam value="#groc.foodtotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#groc.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=ins" addtoken="no" />	
		
			
			<!--- // insurance group expenses --->
			<cfelseif structkeyexists( form, "saveexpins" )>			
			
				<cfset ins = structnew() />
				<cfset ins.budgetid = trim( form.budgetuuid ) />
				<cfset ins.life = rereplace( form.lifeins, "[\$,]", "", "all" ) />
				<cfset ins.medical = rereplace( form.medical, "[\$,]", "", "all" ) />
				<cfset ins.auto = rereplace( form.auto, "[\$,]", "", "all" ) />
				<cfset ins.ltcare = rereplace( form.ltcare, "[\$,]", "", "all" ) />
				
				<!--- // set the total for this expense group --->
				<cfset ins.instotal = ins.life + ins.medical + ins.auto + ins.ltcare />
				<cfset ins.instotal = rereplace( ins.instotal, "[\$,]", "", "all" ) />
				
				<!--- // update this expense group --->
				<cfquery datasource="#application.dsn#" name="insurancegroup">
					update budget
					   set lifeinsurance = <cfqueryparam value="#ins.life#" cfsqltype="cf_sql_float" />,
					       medicaldental = <cfqueryparam value="#ins.medical#" cfsqltype="cf_sql_float" />,
						   autoinsurance = <cfqueryparam value="#ins.auto#" cfsqltype="cf_sql_float" />,
						   longtermcare = <cfqueryparam value="#ins.ltcare#" cfsqltype="cf_sql_float" />,
						   insurancetotal = <cfqueryparam value="#ins.instotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#ins.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=med" addtoken="no" />
				
			
			<!--- // medical group expenses --->
			<cfelseif structkeyexists( form, "saveexpmed" )>
			
				<cfset med = structnew() />
				<cfset med.budgetid = trim( form.budgetuuid ) />
				<cfset med.hsaacct = rereplace( form.hsaacct, "[\$,]", "", "all" ) />
				<cfset med.prescripts = rereplace( form.prescripts, "[\$,]", "", "all" ) />
				<cfset med.copay = rereplace( form.copay, "[\$,]", "", "all" ) />
				<cfset med.otc = rereplace( form.otcdrugs, "[\$,]", "", "all" ) />
				
				<!--- // set the total for this expense group --->
				<cfset med.medtotal = med.hsaacct + med.prescripts + med.copay + med.otc />
				<cfset med.medtotal = rereplace( med.medtotal, "[\$,]", "", "all" ) />
				
				<!--- // update this budget expense group --->
				<cfquery datasource="#application.dsn#" name="medicalgroup">
					update budget
					   set hsaacct = <cfqueryparam value="#med.hsaacct#" cfsqltype="cf_sql_float" />,
					       prescriptions = <cfqueryparam value="#med.prescripts#" cfsqltype="cf_sql_float" />,
						   copaydeduct = <cfqueryparam value="#med.copay#" cfsqltype="cf_sql_float" />,
						   overcounterpills = <cfqueryparam value="#med.otc#" cfsqltype="cf_sql_float" />,
						   medtotal = <cfqueryparam value="#med.medtotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#med.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=care" addtoken="no" />
			
			
			<!--- // child care group expenses --->
			<cfelseif structkeyexists( form, "saveexpcare" )>
			
				<cfset care = structnew() />
				<cfset care.budgetid = trim( form.budgetuuid ) />
				<cfset care.daycare = rereplace( form.childcare, "[\$,]", "", "all" ) />
				<cfset care.aftercare = rereplace( form.aftercare, "[\$,]", "", "all" ) />
				<cfset care.childact = rereplace( form.childact, "[\$,]", "", "all" ) />
				
				<!--- // set the total for this expense group --->
				<cfset care.caretotal = care.daycare + care.aftercare + care.childact />
				<cfset care.caretotal = rereplace( care.caretotal, "[\$,]", "", "all" ) />
				
				<!--- // update the budget expense group --->
				<cfquery datasource="#application.dsn#" name="caregroup">
					update budget
					   set childcare = <cfqueryparam value="#care.daycare#" cfsqltype="cf_sql_float" />,
					       aftercare = <cfqueryparam value="#care.aftercare#" cfsqltype="cf_sql_float" />,
						   childactivity = <cfqueryparam value="#care.childact#" cfsqltype="cf_sql_float" />,
						   childcaretotal = <cfqueryparam value="#care.caretotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#care.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=dom" addtoken="no" />
				
			
			<!--- // domestic court order groups expenses --->
			<cfelseif structkeyexists( form, "saveexpdom" )>
			
				<cfset dm = structnew() />
				<cfset dm.budgetid = trim( form.budgetuuid ) />
				<cfset dm.alimony = rereplace( form.alimony, "[\$,]", "", "all" ) />
				<cfset dm.childsupport = rereplace( form.childsupport, "[\$,]", "", "all" ) />
				<cfset dm.banklevy = rereplace( form.banklevy, "[\$,]", "", "all" ) />
				
				<!--- // set the total for this expense group --->
				<cfset dm.domestictotal = dm.alimony + dm.childsupport + dm.banklevy />
				<cfset dm.domestictotal = rereplace( dm.domestictotal, "[\$,]", "", "all" ) />
				
				<!--- // update this budget expense group --->
				<cfquery datasource="#application.dsn#" name="domesticgroup">
					update budget
					   set alimony = <cfqueryparam value="#dm.alimony#" cfsqltype="cf_sql_float" />,
					       banklevy = <cfqueryparam value="#dm.banklevy#" cfsqltype="cf_sql_float" />,
						   childsupport = <cfqueryparam value="#dm.childsupport#" cfsqltype="cf_sql_float" />,
						   domesticorder = <cfqueryparam value="#dm.domestictotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#dm.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // redirect the user to the next expense group --->
				<cflocation url="#application.root#?event=#url.event#&expgrp=exp" addtoken="no" />
			
			
			
			<!--- // household expenses group --->
			<cfelseif structkeyexists( form, "saveexphousehold" )>		
			
				<cfset hs = structnew() />
				<cfset hs.budgetid = trim( form.budgetuuid ) />
				<cfset hs.clothing = rereplace( form.clothing, "[\$,]", "", "all" ) />
				<cfset hs.recreation = rereplace( form.recreation, "[\$,]", "", "all" ) />
				<cfset hs.stloans = rereplace( form.stloans, "[\$,]", "", "all" ) />
				<cfset hs.famloans = rereplace( form.famloans, "[\$,]", "", "all" ) />
				<cfset hs.pgroom = rereplace( form.personalgroom, "[\$,]", "", "all" ) />
				<cfset hs.dryclean = rereplace( form.dryclean, "[\$,]", "", "all" ) />
				<cfset hs.otherexp = rereplace( form.otherfamexp, "[\$,]", "", "all" ) />
				<cfset hs.otherexpdescr = trim( form.otherfamexpdescr ) />
				<cfset hs.donate = rereplace( form.donate, "[\$,]", "", "all" ) />
				<cfset hs.member = rereplace( form.member, "[\$,]", "", "all" ) />
				<cfset hs.pest = rereplace( form.pestcontrol, "[\$,]", "", "all" ) />
				<cfset hs.secsys = rereplace( form.secsys, "[\$,]", "", "all" ) />
				<cfset hs.yardmaint = rereplace( form.yardmaint, "[\$,]", "", "all" ) />
				
				<!--- // set the total for this expense group --->
				<cfset hs.housetotal = hs.clothing + hs.recreation + hs.stloans + hs.famloans + hs.pgroom + hs.dryclean + hs.otherexp + hs.donate + hs.member + hs.pest + hs.secsys + hs.yardmaint />
				<cfset hs.housetotal = rereplace( hs.housetotal, "[\$,]", "", "all" ) />
				
				<!--- // update this expense group --->
				<cfquery datasource="#application.dsn#" name="householdgroup">
					update budget
					   set clothing = <cfqueryparam value="#hs.clothing#" cfsqltype="cf_sql_float" />,
					       recreation = <cfqueryparam value="#hs.recreation#" cfsqltype="cf_sql_float" />,
						   studentloans = <cfqueryparam value="#hs.stloans#" cfsqltype="cf_sql_float" />,
						   familyloans = <cfqueryparam value="#hs.famloans#" cfsqltype="cf_sql_float" />,
						   personalgrooming = <cfqueryparam value="#hs.pgroom#" cfsqltype="cf_sql_float" />,
						   drycleaning = <cfqueryparam value="#hs.dryclean#" cfsqltype="cf_sql_float" />,
						   miscothera = <cfqueryparam value="#hs.otherexp#" cfsqltype="cf_sql_float" />,
						   miscotheradescr = <cfqueryparam value="#hs.otherexpdescr#" cfsqltype="cf_sql_varchar" />,
						   donations = <cfqueryparam value="#hs.donate#" cfsqltype="cf_sql_float" />,
						   memberships = <cfqueryparam value="#hs.member#" cfsqltype="cf_sql_float" />,
						   pestcontrol = <cfqueryparam value="#hs.pest#" cfsqltype="cf_sql_float" />,
						   securitysystem = <cfqueryparam value="#hs.secsys#" cfsqltype="cf_sql_float" />,
						   yardmaint = <cfqueryparam value="#hs.yardmaint#" cfsqltype="cf_sql_float" />,
						   misctotal = <cfqueryparam value="#hs.housetotal#" cfsqltype="cf_sql_float" />
					 where budgetuuid = <cfqueryparam value="#hs.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
				</cfquery>
				
				<!--- // task automation --->
				<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
					<cfinvokeargument name="leadid" value="#session.leadid#">
					<cfinvokeargument name="taskref" value="monbud">
				</cfinvoke>
				
				<!--- // portal task automation --->
				<cfif isuserinrole( "bclient" )>																										
					<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
						<cfinvokeargument name="portaltaskid" value="1413">
						<cfinvokeargument name="leadid" value="#session.leadid#">
					</cfinvoke>
				</cfif>
				
				<!--- // redirect the user to the expenses summary - last group --->
				<cflocation url="#application.root#?event=page.budget.expenses" addtoken="no" />
			
			
			
			</cfif>
			
			
			<!--- // let's set some values for our gross monthly income --->
			<cfparam name="primarygrossincome" default="">
			<cfparam name="secondarygrossincome" default="">
			<cfparam name="combinedgrossincome" default="">
			<cfset primarygrossincome = budget.primarytotalincome />
			<cfset secondarygrossincome = budget.secondarytotalincome />
			<cfset combinedgrossincome = primarygrossincome + secondarygrossincome />
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SAVE SUCCESS!</strong>  The client's budget expense group was successfully updated.  Please use the tabs below to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The budget item was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  Sorry, there was a problem with the selected record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>						
						
							<!--- // begin widget --->
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-list-alt"></i>							
									<h3>Monthly Budget Expense Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
								
								<div class="widget-content">		
									
									
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
										
										<div class="tabbable">										
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													
													<h3><i class="icon-list-alt"></i> Budget - Expenses by Category</h3>										
													<p>All expenses are based on monthly averages.  If you split expenses with another person, please only indicate your portion of the monthly expense.  If you do not currently have a certain expense, leave it marked as $0.00. Please click on the <strong>Home & Shelter</strong> button to begin entering expenses. </p>
														<cfoutput>
															<ul class="nav nav-tabs">
																<li><a href="#application.root#?event=page.budget">Summary</a></li>
																<li><a href="#application.root#?event=page.budget.employment">Employment</a></li>															
																<li><a href="#application.root#?event=page.budget.income">Primary Income</a></li>
																<li><a href="#application.root#?event=page.budget.income2">Spouse Co-Borrower Income</a></li>
																<li class="active"><a href="#application.root#?event=#url.event#">Expenses</a></li>																
															</ul>															
														</cfoutput>
														
														
														<cfif not structkeyexists( url, "expgrp" )>

															<table class="table table-bordered table-striped">
																<thead>
																	<tr>			
																		<th>Category</th>
																		<th>Category Total</th>
																		<th>Percentage of Gross Income</th>
																	</tr>
																</thead>
																<tbody>
																	<cfoutput>
																	<tr>																		
																		<td><a href="#application.root#?event=#url.event#&expgrp=home">Home &amp; Shelter</a></td>
																		<td>#dollarformat( budget.sheltertotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.sheltertotal / combinedgrossincome * 100.00 ), "99.99" )#% </span><cfelse><span class="label label-important">No income entered, can not calculate...</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=auto">Automobiles</a></td>
																		<td>#dollarformat( budget.autototal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.autototal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=util">Utilities</a></td>
																		<td>#dollarformat( budget.utilitytotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.utilitytotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=trans">Transportation</a></td>
																		<td>#dollarformat( budget.transtotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.transtotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=groc">Groceries &amp; Dining</a></td>
																		<td>#dollarformat( budget.foodtotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.foodtotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=ins">Insurance</a></td>
																		<td>#dollarformat( budget.insurancetotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.insurancetotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=med">Medical Expenses</a></td>
																		<td>#dollarformat( budget.medtotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.medtotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=care">Child Care</a></td>
																		<td>#dollarformat( budget.childcaretotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.childcaretotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=dom">Domestic Court Orders</a></td>
																		<td>#dollarformat( budget.domesticorder )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.domesticorder / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr>
																		<td><a href="#application.root#?event=#url.event#&expgrp=exp">Household Expenses</a></td>
																		<td>#dollarformat( budget.misctotal )#</td>
																		<td><cfif combinedgrossincome neq 0.00><span class="label label-inverse">#numberformat( ( budget.misctotal / combinedgrossincome * 100.00 ), "99.99" )#%</span></cfif></td>
																	</tr>
																	<tr class="alert alert-notice">
																		<td><a href="javascript:;">Total Expenses</a></td>
																		<td colspan="2">#dollarformat( budget.sheltertotal + budget.misctotal + budget.domesticorder + budget.childcaretotal + budget.medtotal + budget.insurancetotal + budget.foodtotal + budget.transtotal + budget.utilitytotal + budget.autototal )#</td>																		
																	</tr>
																	</cfoutput>
																</tbody>
															</table>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "home">
															<cfoutput>
																<form id="lead-budget-expense-home" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-home"></i> Home and Shelter <cfif budget.sheltertotal neq 0.00> - #dollarformat( budget.sheltertotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																		<div class="control-group">
																			<label class="control-label" for="ownrent">Own or Rent</label>
																			<div class="controls">
																				<label class="radio">
																					<input type="radio" name="ownrent" value="OWN"<cfif trim( budget.ownorrent ) is "OWN">checked</cfif>>
																					Homeowner
																				</label>
																				<label class="radio">
																					<input type="radio" name="ownrent" value="RNT"<cfif trim( budget.ownorrent ) is "RNT">checked</cfif>>
																					Renter
																				</label>
																				<p class="help-block">If neither a Homeowner nor Renter, please leave Primary Mortgage/Rent as $0.00.</p>
															
																			</div>
																		</div>									
																		
																		<div class="control-group">											
																			<label class="control-label" for="mtgrent">Primary Mortgage/Rent</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="mtgrent" value="#numberformat( budget.mortgage1, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="mortgage2">2nd Mortgage</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="mortgage2" value="#numberformat( budget.mortgage2, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="mortgage3">3rd Mortgage</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="mortgage3" value="#numberformat( budget.mortgage3, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="estatetax">Real Estate Taxes</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="estatetax" value="#numberformat( budget.realestatetax, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="hoacondo">HOA/Condo Dues</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="hoacondo" value="#numberformat( budget.hoacondodues, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="homeinsure">Insurance</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="homeins" value="#numberformat( budget.homerentinsurance, 'L99.99' )#" />
																				<p class="help-block">To include Renter's Insurance if you are renting.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																														
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexphome"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																	
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "auto">
														
															<cfoutput>
																<form id="lead-budget-expense-auto" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-truck"></i> Automobiles <cfif budget.autototal neq 0.00> - #dollarformat( budget.autototal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="mtgrent">1st Vehicle Payment</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="auto1" value="#numberformat( budget.auto1, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="mortgage2">2nd Vehicle Payment</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="auto2" value="#numberformat( budget.auto2, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="mortgage3">3rd Vehicle Payment</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="auto3" value="#numberformat( budget.auto3, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="estatetax">4th Vehicle Payment</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="auto4" value="#numberformat( budget.auto4, 'L99.99' )#" />
																				<p class="help-block">Any payments on a recreational vehicle should be entered here.  If you currently have more that 4 car payments each month, please list out additional payments in the Household Expenses section in expense group "Other".</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																																															
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpauto"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
														
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "util">
															
															<cfoutput>
																<form id="lead-budget-expense-utility" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-bolt"></i> Utilities <cfif budget.utilitytotal neq 0.00> - #dollarformat( budget.utilitytotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="power">Electric</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="power" value="#numberformat( budget.electric, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="water">Water</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="water" value="#numberformat( budget.water, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="trash">Trash</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="trash" value="#numberformat( budget.trash, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="gas">Gas</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="gas" value="#numberformat( budget.gas, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="cable">Cable</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="cable" value="#numberformat( budget.cable, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="internet">Internet</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="internet" value="#numberformat( budget.internet, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="phone">Local Telephone</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="phone" value="#numberformat( budget.phone, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="cellphone">Cell Phone</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="cellphone" value="#numberformat( budget.cellular, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexputil"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "trans">
															
															<cfoutput>
																<form id="lead-budget-expense-transportation" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-road"></i> Transportation <cfif budget.transtotal neq 0.00> - #dollarformat( budget.transtotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="gasoline">Gasoline</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="gasoline" value="#numberformat( budget.gasoline, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="tolls">Tolls</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="tolls" value="#numberformat( budget.tolls, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="carrepair">Car Repairs</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="carrepair" value="#numberformat( budget.autorepairs, 'L99.99' )#" />
																				<p class="help-block">If you have substantial and continual repairs for your vehicle, this amount should be the annualized amount of these repair costs (total repairs for the year divided by 12).</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="tags">State License/Tags</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="tags" value="#numberformat( budget.autotags, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="publictrans">Public Transportation</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="publictrans" value="#numberformat( budget.publictrans, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexptrans"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "groc">
															
															<cfoutput>
																<form id="lead-budget-expense-dining" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-shopping-cart"></i> Groceries and Dining <cfif budget.foodtotal neq 0.00> - #dollarformat( budget.foodtotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="food">Groceries</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="food" value="#numberformat( budget.groceries, 'L99.99' )#" />
																				<p class="help-block">Food Items - please do not enter amounts for non-food items</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="homesupply">House Supplies</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="homesupply" value="#numberformat( budget.homesupply, 'L99.99' )#" />
																				<p class="help-block">Household non-food items such as toiletries, paper products, etc...</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="mealsout">Outside Meals</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="mealsout" value="#numberformat( budget.mealsoutnonent, 'L99.99' )#" />
																				<p class="help-block">Non-Entertainment</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="entmeals">Outside Meals</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="mealsent" value="#numberformat( budget.mealsoutent, 'L99.99' )#" />
																				<p class="help-block">Entertainment</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="tags">School Lunches</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="schoollunch" value="#numberformat( budget.schoollunch, 'L99.99' )#" />
																				<p class="help-block">If paid only 9 months of the year, multiply the amount by 9, then divide by 12 to get an average monthly amount.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="publictrans">Tobacco/Cigarettes</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="tobacco" value="#numberformat( budget.tobacco, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																		
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpgroc"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "ins">
															
															<cfoutput>
																<form id="lead-budget-expense-insurance" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-certificate"></i> Insurance <cfif budget.insurancetotal neq 0.00> - #dollarformat( budget.insurancetotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="lifeins">Life</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="lifeins" value="#numberformat( budget.lifeinsurance, 'L99.99' )#" />
																				<p class="help-block">If any of the following insurance categories are automatically deducted from your income/paycheck, then do not list the expense here.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="medical">Major Medical</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="medical" value="#numberformat( budget.medicaldental, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="auto">Auto</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="auto" value="#numberformat( budget.autoinsurance, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="ltcare">Long Term Care</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="ltcare" value="#numberformat( budget.longtermcare, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																					
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpins"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "med">
															
															<cfoutput>
																<form id="lead-budget-expense-medical" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-ambulance"></i> Medical Expenses <cfif budget.medtotal neq 0.00> - #dollarformat( budget.medtotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="hsaacct">Medical Savings (HSA)</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="hsaacct" value="#numberformat( budget.hsaacct, 'L99.99' )#" />
																				<p class="help-block">Do not include if HSA is automatically deducted from your income/paycheck.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="prescripts">Prescriptions</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="prescripts" value="#numberformat( budget.prescriptions, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="copay">Co-Pays/Deductibles</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="copay" value="#numberformat( budget.copaydeduct, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="ltcare">OTC Drugs</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="otcdrugs" value="#numberformat( budget.overcounterpills, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																					
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpmed"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "care">
															
															<cfoutput>
																<form id="lead-budget-expense-daycare" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-group"></i> Child Care Expenses <cfif budget.childcaretotal neq 0.00> - #dollarformat( budget.childcaretotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="childcare">Child Day Care</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="childcare" value="#numberformat( budget.childcare, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="aftercare">After School Care</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="aftercare" value="#numberformat( budget.aftercare, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="childact">Child Activities</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="childact" value="#numberformat( budget.childactivity, 'L99.99' )#" />
																				<p class="help-block">Karate, Dance, Extra-Curricular Sports, etc.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																																					
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpcare"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "dom">
															
															<cfoutput>
																<form id="lead-budget-expense-domestic" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-money"></i> Domestic Court Orders <cfif budget.domesticorder neq 0.00> - #dollarformat( budget.domesticorder )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="alimony">Alimony</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="alimony" value="#numberformat( budget.alimony, 'L99.99' )#" />
																				<p class="help-block">Leave as $0.00 if alimony is automatically deducted from your income.  If neither deducted, nor court ordered; then enter the amount in alimony you pay each month.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="childsupport">Child Support</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="childsupport" value="#numberformat( budget.childsupport, 'L99.99' )#" />
																				<p class="help-block">Leave as $0.00 if child support is automatically deducted from your income.  If neither deducted nor court ordered; then enter the amount you pay in child support each month.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="childact">Judgments/Bank Levy</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="banklevy" value="#numberformat( budget.banklevy, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																																					
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexpdom"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														<cfelseif structkeyexists( url, "expgrp" ) and url.expgrp is "exp">
														
															<cfoutput>
																<form id="lead-budget-expense-household" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																	
																	<h4><i class="icon-shopping-cart"></i> Household Expenses <cfif budget.misctotal neq 0.00> - #dollarformat( budget.misctotal )#</cfif><a href="#application.root#?event=page.budget.expenses" style="float:right;" class="btn btn-default btn-small"><i class="icon-circle-arrow-left"></i> Expense Summary</a></h4>
																	<br />
																	<div style="padding-left:30px;">
																																		
																		<div class="control-group">											
																			<label class="control-label" for="clothing">Clothing</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="clothing" value="#numberformat( budget.clothing, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="recreation">Recreation</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="recreation" value="#numberformat( budget.recreation, 'L99.99' )#" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="stloans">Student Loans</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="stloans" value="#numberformat( budget.studentloans, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="famloans">Family Loans</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="famloans" value="#numberformat( budget.familyloans, 'L99.99' )#" />
																				<p class="help-block">Loan repayments to family members.</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="personalgroom">Personal Grooming</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="personalgroom" value="#numberformat( budget.personalgrooming, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="dryclean">Dry Cleaning</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="dryclean" value="#numberformat( budget.drycleaning, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="otherfamexp">Other Family Expenses</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="otherfamexp" value="#numberformat( budget.miscothera, 'L99.99' )#" />&nbsp;&nbsp;<input type="text" class="input-large" name="otherfamexpdescr" value="#budget.miscotheradescr#" placeholder="Other Family Expense Description" />
																				<p class="help-block">Credit cards, pay day loans, medical bills, time shares, etc...</p>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="donate">Charitable Donations</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="donate" value="#numberformat( budget.donations, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="member">Memberships</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="member" value="#numberformat( budget.memberships, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="pestcontrol">Pest Control</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="pestcontrol" value="#numberformat( budget.pestcontrol, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="secsys">Security System</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="secsys" value="#numberformat( budget.securitysystem, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="yardmaint">Yard/Pool Maintenance</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="yardmaint" value="#numberformat( budget.yardmaint, 'L99.99' )#" />																				
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<br />
																		
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="saveexphousehold"><i class="icon-save"></i> Save Expense Group</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.expenses'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																			<input type="hidden" name="__authToken" value="#randout#" />																																		
																		</div> <!-- /form-actions -->
																	</div>	
																	</fieldset>
																</form>
															</cfoutput>
															
														</cfif>
														
																	
												</div> <!-- / .tab1 -->										 
											
											</div> <!-- / .tab-content -->
										
										</div><!-- // .tabbable -->
											
										</div> <!-- / .span8 -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		