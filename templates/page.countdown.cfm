





							<!--- // include this page if we need to show the countdown timer --->
							<cfoutput>


									<script language="JavaScript">
									TargetDate = "#DateFormat('2-29-2008', 'mm/dd/yyyy')#" + " " + "#TimeFormat('16:00', 'h:MM:ss tt')#";
									Now = "#DateFormat(now(), 'mm/dd/yyyy')#" + " " + "#TimeFormat(now(), 'h:MM:ss tt')#";
									CountActive = true;
									CountStepper = -1;
									LeadingZero = true;
									DisplayFormat = "%%D%% D, %%H%% H, %%M%% M, %%S%% S.";
									FinishMessage = "This item has expired";
									</script>
								
								
									<script language="javascript" type="text/javascript" src="../scripts/countdown.js"></script>							
							
							
							</cfoutput>	