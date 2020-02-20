$(function(){
		year = moment().format('YYYY')
		month = moment().format('MM')
	
	$("#month li").click(function () {

		month = $(this).attr('id')
		$("#month input").val(month);
		
		$.ajax({ //ajax通信で以下のことを行います
      url: '/approval_histories/search', //urlを指定
      type: 'GET', //メソッドを指定
      data: {
        			year: year,
        			month: month
    				}, 
      dataType: 'json' //データ形式を指定
    })
    	.done(function(data){ 
    		
    		$('tbody').find('tr').remove(); 
    		$('tbody').find('td').remove(); 
    		
      	$(data).each(function(i, approval_history){ 
      		approval_history.previous_in_at == null ? previous_in_at = '' : previous_in_at = moment(approval_history.previous_in_at).format('HH:mm');
      		approval_history.previous_out_at == null ? previous_out_at = '' : previous_out_at = moment(approval_history.previous_out_at).format('HH:mm');
      		approval_history.in_at == null ? in_at = '' : in_at = moment(approval_history.in_at).format('HH:mm');
      		approval_history.out_at == null ? out_at = '' : out_at = moment(approval_history.out_at).format('HH:mm');
      		$('tbody').append(
      			$("<tr>")
        			.append("<td>" + approval_history.date + "</td>")
        			.append("<td>" + previous_in_at + "</td>")
      				.append("<td>" + previous_out_at + "</td>")
      				.append("<td>" + in_at + "</td>")
      				.append("<td>" + out_at + "</td>")
      				.append("<td>" + approval_history.applying_attendance_change_target.name + "</td>")
      				.append("<td>" + moment(approval_history.created_at).format("YYYY-MM-DD") + "</td>")
      				.append("</tr>")
      		)
      	});
			});
	});
	
	$("#year li").click(function () {
		
		year = $(this).attr('id')
		$("#year input").val(year);


	$.ajax({ //ajax通信で以下のことを行います
      url: '/approval_histories/search', //urlを指定
      type: 'GET', //メソッドを指定
      data: {
        			year: year,
        			month: month
    				}, 
      dataType: 'json' //データ形式を指定
    })
    	.done(function(data){ 
    		
    		$('tbody').find('tr').remove(); 
    		$('tbody').find('td').remove(); 
    		
      	$(data).each(function(i, approval_history){ 
      		approval_history.previous_in_at == null ? previous_in_at = '' : previous_in_at = moment(approval_history.previous_in_at).format('HH:mm');
      		approval_history.previous_out_at == null ? previous_out_at = '' : previous_out_at = moment(approval_history.previous_out_at).format('HH:mm');
      		approval_history.in_at == null ? in_at = '' : in_at = moment(approval_history.in_at).format('HH:mm');
      		approval_history.out_at == null ? out_at = '' : out_at = moment(approval_history.out_at).format('HH:mm');
      		$('tbody').append(
      			$("<tr>")
        			.append("<td>" + approval_history.date + "</td>")
        			.append("<td>" + previous_in_at + "</td>")
      				.append("<td>" + previous_out_at + "</td>")
      				.append("<td>" + in_at + "</td>")
      				.append("<td>" + out_at + "</td>")
      				.append("<td>" + approval_history.applying_attendance_change_target.name + "</td>")
      				.append("<td>" + moment(approval_history.created_at).format("YYYY-MM-DD") + "</td>")
      				.append("</tr>")
      		)
      	});
			});
	});
	
	$("#reset").click(function () {
		
		year = moment().format('YYYY')
		$("#year input").val(year);
		
		month = moment().format('MM')
		$("#month input").val(month);
		


	$.ajax({ //ajax通信で以下のことを行います
      url: '/approval_histories/search', //urlを指定
      type: 'GET', //メソッドを指定
      data: {
        			year: year,
        			month: month
    				}, 
      dataType: 'json' //データ形式を指定
    })
    	.done(function(data){ 
    		
    		$('tbody').find('tr').remove(); 
    		$('tbody').find('td').remove(); 
    		
      	$(data).each(function(i, approval_history){ 
      		approval_history.previous_in_at == null ? previous_in_at = '' : previous_in_at = moment(approval_history.previous_in_at).format('HH:mm');
      		approval_history.previous_out_at == null ? previous_out_at = '' : previous_out_at = moment(approval_history.previous_out_at).format('HH:mm');
      		approval_history.in_at == null ? in_at = '' : in_at = moment(approval_history.in_at).format('HH:mm');
      		approval_history.out_at == null ? out_at = '' : out_at = moment(approval_history.out_at).format('HH:mm');
      		$('tbody').append(
      			$("<tr>")
        			.append("<td>" + approval_history.date + "</td>")
        			.append("<td>" + previous_in_at + "</td>")
      				.append("<td>" + previous_out_at + "</td>")
      				.append("<td>" + in_at + "</td>")
      				.append("<td>" + out_at + "</td>")
      				.append("<td>" + approval_history.applying_attendance_change_target.name + "</td>")
      				.append("<td>" + moment(approval_history.created_at).format("YYYY-MM-DD") + "</td>")
      				.append("</tr>")
      		)
      	});
			});
	});
	
});
