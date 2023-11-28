# lib/bonita_api.rb
module BonitaApi
    require 'faraday'
    BASE_URL = 'http://localhost:8080/bonita'.freeze
    USERNAME = 'walter.bates'.freeze
    PASSWORD = 'bpm'.freeze
    @@bonita_api_key = ""

    def self.login
      response = nil
      @@conn = Faraday.new(url: 'http://localhost:8080/', headers: { 'X-Bonita-API-Token' => @@bonita_api_key })
      while response.nil? 
        response = @@conn.post('bonita/loginservice', username: USERNAME, password: PASSWORD)
      end
      @@conn.headers['Cookie'] = response.headers['set-cookie']
      @@conn.headers['X-Bonita-API-Token'] = response.headers['set-cookie'].split(',')[1].split(';')[0].split('=')[1]
    end
    
    def self.start_process(process_id)
      responsePost = nil
      while responsePost.nil?|| responsePost.status != 200 
        responsePost = @@conn.post do |req|
          req.url "/bonita/API/bpm/case"
          req.headers['Content-Type'] = 'application/json'
          req.body = { processDefinitionId: "#{process_id}", variables: [] }.to_json
        end
      end
      body_hash = JSON.parse(responsePost.body)
      if !body_hash.nil?
        body_hash['id']
      end
    end 

    def self.get_process_id(name)
      response = nil
      while response.nil? || response.status != 200
        response = @@conn.get('bonita/API/bpm/process', f: "name=#{name}", p: 0, c: 1)
      end
      body_hash = JSON.parse(response.body)
      if !body_hash.nil?
        body_hash.first['id']
      end
    end

    def self.current_task(case_id)
      #con este nos devuelve la tarea de otro casooooooo
      #response = @@conn.get('bonita/API/bpm/task?', f:"=caseId=#{case_id}")
      # /API/bpm/userTask?c=10&p=0&f=caseId=1&f=state=ready
      response = @@conn.get('bonita/API/bpm/userTask?', f:"=caseId=#{case_id}&f=state=ready", p: 0, c: 10)
      
      task = JSON.parse(response.body)
      id = task.first["id"]
    end

    def self.assigned_task(task_id)
      response = @@conn.get('bonita/API/identity/user?', f:"userName=walter.bates")
      user  = JSON.parse(response.body)
      if !user.nil?
        id = user[0]['id']
      end
      responsePut = @@conn.put do |req|
        req.url "/bonita/API/bpm/userTask/#{task_id}", { c: '20', p: '0' }
        req.headers['Content-Type'] = 'application/json'
        req.body = { "assigned_id": "#{id}"}.to_json
      end
      return responsePut
    end

    def self.complete_task(task_id)
      responsePut = @@conn.put do |req|
        req.url "bonita/API/bpm/task/#{task_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { state: "completed"}.to_json
      end
      return responsePut
    end
    
    def self.set_variable(name, value, type, case_id)
      responsePut = @@conn.put do |req|
        req.url "bonita/API/bpm/caseVariable/#{case_id}/#{name}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { type: type, value: value }.to_json
      end
    end

    def self.get_variable(name, case_id)
      response = @@conn.get("bonita/API/bpm/caseVariable/#{case_id}/#{name}")
      opciones = JSON.parse(response.body)
    end

      #borra el caso
    def self.delete_case(case_id)
        response = @@conn.delete("bonita/API/bpm/case/#{case_id}")
    end
      
end