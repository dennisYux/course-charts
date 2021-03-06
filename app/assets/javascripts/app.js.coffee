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
  else if path.match /^\/account\/submission/ then $items.eq(4).addClass('active')

#
# project js manipulations are here
#

# css stuff
$ ->
  # common constants
  grey = '#F6F6F6'

  # set section padding
  $('.section-fieldset').filter(':first').css('padding-top', 0)
  $('.section-fieldset').filter(':last').css('margin-bottom', 0)

  # span indentation
  $('.row-fluid > .span6').filter(':even').css('margin-left', 0)

  # row background color
  $('.row-fluid.tr').filter(':even').css(background: grey)

  # chart div
  $('.div-chart').css('height', ($('.div-chart').width()/2))

# add task form
$ ->
  $('.form-inputs').on('click', '.new-task', (e) ->
    # event hold
    e.preventDefault()
    e.stopPropagation()
    # auxiliary parameters
    $this = $(this)
    index = $('.task-info').length
    today = new Date()
    curYear = today.getFullYear()
    curMonth = today.getMonth()
    curDay = today.getDate()
    monthNames = ['NA', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    # selector options
    yearOptions = ''
    for year in [(curYear-5)..(curYear+5)]
      yearOptions = yearOptions.concat '<option '
      yearOptions = yearOptions.concat 'selected="selected" ' if year == curYear
      yearOptions = yearOptions.concat 'value="'+year+'">'+year+'</option>'
    monthOptions = ''
    for month in [1..12]
      monthOptions = monthOptions.concat '<option '
      monthOptions = monthOptions.concat 'selected="selected" ' if month == curMonth+1
      monthOptions = monthOptions.concat 'value="'+month+'">'+monthNames[month]+'</option>'
    dayOptions = ''
    for day in [1..31]
      dayOptions = dayOptions.concat '<option '
      dayOptions = dayOptions.concat 'selected="selected" ' if day == curDay
      dayOptions = dayOptions.concat 'value="'+day+'">'+day+'</option>'
    $this.before(      
      '<fieldset class="task-info">
        <legend></legend>
        <div class="control-group string optional">
          <label class="string optional control-label" for="project_task_'+index+'_name">Name</label>
          <div class="controls">
            <input class="string optional" id="project_task_'+index+'_name" name="project[task]['+index+'][name]" size="50" type="text" />
          </div>
        </div>
        <div class="control-group date optional">
          <label class="date optional control-label" for="project_task_'+index+'_due_at_1i">Deadline</label>
          <div class="controls">
            <select class="date optional" id="project_task_'+index+'_due_at_1i" name="project[task]['+index+'][due_at(1i)]">'+yearOptions+'</select>
            <select class="date optional" id="project_task_'+index+'_due_at_2i" name="project[task]['+index+'][due_at(2i)]">'+monthOptions+'</select>
            <select class="date optional" id="project_task_'+index+'_due_at_3i" name="project[task]['+index+'][due_at(3i)]">'+dayOptions+'</select>
          </div>
        </div>
      </fieldset>'))

# add email form
$ ->
  $('.form-inputs').on('click', '.new-email', (e) ->
    # event hold
    e.preventDefault()
    e.stopPropagation()
    $this = $(this)    
    index = $('.email-info').length
    $this.before(      
      '<div class="email-info">
        <div class="control-group string optional">
          <label class="string optional control-label" for="email_'+index+'">Email</label>
          <div class="controls">
            <input id="email_'+index+'" name="email['+index+']" type="text" />
          </div>
        </div>
      </div>'))
  
google.load "visualization", "1", {packages: ["corechart"]}

# draw charts
$ ->
  #
  # parse date string "2013-01-01" to date object
  #
  strToDate = (str) ->
    date = str.split '-'
    new Date date[0], date[1], date[2]

  #
  # parse time string "23-59-59" to timeofday object
  #
  strToTime = (str) ->
    time = str.split '-'
    [(parseInt time[0]), (parseInt time[1]), (parseInt time[2])]

  #
  # draw single chart
  #
  drawChart = (chart) ->
    # set chart wrapper and draw chart
    wrap = new google.visualization.ChartWrapper
    wrap.setChartType chart.type
    wrap.setDataTable chart.data
    wrap.setOptions chart.options
    wrap.setContainerId chart.container
    wrap.draw()

  #
  # draw charts on project page
  #
  drawCharts = (path) ->
    # trigger an ajax request to get json data for charts
    jsonData = $.ajax({
      url: path+'.json'
      dataType: "json"
      async: false
    }).responseText 

    # parse json string to structured object
    dataset = JSON.parse jsonData

    chartPrefix = 'chartset-';

    ### chart user hours ###
    
    if dataset.user_hours != undefined
      
      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'date', 'Date'
      data.addColumn 'number', 'Total Hours' 
      for point in dataset.user_hours
        data.addRow [strToDate(point.date), point.total_hours]

      # build chart hash
      chart = 
        type: 'ColumnChart'
        data: data
        options:
          title: 'User Hours'
          hAxis:
            viewWindow: 
              min: strToDate dataset.user_hours_from
              max: strToDate dataset.user_hours_to
        container: chartPrefix+'user-hours'

      # draw chart
      drawChart chart

    ### chart user submission ###
    
    if dataset.user_submission != undefined
      
      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'string', 'ID'
      data.addColumn 'date', 'Date'
      data.addColumn 'timeofday', 'Time' 
      data.addColumn 'string', 'Project' 
      data.addColumn 'number', 'Hours' 
      for point in dataset.user_submission
        data.addRow ['', strToDate(point.date), strToTime(point.time), point.project, point.hours]

      # build chart hash
      chart = 
        type: 'BubbleChart'
        data: data
        options:
          title: 'User Records Submission'
          hAxis:
            viewWindow: 
              min: strToDate dataset.user_submission_from
              max: strToDate dataset.user_submission_to            
          sizeAxis:
            maxSize: 20
            minSize: 2
        container: chartPrefix+'user-submission'

      # draw chart
      drawChart chart

    ### chart project hours ###

    if dataset.project_hours != undefined

      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'date', 'Date'
      data.addColumn 'number', 'Total Hours'
      for point in dataset.project_hours
        data.addRow [strToDate(point.date), point.total_hours]

      # build chart hash
      chart =
        type: 'ColumnChart'
        data: data
        options:
          title: 'Project Hours'
          hAxis: 
            viewWindow: 
              min: strToDate dataset.project_hours_from
              max: strToDate dataset.project_hours_to
        container: chartPrefix+'project-hours'

      # draw chart
      drawChart chart

    ### chart tasks span ###

    if dataset.tasks_span != undefined

      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'string', 'Task'
      data.addColumn 'date', 'Expected'
      data.addColumn {type: 'date', role: 'interval'}
      data.addColumn {type: 'date', role: 'interval'}
      data.addColumn 'date', 'Practical'
      data.addColumn {type: 'date', role: 'interval'}
      data.addColumn {type: 'date', role: 'interval'}
      for point in dataset.tasks_span
        data.addRow [point.task, strToDate(dataset.tasks_span_from), strToDate(point.create), 
        strToDate(point.due), strToDate(dataset.tasks_span_from), strToDate(point.start), strToDate(point.finish)]

      # build chart hash
      chart =
        type: 'BarChart'
        data: data
        options:
          title: 'Tasks Span'
          hAxis:
            viewWindow: 
              min: strToDate dataset.tasks_span_from
              max: strToDate dataset.tasks_span_to
        container: chartPrefix+'tasks-span'

      # draw chart
      drawChart chart

    ### chart tasks hours ###
    
    if dataset.tasks_hours != undefined

      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'string', 'Task'
      data.addColumn 'number', 'Total Hours' 
      for point in dataset.tasks_hours
        data.addRow [point.task, point.total_hours]

      # build chart hash
      chart = 
        type: 'PieChart'
        data: data
        options:
          title: 'Tasks Hours'
        container: chartPrefix+'tasks-hours'

      # draw chart
      drawChart chart

    ### chart tasks submission ###
    
    if dataset.tasks_submission != undefined
      
      # parse chart data
      data = new google.visualization.DataTable
      data.addColumn 'string', 'ID'
      data.addColumn 'date', 'Date'
      data.addColumn 'timeofday', 'Time' 
      data.addColumn 'string', 'Task' 
      data.addColumn 'number', 'Hours' 
      for point in dataset.tasks_submission
        data.addRow ['', strToDate(point.date), strToTime(point.time), point.task, point.hours]

      # build chart hash
      chart = 
        type: 'BubbleChart'
        data: data
        options:
          title: 'Tasks Submission'
          hAxis:
            viewWindow: 
              min: strToDate dataset.tasks_submission_from
              max: strToDate dataset.tasks_submission_to            
          sizeAxis:
            maxSize: 20
            minSize: 2
        container: chartPrefix+'tasks-submission'

      # draw chart
      drawChart chart

    ### other charts ###

  # decide whether to draw charts
  path = window.location.pathname
  drawCharts path if path.match /^\/account$/  
  drawCharts path if path.match /^\/account\/projects\/\d+$/
