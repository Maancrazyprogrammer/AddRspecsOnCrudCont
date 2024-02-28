require 'rails_helper'

describe "DELETE /destroy" do
  let(:bookmark) { create(:bookmark) }

  scenario 'deletes the bookmark and returns a successful response' do
    # send put request to /bookmarks/:id
    delete "/bookmarks/#{bookmark.id}", params: { id: bookmark.id }


    # response should have HTTP Status 200 OK
    expect(response.status).to eq(204)



end
end
