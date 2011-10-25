
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showViewDeal(elementID, deal_id)
{
    new Ajax.Request('/deals/view_basic_info?deal='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showDealPaypal(elementID, deal_id)
{
    new Ajax.Request('/admins/view_deal_paypal_info?deal='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showDealCommission(elementID, deal_id)
{
    new Ajax.Request('/admins/view_deal_commission_info?deal='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showTransactionDeal(elementID, deal_id)
{
    new Ajax.Request('/admins/view_deal_transaction_details?deal='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}


function showCustomerDeal(elementID, customer_deal_id)
{
    new Ajax.Request('/customers/view_customer_deal_info?id='+customer_deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}


function customer_name(customer_id)
{
   
    new Ajax.Request('/customers/edit_customer_name/'+customer_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
}


function customer_email(customer_id)
{

    new Ajax.Request('/customers/edit_customer_email/'+customer_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
}

function customer_password()
{
    new Ajax.Request('/customers/change_password', {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
}

function showLocationDeal(elementID, deal_id)
{
    new Ajax.Request('/customers/view_location_deal_info?id='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showKeupointDeal(elementID, deal_id)
{
    new Ajax.Request('/customers/view_keupoint_deal_info?id='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function createKeupointDeal(elementID)
{
    document.getElementById(elementID).style.display = "block";
}

function createGiftDeal(elementID)
{
    document.getElementById(elementID).style.display = "block";
}

function showKeupointDeal(elementID, deal)
{
    new Ajax.Request('/merchant/view_keupoint_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showGiftDeal(elementID, deal)
{
    new Ajax.Request('/merchant/view_gift_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showOpenDeal(elementID, deal)
{
    new Ajax.Request('/merchant/view_open_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function editKeupointDeal(elementID, deal)
{
    new Ajax.Request('/merchant/edit_keupoint_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function editGiftDeal(elementID, deal)
{
    new Ajax.Request('/merchant/edit_gift_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function editOpenDeal(elementID, deal)
{
    new Ajax.Request('/merchant/edit_open_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showCreateDeal(elementID, deal_date)
{
    new Ajax.Request('/deals/view_create_deal?date='+deal_date, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showCreateDemandDeal(elementID, demand_deal)
{
    new Ajax.Request('/merchant/view_create_demand_deal?id='+demand_deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showBidDemandDeal(elementID, demand_deal)
{
    new Ajax.Request('/merchant/view_demand_deal_info?id='+demand_deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function showDemandDealOffer(elementID, demand_deal)
{
    new Ajax.Request('/customers/view_demand_deal_offer?id='+demand_deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function hideElt(elementID)
{
	document.getElementById(elementID).style.display = "none";
}
function showElt(elementID)
{
	document.getElementById(elementID).style.display = "block";
}

function createsubscription(elementID)
{
    document.getElementById(elementID).style.display = "block";
}

function merchantpassword(elementID)
{
    document.getElementById(elementID).style.display = "block";
}

function customerpassword(elementID)
{
    document.getElementById(elementID).style.display = "block";
}


function changeScreenStepOne(){
	var email = document.getElementById("customer_email").value
	var filter = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
	var password = document.getElementById("passwords").value
	var password_confirmation = document.getElementById("customer_password_confirmation").value
	if (email == '') {
		alert('Enter a valid E-email ID');
		email.focus
		return false;
	}
	
	if (!filter.test(email)) {
		alert('Please provide a valid email address');
		email.focus
		return false;
	}
	
	if (password == '') {
		alert('Please enter the Password')
		return false;
	}
	if (password_confirmation == '') {
		alert('Please Confirm your Password again')
		return false;
	}
	if (password == password_confirmation) {
		var all_complete = true;
	}
	else {
		alert('Password and Confirm Password needs to match');
		return false;
	}
	if (all_complete) {
		document.getElementById("customerBasic").style.display = "none";
		document.getElementById("customerProfile").style.display = "block";
	}
}

function changeScreenStepTwo(){
	var fn =  document.getElementById("customer_profile_first_name").value
  	var ln =  document.getElementById("customer_profile_last_name").value
  	var nric =  document.getElementById("customer_profile_customer_pin").value
  	var ad2 =  document.getElementById("customer_profile_address1").value
  	var coun =  document.getElementById("customer_profile_country").value
  	var pin =  document.getElementById("customer_profile_zipcode").value
  	var cn =  document.getElementById("customer_profile_contact_number").value
	
    if (fn == '') {
    	alert('Enter your First Name')
        return false;
    }
	if (ln == ''){
        alert('Enter your Last Name')
        return false;
    }
	if (nric == ''){
        alert('Enter NRIC#')
        return false;
    }
	if (ad2 == ''){
		alert('Enter Address')
        return false;
    }
	if (coun == ''){
		alert('Enter your Country ')
        return false;
    }
	if (pin == ''){
		alert('Enter your Pincode')
        return false;
    }
//	if (cn != ''){
//		var all_complete = true;
//    }
//	else{
//		alert('Enter your Contact Number')
//        return false;
//	}


	if (isNaN(cn) || cn.indexOf(" ") != -1) {
	    alert("Enter numeric value for Mobile Number")
	    return false;
	}
	else if (cn.length != 8) {
	    alert("Enter 8 characters for Mobile Number");
	    return false;
	}
	else if (cn.charAt(0) == "9" || cn.charAt(0) == "8") {
	    var all_complete = true;
	}
	else{
		alert("Mobile Number should start with 8 or 9 ");
	    return false
	}
	
	if (all_complete) {
		document.getElementById("customerProfile").style.display = "none";
		document.getElementById("customerFinal").style.display = "block";
	}
}

function check_tos(){
    var tos = document.getElementById("tos").checked;
    if (tos == true) {
        document.getElementById("form").submit();
    }
    else {
        alert("Please put a tick mark on Terms and conditions");
        return false;
    }
}

function changeButton(id){
    if (id == "available") {
        document.getElementById('available').style.display = "block";
        document.getElementById('used').style.display = "none";
        document.getElementById('expired').style.display = "none";
        document.getElementById('all').style.display = "none";
        
        document.getElementById("visited_btn_available").className=""
        document.getElementById("visited_btn_used").className=""
        document.getElementById("visited_btn_expired").className=""
        document.getElementById("visited_btn_all").className=""
		document.getElementById("visited_btn_available").className="visited"
    }
    else if (id == "used") {
        document.getElementById('available').style.display = "none";
        document.getElementById('used').style.display = "block";
        document.getElementById('expired').style.display = "none";
        document.getElementById('all').style.display = "none";
        
        document.getElementById("visited_btn_available").className=""
        document.getElementById("visited_btn_used").className=""
        document.getElementById("visited_btn_expired").className=""
        document.getElementById("visited_btn_all").className=""
		document.getElementById("visited_btn_used").className="visited"
    }
    else if (id == "expired") {
        document.getElementById('available').style.display = "none";
        document.getElementById('used').style.display = "none";
        document.getElementById('expired').style.display = "block";
        document.getElementById('all').style.display = "none";
        
        document.getElementById("visited_btn_available").className=""
        document.getElementById("visited_btn_used").className=""
        document.getElementById("visited_btn_expired").className=""
        document.getElementById("visited_btn_all").className=""
		document.getElementById("visited_btn_expired").className="visited"
    }
    else if (id == "all") {
        document.getElementById('available').style.display = "none";
        document.getElementById('used').style.display = "none";
        document.getElementById('expired').style.display = "none";
        document.getElementById('all').style.display = "block";
        
        document.getElementById("visited_btn_available").className=""
        document.getElementById("visited_btn_used").className=""
        document.getElementById("visited_btn_expired").className=""
        document.getElementById("visited_btn_all").className=""
		document.getElementById("visited_btn_all").className="visited"
    }
}

function clearText(field){
    if (field.defaultValue == field.value) field.value = '';
    else if (field.value == '') field.value = field.defaultValue;
}