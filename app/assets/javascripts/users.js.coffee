# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

google.load("visualization", "1", {packages:["corechart"]});

#
# parse date string "2013-01-01" to date object
#
strToDate = (str) ->
  date = str.split '-'
  new Date(date[0], date[1], date[2])

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
  wrap.draw();

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

    chart_prefix = 'chartset-'+id+'-';

    ### chart project timeline ###

    # parse chart data
    data = new google.visualization.DataTable
    data.addColumn('date', 'Date')
    data.addColumn('number', 'Total Hours')
    for time_point in dataset.project_timeline
      data.addRow [strToDate(time_point.date), time_point.total_hours]

    # build chart hash
    chart =
      type: 'ColumnChart'
      data: data
      options:
        title: 'Project Timeline' 
      container: chart_prefix+'project_timeline'

    # draw chart
    drawChart chart

    ### chart tasks hours ###
    
    # parse chart data
    data = new google.visualization.DataTable
    data.addColumn('string', 'Task')
    data.addColumn('number', 'Total Hours') 
    for task_hours in dataset.tasks_hours
      data.addRow [task_hours.task, task_hours.total_hours]

    # build chart hash
    chart = 
      type: 'PieChart'
      data: data
      options:
        title: 'Tasks Hours'
      container: chart_prefix+'tasks-hours'

    # draw chart
    drawChart chart

    ### other charts ###

# set callbacks when page load
google.setOnLoadCallback drawCharts
