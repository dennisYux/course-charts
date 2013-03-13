# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

google.load "visualization", "1", {packages: ["corechart"]}
google.setOnLoadCallback drawChart

drawChart ->
	data = google.visualization.arrayToDataTable [
		['Task', 'Hours per Day']
	  ['Work',     11]
	  ['Eat',      2]
	  ['Commute',  2]
	  ['Watch TV', 2]
	  ['Sleep',    7]
	]
	options = {title: 'My Daily Activities'}
	chart = new google.visualization.PieChart document.getElementById 'chart_div'
	chart.draw data, options
