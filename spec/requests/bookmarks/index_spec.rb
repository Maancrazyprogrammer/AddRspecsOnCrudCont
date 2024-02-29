# spec/requests/bookmarks/index_spec.rb

require 'rails_helper'


  describe "GET /index" do
    let(:user) { create(:user) }

    before do
      # Sign in the user before making requests
      sign_in user
    end

    it "returns a successful response with a list of bookmarks in JSON format" do
      bookmark1 = create(:bookmark, title: "Bookmark 1", url: "https://example.com/1")
      bookmark2 = create(:bookmark, title: "Bookmark 2", url: "https://example.com/2")

      get '/index'
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response.length).to eq(2)
      expect(parsed_response[0]["title"]).to eq("Bookmark 1")
      expect(parsed_response[0]["url"]).to eq("https://example.com/1")
      expect(parsed_response[1]["title"]).to eq("Bookmark 2")
      expect(parsed_response[1]["url"]).to eq("https://example.com/2")
    end

    it "assigns @bookmarks with a list of bookmarks" do
      bookmark1 = create(:bookmark)
      bookmark2 = create(:bookmark)

      get '/index'

      expect(assigns(:bookmarks).to_a).to match_array([bookmark1, bookmark2])
    end


  end
