
// When the DOM is ready...
$(function(){
	
    // Hide stuff with the JavaScript. If JS is disabled, the form will still be useable.
    // NOTE:
    // Sometimes using the .hide(); function isn't as ideal as it uses display: none;
    // which has problems with some screen readers. Applying a CSS class to kick it off the
    // screen is usually prefered, but since we will be UNhiding these as well, this works.
    $(".name_wrap").hide();
    $("#company_name_wrap").hide();
    $("#special_accommodations_wrap").hide();
	
    // Reset form elements back to default values
    $("#submit_button").attr("disabled",true);
    $("#num_attendees").val('Please Choose');
    $("#step_2 input[type=radio]").each(function(){
        this.checked = false;
    });
    $("#rock").each(function(){
        this.checked = false;
    });
	
    // Fade out steps 2 and 3 until ready
    $("#step_2").css({
        opacity: 0.3
    });
    $("#step_3").css({
        opacity: 0.3
    });
	
    $.stepTwoComplete_one = "not complete";
    $.stepTwoComplete_two = "not complete";
		
    // When a dropdown selection is made
    $("#customer_email").blur(function(){
          
        $("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //$(".name_wrap").slideUp().find("input").removeClass("active_name_field");
		
    //switch ($("#num_attendees option:selected").text()) {
    //	case '1':
    //		$("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //		break;
    //	case '2':
    //		$("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_2_wrap").slideDown().find("input").addClass("active_name_field");
    //		break;
    //	case '3':
    //		$("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_2_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_3_wrap").slideDown().find("input").addClass("active_name_field");
    //		break;
    //	case '4':
    //		$("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_2_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_3_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_4_wrap").slideDown().find("input").addClass("active_name_field");
    //		break;
    //	case '5':
    //		$("#attendee_1_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_2_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_3_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_4_wrap").slideDown().find("input").addClass("active_name_field");
    //		$("#attendee_5_wrap").slideDown().find("input").addClass("active_name_field");
    //		break;
    //	}///
    });
	
    $("#submit_step_1").click(function(){

        var email =  document.getElementById("customer_email").value
        var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
        var password = document.getElementById("passwords").value
        var password_confirmation = document.getElementById("customer_password_confirmation").value

        if (email == '')
        {
            alert('Enter a valid E-email ID')
            return false;
        }

        if (!filter.test(email))
        {
           alert('Please provide a valid email address');
           email.focus
           return false;
         }

        if (password == '')
        {
            alert('Please enter the Password')
            return false;
        }
        if (password_confirmation == '')
        {
            alert('Please Confirm your Password again')
            return false;
        }
        if (password == password_confirmation)
        {
            document.getElementById("submit_step_1").style.display = 'none';
            var all_complete = true;
        }else{
            alert('Password and Confirm Password needs to match')
        }

		
				
        $(".active_name_field").each(function(){
            if ($(this).val() == '' ) {
                all_complete = false;
            };
        });
		
        if (all_complete) {
            $("#step_1")
            .animate({
                paddingBottom: "90px"
            })
            .css({
                "background-image": "url(images/check.png)",
                "background-position": "bottom center",
                "background-repeat": "no-repeat"
            });
            $("#step_2").css({
                opacity: 1.0
            });
            $("#step_2 legend").css({
                opacity: 1.0 // For dumb Internet Explorer
            });
        };
    });
	
    function stepTwoTest() {
        if (($.stepTwoComplete_two == "complete")) {
            $("#step_2")
            .animate({
                paddingBottom: "90px"
            })
            .css({
                "background-image": "url(images/check.png)",
                "background-position": "bottom center",
                "background-repeat": "no-repeat"
            });
            $("#step_3").css({
                opacity: 1.0
            });
            $("#step_3 legend").css({
                opacity: 1.0 // For dumb Internet Explorer
            });
        }
    };
	
    $("#submit_step_2").click(function(){
          var fn =  document.getElementById("customer_profile_first_name").value
          var ln =  document.getElementById("customer_profile_last_name").value
          var ad1 =  document.getElementById("customer_profile_address1").value
          var ad2 =  document.getElementById("customer_profile_address2").value
          var coun =  document.getElementById("name_input_country").value
          var pin =  document.getElementById("name_input_pin").value
          var cn =  document.getElementById("name_input_cn").value
  if (fn == '')
        {
            alert('Enter your First Name')
            return false;
        }
          if (ln == '')
        {
            alert('Enter your Last Name')
            return false;
        }
          if (ad1 == '')
        {
            alert('Enter Address1')
            return false;
        }
          if (coun == '')
        {
            alert('Enter your Country ')
            return false;
        }
          if (pin == '')
        {
            alert('Enter your Pincode')
            return false;
        }
          if (cn == '')
        {
            alert('Enter your Contact Number')
            return false;
        }
        
        document.getElementById("submit_step_2").style.display = 'none';
        $.stepTwoComplete_two = "complete";
        stepTwoTest();
    });
	
    $("#rock").click(function(){
        if (this.checked && $("#num_attendees option:selected").text() != 'Please Choose'
            &&  $.stepTwoComplete_two == 'complete') {
            $("#submit_button").attr("disabled",false);
        } else {
            $("#submit_button").attr("disabled",true);
        }
    });
	
});