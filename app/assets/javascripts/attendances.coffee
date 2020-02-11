# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 $ ->
    $("#search-form").keyup ->
      $("#search_form").find("input[type='submit']").click()
    $('#search_form').on 'ajax:success', (event, results) ->
      $select = $("#search_check")
      $trs = $select.find("tr")
      $trs.each ->
        value=($(this).find("td").first().text())
        if value in results
          $(this).show()
        else
          $(this).hide()