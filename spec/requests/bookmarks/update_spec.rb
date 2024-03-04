
require 'rails_helper'

describe 'PUT /bookmarks' do
  # this will create a 'bookmark' method, which return the created bookmark object,
  # before each scenario is ran
  let(:user) { create(:user) }

  before do
    # Sign in the user before making requests
    sign_in user
  end

  let!(:bookmark) { Bookmark.create(url: 'https://rubyyagi.com', title: 'Ruby Yagi') }

  scenario 'valid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: 'https://fluffy.es',
        title: 'Fluffy'
      }
    }

    # response should have HTTP Status 200 OK
    expect(response.status).to eq(200)

    # response should contain JSON of the updated object
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq('https://fluffy.es')
    expect(json[:title]).to eq('Fluffy')

    # The bookmark title and url should be updated
    expect(bookmark.reload.title).to eq('Fluffy')
    expect(bookmark.reload.url).to eq('https://fluffy.es')
  end

  scenario 'invalid bookmark attributes' do
    # send put request to /bookmarks/:id
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: '',
        title: 'Fluffy'
      }
    }

    # response should have HTTP Status 422 Unprocessable entity
    expect(response.status).to eq(422)

    # response should contain error message
    json = JSON.parse(response.body).deep_symbolize_keys
    expect(json[:url]).to eq(["can't be blank"])

    # The bookmark title and url remain unchanged
    expect(bookmark.reload.title).to eq('Ruby Yagi')
    expect(bookmark.reload.url).to eq('https://rubyyagi.com')
  end
  scenario 'user is not signed in, cannot update the bookmark' do
    # No sign_in action for this scenario
     sign_out user
    put "/bookmarks/#{bookmark.id}", params: {
      bookmark: {
        url: 'https://fluffy.es',
        title: 'Fluffy'
      }
    }

    expect(response.status).to eq(302)

    # Follow the redirect to the sign-in page if needed
    follow_redirect! if response.status == 302



    # The bookmark should not be updated
    expect(bookmark.reload.title).to eq('Ruby Yagi')
    expect(bookmark.reload.url).to eq('https://rubyyagi.com')
  end
end
