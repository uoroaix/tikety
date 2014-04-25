require 'spec_helper'

describe TicketsController do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }
  let(:ticket1) { create(:ticket, user: user1) }

  describe "#index" do

    it "should render the index page" do
      get :index
      expect(response).to render_template(:index)
    end


    it "should assigns a variable for all the tickets" do
      get :index
      expect(assigns(:tickets)).to be
    end
  end


  describe "#new" do

    context "with signed in user" do
      before { sign_in user }

      it "should assigns a new ticket" do
        get :new
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      it "renders new template" do
        get :new
        expect(response).to render_template(:new)
      end

    end

    context "with signed out user" do

      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end

    end
  end



  describe '#create' do

    context "with signed in user" do
      before { sign_in user }

      context "with valid request" do

        def valid_request
          post :create, ticket: {title: "valid title", description: "valid description"}
        end

        it "should save a new ticket in the database" do
          expect { valid_request }.to change { Ticket.count }.by(1)
        end

        it "should redirect to the ticket index page" do
          valid_request
          expect(response).to redirect_to(tickets_path)
        end

        it "assigns the ticket to the signed in user" do
          expect { valid_request }.to change { user.tickets.count }.by(1)
        end

      end

      context "with invalid request" do
        
        def invalid_request
            post :create, ticket: {title: "", description: "valid description"}
        end

        it "doesn't change the number of tickets in the database" do
          expect { invalid_request }.to_not change { Ticket.count }
        end

        it "renders new template" do
          invalid_request
          expect(response).to render_template(:new)
        end 

      end

    end

    context "with signed out user" do
      it "should redirect to sign_in page" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


  describe '#edit' do

    context "with signed out user" do

      it "redirects to new session path" do
        get :edit, id: ticket.id
        expect(response).to redirect_to(new_user_session_path)
      end

    end

    context "with signed in user" do
      before { sign_in user }


      it "assigns the ticket with the current passed id" do
        get :edit, id: ticket.id
        expect(assigns(:ticket)).to eq(ticket)
      end

      it "renders the edit template" do
        get :edit, id: ticket.id
        expect(response).to render_template(:edit)
      end

      it "raises error if trying to edit another user's ticket" do
        expect { get :edit, id: ticket1.id }.to raise_error
      end

    end
  end


  describe '#destroy' do

    context "with signed in user" do
      before {sign_in user}
      before { ticket }

      it "removes the ticket from the database" do
        expect do
          delete :destroy, id: ticket.id
        end.to change { Ticket.count }.by(-1)
      end

      it "redirects to tickets listing page with successful delete" do
        delete :destroy, id: ticket.id
        expect(response).to redirect_to(tickets_path)
      end

      it "raises error when trying to delete another person's ticket" do
          expect do
            delete :destroy, id: ticket1.id
        end.to raise_error
      end
    end

    context "with signed out user" do

      it "should redirect to sign_in page" do
        delete :destroy, id: ticket.id
        expect(response).to redirect_to(new_user_session_path)
      end

    end
  end

  describe '#update' do
    context "with signed in user" do
      before { sign_in user }

      it "update the question with new title" do
        patch :update, id: ticket.id, ticket: {title: "some new title"}
        ticket.reload
        expect(ticket.title).to match /some new title/i
      end

      it "redirects to ticket show page after successful update" do
        patch :update, id: ticket.id, ticket: {title: "some new title"}
        expect(response).to redirect_to(ticket)
      end

      it "renders edit template with failed update" do
        patch :update, id: ticket.id, ticket: {title: ""}
        expect(response).to render_template(:edit)
      end

      it "sets flash message with successful update" do
        patch :update, id: ticket.id, ticket: {title: "some new title"}
        expect(flash[:notice]).to be
      end

      it "raises an error if trying to update another user's ticket" do
        expect do
          patch :update, id: ticket1.id, ticket: {title: "asdfsdf"}
        end.to raise_error
      end
    end
  end


  describe "#status" do

    context "with signed in user" do
    before { sign_in user}
      
      it "should change status from false to true" do
        get :status, id: ticket.id
        expect(ticket.reload.status).to eq(true)
      end

      it "should change status from true to false" do
        ticket.status = true
        ticket.save
        get :status, id: ticket.id
        expect(ticket.reload.status).to eq(false)
      end


    end

  end



end
