class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_cart
  	Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  	cart = Cart.create
  	session[:cart_id] = cart.id 
  	cart
  end

  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end

   def authorize
        unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please sign in"
      end
    end

  def set_i18n_locale_from_params
        if params[:locale]
          if I18n.available_locales.map(&:to_s).include?(params[:locale])
            I18n.locale = params[:locale]
          else
            flash.now[:notice] = "#{params[:locale]} translation not available" 
            logger.error flash.now[:notice]
          end
        end
      end
      
      def default_url_options
        { locale: I18n.locale }
      end
end

