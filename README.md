# IndigoVPS_UbuntuSetup
IndigoVPS（Ubuntu）の初期設定を行います。
    デフォルトユーザーを削除し作成したユーザーを設定し、tailscaleをインストールします。（exitnodeの設定は外すことが出来ます。）

このスクリプトで設定する内容（詳細） 
    1. Defaultのユーザーを置き換える新規ユーザーを作成
        1-1. 新規ユーザーを作成
        1-2. Defaultユーザーと同じグループを適用
        1-3. Defaultユーザー削除
    2. SSHを設定
        2-1. SSHディレクトリをDefaultユーザーからコピーし、同じ秘密鍵でログインできるように設定。
        2-2. sshに以下の設定を有効化
            [1] PasswordAuthentication no
            [2] PermitRootLogin no
    3. ufwのポート開放
        3-1. 連続アクセスを制限して22番ポートのアクセスを許可
            (注) スクリプトの設定にあるport配列に番号を追加して、設定ポート追加可能
        3-2. ufwを有効化
        3-3. ufwを再起動
    4. tailscaleをインストール
        4-1. tailscaleのリポジトリを追加
        4-2. tailscaleをインストール
        4-3. tailscaleをexitnodeとして設定して起動および認証
            exitnodeとするかはinit_step2.shのexitnode設定から選択可

使い方
    1. releaseからファイルをダウンロード
        
    2. init_step1.shを実行
    3. 作成したユーザーでログイン
        ユーザー名は新しいユーザー名を入力, パスワード無しで秘密鍵を使用してログイン
    4. init_step2.shを実行
    5. 表示されるtailscale認証用URLをコピーし、ブラウザでアクセスして認証
        ブラウザはPC、スマホどちらでも可能
    6. exitnodeを有効化するためtailscaleのマシン一覧からexitnodeを有効化
    7. 完了！
