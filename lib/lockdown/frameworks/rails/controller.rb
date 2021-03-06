module Lockdown
  module Frameworks
    module Rails
      module Controller
        # Locking methods
        module Lock

          def configure_lockdown
            store_location
          end

          # Basic auth functionality needs to be reworked as 
          # Lockdown doesn't provide authentication functionality.
          def set_current_user
            if logged_in?
              whodat = send(Lockdown::Configuration.who_did_it)
              Thread.current[:who_did_it] = whodat
            end
          end

          def check_request_authorization
            unless authorized?(path_from_hash(params))
              parameters = respond_to?(:filter_parameters) ? filter_parameters(params) : params.dup
              raise SecurityError, "Authorization failed! \nparams: #{parameters.inspect}\nsession: #{session.inspect}"
            end
          end

          protected 
  
          def store_location
            if request.get? && (session[:thispage] != sent_from_uri)
              session[:prevpage] = session[:thispage] || ''
              session[:thispage] = sent_from_uri
            end
          end

          if ::Rails::VERSION::MAJOR == 2
            # Rails 2 supports relative_url_root

            def lenient_relative_url_root
              return ENV['RAILS_RELATIVE_URL_ROOT'] || ActionController::Base.relative_url_root
            end

            # Rails ActionController::Request pack method overrides Rack::Request so that it forgets
            # the application's relative_url_root, so it must be put back here. Otherwise
            # redirect_back_or_default will fail.
            # Rails *_path and *_url route methods won't have this problem since they explicitly include
            # the relative_url_root.
            def sent_from_uri
              subdir = lenient_relative_url_root
              if subdir
                subdir + request.fullpath
              else
                request.fullpath
              end
            end
          elsif ::Rails::VERSION::MAJOR == 3
            # Rails 3 Deprecates relative_url_root (very noisily)

            def lenient_relative_url_root
              return ENV['RAILS_RELATIVE_URL_ROOT']
            end

            def sent_from_uri
              request.fullpath
            end
          end
      
          def authorized?(url, method = nil)
            # Reset access unless caching?
            add_lockdown_session_values unless Lockdown.caching?

            return false unless url

            method ||= (params[:method] || request.method)

            url_parts = URI::split(url.strip)

            path = url_parts[5]

            subdir = lenient_relative_url_root
            if subdir && subdir == path[0,subdir.length]
              path = path[subdir.length..-1]
            end

            if Lockdown::Delivery.allowed?(path, session[:access_rights])
              return true 
            end

            path_parts = path.split('/')

            if path_parts.last == "index"
              path_parts.pop
              new_path = path_parts.join('/')
              return Lockdown::Delivery.allowed?(new_path, session[:access_rights])
            end

            begin
              if ::Rails.respond_to?(:application)
                router = ::Rails.application.routes
              else
                router = ActionController::Routing::Routes
              end

              hash = router.recognize_path(path, :method => method)

              if hash
                return Lockdown::Delivery.allowed?(path_from_hash(hash),
                                                      session[:access_rights])
              end
            rescue ActionController::RoutingError
              # continue on
            end

            # Mailto link
            if url =~ /^mailto:/
              return true 
            end

            # Public file
            file = File.join(::Rails.root, 'public', url)
            if File.exists?(file)
              return true 
            end

            # Passing in different domain
            return remote_url?(url_parts[2])
          end
    
          def ld_access_denied(e)

            if Lockdown::Configuration.logout_on_access_violation
              reset_session
            end
            respond_to do |format|
              format.html do
                store_location
                redirect_to (lenient_relative_url_root || '') + Lockdown::Configuration.access_denied_path
                return
              end
              format.xml do
                headers["Status"] = "Unauthorized"
                headers["WWW-Authenticate"] = %(Basic realm="Web Password")
                render :text => e.message, :status => "401 Unauthorized"
                return
              end
            end
          end

          def path_from_hash(hash)
            hash[:controller].to_s + "/" + hash[:action].to_s
          end

          def remote_url?(domain = nil)
            return false if domain.nil? || domain.strip.length == 0
            request.host.downcase != domain.downcase
          end

          def redirect_back_or_default(default)
            if session[:prevpage].nil? || session[:prevpage].blank?
              redirect_to(default) 
            else
              redirect_to(session[:prevpage])
            end
          end
        end # Lock
      end # Controller
    end # Rails
  end # Frameworks
end # Lockdown

