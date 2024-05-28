# IndigoVPS_UbuntuSetup
## 概要
- IndigoVPS（Ubuntu）の初期設定を行います。
- デフォルトユーザーを削除し作成したユーザーを設定し、tailscaleをインストールします。
    ```
    ただし、exitnodeの設定は外すことが出来ます。
    ```

## このスクリプトで設定する内容
- Defaultのユーザーを置き換える新規ユーザーを作成
    - 新規ユーザーを作成
    - Defaultユーザーと同じグループを適用
    - Defaultユーザー削除

- SSHを設定
    - SSHディレクトリをDefaultユーザーからコピーし、同じ秘密鍵でログインできるように設定。
    - sshに以下の設定を有効化
        - PasswordAuthentication no
        - PermitRootLogin no

- ufwのポート開放
    - 連続アクセスを制限して22番ポートのアクセスを許可  
        ``` 
        (注) スクリプトの設定にあるport配列に番号を追加して、設定ポート追加可能
        ``````
    - ufwを有効化
    - ufwを再起動

- tailscaleをインストール
    - tailscaleのリポジトリを追加
    - tailscaleをインストール
    - tailscaleをexitnodeとして設定して起動および認証
        - exitnodeとするかはinit_step2.shのexitnode設定から選択可

## 使い方
1. releaseからファイルをダウンロード    
2. init_step1.shを実行
3. 作成したユーザーでログイン
    - ユーザー名は新しいユーザー名を入力, パスワード無しで秘密鍵を使用してログイン
4. init_step2.shを実行
5. 表示されるtailscale認証用URLをコピーし、ブラウザでアクセスして認証
    - ブラウザはPC、スマホどちらでも可能
6. exitnodeを有効化するためtailscaleのマシン一覧からexitnodeを有効化
7. 完了！
