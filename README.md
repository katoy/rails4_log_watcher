
See
- [http://www.proxygear.com/technic/2014/04/20/rails-engine-to-stram-live-logs.html](http://www.proxygear.com/technic/2014/04/20/rails-engine-to-stram-live-logs.html)  
  > Rails: Engine to stream live logs  

##Dependencies

- Rails 4+

- Setting

    $ bundle install
    $ bundle exec rails g jquery:install
    $ bundle exec rails g wice_grid:install
    $ bundle exec rails generate bootstrap:install static
	$ bundle exec rails g bootstrap:layout application fluid
	$ rails generate rspec:install

- Start server

    $ bundle exec rake db:migrate
	$ bundle exec rails s
    ($ passenger start)

    visit http://localhoist:3000

## Reset gem

See [http://qiita.com/katoy/items/9bcba54b88c5fc7d9aa6](http://qiita.com/katoy/items/9bcba54b88c5fc7d9aa6)  

    $ gem uninstall -I -a -x --user-install --force

##LICENSE

This project rocks and uses MIT-LICENSE.  

# TODO:

- (済) DB の閲覧で 表示件数制御を実装する事。
- (済) log ファイルの ansi カラーシーケンスを html でカラー表示に変換する事。
- Reils log 画面で 自動更新を on/off できるようにする事。
- DB log 画面で、Server push 版ページも作成する事。
- robocop でソースコードをチェックする事。
- rspec を書く事。

# ライセンス

[MIT-LICENSE](MIT-LICENSE)

# その他

pandoc を利用してこのドキュメントを変換する。  

    $ pandoc README.md -o 1.pdf --latex-engine=xelatex -V mainfont=Hiragino\ Kaku\ Gothic\ Pro
    $ pandoc README.md -o 1.html --to html5 -s -S --toc -c pandoc.css
    $ pandoc README.md -o 1.docx

