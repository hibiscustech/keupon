
	function generateCC(f){
	    formname=f.name;
		var cc_number = new Array(16);
		var cc_len = 16;
		var start = 0;
		var rand_number = Math.random();
        
        if(formname=='ThreeDsecureForm')
        creditCardType=document.ThreeDsecureForm.creditCardType.value;
        else
        creditCardType=document.DoDirectPaymentForm.creditCardType.value;
        
		switch(creditCardType)
        {
			case "Visa":
				cc_number[start++] = 4;
				break;
			case "Discover":
				cc_number[start++] = 6;
				cc_number[start++] = 0;
				cc_number[start++] = 1;
				cc_number[start++] = 1;
				break;
			case "MasterCard":
				cc_number[start++] = 5;
				cc_number[start++] = Math.floor(Math.random() * 5) + 1;
				break;
			case "Amex":
				cc_number[start++] = 3;
				cc_number[start++] = Math.round(Math.random()) ? 7 : 4 ;
				cc_len = 15;
				break;
             case "Maestro":
				cc_number[start++] = 3;
				cc_number[start++] = Math.round(Math.random()) ? 7 : 4 ;
				cc_len = 16;
				break;
        }
        for (var i = start; i < (cc_len - 1); i++) {
			cc_number[i] = Math.floor(Math.random() * 10);
        }

		var sum = 0;
		for (var j = 0; j < (cc_len - 1); j++) {
			var digit = cc_number[j];
			if ((j & 1) == (cc_len & 1)) digit *= 2;
			if (digit > 9) digit -= 9;
			sum += digit;
		}

		var check_digit = new Array(0, 9, 8, 7, 6, 5, 4, 3, 2, 1);
		cc_number[cc_len - 1] = check_digit[sum % 10];

        if(formname=='ThreeDsecureForm')
        document.ThreeDsecureForm.creditCardNumber.value="";
        else
		document.DoDirectPaymentForm.creditCardNumber.value = "";
		for (var k = 0; k < cc_len; k++) 
		{
		 if(formname=='ThreeDsecureForm')
		 document.ThreeDsecureForm.creditCardNumber.value += cc_number[k];
		 else
		 document.DoDirectPaymentForm.creditCardNumber.value += cc_number[k];
		}
	}
