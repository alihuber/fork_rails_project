# File is named "*.speck" to prevent it from being run by real RSpec tests
require "spec_helper"


feature "Space/Register" do
  describe "on register page" do
    scenario "register with email" do
      visit orig_engine.register_path
      expect(page).to have_css("input#email")

      expect {
        fill_in("email").with("foo@qux.com")
        click_button "submit_register"
      }.to change { OrigEngine::User.count }.by(1)

      expect(current_path).to eq orig_engine.dashboard_path
      expect(page).to have_text "Welcome"
    end
  end
end
