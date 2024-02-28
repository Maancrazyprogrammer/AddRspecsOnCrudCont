# spec/controllers/bookmarks_controller_spec.rb

require 'rails_helper'


  describe "GET /show" do
    it "returns a successful response with the bookmark details in JSON format" do
      bookmark = create(:bookmark, title: "Bookmark 1", url: "https://example.com/1")

      get "/bookmarks/#{bookmark.id}", params: { id: bookmark.id }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eq("Bookmark 1")
      expect(parsed_response["url"]).to eq("https://example.com/1")

    end

    it "assigns the requested bookmark to @bookmark" do
      bookmark = create(:bookmark)

      get "/bookmarks/#{bookmark.id}", params: { id: bookmark.id }

      expect(assigns(:bookmark)).to eq(bookmark)
    end
  end
