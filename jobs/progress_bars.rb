#coding: utf-8
require "json"
SCHEDULER.every '3600s' do
  uri = URI('http://zz.yanzhaowuliu.com/api/v1/dataset/call_kw.json')
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(:auth_token => "bZLf2G8tDoqQMTDBVnz1",
                      :model => "carrying_bill",
                      :method => "dashing_bills_count_data")

  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  data = JSON.parse(res.body)

  parsed_items = {}
  #计算合计
  group_data = data["result"]["today"].group_by {|e| e["from_org_name"]}
  group_data.each do |org_name,records|
    parsed_items[org_name] = {}
    #carrying_fee
    carrying_fee = 0
    goods_fee = 0
    bill_count = 0
    goods_num = 0
    insured_fee = 0
    from_short_carrying_fee = 0
    to_short_carrying_fee = 0
    records.each  do |x|
      carrying_fee += x['carrying_fee'].to_i
      goods_fee += x['goods_fee'].to_i
      bill_count += x['bill_count'].to_i
      goods_num += x['goods_num'].to_i
      insured_fee += x['insured_fee'].to_i
      from_short_carrying_fee += x['from_short_carrying_fee'].to_i
      to_short_carrying_fee += x['to_short_carrying_fee'].to_i
    end
    parsed_items[org_name]["carrying_fee"] = carrying_fee
    #sum_goods_fee
    parsed_items[org_name]["goods_fee"] = goods_fee
    #bill_count
    parsed_items[org_name]["bill_count"] = bill_count 
    #goods_num
    parsed_items[org_name]["goods_num"] = goods_num 
    #from_short_carrying_fee
    parsed_items[org_name]["from_short_carrying_fee"] = from_short_carrying_fee
    #to_short_carrying_fee
    parsed_items[org_name]["to_short_carrying_fee"] = to_short_carrying_fee
    #insured_fee
    parsed_items[org_name]["insured_fee"] = insured_fee
  end

  #依次得到max数值
  max_carrying_fee_key = parsed_items.max_by {|k,v| v["carrying_fee"] }
  max_carrying_fee =  parsed_items[max_carrying_fee_key.first]["carrying_fee"]

  max_goods_num_key = parsed_items.max_by {|k,v| v["goods_num"] }
  max_goods_num =  parsed_items[max_goods_num_key.first]["goods_num"]

  progress_items_carrying_fee = []
  progress_items_goods_num = []
  parsed_items.each do |org_name,fee_hash|
    carrying_fee = fee_hash["carrying_fee"].to_f
    carrying_fee_val = carrying_fee/max_carrying_fee*100

    goods_num = fee_hash["goods_num"].to_f
    goods_num_val = goods_num/max_goods_num*100


    progress_items_carrying_fee.push(:name => org_name ,:progress => carrying_fee_val,:value => carrying_fee )
    progress_items_goods_num.push(:name => org_name ,:progress => goods_num_val,:value => goods_num )
  end
  send_event( 'progress_bars_carrying_fee', :title => "运费统计",:progress_items => progress_items_carrying_fee)
  send_event( 'progress_bars_goods_num', :title => "货物统计",:progress_items => progress_items_goods_num)
end
