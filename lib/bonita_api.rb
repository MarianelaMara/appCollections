# lib/bonita_api.rb
module BonitaApi
    require 'faraday'
    BASE_URL = 'http://localhost:8080/bonita'.freeze
    USERNAME = 'walter.bates'.freeze
    PASSWORD = 'bpm'.freeze
    @@bonita_api_key = ""

    def self.login
      @@conn = Faraday.new(url: 'http://localhost:8080/', headers: { 'X-Bonita-API-Token' => @@bonita_api_key })
      response = @@conn.post('bonita/loginservice', username: USERNAME, password: PASSWORD)
      @@conn.headers['Cookie'] = response.headers['set-cookie']
      @@conn.headers['X-Bonita-API-Token'] = response.headers['set-cookie'].split(',')[1].split(';')[0].split('=')[1]
    end
    
    def self.start_process(process_id)
      # response = @@conn.post("bonita/API/bpm/process/#{process_id}/instantiation")
      # JSON.parse(response.body)

      responsePost = @@conn.post do |req|
        req.url "/bonita/API/bpm/case"
        req.headers['Content-Type'] = 'application/json'
        req.body = { processDefinitionId: "#{process_id}", variables: [] }.to_json
      end
      JSON.parse(responsePost.body)["id"]
    end 

    def self.get_process_id(name)
      response = @@conn.get('bonita/API/bpm/process', f: "name=#{name}", p: 0, c: 1)
      processes = JSON.parse(response.body)
      id = processes.first["id"]
    end

    def self.current_task(case_id)
      response = @@conn.get('bonita/API/bpm/task?', f:"=caseId=#{case_id}")
      task = JSON.parse(response.body)
      id = task.first["id"]
    end

    def self.assigned_task(task_id)
      #pide el id del usuario walter bates
      response = @@conn.get('bonita/API/identity/user?', f:"userName=walter.bates")
      user = JSON.parse(response.body)
      id = user[0]["id"]
      #asigna la tarea al usuario para iniciarla
      responsePut = @@conn.put do |req|
        req.url "/bonita/API/bpm/userTask/#{task_id}", { c: '20', p: '0' }
        req.headers['Content-Type'] = 'application/json'
        req.body = { assigned_id: id }.to_json
      end
    end

    def self.complete_task(task_id)
      responsePut = @@conn.put do |req|
        req.url "bonita/API/bpm/task/#{task_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { state: "completed"}.to_json
      end
    end
    
    def self.set_variable(name, value, type, case_id)
      responsePut = @@conn.put do |req|
        req.url "bonita/API/bpm/caseVariable/#{case_id}/#{name}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { type: type, value: value }.to_json
      end
    end
      
end