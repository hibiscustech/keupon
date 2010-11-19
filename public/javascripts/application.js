document.observe("dom:loaded", function() {    
  //This section is for ajax pagination
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/spinner.gif'

    function createSpinner() {
      new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        el.up('.pagination').insert(createSpinner())
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
  //ajax pagination section ends
});

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showViewDeal(elementID, deal_id)
{
    new Ajax.Request('/deals/view_basic_info?deal='+deal_id, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
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

function showKeupointDeal(elementID, deal)
{
    new Ajax.Request('/merchant/view_keupoint_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
    document.getElementById(elementID).style.display = "block";
}

function editKeupointDeal(elementID, deal)
{
    new Ajax.Request('/merchant/edit_keupoint_deal?id='+deal, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('f7451406a5f3527c920b15eb7f63840280305729')});
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
