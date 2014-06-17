namespace :pipedrive do
  desc "Look into match up pipedrive with contactually"
 
  require 'httparty'
  require 'json'

  task :import => :environment do
    require 'csv'    

    filename = Rails.root + "lib/tasks/meetingplanners.csv"
    CSV.foreach(filename, :headers => true) do |row|
      name_arr = row[3].split(' ')
      first_name = name_arr.first
      last_name = name_arr.last(name_arr.length-1).join(' ')
      email = row[5]
      company_name = row[1]
      rep = row[2]
      phone = row[4]

      case rep
        when "Austin"
          puts "Austin"
        when "Jeff"
          puts "Jeff"
        when "Joshua"
          puts "Joshua"
        when "Kelsey"
          puts "Kelsey"
        when "Krista"
          puts "Krista"
        when "Patrice"
          puts "Patrice"
        when "Patty"
          puts "Patty"          
        else
          puts "Robyn"
      end

      uploaded_contact = contactually_put_contact(first_name,last_name,email,company_name)        


    end             

  end

   
  def pipedrive
  	url = "http://api.pipedrive.com/v1/deals?start=0&sort_mode=asc&api_token=#{ENV['pipedrive_api_key']}"
    response = HTTParty.get(url)
    json = JSON.parse(response.body)
    if json['success'] = true
    	return json['data']
    end	
  end
  

end
