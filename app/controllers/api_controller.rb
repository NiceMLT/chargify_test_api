class ApiController < ApplicationController
  def authed_session
    HTTParty.get('https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139/')
  end
end
