require 'test_helper'

class TechniciansController; def rescue_action(e) raise e end; end

class TechniciansControllerTest < ActionController::TestCase
  fixtures :users
  
  context "on GET to :index" do
    setup do
      login_as(:bob)
      Factory.create(:greg)
      Factory.create(:tom)
      get :index
    end

    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :new" do
    setup do
      login_as(:bob)
      get :new
    end

    should_respond_with :success
    should_render_template :new
  end
  
  context "on POST to :create" do
    setup do
      login_as(:bob)
      get :create, :technician => {:name => "Sally", :code => "5555", :color => "purple"}
    end

    should_respond_with :redirect
    # should_redirect_to url_for(@technician)
    should_set_the_flash_to /created/i
  end
  
  
  context "on GET to :edit" do
    setup do
      login_as(:bob)
      Factory.create(:greg, :id => 1)
      get :edit, :id => 1
    end

    should_respond_with :success
    should_render_template :edit
  end
  
  # context "on POST to :update" do
  #   setup do
  #     login_as(:bob)
  #     Factory.create(:greg, :id => 1)
  #     get :update, :id => 1
  #   end
  # 
  #   should_respond_with :success
  #   should_render_template :edit
  # end
  
end
