require 'rails_helper'
require 'cancan/matchers' # Include CanCanCan matchers

describe 'POST /bookmarks', type: :request do
  let(:user) { create(:user) }

  before do
    # Sign in the user before making requests
    sign_in user
  end

  scenario 'valid bookmark attributes' do
    post '/bookmarks', params: {
      bookmark: {
        url: 'https://rubyyagi.com',
        title: 'RubyYagi blog'
      }
    }

    expect(response.status).to eq(201)

    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq('https://rubyyagi.com')
    expect(json[:title]).to eq('RubyYagi blog')
    expect(Bookmark.count).to eq(1)
    expect(Bookmark.last.title).to eq('RubyYagi blog')
  end

  scenario 'invalid bookmark attributes' do
    post '/bookmarks', params: {
      bookmark: {
        url: '',
        title: 'RubyYagi blog'
      }
    }

    expect(response.status).to eq(422)

    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])
    expect(Bookmark.count).to eq(0)
  end
  scenario 'user is not signed in' do
    sign_out :user  # Assuming :user is the Devise scope
    post '/bookmarks', params: {
      bookmark: {
        url: 'https://rubyyagi.com',
        title: 'RubyYagi blog'
      }
    }

    expect(response.status).to eq(302)

    # Follow the redirect to the sign-in page if needed
    follow_redirect! if response.status == 302

    # Optionally, check the final status after redirection
    # expect(response.status).to eq(401)
    expect(Bookmark.count).to eq(0)
  end
end
