


			<!--- // CLD 07-01-2013 // SLAdmin templating engine --->

			<!--- Scope the URL variable --->
			<cfparam name="event" default="page.index">

			<!--- generate page template based on event scope --->
			<cfswitch expression="#event#">				
				<cfcase value="page.index">					
					<cfinclude template="../../templates/page.index.cfm">					
				</cfcase>
				<cfcase value="page.logout">					
					<cfinclude template="../../templates/page.logout.cfm">					
				</cfcase>
				<cfcase value="page.portal.home">					
					<cfinclude template="../../templates/page.portal.home.cfm">					
				</cfcase>
				<cfcase value="page.portal.home2">					
					<cfinclude template="../../templates/page.portal.home2.cfm">					
				</cfcase>
				<cfcase value="page.menu.portal.tasks">					
					<cfinclude template="../../templates/page.menu.portal.tasks.cfm">					
				</cfcase>
				<cfcase value="page.menu.document.categories">					
					<cfinclude template="../../templates/page.menu.document.categories.cfm">					
				</cfcase>
				<cfcase value="page.portal.instructions">					
					<cfinclude template="../../templates/page.portal.instructions.cfm">					
				</cfcase>
				<cfcase value="page.loginhistory">
					<cfinclude template="../../templates/page.loginhistory.cfm">
				</cfcase>
				<cfcase value="page.profile">
					<cfinclude template="../../templates/page.profile.cfm">
				</cfcase>
				<cfcase value="page.lead.login">
					<cfinclude template="../../templates/page.lead.login.cfm">
				</cfcase>
				<cfcase value="page.taskmanager">
					<cfinclude template="../../templates/page.taskmanager.cfm">
				</cfcase>
				<cfcase value="page.modal">
					<cfinclude template="../../templates/page.modal.cfm">
				</cfcase>
				<cfcase value="page.growl">
					<cfinclude template="../../templates/page.growl.cfm">
				</cfcase>
				<cfcase value="page.manual">
					<cfinclude template="../../templates/page.manual.cfm">
				</cfcase>
				<cfcase value="page.reports">
					<cfinclude template="../../templates/page.reports.cfm">
				</cfcase>
				<cfcase value="page.reports.leadage">
					<cfinclude template="../../templates/page.reports.leadage.cfm">
				</cfcase>
				<cfcase value="page.reports.enrollment">				
					<cfinclude template="../../templates/page.reports.enrollment.cfm">
				</cfcase>
				<cfcase value="page.reports.esign">				
					<cfinclude template="../../templates/page.reports.esign.cfm">
				</cfcase>
				<cfcase value="page.leads">				
					<cfinclude template="../../templates/page.leads2.cfm">
				</cfcase>
				<cfcase value="page.leads2">				
					<cfinclude template="../../templates/page.leads2.cfm">
				</cfcase>
				<cfcase value="page.lead.new">				
					<cfinclude template="../../templates/page.lead.new.cfm">
				</cfcase>
				<cfcase value="page.clients">				
					<cfinclude template="../../templates/page.clients2.cfm">
				</cfcase>
				<cfcase value="page.clients2">				
					<cfinclude template="../../templates/page.clients2.cfm">
				</cfcase>
				<cfcase value="page.client.assignments">				
					<cfinclude template="../../templates/page.client.assignments.cfm">
				</cfcase>
				<cfcase value="page.client.forms">				
					<cfinclude template="../../templates/page.client.forms.cfm">
				</cfcase>
				<cfcase value="page.lead.tasks">				
					<cfinclude template="../../templates/page.lead.tasks.cfm">
				</cfcase>
				<cfcase value="page.library.forms">				
					<cfinclude template="../../templates/page.library.forms.cfm">
				</cfcase>
				<cfcase value="page.library.forms.upload">				
					<cfinclude template="../../templates/page.library.forms.upload.cfm">
				</cfcase>
				<cfcase value="page.library">				
					<cfinclude template="../../templates/page.library.cfm">
				</cfcase>
				<cfcase value="page.summary">				
					<cfinclude template="../../templates/page.summary.cfm">
				</cfcase>
				<cfcase value="page.tasks">				
					<cfinclude template="../../templates/page.tasks.cfm">
				</cfcase>
				<cfcase value="page.task.view">				
					<cfinclude template="../../templates/page.task.view.cfm">
				</cfcase>
				<cfcase value="page.task.edit">				
					<cfinclude template="../../templates/page.task.edit.cfm">
				</cfcase>
				<cfcase value="page.calc">				
					<cfinclude template="../../templates/page.calc.cfm">
				</cfcase>
				<cfcase value="page.task.reminder">				
					<cfinclude template="../../templates/page.task.reminder.cfm">
				</cfcase>
				<cfcase value="page.enroll">				
					<cfinclude template="../../templates/page.enroll.cfm">
				</cfcase>
				<cfcase value="page.enroll.status">				
					<cfinclude template="../../templates/page.enroll.status.cfm">
				</cfcase>
				<cfcase value="page.enroll.esign">				
					<cfinclude template="../../templates/page.enroll.esign.cfm">
				</cfcase>
				<cfcase value="page.implement.enroll">				
					<cfinclude template="../../templates/page.implement.enroll.cfm">
				</cfcase>
				<cfcase value="page.implement.personal">				
					<cfinclude template="../../templates/page.implement.personal.cfm">
				</cfcase>
				<cfcase value="page.implement.personal.references">				
					<cfinclude template="../../templates/page.implement.personal.references.cfm">
				</cfcase>
				<cfcase value="page.implement.personal.partner">				
					<cfinclude template="../../templates/page.implement.personal.partner.cfm">
				</cfcase>
				<cfcase value="page.conversation">				
					<cfinclude template="../../templates/page.conversation.cfm">
				</cfcase>				
				<cfcase value="page.txtmsg">				
					<cfinclude template="../../templates/page.txtmsg.cfm">
				</cfcase>
				<cfcase value="page.email">				
					<cfinclude template="../../templates/page.email.cfm">
				</cfcase>
				<cfcase value="page.notes">				
					<cfinclude template="../../templates/page.notes.cfm">
				</cfcase>
				<cfcase value="page.note.edit">				
					<cfinclude template="../../templates/page.note.edit.cfm">
				</cfcase>
				<cfcase value="page.note.delete">				
					<cfinclude template="../../templates/page.note.delete.cfm">
				</cfcase>
				<cfcase value="page.docs">				
					<cfinclude template="../../templates/page.docs.cfm">
				</cfcase>				
				<cfcase value="page.activity">				
					<cfinclude template="../../templates/page.activity.cfm">
				</cfcase>
				<cfcase value="page.survey">				
					<cfinclude template="../../templates/page.survey.cfm">
				</cfcase>
				<cfcase value="page.fees">				
					<cfinclude template="../../templates/page.fees.cfm">
				</cfcase>
				<cfcase value="page.fee.edit">				
					<cfinclude template="../../templates/page.fee.edit.cfm">
				</cfcase>
				<cfcase value="page.banking">				
					<cfinclude template="../../templates/page.banking.cfm">
				</cfcase>
				<cfcase value="page.worksheet">				
					<cfinclude template="../../templates/page.worksheet.cfm">
				</cfcase>
				<cfcase value="page.worksheet.add">				
					<cfinclude template="../../templates/page.worksheet.add.cfm">
				</cfcase>
				<cfcase value="page.nslds.upload">				
					<cfinclude template="../../templates/page.nslds.upload.cfm">
				</cfcase>
				<cfcase value="page.nslds.analyze">				
					<cfinclude template="../../templates/page.nslds.analyze.cfm">
				</cfcase>
				<cfcase value="page.nslds.results">				
					<cfinclude template="../../templates/page.nslds.results.cfm">
				</cfcase>
				<cfcase value="page.nslds.history">				
					<cfinclude template="../../templates/page.nslds.history.cfm">
				</cfcase>
				<cfcase value="page.worksheet.edit">				
					<cfinclude template="../../templates/page.worksheet.edit.cfm">
				</cfcase>
				<cfcase value="page.worksheet.delete">				
					<cfinclude template="../../templates/page.worksheet.delete.cfm">
				</cfcase>
				<cfcase value="page.repayments">				
					<cfinclude template="../../templates/page.repayments.cfm">
				</cfcase>
				<cfcase value="page.budget">				
					<cfinclude template="../../templates/page.budget.cfm">
				</cfcase>
				<cfcase value="page.budget.employment">				
					<cfinclude template="../../templates/page.budget.employment.cfm">
				</cfcase>
				<cfcase value="page.budget.income">				
					<cfinclude template="../../templates/page.budget.income.cfm">
				</cfcase>
				<cfcase value="page.budget.income2">				
					<cfinclude template="../../templates/page.budget.income2.cfm">
				</cfcase>
				<cfcase value="page.budget.income.deductions">				
					<cfinclude template="../../templates/page.budget.income.deductions.cfm">
				</cfcase>
				<cfcase value="page.budget.expenses">				
					<cfinclude template="../../templates/page.budget.expenses.cfm">
				</cfcase>
				<cfcase value="page.budget.assets">				
					<cfinclude template="../../templates/page.budget.assets.cfm">
				</cfcase>
				<cfcase value="page.tree">				
					<cfinclude template="../../templates/page.tree.cfm">
				</cfcase>
				<cfcase value="page.tree.ffel">				
					<cfinclude template="../../templates/page.tree.ffel.cfm">
				</cfcase>
				<cfcase value="page.tree.direct">				
					<cfinclude template="../../templates/page.tree.direct.cfm">
				</cfcase>
				<cfcase value="page.tree.perkins">				
					<cfinclude template="../../templates/page.tree.perkins.cfm">
				</cfcase>
				<cfcase value="page.tree.consol">				
					<cfinclude template="../../templates/page.tree.consol.cfm">
				</cfcase>
				<cfcase value="page.tree.healthpro">				
					<cfinclude template="../../templates/page.tree.healthpro.cfm">
				</cfcase>
				<cfcase value="page.tree.plus">				
					<cfinclude template="../../templates/page.tree.plus.cfm">
				</cfcase>
				<cfcase value="page.tree.private">				
					<cfinclude template="../../templates/page.tree.private.cfm">
				</cfcase>
				<cfcase value="page.solution">				
					<cfinclude template="../../templates/page.solution.cfm">
				</cfcase>
				<cfcase value="page.solution.notes">				
					<cfinclude template="../../templates/page.solution.notes.cfm">
				</cfcase>
				<cfcase value="page.solution.tasks">				
					<cfinclude template="../../templates/page.solution.tasks.cfm">
				</cfcase>
				<cfcase value="page.solution.checkout">				
					<cfinclude template="../../templates/page.solution.checkout.cfm">
				</cfcase>
				<cfcase value="page.solution.final">				
					<cfinclude template="../../templates/page.solution.final.cfm">
				</cfcase>
				<cfcase value="page.solution.present">				
					<cfinclude template="../../templates/page.solution.present.cfm">
				</cfcase>
				<cfcase value="page.solution.forms">				
					<cfinclude template="../../templates/page.solution.forms.cfm">
				</cfcase>
				<cfcase value="page.solution.remove">				
					<cfinclude template="../../templates/page.solution.remove.cfm">
				</cfcase>
				<cfcase value="page.worksheet.solution">				
					<cfinclude template="../../templates/page.worksheet.solution.cfm">
				</cfcase>
				<cfcase value="page.create.plan">				
					<cfinclude template="../../templates/page.create.plan.cfm">
				</cfcase>
				<cfcase value="page.solution.implement">				
					<cfinclude template="../../templates/page.solution.implement.cfm">
				</cfcase>
				<cfcase value="page.references">				
					<cfinclude template="../../templates/page.references.cfm">
				</cfcase>
				<cfcase value="page.reminders">				
					<cfinclude template="../../templates/page.reminders.cfm">
				</cfcase>
				<cfcase value="page.close">				
					<cfinclude template="../../templates/page.close.cfm">
				</cfcase>				
				<cfcase value="page.getlead">				
					<cfinclude template="../../templates/page.getlead.cfm">
				</cfcase>
				<cfcase value="page.search">				
					<cfinclude template="../../templates/page.search.cfm">
				</cfcase>
				<cfcase value="page.test">				
					<cfinclude template="../../templates/page.test.cfm">
				</cfcase>
				<cfcase value="page.search.clients">				
					<cfinclude template="../../templates/page.search.clients.cfm">
				</cfcase>
				<cfcase value="page.menu">				
					<cfinclude template="../../templates/page.menu.cfm">
				</cfcase>
				<cfcase value="page.menu.tasks">				
					<cfinclude template="../../templates/page.menu.tasks.cfm">
				</cfcase>
				<cfcase value="page.menu.portal.instructions">				
					<cfinclude template="../../templates/page.menu.portal.instructions.cfm">
				</cfcase>
				<cfcase value="page.menu.jobs">				
					<cfinclude template="../../templates/page.menu.jobs.cfm">
				</cfcase>
				<cfcase value="page.menu.job.edit">				
					<cfinclude template="../../templates/page.menu.job.edit.cfm">
				</cfcase>
				<cfcase value="page.menu.job.delete">				
					<cfinclude template="../../templates/page.menu.job.delete.cfm">
				</cfcase>
				<cfcase value="page.menu.servicers">				
					<cfinclude template="../../templates/page.menu.servicers.cfm">
				</cfcase>
				<cfcase value="page.menu.servicer.add">				
					<cfinclude template="../../templates/page.menu.servicer.add.cfm">
				</cfcase>
				<cfcase value="page.menu.servicer.detail">				
					<cfinclude template="../../templates/page.menu.servicer.detail.cfm">
				</cfcase>
				<cfcase value="page.menu.servicer.edit">				
					<cfinclude template="../../templates/page.menu.servicer.edit.cfm">
				</cfcase>
				<cfcase value="page.menu.servicer.delete">				
					<cfinclude template="../../templates/page.menu.servicer.delete.cfm">
				</cfcase>
				<cfcase value="page.menu.survey">				
					<cfinclude template="../../templates/page.menu.survey.cfm">
				</cfcase>
				<cfcase value="page.menu.survey.edit">				
					<cfinclude template="../../templates/page.menu.survey.edit.cfm">
				</cfcase>
				<cfcase value="page.menu.email">				
					<cfinclude template="../../templates/page.menu.email.cfm">
				</cfcase>
				<cfcase value="page.menu.email.add">				
					<cfinclude template="../../templates/page.menu.email.add.cfm">
				</cfcase>
				<cfcase value="page.menu.email.edit">				
					<cfinclude template="../../templates/page.menu.email.edit.cfm">
				</cfcase>
				<cfcase value="page.menu.email.delete">				
					<cfinclude template="../../templates/page.menu.email.delete.cfm">
				</cfcase>
				<cfcase value="page.menu.points">				
					<cfinclude template="../../templates/page.menu.points.cfm">
				</cfcase>
				<cfcase value="page.menu.point.add">				
					<cfinclude template="../../templates/page.menu.point.add.cfm">
				</cfcase>
				<cfcase value="page.menu.point.edit">				
					<cfinclude template="../../templates/page.menu.point.edit.cfm">
				</cfcase>
				<cfcase value="page.menu.plans">				
					<cfinclude template="../../templates/page.menu.plans.cfm">
				</cfcase>
				<cfcase value="page.menu.steps">				
					<cfinclude template="../../templates/page.menu.steps.cfm">
				</cfcase>
				<cfcase value="page.create.tasklist">				
					<cfinclude template="../../templates/page.create.tasklist.cfm">
				</cfcase>
				<cfcase value="page.users">				
					<cfinclude template="../../templates/page.manage.users2.cfm">
				</cfcase>
				<cfcase value="page.users2">				
					<cfinclude template="../../templates/page.manage.users2.cfm">
				</cfcase>
				<cfcase value="page.users.edit">				
					<cfinclude template="../../templates/page.manage.users.edit.cfm">
				</cfcase>
				<cfcase value="page.depts">				
					<cfinclude template="../../templates/page.manage.depts.cfm">
				</cfcase>
				<cfcase value="page.intake">				
					<cfinclude template="../../templates/page.client.intake.cfm">
				</cfcase>
				<cfcase value="page.intake.review">				
					<cfinclude template="../../templates/page.intake.review.cfm">
				</cfcase>
				<cfcase value="page.portal.welcome">				
					<cfinclude template="../../templates/page.portal.welcome.cfm">
				</cfcase>
				<cfcase value="page.client.agreement">				
					<cfinclude template="../../templates/page.client.agreement.cfm">
				</cfcase>
				<cfcase value="page.message.center">				
					<cfinclude template="../../templates/page.message.center.cfm">
				</cfcase>
				<cfcase value="page.printdocs">				
					<cfinclude template="../../templates/page.printdocs.cfm">
				</cfcase>
				<cfcase value="page.portal.faqs">
					<cfinclude template="../../templates/page.portal.faqs.cfm">
				</cfcase>
				<cfcase value="page.reports.leadsource">
					<cfinclude template="../../templates/page.reports.leadsource.cfm">
				</cfcase>
				<cfcase value="page.reports.intake">
					<cfinclude template="../../templates/page.reports.intake.cfm">
				</cfcase>
				<cfcase value="page.reports.intake.pipeline">
					<cfinclude template="../../templates/page.reports.intake.pipeline.cfm">
				</cfcase>
				<cfcase value="page.reports.advisor.accepted">
					<cfinclude template="../../templates/page.reports.advisor.accepted.cfm">
				</cfcase>
				<cfcase value="page.reports.enrolled">
					<cfinclude template="../../templates/page.reports.enrolled.cfm">
				</cfcase>
				<cfcase value="page.reports.summary.example">
					<cfinclude template="../../templates/page.reports.summary.example.cfm">
				</cfcase>
				<cfcase value="page.admin">				
					<cfif isuserinrole( "admin" )>	
						<cfinclude template="../../templates/page.admin.cfm">
					<cfelse>
						<cfinclude template="../../templates/page.company.admin.cfm">
					</cfif>
				</cfcase>
				<cfcase value="page.company.activity">				
					<cfinclude template="../../templates/page.company.activity.cfm">
				</cfcase>
				<cfcase value="page.settings">				
					<cfinclude template="../../templates/page.settings.cfm">
				</cfcase>
				<cfcase value="page.manage.leads">				
					<cfinclude template="../../templates/page.manage.leads.cfm">
				</cfcase>
				<cfcase value="page.system.activity">				
					<cfinclude template="../../templates/page.system.activity.cfm">
				</cfcase>				
				<cfcase value="page.admin.company">				
					<cfinclude template="../../templates/page.admin.company.cfm">
				</cfcase>
				<cfcase value="page.getcompany">				
					<cfinclude template="../../templates/page.getcompany.cfm">
				</cfcase>
				<cfcase value="page.hash">				
					<cfinclude template="../../templates/page.hash.cfm">
				</cfcase>
						
					
				
				<!--- default case --->
				<cfdefaultcase>
					<cfinclude template="../../templates/page.index.cfm">
				</cfdefaultcase>
			
			</cfswitch>