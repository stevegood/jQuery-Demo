jQuery(function($){
	
	// hide the show hide button by default and bind a click handler to it
	$('#showHideBtn').hide().click(function(){
		$('#results').toggle('slow');
	});
	
	// Set all links with external domains to open in a new window / tab
	var comp = new RegExp(location.host);
	$('a').each(function(){
	   if(!comp.test($(this).attr('href'))){
	       // a link that contains the current host           
	       $(this).attr('target','_blank');
	   }
	});
	
	// handle the contact form submission
	$('#contact').submit(function(event){
		event.preventDefault();
		var $name = $('#name');
		if ($name.val().length > 0){
			$('#showHideBtn').show();
			var output = $('<h2>Hello ' + $name.val() + '!</h2>');
			$('#results').append(output);
			$name.val('');
			
			// alternate the color of each of the values entered
			$('#results h2:even').addClass('even');
			$('#results h2:odd').addClass('odd');
			
		} else {
			alert("Please provide a name!");
		}
	});
	
	$('.button').addClass('big');
	
});
