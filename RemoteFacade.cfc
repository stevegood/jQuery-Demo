<cfcomponent output="false">
	
	<cffunction name="getAllWeatherDataForZip" access="remote" returntype="struct" output="false">
		<cfargument name="zip" type="string" required="true" />
		
		<cfset local.data = {} />
		<cfset local.data['current'] = application.services.weatherBoy.getCurrent(arguments.zip) />
		<cfset local.data['forecasts'] = application.services.weatherBoy.getForecasts(arguments.zip) />
		<cfset local.data['alerts'] = application.services.weatherBoy.getAlerts(arguments.zip) />
		
		<cfset application.services.lookupLogger.recordLookup(arguments.zip) />
		
		<cfreturn local.data />
	</cffunction>
	
	<cffunction name="getRecentLookups" access="remote" returntype="array" output="false">
		<cfargument name="count" type="numeric" required="false" default="5" />
		<cfreturn application.services.lookupLogger.getRecentLookups(arguments.count) />
	</cffunction>
	
</cfcomponent>