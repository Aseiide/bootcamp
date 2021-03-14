# frozen_string_literal: true

require 'application_system_test_case'
require 'supports/tag_helper'

class CurrentUserTest < ApplicationSystemTestCase
  setup { login_user 'komagata', 'testtest' }

  test 'update user' do
    visit '/current_user/edit'
    within 'form[name=user]' do
      fill_in 'user[login_name]', with: 'testuser'
      click_on '更新する'
    end
    assert_text 'ユーザー情報を更新しました。'
  end

  test 'update user tags' do
    login_user 'kimura', 'testtest'
    visit '/current_user/edit'
    tag_input = find '.ti-new-tag-input'
    tag_input.set 'タグ1'
    click_on '更新する'
    assert_text 'タグ1'

    visit '/users'
    assert_text 'タグ1'

    click_on 'タグ1'
    assert_text '「タグ1」のユーザー'
  end

  test 'update user description with blank' do
    login_user 'kimura', 'testtest'
    visit '/current_user/edit'
    fill_in 'user[description]', with: ''
    click_on '更新する'
    assert_text '自己紹介を入力してください'
  end

  # ここから下のテストはTagHelperのmethodを利用する
  include TagHelper

  test 'alert when enter tag with space' do
    visit edit_current_user_path

    assert_alert_when_enter_tag_with_space
  end
end
