require "application_system_test_case"

class WelcomesTest < ApplicationSystemTestCase
  test " / ページを表示" do
    visit root_url

    assert_selector "h1", text: "イベンAAAAト一覧"
  end
end
