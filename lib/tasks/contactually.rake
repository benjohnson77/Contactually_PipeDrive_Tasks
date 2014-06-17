namespace :contactually do
  desc "Look into match up pipedrive with contactually"
 
  require 'httparty'
  require 'json'

  BASE_URL = "https://www.contactually.com/api/v1"
  API_KEY = "ENV['contactually_api_key']"
  DEFAULT_REP = 39315
  REP_MAPPING = {"Austin" =>  39319, "Jeff" => 47301, "Joshua" => 39317, "Kelsey" => 39318, "Krista" => 41241, "Patrice" => 39783, "Patty" => 39783}

  task :import => :environment do
    require 'csv'    

    filename = Rails.root + "lib/tasks/importformat.csv"
    CSV.foreach(filename, :headers => true) do |row|
      contact_hash = {}
      contact_hash[:first_name] = row[3]
      contact_hash[:last_name] = row[4]
      contact_hash[:email] = row[6]
      contact_hash[:company] = row[1]
      contact_hash[:phone_numbers] = ["#{row[5]}"]
      rep = row[2]
      contact_hash[:assigned_to_id] = REP_MAPPING[rep] || DEFAULT_REP
      contact_hash[:user_id] = REP_MAPPING[rep] || DEFAULT_REP
      contact_hash[:user_bucket_id] = 393495

      puts contact_hash

      uploaded_contact = contactually_put_contact(contact_hash)        
      puts uploaded_contact["contact"]["id"].inspect
      update = contactually_update_contact(uploaded_contact["contact"]["id"],contact_hash)
    end             
  end

  task :find_groups => :environment do 
    search_contacts["contacts"].each do |contact|
      
      if contact["id"] == 64050659
        contact_hash = {}
        contact_hash[:email] = contact["email"]
        contact_hash[:user_id] = ""
        update = contactually_update_contact(contact["id"],contact_hash)
        puts update
      end
    end  
  end  

  def search_contacts
    url = "#{BASE_URL}/contacts.json?api_key=#{API_KEY}&bucket_id=390021"
    response = HTTParty.get(url)
    json = JSON.parse(response.body)
  end   

  def contactually_create_contact(contact_hash)
    contact = {:contact => contact_hash}
    url = "#{BASE_URL}/contacts.json?api_key=#{API_KEY}"
    post = HTTParty.post(url, body: contact)
  end

  def contactually_update_contact(contact_id,contact_hash)
    contact = {:id => contact_id,:contact => contact_hash}
    puts contact
    url = "#{BASE_URL}/contacts/#{contact_id}.json?api_key=#{API_KEY}"
    post = HTTParty.put(url, body: contact) 
  end    

end
