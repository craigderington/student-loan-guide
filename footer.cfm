
			
			
			
			<!--- // sub footer // extra links --->
			<div class="extra">

				<div class="container">

					<div class="row">
								
						<div class="span3">
									
							<h4>About</h4>
									
								<ul>
									<li><a href="javascript:;">About Us</a></li>
									<li><a href="javascript:;">eFiscal Networks, LLC.</a></li>									
									<li><a href="javascript:;">Disclaimer</a></li>
								</ul>
									
						</div> <!-- /span3 -->
								
						<div class="span3">
									
							<h4>Support</h4>
									
								<ul>
									<li><a href="javascript:;">Contact Support</a>
									<li><a href="javascript:;">Frequently Asked Questions</a></li>									
									<li><a href="javascript:;">Feedback</a></li>
								</ul>
									
						</div> <!-- /span3 -->
								
						<div class="span3">
									
							<h4>Legal</h4>
									
								<ul>									
									<li><a href="javascript:;">Terms of Use</a></li>
									<li><a href="javascript:;">Privacy Policy</a></li>
									<li><a href="javascript:;">Security</a></li>
								</ul>
									
						</div> <!-- /span3 -->

						<div class="span3">
									
							<span class="pull-right">
								<img src="img/sla2.jpg">									
							</span>
									
						</div> <!-- /span3 -->
						
								
					</div> <!-- /row -->

				</div> <!-- /container -->

			</div> <!-- /extra -->
			
			
			
			
			
			
			<cfoutput>
			<div class="footer">
		
				<div class="container">
					
					<div class="row">
						
						<div id="footer-copyright" class="span6">
							&copy; #Year(Now())# #application.title#  &raquo; All Rights Reserved.
						</div> <!-- /span6 -->
						
						<div id="footer-terms" class="span6">
							<a href="javascript:;" target="_blank">Agency Terms of Use</a> &raquo;  <a href="javascript:;" target="_blank">Disclaimer</a> &raquo; <a href="javascript:;" target="_blank">Legal</a>
						</div> <!-- /.span6 -->
						
					</div> <!-- /row -->
					
				</div> <!-- /container -->
				
			</div> <!-- /footer -->
			</cfoutput>
			
			
			
			
			<!-- JS placed at the end of the document so the pages load faster -->
			<script src="./js/libs/jquery-1.8.3.min.js"></script>
			<script src="./js/jquery.tablesorter.min.js"></script>
			<script src="./js/libs/jquery-ui-1.10.0.custom.min.js"></script>
			<script src="./js/libs/bootstrap.min.js"></script>			
			<script src="./js/Application.js"></script>			
			<script src="./js/demo/sliders.js"></script>
			<script src="./js/plugins/faq/faq.js"></script>
			<script src="./js/demo/faq.js"></script>
			<script src="./js/bootstrap-tooltip.js"></script>
			<script src="./js/bootstrap-popover.js"></script>
			
			<script type="text/javascript" src="https://s3.amazonaws.com/assets.freshdesk.com/widget/freshwidget.js"></script>
			<script type="text/javascript">
				FreshWidget.init("", {"queryString": "&widgetType=popup&formTitle=Student+Loan+Advisor+Online+Support&submitThanks=Thank+you+for+your+feedback.++One+of+our+team+members+will+follow+up+with+you+shortly.+&searchArea=no", "widgetType": "popup", "buttonType": "text", "buttonText": "Contact Support", "buttonColor": "black", "buttonBg": "#ffffff", "alignment": "4", "offset": "350px", "submitThanks": "Thank you for your feedback.  One of our team members will follow up with you shortly. ", "formHeight": "500px", "url": "https://efiscal.freshdesk.com"} );
			</script>
			
			<!--- // rel popover script --->
			<script type="text/javascript">
				$(document).ready(function(){		
					$('a[rel=popover]')
						.popover({
							offset: 10,
							html: true,
							placement: 'left'
						})
				$("#tablesorter").tablesorter({sortList:[[0,0],[2,1]], widgets: ['zebra']});
				});
			</script>
		</body>
	</html>