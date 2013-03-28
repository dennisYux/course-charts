#
# application and account js manipulations are here
#

# set sidebar width once it is affixed
$ ->
  sidebarWidth = $('#account-sidebar').width() - parseInt($('#account-sidebar').css('paddingLeft')) \
    - parseInt($('#account-sidebar').css('paddingRight')) 
  $('#account-sidenav').css('width', sidebarWidth)

# activize sidebar
$ ->
  path = window.location.pathname
  $items = $('#account-sidenav > li').has('a')
  if path.match /^\/account$/ then $items.eq(0).addClass('active')
  else if path.match /^\/account\/edit$/ then $items.eq(1).addClass('active')
  else if path.match /^\/account\/projects\/new$/ then $items.eq(3).addClass('active')
  else if path.match /^\/account\/projects/ then $items.eq(2).addClass('active')

# auto fade flash
$ ->
  setTimeout( ->
    $('div.alert').fadeOut()
  , 3000)
