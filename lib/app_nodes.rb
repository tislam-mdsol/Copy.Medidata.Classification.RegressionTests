module AppNodes
  extend self

  #TODO: Read nodes from Medistrano

  Development =
    {
      web: ['http://localhost:2494'],
      web_service: ['http://localhost:4014'],
      automation: ['http://localhost:60509'],
      workflow: ['http://localhost:53794'],
      api: ['http://localhost:60300'],
      client_database:{:server => ENV['DATABASE_SERVER'], :database => ENV['DATABASE_NAME'], :user => ENV['DATABASE_USERNAME'], :password => ENV['DATABASE_PASSWORD']}
    }
  Sandbox =
      {
          web: ['https://coder-sandbox.imedidata.net/codercloud'],
          web_service:['https://coder-sandbox-ws.imedidata.net/codercloudws'],
          automation: ['https://coder-sandbox-autows.imedidata.net/coderautows'],
          workflow: ['https://coder-sandbox-workflowws.imedidata.net/coderworkflowws'],
          api: ['https://coder-sandbox-api.imedidata.net/codercloud'],
          client_database:{:server => ENV['DATABASE_SERVER'], :database => ENV['DATABASE_NAME'], :user => ENV['DATABASE_USERNAME'], :password => ENV['DATABASE_PASSWORD']}
      }
  Performance =
      {
          web: ['http://ec2-54-242-138-254.compute-1.amazonaws.com/codercloud'],
          web_service:['http://ec2-54-196-191-116.compute-1.amazonaws.com/codercloudws'],
          automation: ['http://ec2-54-196-242-204.compute-1.amazonaws.com/coderautows'],
          workflow: ['http://ec2-54-234-176-171.compute-1.amazonaws.com/coderworkflowws'],
          api: ['http://ec2-54-242-138-254.compute-1.amazonaws.com/codercloud'],
          client_database:{:server => ENV['DATABASE_SERVER'], :database => ENV['DATABASE_NAME'], :user => ENV['DATABASE_USERNAME'], :password => ENV['DATABASE_PASSWORD']}
      }
  Beta =
      {
          web: ['http://coder-validation2.imedidata.net/codercloud'],
          web_service:['http://coder-validation2-ws.imedidata.net/codercloudws'],
          automation: ['http://coder-validation2-autows.imedidata.net/coderautows'],
          workflow: ['http://coder-validation2-workflowws.imedidata.net/coderworkflowws'],
          api: ['http://coder-validation2-api.imedidata.net/codercloud'],
          client_database:{:server => ENV['DATABASE_SERVER'], :database => ENV['DATABASE_NAME'], :user => ENV['DATABASE_USERNAME'], :password => ENV['DATABASE_PASSWORD']}
      }
  Validation =
      {
          web: ['http://coder-validation.imedidata.net/codercloud'],
          web_service:['http://coder-validation-ws.imedidata.net/codercloudws'],
          automation: ['http://coder-validation-autows.imedidata.net/coderautows'],
          workflow: ['http://coder-validation-workflowws.imedidata.net/coderworkflowws'],
          api: ['http://coder-validation-api.imedidata.net/codercloud'],
          client_database:{:server => ENV['DATABASE_SERVER'], :database => ENV['DATABASE_NAME'], :user => ENV['DATABASE_USERNAME'], :password => ENV['DATABASE_PASSWORD']}
      }

  ENV['rake_env'] ||= 'development'
  if ENV['rake_env'] == 'development'
    Nodes = Development
  elsif ENV['rake_env'] == 'sandbox'
    Nodes = Sandbox
  elsif ENV['rake_env'] == 'beta'
    Nodes = Beta
  elsif ENV['rake_env'] == 'validation'
    Nodes = Validation
  else ENV['rake_env'] == 'performance'
    Nodes = Performance
  end


  def web
    Nodes[:web]
  end

  def web_service
    Nodes[:web_service]
  end

  def automation
    Nodes[:automation]
  end

  def workflow
    Nodes[:workflow]
  end

  def api
    Nodes[:api]
  end

  def client_database
    Nodes[:client_database]
  end

  def all
    map(:web) + map(:web_service) + map(:automation) + map(:workflow) + map(:api)
  end

  def map(node_type)
    nodes = Nodes[node_type]
    nodes.map { |node| {:type => node_type, :url => node}}
  end
end
