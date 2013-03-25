# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

google.load "visualization", "1", {packages: ["corechart"]}

#
# parse date string "2013-01-01" to date object
#
strToDate = (str) ->
  date = str.split '-'
  new Date date[0], date[1], date[2]

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

  ### chart project hours ###

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
    container: chartPrefix+'project-hours'

  # draw chart
  drawChart chart

  ### chart tasks span ###

  # parse chart data
  data = new google.visualization.DataTable
  data.addColumn 'string', 'Task'
  data.addColumn 'number', 'Expected'
  data.addColumn {type: 'number', role: 'interval'}
  data.addColumn {type: 'number', role: 'interval'}
  data.addColumn 'number', 'Practical'
  data.addColumn {type: 'number', role: 'interval'}
  data.addColumn {type: 'number', role: 'interval'}
  for point in dataset.tasks_span
    data.addRow [point.task, 0, point.create, point.due, 0, point.start, point.finish]

  # build chart hash
  chart =
    type: 'BarChart'
    data: data
    options:
      title: 'Tasks Span' 
    container: chartPrefix+'tasks-span'

  # draw chart
  drawChart chart

  ### chart tasks hours ###
  
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

  ### other charts ###

# set callbacks when page load
$ ->
  # decide whether to draw charts
  path = window.location.pathname
  drawCharts path if path.match /^\/account\/projects\/\d+$/


$ ->
  $('.tasks-info').on('click', '.new-task', (e) ->
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
      '<div class="task-info">
        <h3>Task '+(index+1)+'</h3>
        <div class="control-group string required">
          <label class="string required control-label" for="project_task_'+index+'_name">
            <abbr title="required">*</abbr> Label
          </label>
          <div class="controls">
            <input class="string required" id="project_task_'+index+'_name" name="project[task]['+index+'][name]" size="50" type="text" />
          </div>
        </div>
        <div class="control-group date required">
          <label class="date required control-label" for="project_task_'+index+'_due_at_1i">
            <abbr title="required">*</abbr> Due 
          </label>
          <div class="controls">
            <select class="date required" id="project_task_'+index+'_due_at_1i" name="project[task]['+index+'][due_at(1i)]">'+yearOptions+'</select>
            <select class="date required" id="project_task_'+index+'_due_at_2i" name="project[task]['+index+'][due_at(2i)]">'+monthOptions+'</select>
            <select class="date required" id="project_task_'+index+'_due_at_3i" name="project[task]['+index+'][due_at(3i)]">'+dayOptions+'</select>
          </div>
        </div>
      </div>')) 
