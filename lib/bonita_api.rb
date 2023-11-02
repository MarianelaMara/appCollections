# lib/bonita_api.rb
module BonitaApi
#    require 'faraday'
#    BASE_URL = 'http://localhost:8080/bonita'.freeze
#    USERNAME = 'walter.bates'.freeze
#    PASSWORD = 'bpm'.freeze
#    @@bonita_api_key = ""
#
#    def self.login
#      @@conn = Faraday.new(url: 'http://localhost:8080/', headers: { 'X-Bonita-API-Token' => @@bonita_api_key })
#      response = @@conn.post('bonita/loginservice', username: USERNAME, password: PASSWORD)
#      @@conn.headers['Cookie'] = response.headers['set-cookie']
#      @@conn.headers['X-Bonita-API-Token'] = response.headers['set-cookie'].split(',')[1].split(';')[0].split('=')[1]
#    end
#    
#    def self.start_process(process_id)
#      response = @@conn.post("bonita/API/bpm/process/#{process_id}/instantiation")
#      JSON.parse(response.body)
#    end 
#
#    def self.get_process_id(name)
#      response = @@conn.get('bonita/API/bpm/process', f: "name=#{name}", p: 0, c: 1, o: 'version desc', f: 'activationState=ENABLED')
#      processes = JSON.parse(response.body)
#      id = processes.first["id"]
#    end
#
#    def self.get_task(process_id)
#      response = @@conn.get("bonita/API/bpm/task", f: "caseId=#{process_id}")
#      JSON.parse(response.body)
#    end 
#     
#    def self.end_collections(task_id)
#      response = @@conn.post("bonita/API/bpm/task/#{process_id}")
#      JSON.parse(response.body)
#    end 
end