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

function moveDeal(deal, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + deal.id + '&title=' + deal.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/deals/move"
    });
}

function resizeDeal(deal, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + deal.id + '&title=' + deal.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/deals/resize"
    });
}

function showDealDetails(deal){
    $('#deal_desc').html(deal.description);
    $('#edit_deal').html("<a href = 'javascript:void(0);' onclick ='editDeal(" + deal.id + ")'>Edit</a>");
    if (deal.recurring) {
        title = deal.title + "(Recurring)";
        $('#delete_deal').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteDeal(" + deal.id + ", " + false + ")'>Delete Only This Occurrence</a>");
        $('#delete_deal').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteDeal(" + deal.id + ", " + true + ")'>Delete All In Series</a>")
        $('#delete_deal').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteDeal(" + deal.id + ", \"future\")'>Delete All Future Deals</a>")
    }
    else {
        title = deal.title;
        $('#delete_deal').html("<a href = 'javascript:void(0);' onclick ='deleteDeal(" + deal.id + ", " + false + ")'>Delete</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(deal, ui){
            $('#desc_dialog').dialog('destroy')
        }

    });

}


function editDeal(deal_id){
    jQuery.ajax({
        data: 'id=' + deal_id,
        dataType: 'script',
        type: 'get',
        url: "/deals/edit"
    });
}

function deleteDeal(deal_id, delete_all){
    jQuery.ajax({
        data: 'id=' + deal_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'post',
        url: "/deals/destroy"
    });
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;

        default:
            $('#frequency').hide();
    }




}
