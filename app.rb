require 'sinatra'
require 'sinatra/reloader' if development?
require 'mechanize'

get '/' do  
  erb :index, :layout => :'layouts/application'
end

get '/rmbp15' do
  list(3, "https://www.avito.ru/rossiya/noutbuki?q=macbook+pro+15+retina", "el")  
  erb :rmbp15, :layout => :'layouts/application'
end

get '/apt_tgn' do
  list(3, "https://www.avito.ru/taganrog/kvartiry/sdam/na_dlitelnyy_srok/1-komnatnye?i=1&pmax=10000&pmin=6000&district=472", "apt")  
  erb :apt_tgn, :layout => :'layouts/application'
end

get '/about' do
  erb :about, :layout => :'layouts/application'
end



#HELPERS

#LISTING ALL ITEMS
def list(page_count, url, type)
  agent = Mechanize.new
  pages = []
  @items =[]

  (1..page_count).each do |p|
    begin
      pages << agent.get(url+"&p=#{p}")
    rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
      p "404!- " + "#{url+"&p=#{p}"}"
      next
    end
  end
  
  case type
    when "el"  
      pages.each do |page|
        page.search('div.item').each do |m|
          @items << [m.at_css('.title').text.strip, #title
                    m.at_css('.about').text.strip.gsub(/[^0-9a-z]/i, '').to_i, #cost
                    m.at_css('h3.title a').map {|link| 'https://www.avito.ru'+link.last}.first, #url
                    m.at_css('.date').text.strip, #date
                    m.at_css('.data p').text.strip, #is_agency/company
                    m.at_css('i').text.strip.to_i] #photo count
        end
      end
      @itms = @items.map{|i| {title:i[0], cost:i[1], url:i[2], date:i[3], owner:i[4], photo_count:i[5] }}
         
    when "apt" 
      pages.each do |page|
        page.search('div.item').each do |m|
          @items << [m.at_css('.title').text.strip,
                    m.at_css('.about').text.strip.gsub(/[^0-9a-z]/i, ''),
                    m.at_css('h3.title a').map {|link| 'https://www.avito.ru'+link.last}.first, #url
                    m.at_css('.date').text.strip,
                    m.at_css('.data p').text.strip,
                    m.at_css('.address').text.strip]
        end
      end
     @itms = @items.map{|i| {title:i[0], cost:i[1], url:i[2], date:i[3], owner:i[4], address:i[5] }}
  
  end   
end







