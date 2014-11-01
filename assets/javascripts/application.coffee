# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

func_update_children_org_ids = (ids)->
  console.log("Yeah! update children org ids!")
  $('#children_org_ids').html("this is atest")

func_update_from_org_id =  (id) ->
  console.log("Yeah! update from org id!")
  $('#from_org_id').html("this is atest 2")

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [300, 360]
  Dashing.numColumns ||= 4

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  if $(window).width() > 768
    Batman.setImmediate ->
      $('.gridster').width(contentWidth)
      $('.gridster ul:first').gridster
        widget_margins: Dashing.widget_margins
        widget_base_dimensions: Dashing.widget_base_dimensions
        avoid_overlapped_widgets: !Dashing.customGridsterLayout
        draggable:
          stop: Dashing.showGridsterInstructions
          start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()

