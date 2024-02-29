require 'rails_helper'

describe "DELETE /destroy" do
  let(:user) { create(:user) }

  before do
    # Sign in the user before making requests
    sign_in user
  end



  let(:bookmark) { create(:bookmark) }

  scenario 'deletes the bookmark and returns a successful response' do
    # send put request to /bookmarks/:id
    delete "/bookmarks/#{bookmark.id}", params: { id: bookmark.id }


    # response should have HTTP Status 200 OK
    expect(response.status).to eq(204)
    expect(Bookmark.exists?(bookmark.id)).to be_falsey
    expect(Bookmark.count).to eq(0)


end
scenario 'user is not signed in, cannot delete the bookmark' do
  sign_out user  # Sign out the user

  # Send DELETE request to /bookmarks/:id
  delete "/bookmarks/#{bookmark.id}"

  # Check for the initial redirect status (302)
  expect(response.status).to eq(302)

  # Follow the redirect to the sign-in page if needed
  follow_redirect! if response.status == 302

  expect(Bookmark.exists?(bookmark.id)).to be_truthy  # Bookmark should not be deleted
end


end
