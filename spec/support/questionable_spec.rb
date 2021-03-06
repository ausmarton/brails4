require 'spec_helper'

shared_examples_for "Questionable" do |questionables|
  questionables.each do |elem|
    #login
    let(:question) { build(:full_question)}
    let(:invalid_attrs) { attributes_for(:question, title: nil)}
    let(:attrs) { attributes_for(:question, options_attributes: [attributes_for(:option), attributes_for(:incorrect_option), attributes_for(:incorrect_option)])}
    let!(:questionable) { create(("full_" + elem.to_s.downcase.singularize).to_sym)}
    let(:hash_key) { (elem.to_s.downcase + "_id").to_sym }

    before(:each) do
      questionable.questions << question
    end

    describe "GET #index" do
      it "populates an array of questions" do
        get :index, hash_key => questionable.id

        page_questions = assigns[:questions]

        expect(page_questions).to include(question)
      end

      it "renders the :index view" do
        get :index, hash_key => questionable.id

        expect(response).to render_template :index
      end
    end

    describe "GET #show" do
      context "when question is found" do
        it "assigns the requested Question to @question" do
          get :show, id: question.id, hash_key => questionable.id
          page_question = assigns[:question]

          expect(question).to eq page_question
        end

        it "renders the :show template" do
          get :show, id: question.id, hash_key => questionable.id
          
          expect(response).to render_template :show
        end
      end
    end

    describe "GET #new" do
      it "assigns a new Question to @question" do
        get :new, hash_key => questionable.id

        page_question = assigns[:question]

        expect(page_question).to_not be_nil
      end

      it "renders the :new template" do
        get :new, hash_key => questionable.id

        expect(response).to render_template :new
      end
    end

    describe "GET #edit" do
      it "assigns the requested Question to @question" do
        get :edit, id: question.id, hash_key => questionable.id

        page_question = assigns[:question]

        expect(question).to eq page_question
      end

      it "renders the :edit template" do
        get :edit, id: question.id, hash_key => questionable.id

        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "saves the new Question in the database" do
          expect { post :create, hash_key => questionable.id, question: attrs}.to change(Question, :count).by(1)
        end

        it "redirects to the :index view" do
          post :create, hash_key => questionable.id, question: attrs

          expect(response).to redirect_to [:admin, questionable]
        end
      end

      context "with invalid attributes" do
        it "doesn't save the new Question in the database" do
          expect{post :create, question: invalid_attrs, hash_key => questionable.id}.to_not change(Question, :count)
        end

        it "redirects to the :new view" do
          post :create, question: invalid_attrs, hash_key => questionable.id

          expect(response).to render_template :new
        end
      end
    end

    describe "PUT #update" do
      context "with valid attributes" do
        it "changes @question attributes" do
          attributes = attributes_for(:question, title: "updated")

          put :update, id: question.id, hash_key => questionable.id, question: attributes

          updated_question = assigns[:question]

          expect(updated_question.title).to eq "updated"
        end

        it "redirects to the :show view" do
          attributes = attributes_for(:question, title: "updated")

          put :update, id: question.id, hash_key => questionable.id, question: attributes

          updated_question = assigns[:question]

          expect(response).to redirect_to [:admin, questionable]
        end

        it "shows a success message" do
          attributes = attributes_for(:question, title: "updated")

          put :update, id: question.id, hash_key => questionable.id, question: attributes

          expect(flash[:notice]). to eq "Question successfully updated."
        end
      end

      context "with invalid attributes" do
        it "doesn't changes @question attributes" do
          put :update, id: question.id, hash_key => questionable.id, question: invalid_attrs

          updated_question = assigns[:question]

          expect(question).to eq updated_question
        end

        it "redirects to the :index view" do
          put :update, id: question.id, hash_key => questionable.id, question: invalid_attrs

          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do
      context "when find the question" do
        it "deletes the question" do
          expect{delete :destroy, id: question.id, hash_key => questionable.id}.to change(Question,:count).by(-1)
        end

        it "redirects to the :index view" do
          delete :destroy, id: question.id, hash_key => questionable.id

          expect(response).to redirect_to [:admin, questionable]
        end
      end
    end
  end
end