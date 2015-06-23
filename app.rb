require 'sinatra'
require 'sinatra/reloader' if development?
require 'mechanize'
require 'json'


configure do
  set :root, File.dirname(__FILE__)
  set :public_folder, "public/app"
end

get '/' do
  File.read(File.join('public/app', 'index.html'))
end

get '/apts_tgn' do
  content_type :json
  list(5, "https://www.avito.ru/taganrog/kvartiry/sdam/na_dlitelnyy_srok/1-komnatnye?i=1&district=472", "apt")
  @itms.to_json
  JSON.pretty_generate(@itms)
end

get '/macs' do
  content_type :json
  list(3, "https://www.avito.ru/rossiya/noutbuki?q=macbook+pro+15+retina", "el")
  @itms.to_json
  JSON.pretty_generate(@itms)
end

get '/rx8' do
  content_type :json
  list(3, "https://www.avito.ru/rossiya/avtomobili_s_probegom/mazda/rx-8?q=rx8", "car")
  @itms.to_json
  JSON.pretty_generate(@itms)
end

#HELPERS

#LISTING ALL ITEMS

def list(page_count, url, type)
  agent = Mechanize.new
  pages, items, item = [],[],[]

  (1..page_count).each do |p|
    begin
      pages << agent.get(url+"&p=#{p}")
    rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
      p "404!- " + "#{url+"&p=#{p}"}"
      next
    end
  end

  pages.each do |page|
    page.search('.catalog-list div.item').each do |m|

      item << m.at_css('.title').text.strip #title
      item << m.at_css('.about').text.strip.gsub(/[^0-9a-z]/i, '').to_i #cost
      item << m.at_css('h3.title a').map {|link| 'https://www.avito.ru'+link.last}.first #url
      item << m.at_css('.date').text.strip #date
      item << m.at_css('.data p').text.strip #owner_type
      item << m.at_css('i').text.strip.to_i #photo_count
      item << m.at_css('.address').text.strip if m.at_css('.address') #address
      
      #cars

      item << m.at_css('.area>.params').text if m.at_css('.area>.params') #auto/manual
      item << m.at_css('span.area span:nth-child(2)').text if m.at_css('.area:nth-last-child(1)') #mileage
      
      case type
      when "el"
        items << item.take(6)
        @itms = items.map{|i| {title:i[0], cost:i[1], url:i[2], date:i[3], owner:i[4], photo_count:i[5] }} #el
        item = []
      when "apt"
        items << item.take(7)
        @itms = items.map{|i| {title:i[0], cost:i[1], url:i[2], date:i[3], owner:i[4], address:i[6] }} #apt
        item = []
      when "car"
        items << item.take(9)
       @itms = items.map{|i| {title:i[0], cost:i[1], url:i[2], date:i[3], owner:i[4], photo_count:i[5], mileage:i[8] }} #car
        item = []
      end
    end
  end
end
