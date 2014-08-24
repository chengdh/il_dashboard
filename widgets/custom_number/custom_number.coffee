class Dashing.CustomNumber extends Dashing.Widget
  #判断显示哪一个数据
  ready: ->
    @show_field = $(@node).data("field")
    if not @show_field
      @show_field = "bill_count"

  @accessor 'from_org_id', -> parseInt($("#from_org_id").val())

  @accessor 'current'

  @accessor 'difference', ->
    current = parseInt(@get("current"))
    last = parseInt(@get('last'))
    if last != 0
      diff = Math.abs(Math.round((current - last) / last * 100))
      "#{diff}%"
    else
      ""

  @accessor 'last'

  @accessor 'arrow', ->
    if @get('last')
      if parseInt(@get('current')) > parseInt(@get('last')) then 'icon-arrow-up' else 'icon-arrow-down'

  onData: (data) ->
    @_parseData(data)
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"

  #解析从服务器端传入的数据
  _parseData: (data) ->
    @today_bills_count = 0
    today_bills = []
    today_bills.push(d) for d in data.today when d.from_org_id == @get('from_org_id')
    for d in today_bills
      @today_bills_count += d[@show_field]


    @yesterday_bills_count = 0
    yesterday_bills = []
    yesterday_bills.push(d) for d in data.yesterday when d.from_org_id == @get('from_org_id')
    for d in yesterday_bills
      @yesterday_bills_count += d[@show_field]

    @set('current',@today_bills_count)
    @set('last',@yesterday_bills_count)
