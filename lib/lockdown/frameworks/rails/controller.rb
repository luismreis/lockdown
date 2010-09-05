module Lockdown
  module Frameworks
    module Rails
      module Controller
        
        def available_actions(klass)
          klass.action_methods
        end

        def controller_name(klass)
          klass.controller_name
        end

        # Locking methods
        module Lock

          def configure_lockdown
            check_session_expiry
            store_location
          end

          # Basic auth functionality needs to be reworked as 
          # Lockdown doesn't provide authentication functionality.
          def set_current_user
            if logged_in?
              Thread.current[:who_did_it] = Lockdown::System.
                call(self, :who_did_it)
            end
          end

          def check_request_authorization
            unless authorized?(path_from_hash(params))
              parameters = respond_to?(:filter_parameters) ? filter_parameters(params) : params.dup
              raise SecurityError, "Authorization failed! \nparams: #{parameters.inspect}\nsession: #{session.inspect}"
            end
          end

          protected 
  
          def check_session_expiry
            if session[:expiry_time] && session[:expiry_time] < Time.now
              reset_lockdown_session
              Lockdown::System.call(self, :session_timeout_method)
            end
            session[:expiry_time] = Time.now + Lockdown::System.fetch(:session_timeout)
          end
          
          def store_location
            if (request.method == :get) && (session[:thispage] != sent_from_uri)
              session[:prevpage] = session[:thispage] || ''
              session[:thispage] = sent_from_uri
            end
          end

          def sent_from_uri
            request.request_uri
          end
      
          def authorized?(url, method = nil)
            # Reset access unless caching?
            add_lockdown_session_values unless Lockdown.caching?

            return false unless url

            method ||= (params[:method] || request.method)

            url_parts = URI::split(url.strip)

            path = url_parts[5]

            subdir = Lockdown::System.fetch(:subdirectory)
            if subdir && subdir == path[1,subdir.length]
              path = path[(subdir.length+1)..-1]
            end

            if Lockdown::Delivery.allowed?(path, session[:access_rights])
              return true 
            end

            begin
              hash = ActionController::Routing::Routes.
                      recognize_path(path, :method => method)
              if hash
                return Lockdown::Delivery.allowed?(path_from_hash(hash),
                                                      session[:access_rights])
              end
            rescue Exception => e
              # continue on
            end

            # Mailto link
            return true if url =~ /^mailto:/

            # Public file
            file = File.join(Rails.root, 'public', url)
            return true if File.exists?(file)

            # Passing in different domain
            return remote_url?(url_parts[2])
          end
    
          def ld_access_denied(e)

            Lockdown.logger.info "Access denied: #{e}"

            if Lockdown::System.fetch(:logout_on_access_violation)
              reset_session
            end
            respond_to do |format|
              format.html do
                store_location
                redirect_to Lockdown::System.fetch(:access_denied_path)
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

