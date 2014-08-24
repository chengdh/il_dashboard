require "json"
current_valuation = 0
current_karma = 0


SCHEDULER.every '2s' do
  uri = URI('http://localhost:3000/api/v1/dataset/call_kw.json')
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(:auth_token => "yfrnsiRhSTi2V4Z6pknP",
                      :model => "carrying_bill",
                      :method => "dashing_bills_count_data")

  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  data = JSON.parse(res.body)
  send_event('bill_count', data["result"])
  send_event('carrying_fee', data["result"])
  send_event('goods_num', data["result"])
  send_event('goods_fee', data["result"])
  send_event('insured_fee', data["result"])
  send_event('from_short_carrying_fee', data["result"])
  send_event('to_short_carrying_fee', data["result"])
  send_event('carrying_fee_pay_type', data["result"])
end

# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '2s' do
  points.shift
  last_x += 1

  uri = URI('http://localhost:3000/api/v1/dataset/call_kw.json')
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data(:auth_token => "yfrnsiRhSTi2V4Z6pknP",
                      :model => "carrying_bill",
                      :method => "dashing_bills_count_data")

  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  data = JSON.parse(res.body)

  points << { x: last_x, y: 0}

  send_event('graph_carrying_fee', points: points,today: data['result']['today'])
end
