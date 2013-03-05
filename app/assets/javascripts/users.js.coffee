# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

google.load "visualization", "1", packages: ["corechart"]
google.setOnLoadCallback drawChart

drawChart = ->
	data = google.visualization.arrayToDataTable [
		['Year', 'Sales', 'Expenses']
    ['2004',  1000,      400]
    ['2005',  1170,      460]
    ['2006',  660,       1120]
    ['2007',  1030,      540]
	]
	options =
		title: 'Company Performance'
		vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
	chart = new google.visualization.BarChart document.getElementById 'chart_div'
	chart.draw data, options

###
$ ->
	$('#chart_div').click ->
		alert "Good ..."
###

###
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
  google.load("visualization", "1", {packages:["corechart"]});
  google.setOnLoadCallback(drawChart);
  function drawChart() {
    var data = google.visualization.arrayToDataTable([
      ['Year', 'Sales', 'Expenses'],
      ['2004',  1000,      400],
      ['2005',  1170,      460],
      ['2006',  660,       1120],
      ['2007',  1030,      540]
    ]);

    var options = {
      title: 'Company Performance',
      vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
    };

    var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
    chart.draw(data, options);
  }
</script>
###