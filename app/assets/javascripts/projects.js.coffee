# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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
