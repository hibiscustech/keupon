  function check_tos(){

    if (document.getElementById("firstname").value == "")
    {
      alert('Please enter firstname')
      return false;
    }

    if (document.getElementById("lastname").value == "")
    {
      alert('Please enter lastname')
      return false;
    }

    if (document.getElementById("merchant_pin").value == "")
    {
      alert('Please enter your NRIC/ FIN Number')
      return false;
    }

    if (document.getElementById("merchant_profile_address1").value == "")
    {
      alert('Please enter your contact address')
      return false;
    }

    if (document.getElementById("merchant_profile_country").value == "")
    {
      alert('Please enter your contact country')
      return false;
    }


    if (document.getElementById("merchant_profile_zipcode").value == "")
    {
      alert('Please enter your contact zipcode')
      return false;
    }
    if (document.getElementById("referal_code").value == "")
    {
      alert('Please enter your referral code')
      return false;
    }

    if (document.getElementById("merchant_profile_contact_number").value == "")
    {
      alert('Please enter your contact number')
      return false;
    }

    if (document.getElementById("merchant_profile_email_address").value == "")
    {
      alert('Please enter your contact email address')
      return false;
    }

    if (document.getElementById("company_name").value == "")
    {
      alert('Please enter your company name')
      return false;
    }

    if (document.getElementById("company_website").value == "")
    {
      alert('Please enter your company URL')
      return false;
    }

    if (document.getElementById("company_address1").value == "")
    {
      alert('Please enter your company address')
      return false;
    }
    if (document.getElementById("company_country").value == "")
    {
      alert('Please enter your company country')
      return false;
    }
    if (document.getElementById("company_zipcode").value == "")
    {
      alert('Please enter your company zipcode')
      return false;
    }
    if (document.getElementById("company_business_registration_number").value == "")
    {
      alert('Please enter your company business registration number')
      return false;
    }
    if (document.getElementById("merchant_company_photo").value == "")
    {
      alert('Please upload your company photo')
      return false;
    }
    if (document.getElementById("company_detail").value == "")
    {
      alert('Please enter your company details')
      return false;
    }


    var tos =  document.getElementById("tos").checked;
    if (tos == true)
    {
      document.getElementById("formElem").submit();
    }
    else
    {
      alert("Please put a tick mark on Terms and conditions");
      return false;
    }
  }

