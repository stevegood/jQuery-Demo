/*
 * A weather dashboard application powered by jQuery
 */

jQuery(function($){
	
	var application = application || {}; // create a 'global' namespace for our variables
	application.facade = '/RemoteFacade.cfc';
	
	$(document).bind('getRecentLookups',function(){
		$.getJSON(
			application.facade,
			{
				method: 'getRecentLookups',
				returnFormat: 'json'
			},
			function(result){
				var output = "";
				$(result).each(function(){
					var lookup = this;
					output += "<li><a class=\"zipLink\" href=\"javascript:void(0);\">" + lookup.zip + "</a></li>";
				});
				$('#recentLookupsList').html(output);
			}
		)
	});
	
	$('#zipFormButton').click(function(){
		var zip = $('#zipField').val();
		if (zip.length > 0){
			$('#weatherOutput').hide('slow',function(){
				$('#weatherOutput').html('<h2>Fetching Weather Data...</h2><p>Please wait while your requested weather data is gathered from the web.</p>');
				$('#weatherOutput').show('slow',function(){
					$.getJSON(
						application.facade,
						{
							method: 'getAllWeatherDataForZip',
							zip: zip,
							returnFormat: 'json'
						},
						function(result){
							$(document).trigger('getRecentLookups');
							$('#weatherOutput').html('<h2>Processing Weather Data...</h2><p>Please wait while your requested weather data is processed.</p>');
							
							var output = "";
							
							// current weather
							output += "<h2>Current Conditions <img src=\"" + result.current.icon + "\" /></h2>";
							var rowBreak = '</tr><tr>';
							var current = '<table id="current"><tbody><tr>';
							current += '<th>Condition</th><td>' + result.current.weather + '</td>';
							current += '<th>Temp</th><td>' + result.current.temp_f + '&deg; (f)</td>';
							current += rowBreak;
							current += '<th>Wind Speed</th><td>' + result.current.wind_mph + ' mph</td>';
							current += '<th>Wind Direction</th><td>' + result.current.wind_dir + '</td>';
							current += rowBreak;
							current += '<th>Visibility</th><td>' + result.current.visibility_mi + ' miles</td>';
							current += '<th>Relative Humidity</th><td>' + result.current.relative_humidity + '</td>';
							
							output += current + "</tr></tbody></table>";
							
							// alerts
							output += "<br/><br/><h2>Alerts</h2>";
							var alerts = '<ul id="alerts">';
							if (result.alerts.length > 0){
								$(result.alerts).each(function(){
									var alert = this;
									alerts += '<li><h3>' + alert.description + '</h3><blockquote><p>' + alert.message + '</p></blockquote><div class="date">' + alert.date + '</div></li>';
								});
							} else {
								alerts += '<li><h3>No Alerts!</h3></li>';
							}
							output += alerts + "</ul>";
							
							// forecast
							output += '<h2>Forecast</h2>';
							var forecastOP = '<table id="forecast"><tbody>';
							
							$(result.forecasts).each(function(){
								var forecast = this;
								if (forecast.title !== undefined){
									forecastOP += "<tr>";
									
									forecastOP += '<th colspan="4">' + forecast.title + ' :: ' + forecast.conditions + '</th>';
									forecastOP += '</tr><tr>';
									forecastOP += '<th>High</th><td>' + forecast.high_f + '&deg; (f)</td>';
									forecastOP += '<th>Low</th><td>' + forecast.low_f + '&deg; (f)</td>';
									
									forecastOP += '</tr><tr><td colspan="4"><img src="' + forecast.icon + '" /> ';
									if (forecast.text !== undefined){
										forecastOP += forecast.text;
									}
									forecastOP += '</td>';
									
									forecastOP += "</tr>";
								}
							});
							
							output += forecastOP + '</tbody></table>';
							
							$('#weatherOutput').hide('slow',function(){
								$('#weatherOutput').html(output);
								$('#weatherOutput').show('slow');
							});
							
						}
					)
				});
			});
		} else {
			alert("Enter a zip.");
		}
	});
	
	$('#zipForm').submit(function(event){
		event.preventDefault();
		$('#zipFormButton').trigger('click');
	});
	
	$('.zipLink').live('click',function(){
		$('#zipField').val($(this).text());
		$('#zipFormButton').trigger('click');		
	});
	
	$(document).trigger('getRecentLookups');
	
});
