# lib/bonita_api.rb
module BonitaApi
    require 'faraday'
    BASE_URL = 'http://localhost:8080/bonita'.freeze
    USERNAME = 'walter.bates'.freeze
    PASSWORD = 'bpm'.freeze
    @@bonita_api_key = ""

    def self.login
        @conn = Faraday.new(url: BASE_URL, headers: { 'X-Bonita-API-Token' => @@bonita_api_key })
        response = @conn.post('/loginservice', username: USERNAME, password: PASSWORD)
        @@bonita_cookies = response.headers['Set-Cookie']
        @conn.headers['Cookie'] = @@bonita_cookies
      end
    
      def self.get_process_instances(session_id, session)
        # Get the API key from the Rails session
        api_key = session[:bonita_api_key]
        response = @conn.get('/API/bpm/processInstance')
        JSON.parse(response.body)
      end
      
      def self.start_process(process_id)
        # Get the API key from the Rails session
        #api_key = session[:bonita_api_key]
        debugger
        response = @conn.post("/API/bpm/process/#{process_id}/instantiation")
        JSON.parse(response.body)
      end
      
  
  
    def self.get_process_id(name)
        response = @conn.get('/API/bpm/process', f: "name=#{name}", p: 0, c: 1, o: 'version desc', f: 'activationState=ENABLED')
        processes = JSON.parse(response.body)
        processes.first["id"]
    end
      
end