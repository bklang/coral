require 'rails_helper'
require 'support/authentication'

RSpec.describe "Restoration Activity Log", type: :request do
  include_context "logged in"
  describe "GET show" do
    let!(:log_entry) { FactoryBot.create(:restoration_activity_log_entry) }

    it "renders" do
      get "/restoration_activity_log_entries/#{log_entry.id}"

      expect(response).to be_successful
    end
  end

  describe "GET new" do
    it "succeeds" do
      get '/restoration_activity_log_entries/new'

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "given images" do
      subject do
        -> {
          post '/restoration_activity_log_entries', params: { restoration_activity_log_entry: { images: images } }
        }
      end

      let(:images) do
        [
          fixture_file_upload(Rails.root.join('spec', 'factories','images', "GOPR3892.JPG")),
          fixture_file_upload(Rails.root.join('spec', 'factories','images', "GOPR3893.JPG"))
        ]
      end

      it "redirects to another page" do
        subject.call
        expect(response).to be_redirect

        follow_redirect!
        expect(response).to be_successful
      end

      it "adds a log entry" do
        expect { subject.call }.to change {RestorationActivityLogEntry.count }.by(1)
      end
    end

    describe "PUT update" do
      context "given images" do
        subject do
          -> {
            put "/restoration_activity_log_entries/#{log_entry.id}", params: { restoration_activity_log_entry: { images: images } }
          }
        end

        let!(:log_entry) { FactoryBot.create(:restoration_activity_log_entry) }


        let(:images) do
          [
            fixture_file_upload(Rails.root.join('spec', 'factories','images', "GOPR3892.JPG")),
            fixture_file_upload(Rails.root.join('spec', 'factories','images', "GOPR3893.JPG"))
          ]
        end

        it "redirects to another page" do
          subject.call
          expect(response).to be_redirect

          follow_redirect!
          expect(response).to be_successful
        end

        it "adds images" do
          expect { subject.call }.to change { log_entry.images.count }.by(2)
        end
      end
    end
  end
end
