require 'faraday'
require 'json'

module AppVersion
  extend self

  APP_VERSION_PAGE              = 'app_version.aspx'

  def connection
    @connection ||= Faraday.new()
  end

  def fetch(node_uri)
    begin
      response = connection.get do |req|
        req.url app_version_url(node_uri)
      end

      result = {status: response.status, data:''}
      if response.status == 200
        result[:data] = JSON.parse(response.body)
      end
    rescue JSON::ParserError
      result = {status: 588, data:''}
    rescue Faraday::Error::ConnectionFailed
      result = {status: 599, data:''}
    rescue Exception
      result = {status: 577, data: ''}
    end

    result
  end

  def fetch_status(node_uri)
    fetch_result = AppVersion.fetch(node_uri)
    status = fetch_result[:status]
    if(status == 200)
      result = {ok: true, version: fetch_result[:data]['fullNumber']}
    elsif(status == 503)
      result = {ok: false, reason: 'service_unavailable'}
    elsif(status == 599)
      result = {ok: false, reason: 'connection_failed'}
    elsif(status == 588)
      result = {ok: false, reason: 'invalid_json'}
    elsif(status == 577)
      result = {ok: false, reason: 'request_timed_out'}
    else
      result = {ok: false, reason: 'bad_status', status: status}
    end

    result
  end

  private

  def app_version_url(node_uri)
    "#{node_uri}/#{APP_VERSION_PAGE}"
    end

end
