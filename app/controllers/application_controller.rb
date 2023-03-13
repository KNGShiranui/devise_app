# deviseのストロングパラメータ設定には、専用のメソッドconfigure_permitted_parametersがあります。
# deviseのコントローラはgem本体にあるため、ストロングパラメータはapplication_controllerに設定します。
class ApplicationController < ActionController::Base
  class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      # deviseで作成したこのUserというモデル（の、マイグレーションファイル）に、自分でnameというカラムを追加したとします。
      # deviseはdeviseが初期で作るカラムには自動でストロングパラメータの設定をしますが、独自実装したカラムには当然その設定はないので、
      # そのままそのカラムに値を保存しようとするとストロングパラメータで弾かれてしまいます。なので、上記のような記述をすることで、
      # nameカラムがUserのストロングパラメータに加わり、無事に保存ができるようになるわけです。
      # 上記では、sign_up時に[:name]の値を許す設定になっています。
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
      # update（ユーザー情報更新）の際は上記のようにします。
    end
  end
end

# このコードは、RailsアプリケーションのApplicationControllerに定義されたクラスであり、devise gemで認証機能を実装する際に使用されます。
# before_actionメソッドは、指定したアクションが呼び出される前に、このクラス内で定義されたconfigure_permitted_parametersメソッドを実行することを指定します。
# このメソッドは、deviseのコントローラーであるかどうかを確認し、deviseのユーザー登録(sign up)フォームで許可するパラメーターを設定します。ここでは、:nameパラメーターを許可しています。
# protectedキーワードは、このクラスの下に定義されたメソッドがプライベートメソッドとして扱われるようにします。
# つまり、このクラス外部から直接呼び出すことはできませんが、他のメソッド内で呼び出すことはできます。

# if: :devise_controller?はどういう意味
# if: :devise_controller?は、before_actionメソッドのオプションとして渡され、このクラスのアクションがDeviseのコントローラーであるかどうかを確認します。
# これは、Deviseのコントローラーでないアクションが呼び出された場合、configure_permitted_parametersメソッドが実行されないようにするためです。
# :devise_controller?は、Devise gemが提供するヘルパーメソッドで、Deviseのコントローラーであるかどうかを判定します。
# 具体的には、DeviseのコントローラーはDevise::SessionsController、Devise::RegistrationsController、Devise::ConfirmationsController、Devise::UnlocksController、Devise::PasswordsControllerです。
# devise_controller?メソッドは、現在のコントローラーがこれらのクラスのいずれかを継承している場合、真を返します。
# したがって、if: :devise_controller?は、現在のコントローラーがDeviseのコントローラーである場合にconfigure_permitted_parametersメソッドを実行することを保証します。

