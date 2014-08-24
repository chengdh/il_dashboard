class Dashing.CustomGraph extends Dashing.Widget

  @accessor 'current'

  @accessor 'from_org_id', -> parseInt($("#from_org_id").val())

  ready: ->
    @show_field = $(@node).data("field")
    if not @show_field
      @show_field = "bill_count"

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: @get("graphtype")
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('points') if @get('points')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @_parseData(data)
      @graph.series[0].data = @get("points")
      @graph.render()

  #解析从服务器端传入的数据
  _parseData: (data) ->
    current_value = 0
    today_bills = []
    today_bills.push(d) for d in data.today when d.from_org_id == @get('from_org_id')
    current_value += d[@show_field] for d in today_bills
    points = @get('points')
    points[points.length - 1].y = parseInt(current_value)
    @set('points',points)
    @set('current',current_value)
