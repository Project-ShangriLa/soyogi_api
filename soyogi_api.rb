require "sinatra"
require "sinatra/json"
require "sequel"
require 'date'

#TODO DB接続情報は設定ファイルに書く
configure do
  set(:database_name) { 'anime_admin_development' }
  set(:database_hostname) { 'localhost' }
  set(:database_username) { 'root' }
  set(:database_password) { '' }
  set(:database_port) { '3306' }
end

def db_connection()
  Sequel.mysql2(settings.database_name,
                :host=>settings.database_hostname,
                :user=>settings.database_username,
                :password=>settings.database_password,
                :port=>settings.database_port)
end

get '/anime/v1/voice-actor/twitter/follower/diff-ranking' do
  range_days = params[:range]
  range_days ||= 1

  db = db_connection()
  result = []

  start_day = Date.today - range_days.to_i
  start_day_next = start_day + 1
  target_day = Date.today
  next_day = target_day + 1

  start_row = db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{start_day}' and get_date < '#{start_day_next}'")
                    .select_hash(:voice_actor_master_id, [:name, :follower])

  end_row = db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{target_day}' and get_date < '#{next_day}'").all

  if end_row.length == 0
    start_day = Date.today - range_days.to_i - 1
    start_day_next = start_day + 1
    target_day = Date.today - 1
    next_day = target_day + 1

    start_row = db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{start_day}' and get_date < '#{start_day_next}'")
                    .select_hash(:voice_actor_master_id, [:name, :follower, :get_date])

    end_row = db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{target_day}' and get_date < '#{next_day}'").reverse(:get_date).all
  end

  diff_map = {}
  hist_row_map = {}

  start_get_date = nil
  end_get_date = nil


  end_row.each do |row|
    vid = row[:voice_actor_master_id]
    hist_row_map[vid] = {}
    next unless start_row.has_key?(vid)

    diff_map[vid] =  row[:follower] - start_row[vid][1]  unless diff_map.has_key?(vid)

    start_get_date ||= start_row[vid][2]
    end_get_date ||= row[:get_date]
  end

  diff_list = diff_map.sort_by {|k, v| v }

  diff_list.reverse.each do |diff|

    vid = diff[0]

    next unless start_row.has_key?(vid)

    puts "#{start_row[vid][0]},#{diff[1]}"

    result << {name: start_row[vid][0], num: diff[1]}
  end


  db.disconnect

  respose = {
      start: start_get_date.strftime("%Y-%m-%d %H:%M"),
      end: end_get_date.strftime("%Y-%m-%d %H:%M"),
      diff_hour: ((end_get_date - start_get_date) / 3600).to_i,
      diff_follower: result
  }

  json respose
end