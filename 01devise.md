## devise

参考文档：https://github.com/plataformatec/devise/blob/master/README.md

```react
gem 'devise'
$ rails generate devise:install
$ rails generate devise User

-devise  
config/routes.rb
	root to: "home#index"
	
app/controllers/home_controller.rb
	class HomeController < ApplicationController
  		before_action :authenticate_user!

 		def index
  		end
	end
	
config/environments/development.rb
	config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
	
自定义视图
config/initializers/devise.rb
	config.scoped_views = true 
rails generate devise:views users  或  rails generate devise:views users -v registrations confirmations（只产生相应action）

自定义controller
rails generate devise:controllers users

自定义路由
devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

devise_scope :user do
  get 'login_validate', to: 'users/sessions#login_validate'
end


I18N
参考文档：https://github.com/plataformatec/devise/wiki/I18n
application.rb修改config.i18n
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.i18n.locale = "zh-CN"
    config.i18n.default_locale = "zh-CN"
    I18n.enforce_available_locales = false

config/locals/devise.zh-CN.yml
en:
  devise:
    sessions:
      signed_in: 'Signed in successfully.'

用户名和邮箱都可以登陆设置：http://www.jianshu.com/p/8dfff067197d    
更改登陆字段
增加了新字段之后，在config/initializers/devise.rb中配置登录验证的字段
config.authentication_keys = [:phone]
config.case_insensitive_keys = [:phone]
config.strip_whitespace_keys = [:phone]

application.rb配置允许的参数
before_action :configure_permitted_parameters, if: :devise_controller?
protected
def configure_permitted_parametersod_name
    devise_parameter_sanitizer.permit(:sign_in) {|u| u.permit(:email, :username)}
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:email, :username, :password, :password_confirmation)}
end
```

