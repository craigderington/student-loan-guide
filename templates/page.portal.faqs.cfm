					
					
					
					<!--- // get our data access components --->
					<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
						<cfinvokeargument name="leadid" value="#session.leadid#">
					</cfinvoke>
					
					
					
					
					<link href="./js/plugins/faq/faq.css" rel="stylesheet"> 
					
					
					
					
					
					
					
					
					
					
					
					<div class="main">

						<div class="container">

						  <div class="row">
							
							<div class="span8">
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-pushpin"></i>
										<h3>Frequently Asked Questions</h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">	
										
										
										<ol class="faq-list">
											
											<li>
													
													<h4>What is NSLDS?</h4>
													<p>NSLDS stands for National Student Loan Data System. It is the U.S. Departments central database for student aid. It receives data from schools, agencies that guaranty loans, the Direct Loan Program and other US Department of Education Programs. The NSLDS allows a borrower to view all Title IV loans and grants that he/she received in the course of their education and the history of the loan.</p>	
													
											
											</li>
											
											<li>
													
													<h4>What is my Federal Student Aid PIN?</h4>
													<p>Your Federal Student Aid PIN is your electronic personal identification number that allows you access to your personal information to the U.S. Department of Education systems like www.nslds.ed.gov and www.studentaid.gov and acts as your digital signature on some online forms.</p>
											
											</li>
											
											<li>
												
													<h4>Who are my loan servicers?</h4>
													<p>Your loan servicers are listed on your NSLDS. They are under the contact type- Current Servicer. The servicer of your loan is the organization currently servicing a loan on behalf of a lender or school. The servicer collects payments and assists borrowers.</p>
											
											</li>
											
											<li>
													
													<h4>What is a Master Promissory Note (MPN)?</h4>
													<p>The Master Promissory Note is a legal document in which you promise to repay your loans(s) and any accrued interest and fees to the lender and is used to make one or more loans for one or more academic years.  It also explains the terms and conditions of your loan.</p>
											
											</li>
											
											<li>
												
													<h4>What does it mean to be in Grace Period?</h4>
													<p>The grace period is a period of time after borrowers graduate, leave school, or drop below half-time enrollment where they are not required to make payments on certain federal student loans. Some federal student loans will accrue interest during the grace period, and if the interest is unpaid, it will be added to the principal balance of the loan when the repayment period begins.</p>
											
											</li>
											
											<li>
													
													<h4>What is the difference between Default and Delinquent?</h4>
													<p>A loan is delinquent when loan payments are not received by the due dates. A loan remains delinquent until the borrower makes up he missed payment (s) through payment, deferment or forbearance.</p>			
											
											</li>
											
											<li>
												
													<h4>What is Gross Income?</h4>
													<p>Gross income is an individual’s total personal income before taking taxes or deductions into account.</p>
											
											</li>
											
											<li>
												
													<h4>What is Net Income?</h4>
													<p>An individual’s income after deductions, credits and taxes are factored into gross income.</p>
											
											</li>
											
											<li>
												
													<h4>What is Adjusted Gross Income?</h4>
													<p>Adjusted gross income is gross income from taxable sources minus deductions it is also referred to as net income.</p>
											
											</li>									
											
											
										</ol>
										
										
									</div> <!-- /widget-content -->
										
								</div> <!-- /widget -->	
								
							</div> <!-- /span8 -->
							
							
							
							<div class="span4">
										
								<div class="widget widget-plain">
									
									<div class="widget-content">
										
										<cfoutput>
											<cfif companysettings.useportalconvo eq 1>
												<a href="#application.root#?event=page.conversation&fuseaction=new" class="btn btn-large btn-warning btn-support-ask">Ask A Question</a>										
												<a href="mailto:#leaddetail.companyprimarycontact#" class="btn btn-large btn-support-contact" title="Contact #leaddetail.companyname#">Contact #leaddetail.dba#</a>
											<cfelse>																					
												<a href="mailto:#leaddetail.companyprimarycontact#" target="_blank" class="btn btn-large btn-support-contact" title="Contact #leaddetail.companyname#">Contact #leaddetail.dba#</a>
											</cfif>
										</cfoutput>
										
										
									</div> <!-- /widget-content -->
										
								</div> <!-- /widget -->
								
								
								
								<div class="widget stacked widget-box">
									
									<div class="widget-header">	
										<h3>Helpful Website Links</h3>			
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<p><a href="javascript:;" onclick="window.open('https://www.nslds.ed.gov/nslds_SA/','','scrollbars=yes,width=918,height=695');">Access NSLDS</a></p>
										<p><a href="javascript:;" onclick="window.open('https://pin.ed.gov/PINWebApp/pinindex.jsp','','scrollbars=yes,width=918,height=695');">Retrieve NSLDS PIN</a></p>
										<p><a href="javascript:;" onclick="window.open('http://www.irs.gov/uac/Definition-of-Adjusted-Gross-Income','','scrollbars=yes,width=918,height=695');">IRS - Adjusted Gross Income</a></p>
										<p></p>
										
									</div> <!-- /widget-content -->
									
								</div> <!-- /widget -->
								
							</div> <!-- /span4 -->
							
							
							
						  </div> <!-- /row -->

						</div> <!-- /container -->
							
					</div> <!-- /main -->
