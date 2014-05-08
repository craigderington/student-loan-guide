<cffunction name="roundUpToNearestQuarter" output="FALSE" returntype="numeric">
  <cfargument name="number" type="numeric" required="TRUE" />

  <cfscript>
	  var remainder = arguments.number - Int( arguments.number );
	
	  if( remainder <= .25 ){
		remainder = .25;
	  }else if( remainder <= .5 ){
		remainder = .5;
	  }else if( remainder <= .75 ){
		remainder = .75;
	  }else{
		remainder = 1;
	  }

	  return Int( arguments.number ) + remainder;
  </cfscript>
</cffunction>

