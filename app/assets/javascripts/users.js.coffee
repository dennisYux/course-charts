# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

google.load("visualization", "1", {packages:["corechart"]});

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

    ### chart tasks hours ###
  
    # parse chart data
    dataArray = [['Task', 'Total Hours']]    
    for task_hours, i in dataset.tasks_hours
      dataArray.push ['Task '+(i+1), task_hours]
      #console.log dataArray[i]

    # build chart hash
    chart = 
      type: 'BarChart'
      data: google.visualization.arrayToDataTable dataArray
      options:
        title: 'Tasks Hours'
      container: 'chartset-'+id+'-tasks-hours'

    # draw chart
    drawChart chart

    ### other charts ###

# set callbacks when page load
google.setOnLoadCallback drawCharts
