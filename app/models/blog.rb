class Blog < ApplicationRecord
  enum status: { public: 0, private: 1 }, _prefix: true
  # 上記のように_prefix: trueを記述してない状態でブラウザを開いたら、エラーが出ることがある。
  # エラー文を確認すると、publicというメソッドが重複しているとのこと。
  # 重複してエラーが出ていなければ_prefix: trueを記述しなくてもOK。
  belongs_to :user
end
