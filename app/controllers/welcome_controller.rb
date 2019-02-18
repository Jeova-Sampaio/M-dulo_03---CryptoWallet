class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails - Jeová C Sampaio [COOKIE]"
    session[:curso] = "Curso de Ruby on Rails - Jeová C Sampaio [SESSION]"
    @meu_nome = params[:nome]
    @curso = params[:curso]
  end
end
