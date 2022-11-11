require 'rails_helper'

RSpec.describe "Api::Rows", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/rows/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/rows/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/rows/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/rows/update"
      expect(response).to have_http_status(:success)
    end
  end

end
