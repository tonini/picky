# Simple Rack Middleware to kill Unicorns after X requests.
#
# Use as follows in e.g. your rackup File:
#
# Rack::Harakiri.after = 50
# use Rack::Harakiri
#
module Rack
  class Harakiri
    
    # Set the amount of requests before the Unicorn commits Harakiri.
    #
    cattr_accessor :after
    
    def initialize app
      @app = app
      
      @requests            = 0
      @quit_after_requests = @@after || 50
    end
    
    def call env
      harakiri
      @app.call env
    end
    
    # Checks to see if it is time to honorably retire.
    #
    # If yes, kills itself (Unicorn will answer the request, honorably).
    #
    def harakiri
      @requests = @requests + 1
      Process.kill(:QUIT, Process.pid) if @requests > @quit_after_requests
    end
    
  end
end