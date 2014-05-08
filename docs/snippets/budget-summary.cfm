


			<cfoutput>

			<!--- // begin budget summary --->
			<table width="100%"  border="0" cellspacing="0" cellpadding="10">
				
				<tr>
					<td colspan="2"><div align="center" class="style3">MONTHLY BUDGET SUMMARY </div></td>
				</tr>
				
				<tr valign="top">
				    <td width="50%" bgcolor="##f2f2f2"><div align="left">INCOME</div></td>			
					<td width="50%" bgcolor="##f2f2f2"><div align="left">EXPENSES</div></td>
				</tr>
				
				
				<!--- // income section --->
				<tr valign="top">
					<td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="5">
							<tr>
								<td colspan="2" class="style2"><strong>Primary Income </strong></td>
							</tr>
							<!--- // primary income and totals --->
							<tr>
								<td width="29%" class="style2">Gross Monthly Income: </td>
								<td width="71%" class="style2">#dollarformat( budget.primarygrossmonthly )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&bull; Federal Withholding </td>
								<td class="style2">#dollarformat( budget.primarywithholding )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&bull; FICA </td>
							    <td class="style2">#dollarformat( budget.primaryfica )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&bull; Medicare</td>
								<td class="style2">#dollarformat( budget.primarymedicare )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&bull; 401k/Retirement </td>
								<td class="style2">#dollarformat( budget.primary401k )#</td>
							</tr>
							  
							  
							<tr>
								<td class="style2">&bull; Benefits </td>
								<td class="style2">#dollarformat( budget.primarybenefits )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&bull; Other Withholding </td>
								<td class="style2"><cfif budget.primarycitytax neq 0.00>City Tax: #dollarformat( budget.primarycitytax )# <br /></cfif><cfif budget.primarystatetax neq 0.00>State Tax: #dollarformat( budget.primarystatetax )#</cfif></td>
							</tr>
							  
							<tr>
							    <td class="style4">&nbsp;</td>
							    <td class="style2">&nbsp;</td>
				            </tr>
							  
							<tr>
							    <td class="style4">Other Income </td>
							    <td class="style2">&nbsp;</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Part Time Job </td>
							    <td class="style2">#dollarformat( budget.primaryparttimejob )# <cfif budget.primaryparttimejobdescr is not ""> - #budget.primaryparttimejobdescr#</cfif></td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Pension </td>
							    <td class="style2">#dollarformat( budget.primarypension )#</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; SSI </td>
							    <td class="style2">#dollarformat( budget.primaryssi )#</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Child Support </td>
							    <td class="style2">#dollarformat( budget.primarychildsupport )#</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Rental Property </td>
							    <td class="style2">#dollarformat( budget.primaryrentalproperty )#</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Food Stamps </td>
							    <td class="style2">#dollarformat( budget.primaryfoodstamps )#</td>
				            </tr>
							  
							<tr>
							    <td class="style2">&bull; Other Income</td>
								<td class="style2">#dollarformat( budget.primaryincomeothera )# <cfif budget.primaryincomeotheradescr is not ""> - #budget.primaryincomeotheradescr#</cfif></td>
							</tr>
							  
							<tr>
							    <td class="style3">&nbsp;</td>
							    <td class="style2">&nbsp;</td>
				            </tr>
							  
							<tr>
								<td class="style3">Primary Net Income </td>
								<td class="style2">#dollarformat( budget.primarytotalincome )#</td>
							</tr>
							  
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
							  
							<!--- // secondary income and totals --->
							<tr>
								<td colspan="2" class="style2"><strong>Secondary Income </strong></td>
							</tr>
								  
							<tr>
								<td class="style2">Gross Monthy Income </td>
								<td class="style2">#dollarformat( budget.secondarygrossmonthly )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Federal Withholding</td>
								<td class="style2">#dollarformat( budget.secondarywithholding )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; FICA </td>
								<td class="style2">#dollarformat( budget.secondaryfica )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Medicare </td>
								<td class="style2">#dollarformat( budget.secondarymedicare )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; 401k/Retirment </td>
								<td class="style2">#dollarformat( budget.secondary401k )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Benefits </td>
								<td class="style2">#dollarformat( budget.secondarybenefits )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Other Withholding </td>
								<td class="style2"><cfif budget.secondarycitytax neq 0.00>City Tax: #dollarformat( budget.secondarycitytax )# <br /></cfif><cfif budget.secondarystatetax neq 0.00>State Tax: #dollarformat( budget.secondarystatetax )#</cfif></td>
							</tr>
								  
							<tr>
								<td class="style4">&nbsp;</td>
								<td class="style2">&nbsp;</td>
				            </tr>
								  
							<tr>
								<td class="style4">Other Income </td>
								<td class="style2">&nbsp;</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Part Time Job </td>
								<td class="style2">#dollarformat( budget.secondaryparttimejob )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Pension </td>
								<td class="style2">#dollarformat( budget.secondarypension )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; SSI </td>
								<td class="style2">#dollarformat( budget.secondaryssi )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Child Support </td>
								<td class="style2">#dollarformat( budget.secondarychildsupport )#</td>
				     		</tr>
								  
							<tr>
								<td class="style2">&bull; Rental Property </td>
								<td class="style2">#dollarformat( budget.secondaryrentalproperty )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Food Stamps </td>
								<td class="style2">#dollarformat( budget.secondaryfoodstamps )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&bull; Other Income</td>
								<td class="style2">#dollarformat( budget.secondaryincomeothera )# <cfif budget.secondaryincomeotheradescr is not ""> - #budget.secondaryincomeotheradescr#</cfif></td>
				            </tr>
								  
							<tr>
								<td class="style3">&nbsp;</td>
								<td class="style2">&nbsp;</td>
				            </tr>
								  
							<tr>
								<td class="style3">Secondary Net Income </td>
								<td class="style2">#dollarformat( budget.secondarytotalincome )#</td>
							</tr>
								  
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
								  
							<tr>
								<td class="style3">Combined Total Net Income </td>
								<td class="style2">#dollarformat( budget.primarytotalincome + budget.secondarytotalincome )#</td>
							</tr>
						</table>
					</td>
					
					<!--- // expenses --->
					<td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="5">
							<tr>
								<td width="30%" class="style3">Home and Shelter </td>
								<td width="70%" class="style2"><cfif budget.sheltertotal neq 0.00><strong>#dollarformat( budget.sheltertotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Mortgage/Rent </td>
								<td class="style2">#dollarformat( budget.mortgage1 )#</td>
							</tr>
							
							<tr>
								<td class="style2">&bull; 2nd Mortgage </td>
								<td class="style2">#dollarformat( budget.mortgage2 )#</td>
							</tr>
							
							<tr>
								<td class="style2">&bull; 3rd Mortgage </td>
								<td class="style2">#dollarformat( budget.mortgage3 )#</td>
							</tr>
							
							<tr>
								<td class="style2">&bull; Real Estate Taxes </td>
								<td class="style2">#dollarformat( budget.realestatetax )#</td>
							</tr>
							
							<tr>
								<td class="style2">&bull; HOA/Condo Dues </td>
								<td class="style2">#dollarformat( budget.hoacondodues )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Insurance </td>
								<td class="style2">#dollarformat( budget.homerentinsurance )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Automobiles</td>
								<td class="style2"><cfif budget.autototal neq 0.00><strong>#dollarformat( budget.autototal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Car Payment </td>
								<td class="style2">#dollarformat( budget.auto1 )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; 2nd Car Payment </td>
								<td class="style2">#dollarformat( budget.auto2 )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; 3rd Car Payment</td>
								<td class="style2">#dollarformat( budget.auto3 )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; 4th Car Payment </td>
								<td class="style2">#dollarformat( budget.auto4 )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Utilities</td>
								<td class="style2"><cfif budget.utilitytotal neq 0.00><strong>#dollarformat( budget.utilitytotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Electric </td>
								<td class="style2">#dollarformat( budget.electric )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Water </td>
								<td class="style2">#dollarformat( budget.water )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Trash </td>
								<td class="style2">#dollarformat( budget.trash )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Gas </td>
								<td class="style2">#dollarformat( budget.gas )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Cable </td>
								<td class="style2">#dollarformat( budget.cable )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Internet </td>
								<td class="style2">#dollarformat( budget.internet )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Local Telephone </td>
								<td class="style2">#dollarformat( budget.phone )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Cell Phone </td>
								<td class="style2">#dollarformat( budget.cellular )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Transportation</td>
								<td class="style2"><cfif budget.transtotal neq 0.00><strong>#dollarformat( budget.transtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Gasoline </td>
								<td class="style2">#dollarformat( budget.gasoline )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Tolls </td>
								<td class="style2">#dollarformat( budget.tolls )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Car Repairs </td>
								<td class="style2">#dollarformat( budget.autorepairs )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; State License/Tags </td>
								<td class="style2">#dollarformat( budget.autotags )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Public Transportation </td>
								<td class="style2">#dollarformat( budget.publictrans )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Groceries and Dining </td>
								<td class="style2"><cfif budget.foodtotal neq 0.00><strong>#dollarformat( budget.foodtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Groceries </td>
								<td class="style2">#dollarformat( budget.groceries )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; House Supplies </td>
								<td class="style2">#dollarformat( budget.homesupply )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Outside Meals (non-ent) </td>
								<td class="style2">#dollarformat( budget.mealsoutnonent )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Outside Meals (ent) </td>
								<td class="style2">#dollarformat( budget.mealsoutent )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; School Lunches </td>
								<td class="style2">#dollarformat( budget.schoollunch )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Tobacco/Cigarettes </td>
								<td class="style2">#dollarformat( budget.tobacco )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Insurance</td>
								<td class="style2"><cfif budget.insurancetotal neq 0.00><strong>#dollarformat( budget.insurancetotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Life Insurance </td>
								<td class="style2">#dollarformat( budget.lifeinsurance )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Major Medical </td>
								<td class="style2">#dollarformat( budget.medicaldental )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Auto Insurance </td>
								<td class="style2">#dollarformat( budget.autoinsurance )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Long Term Care </td>
								<td class="style2">#dollarformat( budget.longtermcare )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Medical Expenses </td>
								<td class="style2"><cfif budget.medtotal neq 0.00><strong>#dollarformat( budget.medtotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Medical Savings (HSA) </td>
								<td class="style2">#dollarformat( budget.hsaacct )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Prescriptions</td>
								<td class="style2">#dollarformat( budget.prescriptions )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Co-Pays/Deductibles </td>
								<td class="style2">#dollarformat( budget.copaydeduct )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; OTC Drugs </td>
								<td class="style2">#dollarformat( budget.overcounterpills )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Child Care </td>
								<td class="style2"><cfif budget.childcaretotal neq 0.00><strong>#dollarformat( budget.childcaretotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Day Care</td>
								<td class="style2">#dollarformat( budget.childcare )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; After School Care </td>
								<td class="style2">#dollarformat( budget.aftercare )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Child Activities </td>
								<td class="style2">#dollarformat( budget.childactivity )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Domestic Court Orders </td>
								<td class="style2"><cfif budget.domesticorder neq 0.00><strong>#dollarformat( budget.domesticorder )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Alimony </td>
								<td class="style2">#dollarformat( budget.alimony )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Child Support </td>
								<td class="style2">#dollarformat( budget.childsupport )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Judgements/Bank Levy </td>
								<td class="style2">#dollarformat( budget.banklevy )#</td>
							</tr>
						
							<tr>
								<td class="style2">&nbsp;</td>
								<td class="style2">&nbsp;</td>
							</tr>
						
							<tr>
								<td class="style3">Household Expenses </td>
								<td class="style2"><cfif budget.misctotal neq 0.00><strong>#dollarformat( budget.misctotal )#</strong><cfelse><strong>$0.00</strong></cfif></td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Clothing </td>
								<td class="style2">#dollarformat( budget.clothing )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Recreation </td>
								<td class="style2">#dollarformat( budget.recreation )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Student Loans </td>
								<td class="style2">#dollarformat( budget.studentloans )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Family Loans </td>
								<td class="style2">#dollarformat( budget.familyloans )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Personal Grooming </td>
								<td class="style2">#dollarformat( budget.personalgrooming )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Dry Cleaning </td>
								<td class="style2">#dollarformat( budget.drycleaning )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Other Family Expense </td>
								<td class="style2">#dollarformat( budget.familyexpenseother )#<cfif budget.familyexpenseotherdescr is not ""> for #budget.familyexpenseotherdescr#</cfif>
							</tr>
						
							<tr>
								<td class="style2">&bull; Charitable Donations </td>
								<td class="style2">#dollarformat( budget.donations )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Memberships </td>
								<td class="style2">#dollarformat( budget.memberships )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Pest Control </td>
								<td class="style2">#dollarformat( budget.pestcontrol )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Security System </td>
								<td class="style2">#dollarformat( budget.securitysystem )#</td>
							</tr>
						
							<tr>
								<td class="style2">&bull; Yard/Pool Maintenance </td>
								<td class="style2">#dollarformat( budget.yardmaint )#</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			
			
			</cfoutput>