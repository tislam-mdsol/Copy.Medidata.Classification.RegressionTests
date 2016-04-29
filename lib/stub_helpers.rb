#encoding: utf-8

def coder_apps
  ["CoderWS", "CoderWeb", "CoderAutomationSvc", "CoderDictionarySvc", "CoderWorkflowSvc"]
end

def app_port(name)
  # No well known ports at bottom of 32000 range -- http://www.networksorcery.com/enp/protocol/ip/ports32000.htm
  base_port = 32100 + 10 * (ENV['EXECUTOR_NUMBER'] || "0").to_i
  index = coder_apps.index(name)
  raise "invalid service: #{name}" if index.nil?
  base_port + index + 1
end

def stub_request(req)
  request = Net::HTTP::Post.new("/", initheader = {'Content-Type' => 'application/json'})
  request.body = req
  response = Net::HTTP.new("localhost", 8889).start {|http| http.request(request) }
  response.code.to_i.should == 201
end

def stub_login_redirect
  stub_request '[
  {
    "request": {
      "url": "login", 
      "method": "GET"
    }, 
    "response": {
      "status": 301, 
      "headers": {
        "Location": "http://localhost:'+ app_port("CoderWeb").to_s + '/LoginPage.aspx/?ticket=ST-1391535816rA1BA9CA34AAD587E39"
      },
    }
  }]'
end

def stub_proxy_validate(name, id, uuid, email)
  stub_request '[
  {
    "request": {
      "url": "proxyValidate", 
      "method": "GET"
    }, 
    "response": {
      "status": 200, 
      "headers": {
        "Content-Type": "application/xml"
      },
      "body": "<cas:serviceResponse xmlns:cas=\"http://www.yale.edu/tp/cas\">
          <cas:authenticationSuccess>
            <cas:user>'+name+'</cas:user>
            <user_id>'+id+'</user_id>
            <user_uuid>'+uuid+'</user_uuid>
            <user_email>'+email+'</user_email>
          </cas:authenticationSuccess>
        </cas:serviceResponse>"
    }
  }]'
end
  
def stub_request_token    
  stub_request '[
    {
    "request": {
      "url": "/api/v2/request_tokens/new",
      "method": "GET"
    },
    "response": {
      "status": 200,
      "headers": {
        "request_token": "T8PT3hymCJ8qhwtss9BrJ%2BlZ7FLOLagn0aRgx%2FJuyBBel084gdJcHRbfHzCk%0Au34ZmMreTyCmEq494IjOpfaaSZyu60YhAEmywjSSmwIXfFO%2BHiwH78gtAtpv%0AyEUI%2FNhbizRPsq04qAe2vQN9niG2GVW0ibv%2FvI%2F%2BLtgB7z4nl7c%3D%0A",
        "Content-Type": "text/plain"
      },
      "body": "UsobFMdKDExJIU8nZGGAb5pHPoz41QwblwiAAYm0DWAlzOJqPCJVA4QmSWZ/nEJAwFnqoonMZwB6Kp7MLe/jOJBlKr8nV8TpjCD/DNNVBKUiMNMIW9iIuP2pUGR6E6aPTbZCx936OItyZ3BrppFWfDRPhZ4h07U4bn9v32E+xIE="
    }
  }]'
end  

def standard_200_response_headers
  '"headers": {
    "request_token": "fckr1CJx%2FZfimGPqfqw8QwpBKwYyL4FghjSTMKw6f6akgwGLmPytiUL%2FP53U%0AE3XIgc%2FXx5ErMmjcrjPs%2FYriF7nftPusMgm99o%2FuUKpAKO8pZuq8IOqChQl3%0AeGs7nZxWBka2ycwTbYB2goF1boP%2BhHIJ57C849sf%2F5T3vWvcXaY%3D%0A",
    "Content-Type": "application/xml"
  }'
end

def stub_login(user)
  email = user.Login
  id = user.UserID
  uuid = user.IMedidataId
  name = "#{user.FirstName} #{user.LastName}"

  stub_login_redirect
  stub_request_token
  stub_proxy_validate(name, id, uuid, email)
end  

