# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

###
$ ->
  a =
    b: 'x'
    f: 'z'
    m: 'e'

  $('#chart_div').click( ->
    alert a.b
    alert a[f]
  )
###