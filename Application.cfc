<cfcomponent output="false">
	
	<cfscript>
	this.name = "jQuery_Demo";
	this.datasource = "weather_dashboard";
	this.ormenabled = true;
	this.ormsettings = {
		dialect = "mysql",
		dbcreate = "dropcreate"
	};
	</cfscript>
	
	<cffunction name="onRequestStart">
		<cfif !structKeyExists(application,'services') || structKeyExists(url,'reload')>
			<cfset application.services = {} />
			<cfset application.services.weatherBoy = CreateObject("component","com.service.weather.WeatherBoy").init() />
			<cfset application.services.lookupLogger = CreateObject("component","com.service.weather.LookupLogger").init() />
		</cfif>
	</cffunction>
	
</cfcomponent>