ready = ->
  user_id = $("#user-charts").data("user-id");
  calories_input = $('#calories input');
  fat_input = $('#fat input');
  carbo_input = $('#carbo input');
  protein_input = $('#protein input');
  sleep_input = $('#sleep input');
  weight_input = $('#weight input');
  trainings_input = $('#trainings input');
  plan_input = $('#plan input');

  charts_to_update = [
    [calories_input, '/charts/' + user_id + '/calories/', 'chart-4'],
    [fat_input, '/charts/' + user_id + '/fat/', 'chart-5'],
    [carbo_input, '/charts/' + user_id + '/carbo/', 'chart-6'],
    [protein_input, '/charts/' + user_id + '/protein/', 'chart-7'],
    [sleep_input, '/charts/' + user_id + '/sleep/', 'chart-8'],
    [weight_input, '/charts/' + user_id + '/weight/', 'chart-1'],
    [trainings_input, '/charts/' + user_id + '/trainings/', 'chart-2'],
    [plan_input, '/charts/' + user_id + '/plan/', 'chart-3']
  ]

  $('input#start_date, input#end_date').on 'keyup', (event) ->
    if($(this).val().length == 10)
      $(this).datepicker( "setDate", $(this).val())
    return false

  #set time to charts
  #now
  today = new Date
  yyyy = today.getFullYear()
  mm = today.getMonth() + 1
  dd = today.getDate()
  if dd < 10
    dd = '0' + dd
  if mm < 10
    mm = '0' + mm

  #month ago
  month_ago = Date.today().add({ months: -1 })
  m_yyyy = month_ago.getFullYear()
  m_mm = month_ago.getMonth() + 1
  m_dd = month_ago.getDate()
  if m_dd < 10
    m_dd = '0' + m_dd
  if m_mm < 10
    m_mm = '0' + m_mm

  #year ago
  year_ago = Date.today().add({ months: -12 })
  y_yyyy = year_ago.getFullYear()
  y_mm = year_ago.getMonth() + 1
  y_dd = year_ago.getDate()
  if y_dd < 10
    y_dd = '0' + y_dd
  if y_mm < 10
    y_mm = '0' + y_mm

  for chart in charts_to_update
    do ->
      inputs = chart[0]
      url = chart[1]
      chart_id = chart[2]

      #own change
      inputs.on 'keyup change', (event) ->
        inputs.parent().parent().find("select").val("other")
        $.ajax
          url: url + inputs.filter("#start_date").val().replace(/\./g, "DOT") + '/' + inputs.filter("#end_date").val().replace(/\./g, "DOT")
          type: 'GET'
          dataType: 'json'
          error: (jqXHR, textStatus, errorThrown) ->
          success: (data, textStatus, jqXHR) ->
            Chartkick.charts[chart_id].updateData(data);
        event.stopImmediatePropagation();
        return false

      #select change
      select_input = inputs.parent().parent().find("select");
      select_input.on 'change', (event) ->
        selected_option = select_input.val();
        if selected_option == "last_year"
          inputs.filter("#start_date").val(y_dd + "." + y_mm + "." + y_yyyy);
          inputs.filter("#end_date").val(dd + "." + mm + "." + yyyy);
        if selected_option == "last_month"
          inputs.filter("#start_date").val(m_dd + "." + m_mm + "." + m_yyyy);
          inputs.filter("#end_date").val(dd + "." + mm + "." + yyyy);

        $.ajax
          url: url + inputs.filter("#start_date").val().replace(/\./g, "DOT") + '/' + inputs.filter("#end_date").val().replace(/\./g, "DOT")
          type: 'GET'
          dataType: 'json'
          error: (jqXHR, textStatus, errorThrown) ->
          success: (data, textStatus, jqXHR) ->
            Chartkick.charts[chart_id].updateData(data);
          event.stopImmediatePropagation();
        return false
      return false


$(document).ready ready
$(document).on 'turbolinks:load', ready