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
drawCharts = ->
	# trigger an ajax request to get json data for charts
  jsonData = $.ajax({
   	url: '/data/in-progress.json'
    dataType: "json"
    async: false
  }).responseText 

  # parse json string to structured object
  datasets = JSON.parse jsonData

  # iteratively draw charts for each project
  for dataset, id in datasets

    chartPrefix = 'chartset-'+id+'-';

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
google.setOnLoadCallback drawCharts