def stub_user(user)
  email = user.Login
  uuid = user.IMedidataId
  name = "#{user.FirstName} #{user.LastName}"

  stub_request '[
  {
    "request": {
      "url": "/api/v2/users/'+uuid+'.xml",
      "method": "GET"
    },
    "response": {
      "status": 200,
      ' + standard_200_response_headers + ',
      "body": "<user login=\"'+email+'\" email=\"'+email+'\" uuid=\"'+uuid+'\" activation_code=\"\" name=\"'+name+'\" first_name=\"'+user.FirstName+'\" last_name=\"'+user.LastName+'\" time_zone=\"Eastern Time (US &amp; Canada)\" locale=\"eng\" institution=\"\" title=\"\" department=\"\" address_line_1=\"\" address_line_2=\"\" address_line_3=\"\" city=\"\" state=\"\" postal_code=\"\" country=\"\" telephone=\"1234\" fax=\"\" pager=\"\" mobile=\"\" creator_uuid=\"\"/>"
    }
  }]'
end  

def stub_study(study)
  attrs = [:uuid, :name, :oid, :protocol, :is_production].inject("") { |list,attr|
    list = list + ' ' + attr.to_s + '=\"' + study.send(attr) + '\"'
  }

  stub_request '[
  {
    "request": {
      "url": "/api/v2/studies/' + study.uuid + '.xml",
      "method": "GET"
    },
    "response": {
      "status": 200, 
      ' + standard_200_response_headers + ',
      "body": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>' + 
        '<study ' + attrs + '/>"
    }
  }]'
end

def stub_user_studies(user, studies)
  #raise "No studies associated with user #{user.IMedidataID}" if studies.nil? || studies.count == 0
  uuid = user.IMedidataId
  studies_list_xml = ""
  
  studies.each do |s|
    stub_study(s)
    xml = s.to_xml([:uuid, :href, :parent_uuid])
    studies_list_xml = "#{studies_list_xml}#{xml}"
  end if studies.count > 0
  
  stub_request '[
  {
    "request": {
      "url": "/api/v2/users/'+uuid+'/studies.xml",
      "method": "GET"
    },
    "response": {
      "status": 200, 
      ' + standard_200_response_headers + ',
      "body": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
        <studies>' + 
           studies_list_xml +
        '</studies>"
    }
  }]'
  
end

def stub_uuid_groups(uuid,group_list_xml,owned)
  stub_request '[
  {
    "request": {
      "url": "/api/v2/users/' + uuid + '/' + (owned ? "owned_" : "") + 'study_groups.xml",
      "method": "GET"
    },
    "response": {
      "status": 200, 
      ' + standard_200_response_headers + ',
      "body": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
        <study-groups>' +
          group_list_xml +
        '</study-groups>"
    }
  }]'
end

def stub_user_study_groups(user, groups, filter_owned = false)
  group_list_xml = ""
  groups.select!{|g| g.owner == user.IMedidataId} if filter_owned

  unless groups.nil? or groups.count == 0
    group_list_xml = groups.inject(""){|list,group| list += group.to_xml }
  end
  
  stub_uuid_groups(user.IMedidataId, group_list_xml, filter_owned)
end

def stub_user_owned_study_groups(user, groups)
  stub_user_study_groups(user, groups, true)
end

def stub_apps_for_study(study_uuid)
  stub_request '[
  {
    "request": {
      "url": "/api/v2/studies/'+study_uuid+'/apps.xml",
      "method": "GET"
    },
    "response": {
      "status": 200, 
      ' + standard_200_response_headers + ',
      "body": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
        <applications>
          <application>
            <name>Coder</name>
            <api_id>9cddecf7-4e04-405e-8b1d-f326c151c120</api_id>
            <public_key>
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBANrvxzDxt92vWs73y6a524FxrNOS0+X+E3t2U/BYbfKeg7Tj0IYK4SZ2
+CeTRdt91DOL7sHTk98mHI/r6v2TmlJg9mTOdknjzx6Hj9/WVa56+meaZaNE9+yp
79PjPX9Gy8UglvDBgPy5R6Zu5lzZPMQFxh5LSDZvDtCd+sXMGAsNAgMBAAE=
-----RSA PUBLIC KEY-----
            </public_key>
            <UUID>9cddecf7-4e04-405e-8b1d-f326c151c120</UUID>
            <base_url>http://coder.com</base_url>
            <app_type href=\"http://localhost:8882/api/v2/app_types/'+ study_uuid +'\" name=\"Coder\"/>
          </application>
        </applications>"
    }
  }]'
 
end
