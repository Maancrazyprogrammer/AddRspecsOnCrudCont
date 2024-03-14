
require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do

  let(:user) { create(:user) }
  let(:bookmark) { create(:bookmark) }
  let(:admin_user) { create(:user, role: 'admin', email: 'admin@example.com') }
  let(:student_user) { create(:user, role: 'student', email: 'student@example.com') }

  # let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  describe 'GET /index' do
    before { sign_in admin_user }
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'redirects to sign-in page when user is not signed in' do
      sign_out user

      get :index
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not allow access to the bookmark data when user is not signed in' do
      sign_out user

      get :index
      expect(response.body).to be_empty
    end
  end
  describe 'GET /index' do
    before { sign_in student_user }
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end


  end

  describe 'GET /show' do
    before { sign_in admin_user }
    let(:bookmark) { create(:bookmark) }

    it 'returns a success response' do
      get :show, params: { id: bookmark.to_param }
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eq("MyString")
      expect(parsed_response["url"]).to eq("MyString")
    end
    context 'when user is not signed in' do

      it 'redirects to sign-in page' do
        sign_out user
        get :show, params: { id: bookmark.to_param }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'does not allow access to the bookmark data' do
        sign_out user
        get :show, params: { id: bookmark.to_param }

        expect(response.body).to be_empty
      end
    end
  end

  describe 'GET /show' do
    before { sign_in student_user }
    let(:bookmark) { create(:bookmark) }

    it 'returns a success response' do
      get :show, params: { id: bookmark.to_param }
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eq("MyString")
      expect(parsed_response["url"]).to eq("MyString")
    end
  end
  describe 'POST /bookmarks' do
    before { sign_in admin_user }
    let(:valid_attributes) {
      { bookmark: attributes_for(:bookmark) }
    }

    let(:invalid_attributes) {
      { bookmark: { title: '', url: '' } }
    }

    context 'with valid parameters' do
      it 'creates a new Bookmark' do
        expect {
          post :create, params: valid_attributes
        }.to change(Bookmark, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable_entity status' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      scenario 'user is not signed in' do
        sign_out :user  # Assuming :user is the Devise scope
        expect {
          post :create, params: valid_attributes
        }.to change(Bookmark, :count).by(0)

        expect(response.status).to eq(302)


        expect(Bookmark.count).to eq(0)
      end
    end
    context 'when user is not admin' do
            before { sign_in student_user }

            it 'does not create a new Bookmark' do
              expect {
                post :create, params: { bookmark: attributes_for(:bookmark) }
              }.to raise_error(CanCan::AccessDenied)

              # expect(response.status).to eq(302)


        expect(Bookmark.count).to eq(0)
            end
          end
  end

  describe 'PATCH /update' do
    before { sign_in admin_user }
    let(:bookmark) { create(:bookmark) }
    let(:new_attributes) { { title: 'Updated Title' } }

    context 'with valid parameters' do
      it 'updates the requested bookmark' do
        patch :update, params: { id: bookmark.to_param, bookmark: new_attributes }
        expect(response).to have_http_status(:success)
        bookmark.reload
        expect(bookmark.title).to eq('Updated Title')
      end

    end

    context 'with invalid parameters' do
      it 'returns unprocessable_entity status' do
        patch :update, params: { id: bookmark.to_param, bookmark: { title: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      scenario 'user is not signed in, cannot update the bookmark' do
        # No sign_in action for this scenario
         sign_out user
         patch :update, params: { id: bookmark.to_param, bookmark: new_attributes }
        expect(response.status).to eq(302)
        # The bookmark should not be updated
        expect(bookmark.reload.title).to eq('MyString')

      end
    end
    context 'when user is not admin' do
      before { sign_in student_user }

      it 'does not update a Bookmark' do
        expect {
          patch :update, params: { id: bookmark.to_param, bookmark: new_attributes }
        }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

  describe 'DELETE /destroy' do
    before { sign_in admin_user }
    let!(:bookmark) { create(:bookmark) }

    it 'destroys the requested bookmark' do
      expect {
        delete :destroy, params: { id: bookmark.to_param }
      }.to change(Bookmark, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
    scenario 'user is not signed in, cannot delete the bookmark' do
      sign_out user  # Sign out the user

      # Send DELETE request to /bookmarks/:id
      expect {
        delete :destroy, params: { id: bookmark.to_param }
      }.to change(Bookmark, :count).by(0)

      expect(response.status).to eq(302)
      expect(Bookmark.exists?(bookmark.id)).to be_truthy  # Bookmark should not be deleted
    end
    context 'when user is not admin' do
      before { sign_in student_user }

      it 'does not destroy a Bookmark' do
        expect {
          delete :destroy, params: { id: bookmark.to_param }
        }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

end
