class Dashing.CustomList extends Dashing.Widget

  @accessor 'from_org_id', -> parseInt($("#from_org_id").val())

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

  onData: (data) ->
    @_parseData(data)

  #解析从服务器端传入的数据
  _parseData: (data) ->
    today_bills = []
    items = []
    #现金付
    item_pay_type_ca = 0
    #提货付
    item_pay_type_th = 0

    #回执付
    item_pay_type_re = 0

    #款中扣
    item_pay_type_kg= 0

    today_bills.push(d) for d in data.today when d.from_org_id == @get('from_org_id')
    item_pay_type_ca += d.carrying_fee for d in today_bills when d.pay_type == 'CA'
    item_pay_type_th += d.carrying_fee for d in today_bills when d.pay_type == 'TH'
    item_pay_type_re += d.carrying_fee for d in today_bills when d.pay_type == 'RE'
    item_pay_type_kg += d.carrying_fee for d in today_bills when d.pay_type == 'KG'

    items.push(label: '现金付',value : item_pay_type_ca)
    items.push(label: '提货付',value : item_pay_type_th)
    items.push(label: '回执付',value : item_pay_type_re)
    items.push(label: '款中扣',value : item_pay_type_kg)

    @set('items',items)

