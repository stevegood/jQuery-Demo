<!---
  Weatherboy v1.0 - A CFC that connects to Weather Underground's XML API feed. Provides current conditions, future forecasts, and weather alerts.
  Tested in Coldfusion 9. Should work fine in Coldfusion 8. Might work in Coldfusion 7.
  (c) 2011 Tony Drake - www.t27duck.com - t27duck@gmail.com
  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
--->
<cfcomponent nickname="Weatherboy" version="1.0" output="false">
  
  <cffunction name="init" access="public" returntype="any" output="false" hint="I return an initialized Weatherboy component.">
    <cfreturn this />
  </cffunction>
  
  <cffunction name="makeCall" access="private" returntype="any" output="false" hint="I make an API call">   
    <cfargument name="url" type="string" required="true" hint="I am the URL to call" />
    <cfhttp
      result = "local.api_call"
      url = "#ARGUMENTS.url#"
      throwOnError = "yes" 
      timeout = "10" 
      >
    </cfhttp>
    <cfreturn local.api_call.filecontent />
  </cffunction>
  
  <cffunction name="getCurrent" access="public" returntype="struct" output="false" hint="I get current weather conditions">   
    <cfargument name="location" type="string" required="true" hint="I am the location zipcode" />
	
	<cfset local.call_url = "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#arguments.location#">
    <cfset local.xml = xmlParse(makeCall(local.call_url))>
    <cfscript>
      local.cc = StructNew();
      local.cc['icon'] = "http://icons-ecast.wxug.com/graphics/conds/#xmlSearch(local.xml,'current_observation/icon')[1].xmlText#.gif";
      local.cc['weather'] = xmlSearch(local.xml,'current_observation/weather')[1].xmlText;
      local.cc['temp_f'] = xmlSearch(local.xml,'current_observation/temp_f')[1].xmlText;
      local.cc['temp_c'] = xmlSearch(local.xml,'current_observation/temp_c')[1].xmlText;
      local.cc['relative_humidity'] = xmlSearch(local.xml,'current_observation/relative_humidity')[1].xmlText;
      local.cc['wind_dir'] = xmlSearch(local.xml,'current_observation/wind_dir')[1].xmlText;
      local.cc['wind_mph'] = xmlSearch(local.xml,'current_observation/wind_mph')[1].xmlText;
      local.cc['pressure_mb'] = xmlSearch(local.xml,'current_observation/pressure_mb')[1].xmlText;
      local.cc['pressure_in'] = xmlSearch(local.xml,'current_observation/pressure_in')[1].xmlText;
      local.cc['dewpoint_f'] = xmlSearch(local.xml,'current_observation/dewpoint_f')[1].xmlText;
      local.cc['dewpoint_c'] = xmlSearch(local.xml,'current_observation/dewpoint_c')[1].xmlText;
      local.cc['heat_index_f'] = xmlSearch(local.xml,'current_observation/heat_index_f')[1].xmlText;
      local.cc['heat_index_c'] = xmlSearch(local.xml,'current_observation/heat_index_c')[1].xmlText;
      local.cc['windchill_f'] = xmlSearch(local.xml,'current_observation/windchill_f')[1].xmlText;
      local.cc['windchill_c'] = xmlSearch(local.xml,'current_observation/windchill_c')[1].xmlText;
      local.cc['windchill_c'] = xmlSearch(local.xml,'current_observation/windchill_c')[1].xmlText;
      local.cc['visibility_mi'] = xmlSearch(local.xml,'current_observation/visibility_mi')[1].xmlText;
      local.cc['visibility_km'] = xmlSearch(local.xml,'current_observation/visibility_km')[1].xmlText;
    </cfscript>
    <cfreturn local.cc>
  </cffunction>
  
  <cffunction name="getAlerts" access="public" returntype="array" output="false" hint="I get weather alerts">
	<cfargument name="location" type="string" required="true" hint="I am the location zipcode" />
	   
    <cfset local.call_url = "http://api.wunderground.com/auto/wui/geo/AlertsXML/index.xml?query=#arguments.location#">
    <cfset local.xml = xmlParse(makeCall(call_url))>
	
    <cfset local.alerts = [] />    
    <cfset local.alert_nodes = xmlSearch(local.xml, '/alerts/alert/AlertItem')>
    <cfloop from="1" to="#arrayLen(local.alert_nodes)#" index="local.i">
      <cfscript>
		local.alertXML = xmlParse(alert_nodes[local.i]);
		local.alert = {};
		local.alert['date'] = local.alertXML.AlertItem.date[1].xmlText;
		local.alert['message'] = local.alertXML.AlertItem.message[1].xmlText;
		local.alert['description'] = local.alertXML.AlertItem.description[1].xmlText;
		arrayAppend(local.alerts,local.alert);
      </cfscript>
    </cfloop>
    <cfreturn local.alerts>
  </cffunction>
  
  <cffunction name="getForecasts" access="public" returntype="array" output="false" hint="I get weather forecasts">
	<cfargument name="location" type="string" required="true" hint="I am the location zipcode" />
	
    <cfset local.call_url = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#arguments.location#">
    <cfset local.xml = xmlParse(makeCall(call_url))>
    <cfset local.forecasts = [] />
    
    <!--- First pass --->
    <cfset local.forecast_nodes = xmlSearch(local.xml, '/forecast/simpleforecast/forecastday')>
    <cfloop from="1" to="#arrayLen(local.forecast_nodes)#" index="local.i">
      <cfscript>
		local.forecastXML = xmlParse(local.forecast_nodes[local.i]);
		local.forecast = {};
		local.forecast['high_f'] = xmlSearch(local.forecastXML, 'forecastday/high/fahrenheit')[1].xmlText;
        local.forecast['high_c'] = xmlSearch(local.forecastXML, 'forecastday/high/celsius')[1].xmlText;
        local.forecast['low_f'] = xmlSearch(local.forecastXML, 'forecastday/low/fahrenheit')[1].xmlText;
        local.forecast['low_c'] = xmlSearch(local.forecastXML, 'forecastday/low/celsius')[1].xmlText;
        local.forecast['conditions'] = xmlSearch(local.forecastXML, 'forecastday/conditions')[1].xmlText;
        local.forecast['pop'] = xmlSearch(local.forecastXML, 'forecastday/pop')[1].xmlText;
        local.forecast['icon'] = "http://icons-ecast.wxug.com/graphics/conds/#xmlSearch(local.forecastXML, 'forecastday/icon')[1].xmlText#.gif";
        arrayAppend(local.forecasts,local.forecast);
      </cfscript>
    </cfloop>
    
    <!--- Second pass --->
    <cfset local.forecast_nodes = xmlSearch(local.xml, '/forecast/txt_forecast/forecastday')>
    <cfloop from="1" to="#arrayLen(local.forecast_nodes)#" index="local.i">
      <cfscript>
        local.forecastXML = xmlParse(local.forecast_nodes[local.i]);
        local.forecast = local.forecasts[local.i];
        local.forecast['text'] = xmlSearch(local.forecastXML, 'forecastday/fcttext')[1].xmlText;
        local.forecast['title'] = xmlSearch(local.forecastXML, 'forecastday/title')[1].xmlText;
      </cfscript>
    </cfloop>
    
    <cfreturn local.forecasts />
  </cffunction>
  
</cfcomponent>
